return {
  "lewis6991/gitsigns.nvim",
  event = "BufReadPre",
  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "]g", gs.next_hunk, vim.tbl_extend("force", opts, { desc = "下一个 git 变更块" }))
        vim.keymap.set("n", "[g", gs.prev_hunk, vim.tbl_extend("force", opts, { desc = "上一个 git 变更块" }))
        vim.keymap.set("n", "<leader>gb", gs.blame_line, vim.tbl_extend("force", opts, { desc = "git blame 当前行" }))
        vim.keymap.set("n", "<leader>gp", gs.preview_hunk, vim.tbl_extend("force", opts, { desc = "预览变更块" }))
        vim.keymap.set("n", "<leader>gs", gs.stage_hunk, vim.tbl_extend("force", opts, { desc = "暂存变更块" }))
        vim.keymap.set("n", "<leader>gu", gs.undo_stage_hunk, vim.tbl_extend("force", opts, { desc = "取消暂存变更块" }))
      end,
    })
  end,
}
