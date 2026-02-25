return {
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
}
