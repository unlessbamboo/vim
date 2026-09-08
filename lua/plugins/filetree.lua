--[[
依赖项:
  a. 需要提前安装字体, brew install font-hack-nerd-font
  b. 需要iterm2终端选择该字体,才会显示相应的图标,否则都是问号

--]]

return {
	"nvim-tree/nvim-tree.lua",
	lazy = false, -- 启动时加载（也可设为 lazy=true，通过快捷键触发）
	dependencies = {
		"nvim-tree/nvim-web-devicons", -- 必装，显示文件类型图标
	},
	config = function()
		-- 初始化配置
		require("nvim-tree").setup({
			-- 核心设置
			sort_by = "case_sensitive", -- 排序规则（大小写敏感）
			view = {
				width = 25, -- 侧边栏宽度（可手动拖动调整）
				side = "left", -- 显示在左侧（可选 right）
				relativenumber = false, -- 关闭相对行号
			},
			renderer = {
				group_empty = true, -- 折叠空目录
				icons = {
					show = {
						file = true, -- 显示文件图标
						folder = true, -- 显示文件夹图标
						git = true, -- 显示 Git 状态图标
					},
					glyphs = {
						folder = {
							arrow_closed = "", -- 折叠箭头
							arrow_open = "", -- 展开箭头
						},
						git = {
							unstaged = "✗",
							staged = "✓",
							unmerged = "",
							renamed = "➜",
							untracked = "★",
							deleted = "",
							ignored = "◌",
						},
					},
				},
			},
			-- 功能开关
			actions = {
				open_file = {
					quit_on_open = false, -- 打开文件后不关闭树
					resize_window = true, -- 打开文件时自动调整窗口大小
				},
			},
			filters = {
				-- 忽略指定文件/目录（和你 fzf-lua 的忽略规则一致）
				custom = {
					"^.git$",
					"node_modules",
					"venv",
					".venv",
					"__pycache__",
					"dist",
					"build",
				},
				dotfiles = false, -- 显示隐藏文件（.开头的文件）
			},
			git = {
				enable = true, -- 启用 Git 状态显示
				ignore = true, -- 遵循 .gitignore 规则
			},
			-- 自动关闭：当树是最后一个窗口时关闭 Neovim
			hijack_unnamed_buffer_when_opening = false,
		})

		-- 绑定快捷键（和你的 fzf-lua 快捷键风格统一）
		local opts = { noremap = true, silent = true }
		-- <F2> 改为「文件树 + 大纲」一起开关，定义在 lua/plugins/outline.lua
		vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFile<CR>", opts) -- 定位当前文件在树中的位置
		vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", opts) -- 折叠所有目录
		vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", opts) -- 刷新树形窗口
	end,
}
