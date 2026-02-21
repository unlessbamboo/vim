-- 缩进和折叠配置

-- ========================================
-- 折叠配置
-- ========================================
vim.opt.foldmethod = "indent" -- 基于缩进折叠（替代 syntax 折叠）
-- vim.opt.foldmethod = "syntax" -- 注释：如需语法折叠取消注释
vim.opt.foldenable = false -- 关闭默认折叠（nofoldenable → foldenable=false）
vim.opt.foldlevelstart = 99 -- 启动时展开所有折叠

-- 空格键切换折叠
vim.keymap.set("n", "<space>", "za", { desc = "切换折叠状态" })
vim.keymap.set("v", "<space>", "zf", { desc = "创建折叠" })

-- HTML 预览快捷键
vim.keymap.set("n", "<leader>hml", ":!open % <CR>", { desc = "预览 HTML 文件" })

-- ========================================
-- 制表符/缩进配置
-- ========================================

-- 自动检测文件类型 + 语法高亮
vim.o.filetype = "on"
vim.cmd("filetype plugin on")
vim.o.cindent = true     -- C 风格缩进（适配多数编程语言）
vim.opt.syntax = "enable" -- 兼容 syntax enable
-- 缩进
vim.o.tabstop = 4          -- Tab 显示为 4 空格
vim.o.shiftwidth = 4       -- 默认缩进步长 4
vim.o.expandtab = true     -- Tab 转空格
vim.o.softtabstop = 4      -- 编辑时 Tab 插入 4 空格
vim.o.autoindent = true    -- 自动缩进
vim.o.smartindent = true   -- 智能缩进
vim.opt.backspace = { "indent", "eol", "start" } -- Backspace 支持
vim.opt.whichwrap = { b = true, s = true, ["<"] = true, [">"] = true } -- 行间移动支持

-- ========================================
-- 语言特定缩进配置（html/css/js 等）
-- ========================================
local indent_autocmd = vim.api.nvim_create_augroup("CustomIndent", { clear = true })
-- 匹配后端文件
vim.api.nvim_create_autocmd("FileType", {
  group = indent_autocmd,
  pattern = { "python", "java", "cpp", "c", "htmldjango" },
  callback = function()
    vim.opt_local.tabstop = 4      -- Python 用 4 空格
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
  end,
  desc = "Python 缩进：4 空格"
})

vim.api.nvim_create_autocmd("FileType", {
  group = indent_autocmd,
  pattern = { "html", "css", "javascript", "typescript", "vue" }, -- 前端文件
  callback = function()
    vim.opt_local.tabstop = 2      -- 前端文件用 2 空格
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
  desc = "前端文件缩进：2 空格"
})

vim.api.nvim_create_autocmd("FileType", {
  group = indent_autocmd,
  pattern = { "lua", "ruby" }, -- Lua 文件（比如 Neovim 配置）
  callback = function()
    vim.opt_local.tabstop = 2      -- Lua 用 2 空格
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
  end,
  desc = "Lua 缩进：2 空格"
})

-- XML 格式化配置
vim.api.nvim_create_autocmd("FileType", {
  pattern = "xml",
  callback = function()
    vim.opt_local.equalprg = "xmllint --format --recover - 2>/dev/null"
  end,
  desc = "XML 文件使用 xmllint 格式化"
})
