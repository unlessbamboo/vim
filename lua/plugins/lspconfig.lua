--[[
1. 以Python替代方案作为重点说明:
  从jedi-vim变为:原生LSP + pyright,其中
    + nvim-lspconfig管理Pyright的启动和通信
    + pyright作为LSP服务器,支持类型检查、补全、跳转、诊断、重命名
    + nvim-cmp代码补全框架,整合 LSP 补全结果
    + cmp-nvim-lsp连接 nvim-cmp 和原生 LSP 的桥梁
    + cmp-buffer/cmp-path补充缓冲区 / 路径补全(可选项)
NOTE: 注意,能以lazy.nvim插件配置格式返回的都是已有的插件
--]]
return {
	"neovim/nvim-lspconfig", -- LSP 配置简化工具
	lazy = false,
	ft = { "python", "go", "lua", "javascript", "typescript", "html", "css" },
	dependencies = {
		"hrsh7th/nvim-cmp", -- 补全框架
		"hrsh7th/cmp-nvim-lsp", -- cmp 对接 LSP 的桥梁
		"hrsh7th/cmp-buffer", -- 缓冲区补全
		"hrsh7th/cmp-path", -- 路径补全
	},
	config = function()
		require("lsp.init").setup()
		-- python
		require("lsp.pyright")
		require("format.ruff").setup()
		-- lua
		require("lsp.lua_ls")
		require("format.stylua").setup()
	end,
}
