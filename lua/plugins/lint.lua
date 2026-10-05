return {
  "mfussenegger/nvim-lint",
  lazy = true,
  event = { "BufWritePost", "BufEnter" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      python = { "ruff" },
      -- eslint_d 由 mason 安装（:MasonInstall eslint_d），不依赖 fnm 当前 node 版本的全局包
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      vue = { "eslint_d" },
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
