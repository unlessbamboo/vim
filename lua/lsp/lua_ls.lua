local lsp_init = require("lsp.init")

vim.lsp.config["lua_ls"] = {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luacheckrc",
    "stylua.toml",
    ".git",
  },
  autostart = true,
  single_file_support = true,
  capabilities = lsp_init.capabilities,
  on_attach = lsp_init.on_attach,
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      diagnostics = {
        enable = true,
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = { enable = false },
    },
  },
}

vim.lsp.enable("lua_ls")
