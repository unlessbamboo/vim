-- ========================================
-- 2. Lazy.nvim 初始化（先安装 Lazy 后启用）
-- ========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- ========================================
-- 3. Lazy.nvim 插件配置（替代原 vim-plug 配置）
-- ========================================
require("lazy").setup(
  {
      -- 基础
      require("plugins.basic"),
      require("plugins.translate").setup(),
      require("plugins.fzf"),
      require("plugins.filetree"),
      -- 插件分组：语言/语法支持
      require("plugins.language"),
      -- 插件分组：代码补全（LSP + cmp）
      require("plugins.lsp"),
      -- treesitter
      require("plugins.treesitter"),
  }, 
  {
      install = {
        missing = true, -- 自动安装缺失插件
      },
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
     },
  }
)

-- ========================================
-- 4. 补充
-- ========================================
