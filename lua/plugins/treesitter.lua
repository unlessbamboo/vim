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
    config = function()
        require'nvim-treesitter'.install {
            'rust', 'javascript', 'python', 'html', 'css', 'markdown',
            'go',
        }
    end,
  },
  {
    "numToStr/Comment.nvim", -- 代码注释（依赖 treesitter）
    lazy = true,
    event = "BufReadPost",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("Comment").setup({
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = nil,
        toggler = {
            line = '<leader>cc',
            block = '<leader>bc',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            line = '<leader>c',
            block = '<leader>b',
        },
      }) -- 默认配置，满足基础注释需求
    end,
  },
}
