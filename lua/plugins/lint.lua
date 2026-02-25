return {
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
