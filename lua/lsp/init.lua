local M = {}

M.setup_diagnostics = function()
  vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 2 },
    signs = true,
    float = { border = "rounded", source = "always" },
    update_in_insert = false,
  })
end

-- LSP 连接到缓冲区时执行：注册快捷键，禁用 LSP 自带格式化（统一交给 conform.nvim）
M.on_attach = function(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "跳转至定义" }))
  vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "跳转至实现" }))
  vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "查看引用" }))
  vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "悬浮文档" }))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "重命名" }))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "代码操作" }))
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "显示错误详情" }))
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "上一个错误" }))
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "下一个错误" }))
end

M.setup = function()
  M.setup_diagnostics()
  -- capabilities 在此初始化，供各 LSP 配置文件使用
  M.capabilities = require("cmp_nvim_lsp").default_capabilities()
  M.capabilities.textDocument.completion.completionItem.snippetSupport = true
end

return M
