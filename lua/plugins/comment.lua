return {
	{
		"numToStr/Comment.nvim", -- 代码注释（依赖 treesitter）
		lazy = true,
		event = "BufReadPost",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("Comment").setup({
				padding = true,
				sticky = true,
				ignore = nil,
				toggler = {
					line = "<leader>cc",
					block = "<leader>bc",
				},
				---LHS of operator-pending mappings in NORMAL and VISUAL mode
				opleader = {
					line = "<leader>c",
					block = "<leader>b",
				},
			}) -- 默认配置，满足基础注释需求
		end,
	},
}
