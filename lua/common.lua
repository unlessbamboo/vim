-- ========================================
-- 基础核心配置（全局设置）
-- ========================================

-- ========================================
-- vim-markdown 插件配置
-- ========================================
vim.g.vim_markdown_toc_autofit = 1 -- 自动适配 TOC 窗口大小
vim.g.vim_markdown_folding_level = 6 -- 折叠层级
-- vim.g.vim_markdown_folding_style_pythonic = 1 -- 注释：如需启用取消注释
vim.opt.conceallevel = 2 -- 启用隐藏（隐藏 ``` 等标记）

-- 映射 TOC 快捷键
vim.keymap.set("n", "<leader>toc", ":Toc<CR>", { desc = "打开 markdown 目录" })

-- ========================================
-- bash-support.vim 配置
-- ========================================
vim.g.BASH_AuthorName = 'bamboo'
vim.g.BASH_Email = 'unlessbamboo@gmail.com'
vim.g.BASH_Company = 'BigUniverse'

-- ========================================
-- 通用编辑器配置
-- ========================================
-- 搜索相关
vim.opt.hlsearch = true -- 高亮搜索结果
vim.keymap.set("n", "<leader>hl", ":nohlsearch<Bar>:echo<CR>", { desc = "取消搜索高亮" })
vim.opt.ignorecase = true -- 搜索忽略大小写
vim.opt.incsearch = true -- 实时增量搜索
-- 宏快捷键：leader+h 映射到 @a 寄存器
vim.keymap.set("n", "<leader>h", "@", { desc = "执行宏（@a 寄存器）" })

-- Crontab 编辑配置
if vim.env.VIM_CRONTAB == "true" then
  vim.opt.backup = false -- 关闭备份
  vim.opt.writebackup = false -- 关闭写入备份
end

-- 界面显示
vim.opt.cursorline = true -- 高亮当前行
vim.opt.number = true -- 显示行号（nu → number）
vim.opt.laststatus = 2 -- 始终显示状态栏
vim.opt.ruler = true -- 显示光标位置（行/列）
vim.opt.showcmd = true -- 显示正在输入的命令
vim.opt.mouse = "a" -- 启用鼠标支持（所有模式）

-- 补全配置
vim.opt.completeopt = { "longest", "menu" } -- 补全仅显示最长匹配 + 菜单

-- 时间插入快捷键
vim.keymap.set("n", "<leader>date", function()
  -- 按下快捷键时，实时获取当前日期
  local current_date = os.date("%Y-%m-%d")
  -- 插入到光标位置（"c" 表示字符模式，后两个 true 表示保持光标位置）
  vim.api.nvim_put({current_date}, "c", true, true)
end, { desc = "插入日期", noremap = true, silent = true })

-- 时间快捷键的最优版
vim.keymap.set("n", "<leader>time", function()
  local current_time = os.date("%Y-%m-%d %T")
  vim.api.nvim_put({current_time}, "c", true, true)
end, { desc = "插入时间", noremap = true, silent = true })

-- Paste 模式切换
vim.keymap.set("n", "<leader>p", ":set paste!<CR>", { desc = "切换粘贴模式" })

-- 保存所有文件
vim.keymap.set("n", "<leader>wa", ":wa<CR>", { desc = "保存所有文件" })

-- 滚动位置映射
vim.keymap.set("n", "<leader>mo3", "30%", { desc = "跳转到 30% 位置" })
vim.keymap.set("n", "<leader>mo5", "50%", { desc = "跳转到 50% 位置" })
vim.keymap.set("n", "<leader>mo8", "80%", { desc = "跳转到 80% 位置" })

-- ========================================
-- 窗口分割/跳转配置
-- ========================================
-- 窗口分割
vim.keymap.set("n", "<leader>vs", ":vs<CR>", { desc = "垂直分割窗口" })
vim.keymap.set("n", "<leader>sp", ":sp<CR>", { desc = "水平分割窗口" })

-- 窗口跳转
vim.keymap.set("n", "<leader>hw", "<C-w>h", { desc = "跳转到左侧窗口" })
vim.keymap.set("n", "<leader>lw", "<C-w>l", { desc = "跳转到右侧窗口" })
vim.keymap.set("n", "<leader>kw", "<C-w>k", { desc = "跳转到上方窗口" })
vim.keymap.set("n", "<leader>jw", "<C-w>j", { desc = "跳转到下方窗口" })
vim.keymap.set("n", "<leader>rw", "<C-w><C-r>", { desc = "旋转窗口布局" })

-- 窗口大小调整
vim.keymap.set("n", "<leader>=w", "<C-w>=", { desc = "所有窗口等宽等高" })
vim.keymap.set("n", "<leader>s_", ":resize -20<CR>", { desc = "窗口高度减少 20" })
vim.keymap.set("n", "<leader>s+", ":resize +20<CR>", { desc = "窗口高度增加 20" })
vim.keymap.set("n", "<leader>v_", ":vertical resize -20<CR>", { desc = "窗口宽度减少 20" })
vim.keymap.set("n", "<leader>v+", ":vertical resize +20<CR>", { desc = "窗口宽度增加 20" })
