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
    export AI_PROVIDER=ollama     # 内网 bamboo-mini(M2)跑的 qwen2.5-coder:7b,无需 API key

avante.nvim 共用同一个 AI_PROVIDER 变量,两个插件保持同一模型栈(avante 未接 ollama,切过去 avante 会退回 deepseek)。

ollama 最早跑在 bamboo-server(纯 CPU,老 Xeon)上,qwen2.5-coder:3b 只有约 11 token/s,
FIM 请求经常撞超时拿不到补全,已经放弃,换成了 bamboo-mini(Mac mini M2,Metal GPU 加速)。
实测 qwen2.5-coder:7b 在 M2 上能跑到约 20 token/s(ollama ps 显示 100% GPU),
比之前快很多,所以 context_window/max_tokens 都放宽了一些。
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
		-- 单位是字符,实测 M2 上约 3.4 字符/token,4096 字符 ≈ 1200 token,
		-- 远低于 ollama 给这个模型的 num_ctx=8192,不会被静默截断。
		-- 实测 prompt eval 约 345 tok/s: 冷 cache 读 4096 字符要 3.5s(在 timeout 10s 内),
		-- 但 ollama 的 KV cache 按前缀复用,同一文件连续编辑只要 0.2s,所以日常无感。
		-- 再往上给(8192 字符≈2400 token)冷启动涨到 7s,而 7B 的有效注意力本就只有 1-2k token,
		-- 质量不升反降,不划算。
		context_window = 4096,
		request_timeout = 10, -- 留够余量给模型闲置卸载后的冷启动(实测热态 1-3s,冷启动会更久)
		provider_options = {
			api_key = "TERM", -- Ollama 不校验 key,只要求环境变量存在且非空
			name = "Ollama",
			end_point = "http://bamboo-mini.local:11434/v1/completions",
			model = "qwen2.5-coder:7b",
			optional = {
				max_tokens = 64,
				top_p = 0.9,
			},
		},
	},
}

local active = presets[AI_PROVIDER] or presets.deepseek

-- 灰字自动弹出只在这些语言开启(避免其他 filetype 也发请求增加费用)
local auto_trigger_ft = { "python", "javascript", "typescript", "vue", "html", "css", "lua", "go" }

return {
	"milanglacier/minuet-ai.nvim",
	event = "InsertEnter",
	-- :AiStatus 实测当前后端能不能用。
	-- lualine 上的 minuet 组件只显示"配置成了谁",连不连得上看不出来;
	-- 这个命令会真去打一次 endpoint,并把失败原因原样打出来,不做兜底。
	init = function()
		vim.api.nvim_create_user_command("AiStatus", function()
			local po = active.provider_options
			local key_var = po.api_key
			local key_val = vim.env[key_var]
			local lines = {
				"AI_PROVIDER   = " .. (vim.env.AI_PROVIDER or "(未设置,回退 deepseek)"),
				"provider      = " .. active.provider,
				"model         = " .. (po.model or "?"),
				"endpoint      = " .. (po.end_point or "?"),
				string.format(
					"api_key($%s) = %s",
					key_var,
					key_val and ("已设置," .. #key_val .. " 字符")
						or "【缺失!请求会直接失败】"
				),
			}

			local base = (po.end_point or ""):match("^(https?://[^/]+)")
			if AI_PROVIDER ~= "ollama" or not base then
				vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
				return
			end

			-- ollama: 额外探测服务可达性与模型驻留状态
			vim.system({ "curl", "-sf", "--max-time", "5", base .. "/api/ps" }, { text = true }, function(res)
				vim.schedule(function()
					if res.code ~= 0 then
						table.insert(
							lines,
							"连接        = 【失败】curl exit " .. res.code .. " " .. (res.stderr or "")
						)
						vim.notify(table.concat(lines, "\n"), vim.log.levels.ERROR)
						return
					end
					local ok, data = pcall(vim.json.decode, res.stdout)
					local models = ok and data and data.models or {}
					table.insert(lines, "连接        = OK")
					if #models == 0 then
						table.insert(lines, "模型驻留    = 无(首次补全需加载权重,会慢几秒)")
					else
						for _, m in ipairs(models) do
							table.insert(
								lines,
								string.format(
									"模型驻留    = %s (%.1fGB VRAM, ctx %s, 到期 %s)",
									m.name,
									(m.size_vram or 0) / 1e9,
									m.context_length or "?",
									(m.expires_at or ""):sub(1, 19)
								)
							)
						end
					end
					vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
				end)
			end)
		end, { desc = "检查当前 AI 补全后端(provider/model/key/连通性)" })
	end,
	-- 仅靠 event = InsertEnter 懒加载会漏掉 virtualtext 的自动触发:
	-- minuet 内部靠一个 FileType autocmd 给 buffer 打 vim.b.minuet_virtual_text_auto_trigger 标记,
	-- 但一个会话里第一次打开的文件,FileType 早于 InsertEnter 触发,插件加载后补注册的 FileType
	-- autocmd 已经没机会响应那次事件 —— 表现为第一个文件第一次进插入模式,灰字永远不弹。
	-- 加上 ft 触发后,lazy.nvim 会在插件加载完成后重放 FileType 事件,补上这个标记。
	ft = auto_trigger_ft,
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
			auto_trigger_ft = auto_trigger_ft,
			-- 默认 false 时,只要 cmp 菜单可见就不触发灰字(minuet/virtualtext.lua 的 schedule 守卫)。
			-- html 里 nvim_lsp(html-lsp) + buffer 两个 source 几乎每个字符都有候选,菜单常驻,
			-- 结果灰字永远弹不出来 —— 打开它才能和菜单共存,cmp.lua 的 <Tab> 优先级也才有意义。
			show_on_completion_menu = true,
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
