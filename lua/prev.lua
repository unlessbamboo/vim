-- lua/prev.lua （修复版，兼容 Neovim 0.8+）
local M = {}  -- 必须定义模块表

-- 兼容低版本 Neovim 的 split 函数（替代 vim.split）
local function split_path(str, sep)
  sep = sep or ":"
  local result = {}
  for part in string.gmatch(str, "([^" .. sep .. "]+)") do
    table.insert(result, part)
  end
  return result
end

-- 核心逻辑（加全量异常捕获）
local function setup_npm_path()
  -- 全量 pcall 捕获所有错误，避免模块加载失败
  local ok, err = pcall(function()
    -- 1. 检查 npm 是否安装
    if vim.fn.executable("npm") ~= 1 then
      return
    end

    -- 2. 获取 npm prefix（屏蔽错误）
    local npm_prefix = vim.fn.system("npm config get prefix 2>/dev/null")
    -- 兼容不同系统的换行符（\n 或 \r\n）
    npm_prefix = string.gsub(npm_prefix, "[\n\r]", "")
    if npm_prefix == "" then
      return
    end

    -- 3. 拼接 bin 目录
    local npm_bin = npm_prefix .. "/bin"

    -- 4. 检查是否在 PATH 中（用兼容版 split）
    local path_str = vim.env.PATH or ""
    local path_list = split_path(path_str, ":")
    local is_in_path = false
    for _, path in ipairs(path_list) do
      if path == npm_bin then
        is_in_path = true
        break
      end
    end

    -- 5. 仅不在时添加
    if not is_in_path then
      vim.env.PATH = npm_bin .. ":" .. path_str
    end
  end)

  -- 可选：打印错误（调试用）
  -- if not ok then
  --   print("prev.lua 执行错误：" .. err)
  -- end
end

-- 暴露 setup 函数（核心：确保返回函数，不是布尔值）
function M.setup()
  -- 用 VimEnter 延迟执行，避免启动时机问题
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = setup_npm_path
  })
end

-- 必须返回模块表（关键！漏写会导致 require 返回 nil/false）
return M
