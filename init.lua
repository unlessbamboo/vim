-- ========================================
-- 1. 系统环境与路径配置（替代原有 Vimscript 路径逻辑）
-- ========================================
vim.g.mapleader = ","
local ok, prev = pcall(require, "prev")
if ok and prev and type(prev.setup) == "function" then
  prev.setup()  -- 仅当模块加载成功且有 setup 函数时执行
else
  print("加载 prev.lua 失败：" .. (prev or "模块不存在"))
end

-- ========================================
-- 2. 全局镜像配置（适配所有基于 git 的插件）
-- ========================================
-- 替换 git clone 的默认源（FastGit 镜像，稳定）
vim.g.git_default_url_format = "https://hub.fastgit.xyz/%s.git"

-- ========================================
-- 3. Lazy.nvim 插件镜像配置（核心）
-- ========================================
-- 配置 Lazy.nvim 下载插件时使用镜像
local lazy_mirror = "https://hub.fastgit.xyz/"
-- 覆盖 Lazy.nvim 的默认 git 克隆参数
vim.api.nvim_create_autocmd("User", {
  pattern = "LazySetup",
  callback = function()
    require("lazy.core.config").options.git.url_format = lazy_mirror .. "%s.git"
  end,
})
require("lazyconfig")


-- ========================================
-- 4. 通用和入口配置
-- ========================================
require("commonconfig")
require('entrypoint')

-- ========================================
-- 5. 加载自定义 Lua 模块（bamboo）
-- ========================================
pcall(require, "bamboo") -- pcall 避免模块不存在时报错
