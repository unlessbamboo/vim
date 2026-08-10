--[[
AI 补全插件: minuet-ai.nvim
提供 as-you-type 代码补全,支持 OpenAI 兼容 / FIM / Ollama / llama.cpp 等任意模型。

模型切换(改环境变量后重启 nvim,或 :Lazy reload minuet-ai.nvim 生效):
    export AI_PROVIDER=deepseek   # 默认,需要 DEEPSEEK_API_KEY
    export AI_PROVIDER=openai     # 需要 OPENAI_API_KEY

avante.nvim 共用同一个 AI_PROVIDER 变量,两个插件保持同一模型栈。
]]
local AI_PROVIDER = vim.env.AI_PROVIDER or "deepseek"

-- 每个预设 = 一种 provider 类型 + 对应 provider_options
local presets = {
	deepseek = {
		provider = "openai_fim_compatible",
		provider_options = {
			api_key = "DEEPSEEK_API_KEY", -- 对应环境变量名
			name = "DeepSeek",
			end_point = "https://api.deepseek.com/v1/completions",
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
	-- 想加本地模型: 复制一个预设,把 provider_options 指向 Ollama/llama.cpp 即可
	-- ollama = {
	-- 	provider = "openai_fim_compatible",
	-- 	provider_options = {
	-- 		api_key = "TERM",
	-- 		name = "Ollama",
	-- 		end_point = "http://localhost:11434/v1/completions",
	-- 		model = "qwen2.5-coder:7b",
	-- 		optional = { max_tokens = 56, top_p = 0.9 },
	-- 	},
	-- },
}

local active = presets[AI_PROVIDER] or presets.deepseek

return {
	"milanglacier/minuet-ai.nvim",
	event = "InsertEnter",
	opts = {
		provider = active.provider,
		n_completions = 1, -- 省钱/省资源,云端模型可调大
		context_window = 4096, -- 上下文窗口(字符),本地小模型建议 512
		throttle = 1000, -- 请求节流,防止费用飙升
		debounce = 400,
		provider_options = {
			[active.provider] = active.provider_options,
		},
	},
}
