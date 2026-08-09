return {
  "neovim/nvim-lspconfig",
  ft = { "python", "go", "lua", "javascript", "typescript", "html", "css" },
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    require("lsp.init").setup()
    require("lsp.pyright")
    require("lsp.lua_ls")
    require("lsp.ts_ls")
    require("lsp.html_css")
  end,
}
