-- ========================================
-- 1. 系统环境与路径配置（替代原有 Vimscript 路径逻辑）
-- ========================================
vim.g.mapleader = ","
vim.g.maplocalleader = ","
local ok, prev = pcall(require, "prev")
if ok and prev and type(prev.setup) == "function" then
	prev.setup() -- 仅当模块加载成功且有 setup 函数时执行
else
	print("加载 prev.lua 失败：" .. (prev or "模块不存在"))
end

-- ========================================
-- 2. 插件源配置（恢复官方 GitHub 源）
-- ========================================
-- FastGit 镜像已停运，这里不再覆盖 lazy.nvim 的默认 git 源
-- （默认 url_format 即 https://github.com/%s.git）
require("lazyentry")

-- ========================================
-- 4. 通用和入口配置
-- NOTE: 对于自定义的插件,不能使用lazy来进行加载, lazy是插件管理
-- ========================================
require("custom.translate").setup()
require("custom.indent")
require("custom.color")
require("custom.reload")
require("custom.common")
require("custom.quickfix")

-- ========================================
-- 5. 加载自定义 Lua 模块（bamboo）
-- ========================================
pcall(require, "bamboo") -- pcall 避免模块不存在时报错
