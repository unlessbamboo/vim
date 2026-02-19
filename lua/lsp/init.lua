local M = {} -- 导出模块（M = module）

-- 全局诊断样式（错误提示外观）
M.setup_diagnostics = function()
  vim.diagnostic.config({
    virtual_text = { prefix = "●", spacing = 2 },
    signs = true, -- 行号旁显示错误图标
    float = { border = "rounded", source = "always" },
    update_in_insert = false, -- 插入模式不更新诊断（避免干扰）
  })
end

-- 新增：表合并工具函数
local function merge_tables(t1, t2)
  local merged = {}
  for k, v in pairs(t1) do merged[k] = v end
  for k, v in pairs(t2) do merged[k] = v end
  return merged
end

-- on_attach：LSP 连接到缓冲区时执行的逻辑（快捷键、禁用冗余功能）
M.on_attach = function(client, bufnr)
  -- 禁用 pyright 的格式化（交给 black/ruff，避免冲突）
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
  
  -- LSP 常用快捷键（仅在当前缓冲区生效）
  -- 查看某个键位是否生效 -- :verbose nmap <leader>gi
  local opts_base = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, merge_tables(opts_base, { desc = "跳转至定义" }))
  vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, merge_tables(opts_base, { desc = "跳转至实现" }))
  vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, merge_tables(opts_base, { desc = "查看引用" }))
  vim.keymap.set("n", "<leader>K", vim.lsp.buf.hover, merge_tables(opts_base, { desc = "悬浮文档" }))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, merge_tables(opts_base, { desc = "重命名" }))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, merge_tables(opts_base, { desc = "代码操作" }))
  vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, merge_tables(opts_base, { desc = "显示错误详情" }))
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, merge_tables(opts_base, { desc = "上一个错误" }))
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, merge_tables(opts_base, { desc = "下一个错误" }))
end

-- ========== 3. nvim-cmp 补全配置 ==========
M.setup_cmp = function()
  local cmp = require("cmp")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")
  
  -- 生成 LSP 能力对象（供所有 LSP 使用）
  M.capabilities = cmp_nvim_lsp.default_capabilities()
  M.capabilities.textDocument.completion.completionItem.snippetSupport = true

  -- 配置 cmp
  cmp.setup({
    completion = { completeopt = "menu,menuone,noinsert" },
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "buffer" },
      { name = "path" },
    }),
    mapping = cmp.mapping.preset.insert({
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping.select_next_item(),
      ["<S-Tab>"] = cmp.mapping.select_prev_item(),
      ["<ESC>"] = cmp.mapping.abort(),
    }),
  })
end

-- ========== 4. 统一初始化 LSP 配置 ==========
M.setup = function()
  M.setup_diagnostics() -- 初始化诊断
  M.setup_cmp() -- 初始化补全
end

return M -- 导出模块（必须）
