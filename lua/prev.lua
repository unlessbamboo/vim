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

-- init.lua 最顶部添加：加载 nvm 环境
local function load_nvm_npm_path()
  -- 全量 pcall 捕获错误，避免阻塞启动
  local ok, _ = pcall(function()
    local home_dir = vim.fn.expand("~")
    local nvm_versions_dir = home_dir .. "/.nvm/versions/node"
    local nvm_npm_bin = ""

    -- 步骤1：读取 nvm 默认版本别名（纯文件读取，无 Shell）
    local default_alias_file = home_dir .. "/.nvm/alias/default"
    local default_alias = ""
    if vim.fn.filereadable(default_alias_file) == 1 then
      local f = io.open(default_alias_file, "r")
      default_alias = f:read("*a")
      f:close()
      default_alias = string.gsub(default_alias, "[\n\r%s]", "") -- 清理空白
    end

    -- 步骤2：枚举 nvm 版本目录，验证有效性（核心！兼容所有版本格式）
    if vim.fn.isdirectory(nvm_versions_dir) == 1 then
      -- 读取所有 node 版本目录（比如 v20.20.0、v18.19.0、lts/hydrogen）
      local ver_dirs = vim.fn.readdir(nvm_versions_dir)
      for _, ver_dir in ipairs(ver_dirs) do
        -- 优先匹配默认别名（比如 lts/hydrogen → 对应目录）
        if ver_dir == default_alias then
          local bin_path = nvm_versions_dir .. "/" .. ver_dir .. "/bin"
          if vim.fn.isdirectory(bin_path) == 1 then
            nvm_npm_bin = bin_path
            break
          end
        end
        -- 匹配任意版本格式（v20.20.0、v20.20、20.20.0 等）
        if string.match(ver_dir, "^v?%d+%.%d+") then
          local bin_path = nvm_versions_dir .. "/" .. ver_dir .. "/bin"
          if vim.fn.isdirectory(bin_path) == 1 then
            nvm_npm_bin = bin_path
            -- 优先选高版本（比如 v20.20.0 比 v18.19.0 优先）
            if string.match(ver_dir, "^v20") then -- 替换为你的主版本号，比如 v20/v18
              break
            end
          end
        end
      end
    end

    -- 步骤3：兜底（手动指定已知有效路径，最后保障）
    local fallback_bin = home_dir .. "/.nvm/versions/node/v20.20.0/bin" -- 替换为你的实际路径
    if nvm_npm_bin == "" and vim.fn.isdirectory(fallback_bin) == 1 then
      nvm_npm_bin = fallback_bin
    end

    -- 步骤4：添加到 PATH（仅当路径有效）
    if nvm_npm_bin ~= "" then
      if not string.find(vim.env.PATH, nvm_npm_bin, 1, true) then
        vim.env.PATH = nvm_npm_bin .. ":" .. vim.env.PATH
      end
    else
      vim.notify([[au VimEnter * ++once lua print("未找到有效 nvm 路径，使用系统默认")]])
    end
  end)

  -- 错误不影响启动，仅静默记录
  if not ok then
    vim.notify([[au VimEnter * ++once lua print("加载 nvm 路径失败，使用系统默认 npm")]])
  end
end

-- 核心逻辑（加全量异常捕获）
local function setup_npm_path()
  -- 全量 pcall 捕获所有错误，避免模块加载失败
  local ok, err = pcall(function()
    -- 1. 检查 npm 是否安装
    if vim.fn.executable("npm") ~= 1 then
      return
    end

    -- 启动时加载 nvm 环境
    load_nvm_npm_path()
  end)
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
