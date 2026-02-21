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
	{
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
	},
	{
		"hrsh7th/nvim-cmp", -- 补全核心框架
		lazy = true,
		event = "InsertEnter", -- 进入插入模式时加载
		dependencies = {
			"hrsh7th/cmp-buffer", -- 缓冲区内容补全
			"hrsh7th/cmp-path", -- 文件路径补全
			"hrsh7th/cmp-cmdline", -- 命令行补全
		},
		config = function()
			-- nvim-cmp 核心配置（保留原有补全逻辑）
			local cmp = require("cmp")
			cmp.setup({
				snippet = {
					expand = function(args)
						-- 若后续添加代码片段插件，需在这里配置
						vim.fn["vsnip#anonymous"](args.body) -- 兼容原有 vsnip 逻辑（如有）
					end,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- LSP 补全（最高优先级）
					{ name = "buffer" }, -- 缓冲区补全
					{ name = "path" }, -- 路径补全
				}),
				mapping = cmp.mapping.preset.insert({
					["<CR>"] = cmp.mapping.confirm({ select = true }), -- 回车确认补全
					["<Tab>"] = cmp.mapping.select_next_item(), -- Tab 下一个
					["<S-Tab>"] = cmp.mapping.select_prev_item(), -- Shift+Tab 上一个
				}),
			})
			-- 命令行补全配置
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = { { name = "buffer" } },
			})
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
			})
		end,
	},

	-- 插件分组：代码检查/格式化
	{
		"mfussenegger/nvim-lint", -- 代码检查（替代 ALE）
		lazy = true,
		event = { "BufWritePost", "BufEnter" }, -- 保存/打开文件时触发
		config = function()
			local lint = require("lint")
			-- 配置各语言检查工具（按需扩展）
			lint.linters_by_ft = {
				python = {},
				javascript = { "eslint" },
				typescript = { "eslint" },
				vue = { "eslint" },
				go = { "golangci-lint" },
				sh = { "shellcheck" },
			}
			-- 保存文件时自动检查
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
	{
		"sbdchd/neoformat", -- 代码格式化
		lazy = true,
		cmd = "Neoformat",
		ft = { "python", "go", "javascript", "typescript", "vue", "html", "css" },
	},
	{
		"psf/black", -- python 格式化
		lazy = true,
		ft = "python",
		branch = "stable",
	},
}
