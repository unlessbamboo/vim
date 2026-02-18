--[[
1. 核心模块加载失败问题处理
    a. 检查插件是否已经安装:
        lua print(vim.fn.isdirectory(vim.fn.stdpath("data").."/lazy/nvim-treesitter"))
        输出1则表示插件已经安装
    b. 检查核心模块是否存在:
        lua print(vim.fn.filereadable(vim.fn.stdpath("data").."/lazy/nvim-treesitter/lua/nvim-treesitter/configs.lua"))
        输出1表示文件存在,否则表示文件缺失
]]
return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    -- 新增：明确依赖 Lazy 加载完成
    dependencies = { "folke/lazy.nvim" },
  },
  {
    "numToStr/Comment.nvim", -- 代码注释（依赖 treesitter）
    lazy = true,
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("Comment").setup() -- 默认配置，满足基础注释需求
    end,
  },
}

--[[
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = true,
  event = "BufReadPost",
  build = function()
    -- 强制安装解析器，解决 build 阶段不触发的问题
    require("nvim-treesitter.install").update({ with_sync = true })
  end,

  config = function()
    local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      vim.notify("nvim-treesitter 核心模块加载失败", vim.log.levels.ERROR)
      return
    end

    treesitter_configs.setup({
      -- 确保解析器安装配置生效
      ensure_installed = { "python", "go", "lua", "markdown" }, -- 明确需要的语言
      sync_install = false, -- 异步安装（不阻塞 Neovim 启动）
      auto_install = true, -- 打开文件时，自动安装缺失的解析器
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      -- 加一个钩子，避免安装失败时报错
      install = {
        -- 忽略安装失败的解析器，不影响整体使用
        ignore_install = { "" },
      },
    })

    -- 额外：检查解析器是否安装，未安装则提示（而非报错）
    local function check_ts_parsers()
      local parsers = require("nvim-treesitter.parsers")
      local missing = {}
      for _, lang in ipairs({ "python", "go", "lua", "markdown" }) do
        if not parsers.has_parser(lang) then
          table.insert(missing, lang)
        end
      end
      if #missing > 0 then
        vim.notify("缺失 treesitter 解析器：" .. table.concat(missing, ","), vim.log.levels.WARN)
        -- 自动安装缺失的解析器
        vim.cmd("TSInstall " .. table.concat(missing, " "))
      end
    end

    -- 延迟执行检查，避免启动时阻塞
    vim.defer_fn(check_ts_parsers, 1000)
  end,
  -- 新增：明确依赖 Lazy 加载完成
  dependencies = { "folke/lazy.nvim" },
}
]]
