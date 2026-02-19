local lsp_init = require("lsp.init")
vim.lsp.config["pyright"] = {
  cmd = { 'pyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  autostart = true,
  single_file_support = true,
  capabilities = lsp_init.capabilities, -- 关联补全能力
  on_attach = lsp_init.on_attach,       -- 关键：关联 on_attach（快捷键绑定）
  -- 可选：自定义设置
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
    },
  },
}

vim.lsp.enable("pyright")
