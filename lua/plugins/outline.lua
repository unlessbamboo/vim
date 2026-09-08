--[[
1. 代码大纲侧边栏（类/变量/函数列表，类似 VSCode Outline）
2. 依赖 LSP 的 documentSymbol 能力，无额外外部命令
3. 快捷键：
   - <F2>      文件树 + 大纲 一起开/关（大纲堆在文件树下方）
   - <leader>o 只开/关大纲（nvim-tree 已开时堆到其下方）
   大纲默认左侧、宽度 25，与 nvim-tree 对齐
]]

-- 找到当前标签页里指定 filetype 的窗口
local function win_by_ft(ft)
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == ft then
			return win
		end
	end
end

-- 打开大纲；若 nvim-tree 已开，则堆到其下方（水平分栏）
local function open_outline()
	local outline = require("outline")
	if outline.is_open() then
		return
	end

	-- 如果焦点在文件树里，先跳回代码窗口，避免大纲把树当成 code 窗口
	local tree = win_by_ft("NvimTree")
	if tree and vim.api.nvim_get_current_win() == tree then
		vim.cmd("wincmd p")
	end

	local opts = { focus_outline = false }
	if tree then
		-- 切到文件树窗口后在其下方开一个水平分栏
		opts.split_command = ("call win_gotoid(%d) | belowright split"):format(tree)
	end
	outline.open(opts)
end

-- <leader>o：只切换大纲
local function toggle_outline()
	local outline = require("outline")
	if outline.is_open() then
		outline.close()
	else
		open_outline()
	end
end

-- <F2>：文件树 + 大纲一起开 / 关
local function toggle_sidebars()
	local outline = require("outline")
	local tree_open = win_by_ft("NvimTree") ~= nil
	local outline_open = outline.is_open()

	if tree_open or outline_open then
		-- 任意一个开着就全部关掉
		if outline_open then
			outline.close()
		end
		if tree_open then
			vim.cmd("NvimTreeClose")
		end
	else
		-- 都关着：先开文件树，再把大纲堆到它下方
		vim.cmd("NvimTreeOpen")
		open_outline()
	end
end

return {
	"hedyhli/outline.nvim",
	cmd = { "Outline", "OutlineOpen" },
	keys = {
		{ "<F2>", toggle_sidebars, desc = "切换文件树+大纲" },
		{ "<leader>o", toggle_outline, desc = "切换代码大纲" },
	},
	opts = {
		outline_window = {
			position = "left", -- 左侧
			width = 25, -- 固定 25 列，和 nvim-tree 对齐
			relative_width = false, -- width 按列算，不按百分比
			auto_close = false, -- 选中 symbol 跳转后不关闭大纲窗口
			auto_jump = true,
		},
		outline_items = {
			show_symbol_lineno = true,
		},
	},
}
