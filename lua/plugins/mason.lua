return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        -- 仅列出需要 mason 管理的 LSP，不会自动安装（按需手动 :MasonInstall）
        ensure_installed = { "pyright", "lua_ls", "ts_ls", "html", "cssls" },
        automatic_installation = false,
      })
    end,
  },
}
