return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("lualine").setup({
			options = {
				theme = "auto",
				component_separators = "|",
				section_separators = "",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = {
					-- minuet 自带的 lualine 组件:常驻显示当前 AI provider:model,
					-- 发补全请求时转 spinner,一眼能看出现在接的是 opencode 还是 deepseek。
					-- 注意:这里 require 会让 minuet 在 lualine 加载时就被拉起来,
					-- 它原本的 event=InsertEnter 懒加载就失效了(换来状态栏始终可用)。
					{
						require("minuet.lualine"),
						display_name = "both",
						provider_model_separator = ":",
						display_on_idle = true,
					},
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
