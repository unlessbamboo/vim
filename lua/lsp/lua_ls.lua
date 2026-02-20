local lsp_init = require("lsp.init")

-- 配置 lua-ls（Lua Language Server）
vim.lsp.config["lua_ls"] = {
  cmd = { "lua-language-server" }, -- 确保命令在 PATH 中
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
  on_attach = function(client, bufnr)
    lsp_init.on_attach(client, bufnr)
    
    -- 禁用 lua-ls 内置格式化（交给 stylua）
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
  settings = {
    Lua = {
      -- 类型检查（对标 pyright 的 typeCheckingMode）
      runtime = { version = "LuaJIT" }, -- 适配 Neovim 的 LuaJIT 环境
      diagnostics = {
        enable = true,
        globals = { "vim" }, -- 识别 Neovim 全局变量（关键）
      },
      workspace = {
        checkThirdParty = false, -- 关闭第三方库检查（提升性能）
        library = vim.api.nvim_get_runtime_file("", true), -- 加载 Neovim 内置 Lua 库
      },
      telemetry = { enable = false }, -- 关闭遥测
    },
  },
}

-- 启用 lua-ls
vim.lsp.enable("lua_ls")
