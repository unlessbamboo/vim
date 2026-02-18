-- ========================================
-- 适配 Lua 配置的「快速编辑/重载」功能
-- ========================================
-- 1. 快速编辑 Neovim 主配置文件（init.lua）
vim.keymap.set("n", "<leader>ee", ":e $MYVIMRC<CR>", { 
  desc = "编辑 Neovim 主配置文件（init.lua）" 
})

-- 2. 核心工具函数：重载 Lua 模块（支持单个模块/全部配置）
local function reload_config()
  -- 清空所有自定义模块的缓存（根据你的目录结构调整）
  local modules_to_reload = {
    "entrypoint",        -- 核心入口模块
    "config.editor",     -- 编辑器配置模块
    "config.keymaps",    -- 快捷键模块
    "config.autocmds",   -- 自动命令模块
    "utils.common"       -- 工具函数模块
  }

  -- 逐个清空缓存
  for _, mod in ipairs(modules_to_reload) do
    package.loaded[mod] = nil
  end

  -- 重新加载主配置文件（init.lua）
  dofile(vim.env.MYVIMRC)
  
  -- 提示重载成功
  vim.notify("Neovim 配置已重载 ✨", vim.log.levels.INFO)
end

-- 3. 快速重载配置（替换原 <leader>ss）
vim.keymap.set("n", "<leader>ss", reload_config, { 
  desc = "重载 Neovim Lua 配置" 
})

-- 4. 保存 init.lua 后自动重载（替换原 BufWritePost .vimrc）
vim.api.nvim_create_autocmd("BufWritePost", {
  pattern = vim.env.MYVIMRC,  -- 自动匹配 init.lua 路径（无需硬编码）
  callback = reload_config,
  desc = "保存 init.lua 后自动重载配置"
})
