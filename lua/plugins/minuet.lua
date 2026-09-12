--[[
AI 补全插件: minuet-ai.nvim
提供 as-you-type 代码补全,支持 OpenAI 兼容 / FIM / Ollama / llama.cpp 等任意模型。

cmp source 只在 @ . ( [ : 空格等触发字符处自动请求(插件自身写死,普通字母不算关键字),
平时打字看不到自动弹出是设计如此,靠 <C-l> / <A-y> 手动强制。
想要随打随出的效果用下面 virtualtext(灰字)前端,常用键位:
    <A-A> 接受整段  <A-a> 接受一行  <A-z> 接受 n 行  <A-e> 取消
    <A-[> / <A-]> 切换候选(灰字未显示时也可用来手动触发)

模型切换(改环境变量后重启 nvim,或 :Lazy reload minuet-ai.nvim 生效):
    export AI_PROVIDER=deepseek   # 默认,需要 DEEPSEEK_API_KEY
    export AI_PROVIDER=openai     # 需要 OPENAI_API_KEY
    export AI_PROVIDER=opencode   # OpenCode Go 套餐网关,需要 OPENCODE_API_KEY
    export AI_PROVIDER=ollama     # 内网 bamboo-server 跑的 qwen2.5-coder:3b,无需 API key

avante.nvim 共用同一个 AI_PROVIDER 变量,两个插件保持同一模型栈(avante 未接 ollama,切过去 avante 会退回 deepseek)。

ollama 是纯 CPU 推理(bamboo-server 无 GPU),实测 qwen2.5-coder:3b 约 11 token/s,
所以 context_window 调小、request_timeout 调大,避免默认 3s 超时导致经常拿不到补全。
]]
local AI_PROVIDER = vim.env.AI_PROVIDER or "deepseek"

-- OpenCode Go 网关要求每个请求带 x-opencode-session,否则报 MissingSessionID
-- (https://opencode.ai/docs/go/#where-can-i-use-it);本次 nvim 进程生成一个 id,所有请求复用
local function random_session_id()
	math.randomseed(os.time() + vim.loop.hrtime())
	local chars = "0123456789abcdef"
	local id = {}
	for i = 1, 32 do
		local idx = math.random(1, #chars)
		id[i] = chars:sub(idx, idx)
	end
	return table.concat(id)
end
local opencode_session_id = random_session_id()

-- 每个预设 = 一种 provider 类型 + 对应 provider_options
local presets = {
	deepseek = {
		provider = "openai_fim_compatible",
		provider_options = {
			api_key = "DEEPSEEK_API_KEY", -- 对应环境变量名
			name = "DeepSeek",
			-- DeepSeek 的 FIM 补全接口自 2025 年起只走 beta 域名,普通 /v1 会报错
			end_point = "https://api.deepseek.com/beta/completions",
			model = "deepseek-chat",
			optional = {
				max_tokens = 128,
				top_p = 0.9,
			},
		},
	},
	openai = {
		-- OpenAI 官方不支持 FIM,改用 chat 补全(openai_compatible)
		provider = "openai_compatible",
		provider_options = {
			api_key = "OPENAI_API_KEY",
			name = "OpenAI",
			end_point = "https://api.openai.com/v1/chat/completions",
			model = "gpt-4o-mini",
			optional = {
				max_tokens = 128,
				top_p = 0.9,
			},
		},
	},
	opencode = {
		-- OpenCode Go 套餐网关,走 openai-completions(chat 补全)协议,不是 FIM
		provider = "openai_compatible",
		provider_options = {
			api_key = "OPENCODE_API_KEY",
			name = "OpenCode",
			end_point = "https://opencode.ai/zen/go/v1/chat/completions",
			model = "deepseek-v4.1-flash",
			optional = {
				max_tokens = 128,
				top_p = 0.9,
			},
			transform = {
				function(data)
					data.headers["x-opencode-session"] = opencode_session_id
					return data
				end,
			},
		},
	},
	ollama = {
		provider = "openai_fim_compatible",
		context_window = 512, -- 本地小模型,上下文越大预填充越慢
		request_timeout = 6, -- 纯 CPU 推理比云端慢,默认 3s 经常来不及吐完
		provider_options = {
			api_key = "TERM", -- Ollama 不校验 key,只要求环境变量存在且非空
			name = "Ollama",
			end_point = "http://bamboo-server.local:11434/v1/completions",
			model = "qwen2.5-coder:3b",
			optional = {
				max_tokens = 32, -- 实测约 11 token/s,32 token 约 3s,配合上面 timeout
				top_p = 0.9,
			},
		},
	},
}

local active = presets[AI_PROVIDER] or presets.deepseek

return {
	"milanglacier/minuet-ai.nvim",
	event = "InsertEnter",
	opts = {
		provider = active.provider,
		n_completions = 1, -- 省钱/省资源,云端模型可调大
		context_window = active.context_window or 4096, -- 上下文窗口(字符)
		request_timeout = active.request_timeout or 3,
		throttle = 1000, -- 请求节流,防止费用飙升
		debounce = 400,
		provider_options = {
			[active.provider] = active.provider_options,
		},
		virtualtext = {
			-- 只在常用语言自动弹灰字建议,避免其他 filetype 也发请求增加费用
			auto_trigger_ft = { "python", "javascript", "typescript", "vue", "html", "css", "lua", "go" },
			keymap = {
				accept = "<A-A>",
				accept_line = "<A-a>",
				accept_n_lines = "<A-z>",
				next = "<A-]>",
				prev = "<A-[>",
				dismiss = "<A-e>",
			},
		},
	},
}
