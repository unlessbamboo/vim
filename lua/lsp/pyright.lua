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
  on_attach = function(client, bufnr)
    lsp_init.on_attach(client, bufnr)
    
    -- 关闭文档级格式化
    client.server_capabilities.documentFormattingProvider = false
    -- 关闭范围级格式化（选中文本格式化）
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.documentFormattingSyncProvider = false
  end,
  -- 可选：自定义设置
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
      },
      formatting = {
        enabled = false
      }
    },
  },
}

vim.lsp.enable("pyright")
