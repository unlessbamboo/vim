--[[
AI 补全插件: minuet-ai.nvim
提供 as-you-type 代码补全,支持 OpenAI 兼容 / FIM / Ollama / llama.cpp 等任意模型。

== 术语 ==
本文件里说的"灰字"不是传统意义上的补全,两者技术路径完全不同,业界用不同的词区分:

  ghost text(幽灵文本)
      光标后那段灰色的、尚未接受的预览文本,指的是"视觉形态"。
      Copilot / VSCode / JetBrains 都用这个叫法。
  virtual text(虚拟文本)
      nvim extmark API 的概念: 不真实存在于 buffer 里、只负责渲染的文本。
      是 ghost text 在 neovim 里的实现机制,下面那个 virtualtext = {} 配置就得名于此。
  inline completion / inline suggestion(行内补全 / 行内建议)
      指的是"功能"本身。LSP 3.18 起有标准方法 textDocument/inlineCompletion,
      VSCode 扩展 API 叫 InlineCompletionItemProvider。
  FIM (Fill-in-the-Middle,中间填充)
      模型侧的任务名。请求体里的 prompt(光标前) + suffix(光标后)就是 FIM 接口 ——
      让模型看着前后文填中间那段。传统补全不存在这个概念。

和传统补全(autocomplete / IntelliSense)的区别:
  传统补全  弹候选列表 | 来自 LSP 静态分析和 buffer 词法 | 补标识符 | 确定性,符号存在就合法
  行内补全  直接显示整段 | 来自 LLM 生成      | 补任意片段,可跨行 | 概率性,可能是幻觉

注意 minuet 把这两种前端都提供了 —— 下面 cmp source 走传统候选菜单,virtualtext 走灰字,
同一个模型的输出有两条展示路径。(它俩默认互斥,见 virtualtext.show_on_completion_menu 的注释)

cmp source 只在 @ . ( [ : 空格等触发字符处自动请求(插件自身写死,普通字母不算关键字),
平时打字看不到自动弹出是设计如此,靠 <C-l> / <A-y> 手动强制。
想要随打随出的效果用下面 virtualtext(灰字)前端,常用键位:
    <A-A> 接受整段  <A-a> 接受一行  <A-z> 接受 n 行  <A-e> 取消
    <A-[> / <A-]> 切换候选(灰字未显示时也可用来手动触发)

模型切换(改环境变量后重启 nvim,或 :Lazy reload minuet-ai.nvim 生效):
    export AI_PROVIDER=opencode   # 默认,OpenCode Go 套餐网关,需要 OPENCODE_API_KEY
    export AI_PROVIDER=deepseek   # 需要 DEEPSEEK_API_KEY
    export AI_PROVIDER=openai     # 需要 OPENAI_API_KEY

本地 ollama 栈(bamboo-mini 上的 qwen2.5-coder:7b)已停用:实际写代码的时间很少,补全这种
场景用不上本地小模型,还一直拖着 5GB 权重常驻占内存;改用 OpenCode Go 网关的
deepseek-v4.1-flash。minuet 本身仍支持 ollama / llama.cpp 等本地后端,
想恢复在下面 presets 里把 ollama 那份配置加回来即可(旧的 ollama preset 见 git 历史)。

avante.nvim 共用同一个 AI_PROVIDER 变量,但它没接 opencode(切过去会退回 deepseek);
avante 已在 lazyentry.lua 里注释掉,暂不启用。
]]
local AI_PROVIDER = vim.env.AI_PROVIDER or "opencode"

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
}

local active = presets[AI_PROVIDER] or presets.opencode

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
				"AI_PROVIDER   = " .. (vim.env.AI_PROVIDER or "(未设置,回退 opencode)"),
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

			vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
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
		-- 默认值按云端 API 省钱设计;本地 provider 可在自己的 preset 里覆盖成更跟手的值
		throttle = active.throttle or 1000, -- 最快多久发一次请求
		debounce = active.debounce or 400, -- 停手多久后才发请求
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
