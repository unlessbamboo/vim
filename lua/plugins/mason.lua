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
        -- 不让 mason-lspconfig 自己 vim.lsp.enable，交给 lua/lsp/*.lua 统一管理，
        -- 否则会和原生配置抢注册，导致 on_attach（快捷键）不生效
        automatic_enable = false,
      })
    end,
  },
}
