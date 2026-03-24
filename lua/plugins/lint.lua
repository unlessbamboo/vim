return {
  "mfussenegger/nvim-lint",
  lazy = true,
  event = { "BufWritePost", "BufEnter" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      python = { "ruff" },
      javascript = { "eslint" },
      typescript = { "eslint" },
      vue = { "eslint" },
      go = { "golangci-lint" },
      sh = { "shellcheck" },
    }
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}
