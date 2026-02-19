
-- 字体和背景,实际上基本是按照colors目录下的配置来设置的
vim.opt.background = "dark" -- 深色背景
vim.opt.guifont = "Monaco:h20" -- 设置字体和字号
vim.o.termguicolors = true  -- 增强：启用终端真彩色（语法高亮更鲜艳）
vim.cmd("colorscheme molokai")  -- 启用 molokai 配色
-- vim.api.nvim_set_hl(0, "LineNr", { fg = "#888888" }) -- 行号颜色


-- ========================================
-- 大文件优化配置
-- ========================================
vim.opt.redrawtime = 5000  -- 解决大文件无高亮
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
