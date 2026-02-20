local M = {}

-- 初始化 ruff 格式化+检查
function M.setup()
  -- 1. 保存前自动格式化 Python 文件
  local ruff_augroup = vim.api.nvim_create_augroup("RuffAutoFormat", { clear = true })
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = ruff_augroup,
    pattern = "*.py", -- 仅对 Python 文件生效
    callback = function()
      -- 跳过大型文件（>1MB）避免卡顿
      local file_size = vim.fn.getfsize(vim.fn.expand("%"))
      if file_size and file_size > 1024 * 1024 then
        vim.notify("文件过大，跳过 ruff 格式化", vim.log.levels.WARN)
        return
      end

      -- 调用 ruff 格式化（核心：命令行方式，无需 LSP）
      local format_cmd = string.format(
        "ruff format --line-length=120 --indent-width=4 %s",
        vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
      )
      vim.fn.system(format_cmd)

      -- 调用 ruff 检查，输出诊断信息（可选）
      local check_cmd = string.format(
        "ruff check --quiet --format=json %s",
        vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))
      )
      local check_result = vim.fn.system(check_cmd)
      if check_result ~= "" then
        local ok, diagnostics = pcall(vim.json.decode, check_result)
        if ok and #diagnostics > 0 then
          local diag_list = {}
          local ns = vim.api.nvim_create_namespace("ruff")
          vim.diagnostic.reset(ns, 0) -- 清空原有 ruff 诊断
          for _, d in ipairs(diagnostics) do
            table.insert(diag_list, {
              bufnr = 0,
              lnum = d.location.row - 1, -- Neovim 行号从 0 开始
              col = d.location.column - 1,
              severity = vim.diagnostic.severity.WARN,
              source = "ruff",
              message = string.format("[%s] %s", d.code, d.message),
            })
          end
          vim.diagnostic.set(ns, 0, diag_list)
        end
      end

      -- 刷新缓冲区，应用格式化结果
      vim.cmd("edit!")
    end,
    desc = "保存前用 ruff 格式化 Python 文件",
  })

  -- 2. 手动触发 ruff 操作的快捷键
  local opts = { noremap = true, silent = true }
  
  -- 手动格式化（修复：正确合并 opts 和 desc）
  vim.keymap.set("n", "<leader>rf", function()
    local cmd = string.format("ruff format %s", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)))
    vim.fn.system(cmd)
    vim.cmd("edit!")
    vim.notify("Ruff 格式化完成", vim.log.levels.INFO)
  end, vim.tbl_extend("force", opts, { desc = "Ruff 格式化当前文件" }))

  -- 手动修复所有可修复问题（修复：正确合并 opts 和 desc）
  vim.keymap.set("n", "<leader>rx", function()
    local cmd = string.format("ruff check --fix %s", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)))
    vim.fn.system(cmd)
    vim.cmd("edit!")
    vim.notify("Ruff 自动修复完成", vim.log.levels.INFO)
  end, vim.tbl_extend("force", opts, { desc = "Ruff 自动修复问题" }))

  -- 清除 ruff 诊断提示（修复：正确合并 opts 和 desc）
  vim.keymap.set("n", "<leader>rc", function()
    vim.diagnostic.reset(vim.api.nvim_create_namespace("ruff"), 0)
  end, vim.tbl_extend("force", opts, { desc = "清除 Ruff 诊断提示" }))
end

return M
