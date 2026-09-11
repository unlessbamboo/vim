--[[
用途：按下 leader（,）或其它前缀键后延迟弹出提示框，展示可用快捷键及其 desc。
用法：按 <leader> 稍等片刻即弹出；映射需带 desc 才会显示有意义的说明。
无外部依赖。
]]
return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
}
