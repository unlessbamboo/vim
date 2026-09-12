--[[
AI 助手插件: avante.nvim(Cursor 风格: 对话、内联编辑、自动应用 diff)
依赖(自动随 avante 安装): plenary.nvim / nui.nvim / nvim-web-devicons / render-markdown.nvim

模型切换:
    启动默认模型: export AI_PROVIDER=deepseek(默认) | openai | claude | ollama
    nvim 内随时切换(无需重启): :AvanteSwitchProvider 或 :AvanteModels

ollama 复用 bamboo-server 上给 minuet 用的同一个 qwen2.5-coder:3b(纯 CPU,约 11 token/s),
对话场景比补全更耗 token,回复会明显慢,只适合简单问答/小改动。
]]
local AI_PROVIDER = vim.env.AI_PROVIDER or "deepseek"
local provider_by_env = {
	deepseek = "deepseek",
	openai = "openai",
	claude = "claude",
	ollama = "ollama",
}

return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false, -- 跟随 main 分支
	build = "make", -- 编译 tiktoken_core,必须保留
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	opts = {
		-- 与 minuet 共用 AI_PROVIDER
		provider = provider_by_env[AI_PROVIDER] or "deepseek",
		providers = {
			deepseek = {
				__inherited_from = "openai",
				endpoint = "https://api.deepseek.com/v1",
				model = "deepseek-chat",
				api_key_name = "DEEPSEEK_API_KEY",
				timeout = 30000,
			},
			-- 覆盖内置 openai provider 的默认模型
			openai = {
				model = "gpt-4o-mini",
				api_key_name = "OPENAI_API_KEY",
			},
			-- 用 Claude 时: 设置 ANTHROPIC_API_KEY 并取消下行注释
			claude = {
				model = "claude-sonnet-4-20250514",
				api_key_name = "ANTHROPIC_API_KEY",
			},
			ollama = {
				endpoint = "http://bamboo-server.local:11434",
				model = "qwen2.5-coder:3b",
				timeout = 60000, -- 纯 CPU 推理,对话比补全慢很多,超时给宽松点
				-- ollama provider 默认禁用(avante 内置行为),要用它必须显式探活开启
				-- 用函数包一层延迟 require,避免 avante.nvim 还没被 lazy 加载到 rtp 时报 module not found
				is_env_set = function()
					return require("avante.providers.ollama").check_endpoint_alive()
				end,
				extra_request_body = {
					options = {
						temperature = 0.75,
						num_ctx = 4096, -- CPU 上 20480 默认值预填充太慢,降下来
						keep_alive = "5m",
					},
				},
			},
		},
		-- 复用已有 fzf-lua 做文件选择
		selector = {
			provider = "fzf",
		},
		-- 保持默认 native 输入框,不再引入 dressing/snacks 等额外依赖
		input = { provider = "native" },
		-- 侧栏窗口: width 为屏幕宽度百分比(默认 30,偏宽),可自行调整
		windows = {
			width = 15,
		},
	},
}
