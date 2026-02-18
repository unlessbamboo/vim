-- ========================================
-- 通用编辑器配置
-- ========================================
-- 宏快捷键：leader+h 映射到 @a 寄存器
vim.keymap.set("n", "<leader>h", "@", { desc = "执行宏（@a 寄存器）" })

-- Crontab 编辑配置
if vim.env.VIM_CRONTAB == "true" then
  vim.opt.backup = false -- 关闭备份
  vim.opt.writebackup = false -- 关闭写入备份
end

-- 搜索相关
vim.opt.hlsearch = true -- 高亮搜索结果
vim.keymap.set("n", "<leader>hl", ":nohlsearch<Bar>:echo<CR>", { desc = "取消搜索高亮" })
vim.opt.ignorecase = true -- 搜索忽略大小写
vim.opt.incsearch = true -- 实时增量搜索

-- 界面显示
vim.opt.cursorline = true -- 高亮当前行
vim.opt.number = true -- 显示行号（nu → number）
vim.opt.laststatus = 2 -- 始终显示状态栏
vim.opt.ruler = true -- 显示光标位置（行/列）
vim.opt.showcmd = true -- 显示正在输入的命令
vim.opt.background = "dark" -- 深色背景
vim.opt.guifont = "Monaco:h20" -- 设置字体和字号
vim.opt.mouse = "a" -- 启用鼠标支持（所有模式）
-- vim.keymap.set("n", "<F4>", ":let &mouse = (&mouse == 'a' ? 'v' : 'a')<CR>", { desc = "切换鼠标模式" }) -- 注释：如需启用取消注释

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

-- 解决大文件无高亮
vim.opt.redrawtime = 5000
