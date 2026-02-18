-- ========================================
-- 基础核心配置（全局设置）
-- ========================================
-- 设置 leader 键为逗号
vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- 自动检测文件类型 + 语法高亮
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")
vim.opt.syntax = "enable" -- 兼容 syntax enable

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
-- 折叠配置
-- ========================================
vim.opt.foldmethod = "indent" -- 基于缩进折叠（替代 syntax 折叠）
-- vim.opt.foldmethod = "syntax" -- 注释：如需语法折叠取消注释
vim.opt.foldenable = false -- 关闭默认折叠（nofoldenable → foldenable=false）
vim.opt.foldlevelstart = 99 -- 启动时展开所有折叠

-- 空格键切换折叠
vim.keymap.set("n", "<space>", "za", { desc = "切换折叠状态" })
vim.keymap.set("v", "<space>", "zf", { desc = "创建折叠" })

-- ========================================
-- vimrc 重载配置
-- ========================================
require('reload')

-- ========================================
-- 制表符/缩进配置
-- ========================================
vim.opt.autoindent = true -- 自动缩进
vim.opt.shiftwidth = 4 -- 缩进宽度
vim.opt.tabstop = 4 -- Tab 键宽度
vim.opt.expandtab = true -- Tab 转为空格
vim.opt.backspace = { "indent", "eol", "start" } -- Backspace 支持
vim.opt.whichwrap = { b = true, s = true, ["<"] = true, [">"] = true } -- 行间移动支持

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

-- ========================================
-- 语言特定缩进配置（html/css/js 等）
-- ========================================
-- HTML 缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = "html",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
  desc = "HTML 文件缩进为 2 空格"
})

-- htmldjango 缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = "htmldjango",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
  desc = "htmldjango 文件缩进为 4 空格"
})

-- CSS 缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = "css",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
  desc = "CSS 文件缩进为 2 空格"
})

-- Ruby 缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
  desc = "Ruby 文件缩进为 2 空格"
})

-- JavaScript 缩进
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
  desc = "JS 文件缩进为 2 空格"
})

-- HTML 脚本缩进
vim.g.html_indent_script1 = "zero"

-- ========================================
-- XML 格式化配置
-- ========================================
vim.api.nvim_create_autocmd("FileType", {
  pattern = "xml",
  callback = function()
    vim.opt_local.equalprg = "xmllint --format --recover - 2>/dev/null"
  end,
  desc = "XML 文件使用 xmllint 格式化"
})

-- ========================================
-- 大文件优化配置
-- ========================================
if not vim.g.my_auto_commands_loaded then
  vim.g.my_auto_commands_loaded = 1
  local large_file_size = 1024 * 1024 * 10 -- 10MB

  vim.api.nvim_create_augroup("LargeFile", { clear = true })
  vim.api.nvim_create_autocmd("BufReadPre", {
    group = "LargeFile",
    callback = function(args)
      local file_size = vim.fn.getfsize(args.file)
      if file_size > large_file_size then
        vim.opt.eventignore:append("FileType")
        vim.opt_local.swapfile = false
        vim.opt_local.bufhidden = "unload"
        vim.opt_local.buftype = "nowrite"
        vim.opt_local.undolevels = -1
      else
        vim.opt.eventignore:remove("FileType")
      end
    end,
    desc = "大文件优化（只读、关闭语法高亮等）"
  })
end

-- 遍历 plugin/ 目录下所有 .vim 文件并加载
-- local config_dir = vim.fn.stdpath("config")
-- local plugin_dir = config_dir .. "/plugin"
-- local vim_files = vim.fn.glob(plugin_dir .. "/*.vim", false, true)
-- for _, file in ipairs(vim_files) do
--   if vim.fn.filereadable(file) == 1 then
--     print("加载 Vim 配置文件中：" .. file)
--     vim.cmd.source(file)
--   end
-- end

-- ========================================
-- HTML 预览快捷键
-- ========================================
vim.keymap.set("n", "<leader>hml", ":!open % <CR>", { desc = "预览 HTML 文件" })

-- 与 VSCode 不同，vim 没有工作区支持。解决方案是从打开的文件解析工作区文件夹
-- 参考: https://github.com/neoclide/coc.nvim/wiki/Using-workspaceFolders
vim.api.nvim_create_augroup("CocHtmlRootPattern", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "CocHtmlRootPattern", -- 归属到指定组
  pattern = "html",
  callback = function()
    vim.b.coc_root_patterns = { ".git", ".env", "tailwind.config.js", "tailwind.config.cjs" }
  end,
  desc = "为 HTML 文件设置 CoC 根目录识别规则"
})
