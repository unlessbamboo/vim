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
require("lazy").setup({
  -- 插件分组：窗口/缓冲区管理
  {
    "vim-scripts/winmanager", -- 窗口管理
    lazy = true, -- 懒加载，按需启用
    cmd = { "WMToggle", "WMFocus" }, -- 仅执行这些命令时加载
  },
  {
    "scrooloose/nerdtree", -- 树形文件浏览器
    lazy = true,
    cmd = { "NERDTreeToggle", "NERDTree" },
  },
  {
    "jlanzarotta/bufexplorer", -- 缓冲区浏览
    lazy = true,
    cmd = { "BufExplorer", "BufExplorerHorizontal" },
  },

  -- 插件分组：语言/语法支持
  {
    "vim-scripts/bash-support.vim", -- bash 语法支持
    lazy = true,
    ft = { "sh", "bash" }, -- 仅打开 sh/bash 文件时加载
  },
  {
    "cespare/vim-toml", -- toml 语法支持
    lazy = true,
    ft = "toml",
  },
  {
    "preservim/vim-markdown", -- markdown 语法支持
    lazy = true,
    ft = "markdown",
    dependencies = { "godlygeek/tabular" }, -- 依赖 tabular 插件
  },
  {
    "mattn/emmet-vim", -- HTML/JS/CSS 快速编写
    lazy = true,
    ft = { "html", "css", "javascript", "vue" },
  },
  {
    "fatih/vim-go", -- go 开发工具
    lazy = true,
    ft = "go",
    build = ":GoUpdateBinaries", -- 安装后自动更新二进制工具
  },
  {
    "Vimjas/vim-python-pep8-indent", -- python 缩进规范
    lazy = true,
    ft = "python",
  },

  -- 插件分组：代码补全（LSP + cmp）
  {
    "neovim/nvim-lspconfig", -- LSP 配置简化工具
    lazy = true,
    ft = { "python", "go", "lua", "javascript", "typescript", "html", "css" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- cmp 对接 LSP 的桥梁
    },
  },
  {
    "hrsh7th/nvim-cmp", -- 补全核心框架
    lazy = true,
    event = "InsertEnter", -- 进入插入模式时加载
    dependencies = {
      "hrsh7th/cmp-buffer", -- 缓冲区内容补全
      "hrsh7th/cmp-path", -- 文件路径补全
      "hrsh7th/cmp-cmdline", -- 命令行补全
    },
    config = function()
      -- nvim-cmp 核心配置（保留原有补全逻辑）
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            -- 若后续添加代码片段插件，需在这里配置
            vim.fn["vsnip#anonymous"](args.body) -- 兼容原有 vsnip 逻辑（如有）
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" }, -- LSP 补全（最高优先级）
          { name = "buffer" },   -- 缓冲区补全
          { name = "path" },     -- 路径补全
        }),
        mapping = cmp.mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({ select = true }), -- 回车确认补全
          ["<Tab>"] = cmp.mapping.select_next_item(),        -- Tab 下一个
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),     -- Shift+Tab 上一个
        }),
      })
      -- 命令行补全配置
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
      })
    end,
  },

  -- 插件分组：代码检查/格式化
  {
    "mfussenegger/nvim-lint", -- 代码检查（替代 ALE）
    lazy = true,
    event = { "BufWritePost", "BufEnter" }, -- 保存/打开文件时触发
    config = function()
      local lint = require("lint")
      -- 配置各语言检查工具（按需扩展）
      lint.linters_by_ft = {
        python = { "pylint", "flake8" },
        javascript = { "eslint" },
        typescript = { "eslint" },
        vue = { "eslint" },
        go = { "golangci-lint" },
        sh = { "shellcheck" },
      }
      -- 保存文件时自动检查
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function() lint.try_lint() end,
      })
    end,
  },
  {
    "sbdchd/neoformat", -- 代码格式化
    lazy = true,
    cmd = "Neoformat",
    ft = { "python", "go", "javascript", "typescript", "vue", "html", "css" },
  },
  {
    "psf/black", -- python 格式化
    lazy = true,
    ft = "python",
    branch = "stable",
  },

  -- 插件分组：语法解析/注释
  {
      "nvim-treesitter/nvim-treesitter",
      lazy = true,
      event = "BufReadPost",
      build = function()
        -- 强制安装解析器，解决 build 阶段不触发的问题
        local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
        ts_update()
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

  -- 插件分组：工具类
  {
    "vim-scripts/genutils", -- 通用工具函数
    lazy = true,
  },
  {
    "yianwillis/vimcdoc", -- 中文文档
    lazy = true,
    cmd = "HelpDoc",
  },
  {
    "tpope/vim-fugitive", -- Git 集成
    lazy = true,
    cmd = { "Git", "Gstatus", "Gcommit", "Gblame" },
  },
  {
    "junegunn/fzf", -- 模糊搜索
    lazy = true,
    build = "./install --bin", -- 仅安装二进制文件
    cmd = "FZF",
  },
  {
    "junegunn/fzf.vim", -- fzf vim 集成
    lazy = true,
    dependencies = { "junegunn/fzf" },
    cmd = { "Files", "Buffers", "Rg" },
  },
  {
    "godlygeek/tabular", -- 文本对齐（markdown 依赖）
    lazy = true,
    cmd = "Tabularize",
  },
  {
    "powerline/powerline", -- 状态栏
    lazy = false, -- 启动时加载（状态栏需全局生效）
  },
  { "tomasr/molokai" }, -- Molokai 配色插件（核心）
  }, {
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
