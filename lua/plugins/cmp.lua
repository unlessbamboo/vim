return {
	"hrsh7th/nvim-cmp",
	lazy = true,
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
	},
	config = function()
		local cmp = require("cmp")
		cmp.setup({
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "buffer" },
				{ name = "path" },
				-- AI 补全(minuet-ai.nvim)
				-- minuet 只在触发字符处自动请求;这里保留官方 6 个触发字符并追加中文标点
				{
					name = "minuet",
					trigger_characters = { "@", ".", "(", "[", ":", " ", "，", "。", "、", "；" },
				},
			}),
			-- LLM 响应比普通 source 慢,加大超时避免 minuet 结果被丢弃
			performance = {
				fetching_timeout = 2000,
			},
			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				-- Tab 优先级: minuet 灰字建议 > cmp 补全菜单 > 普通 Tab
				-- (避免 iTerm2 里 Option/Alt 键不可靠时,minuet 灰字建议只能靠 Alt 键接受)
				["<Tab>"] = cmp.mapping(function(fallback)
					local minuet_vt = require("minuet.virtualtext")
					if minuet_vt.action.is_visible() then
						minuet_vt.action.accept()
					elseif cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
				["<ESC>"] = cmp.mapping.abort(),
				-- 手动触发 minuet 补全:
				-- C-l 在 iTerm2 下可靠;A-y 需要终端把 Option 键设为 "Esc+"
				["<C-l>"] = require("minuet").make_cmp_map(),
				["<A-y>"] = require("minuet").make_cmp_map(),
			}),
		})
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
