return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format" },
        lua = { "stylua" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        json = { "prettier" },
        markdown = { "prettier" },
      },
      format_on_save = {
        timeout_ms = 3000,
        lsp_fallback = false,
      },
    })

    -- 手动格式化，复用之前的 <leader>rf 键位
    vim.keymap.set({ "n", "v" }, "<leader>rf", function()
      require("conform").format({ async = true, lsp_fallback = false })
    end, { desc = "格式化当前文件" })
  end,
}
