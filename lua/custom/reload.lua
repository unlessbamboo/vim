-- ========================================
-- 适配 Lua 配置的「快速编辑/重载」功能
-- ========================================
-- 1. 快速编辑 Neovim 主配置文件（init.lua）
vim.keymap.set("n", "<leader>ee", ":e $MYVIMRC<CR>", { 
  desc = "编辑 Neovim 主配置文件（init.lua）" 
})

-- 2. 核心工具函数：重载 Lua 模块（支持单个模块/全部配置）
-- 清空模块缓存，使 require 时重新执行文件内容
local function clear_module_cache()
  for mod in pairs(package.loaded) do
    -- custom.*：自写功能模块；prev/lazyentry/bamboo：init.lua 直接引用的模块
    if mod:match("^custom%.") or mod == "prev" or mod == "lazyentry" or mod == "bamboo" then
      package.loaded[mod] = nil
    end
  end
end

local function reload_config()
  clear_module_cache()

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
-- 使用命名 augroup（clear=true），避免多次重载后自动命令堆叠
vim.api.nvim_create_augroup("ReloadConfig", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "ReloadConfig",
  pattern = vim.env.MYVIMRC,  -- 自动匹配 init.lua 路径（无需硬编码）
  callback = reload_config,
  desc = "保存 init.lua 后自动重载配置"
})
