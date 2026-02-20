--[[
1. 依赖外部命令: fzf, fd
2. exclude_dirs为忽略目录
]]
return {
  "ibhagwan/fzf-lua",
  lazy = false,
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- 可选，显示图标
  config = function()
    -- 定义全局忽略列表
    local exclude_dirs = {
      "node_modules", "venv", ".venv", "__pycache__",
      ".git", "dist", "build", ".idea", "target",
      ".python-version", "package.json", "package-lock.json",
      "uv.lock",
    }
    local fd_exclude = vim.tbl_map(function(dir)
      return "--exclude " .. dir
    end, exclude_dirs)
    local rg_exclude = vim.tbl_map(function(dir)
      return "--glob '!" .. dir .. "/**'"
    end, exclude_dirs)

    -- 基础配置（按需调整）
    require("fzf-lua").setup({
      -- 通用设置
      winopts = {
        border = "rounded", -- 圆角窗口
        height = 0.8,       -- 窗口高度
        width = 0.8,        -- 窗口宽度
      },
      -- 常用功能配置
      files = {
        prompt = "Files> ",
        git_icons = true,   -- git 状态图标
        file_icons = true,  -- 文件类型图标
        cmd = table.concat({
          "fd --type f", "--hidden", "--follow",
          unpack(fd_exclude) -- 展开排除参数
        }, " "),
      },
      grep = {
        prompt = "Grep> ",
        rg_opts = table.concat({
          "--hidden --column --line-number --no-heading --color=always",
          unpack(rg_exclude)
        }, " "),
      },
    })

    -- 绑定常用快捷键（和你的 LSP 快捷键风格统一）
    local opts = { noremap = true, silent = true }
    vim.keymap.set("n", "<leader>ff", "<cmd>lua require('fzf-lua').files()<CR>", opts) -- 查找文件
    vim.keymap.set("n", "<leader>fg", "<cmd>lua require('fzf-lua').live_grep()<CR>", opts) -- 实时文本搜索
    vim.keymap.set("n", "<leader>fb", "<cmd>lua require('fzf-lua').buffers()<CR>", opts) -- 查找缓冲区
    vim.keymap.set("n", "<leader>fh", "<cmd>lua require('fzf-lua').help_tags()<CR>", opts) -- 查找帮助
    vim.keymap.set("n", "<leader>fr", "<cmd>lua require('fzf-lua').lsp_references()<CR>", opts) -- LSP 引用（适配你的 Pyright）
  end,
}
