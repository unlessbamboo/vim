--[[
问题1： 在使用ai提供的两个代码中有一个明显的问题，会多次写入导致代码改动在保存的时候
    自动回滚，下面的更改过的代码，保存之前这些格式化代码将改动保存到缓存中而非写入磁盘
--]]

local M = {}

-- 初始化 ruff 格式化+检查（核心：仅操作缓冲区，不碰磁盘）
function M.setup()
	-- 辅助函数：通过管道给 Ruff 传递缓冲区内容，返回格式化/修复后的结果
	local function ruff_operate_on_buffer(operation)
		local bufnr = vim.api.nvim_get_current_buf()
		local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
		if content == "" then
			return nil, "缓冲区为空，无需操作"
		end

		-- 构建 Ruff 命令（从标准输入读取内容，- 表示标准输入）
		local cmd
		if operation == "format" then
			cmd = string.format("echo %s | ruff format -", vim.fn.shellescape(content))
		elseif operation == "fix" then
			cmd = string.format("echo %s | ruff check --fix --quiet -", vim.fn.shellescape(content))
		else
			return nil, "不支持的操作类型：" .. operation
		end

		-- 执行命令并返回结果
		-- vim.notify("格式化命令：" .. cmd)
		local result = vim.fn.system(cmd)
		if vim.v.shell_error ~= 0 then
			return nil, "Ruff 执行失败：" .. result
		end
		return result, nil
	end

	-- 辅助函数：解析 Ruff JSON 诊断结果
	local function parse_ruff_diagnostics(content)
		local check_cmd =
			string.format("echo %s | ruff check --quiet --format=json -", vim.fn.shellescape(content))
		local check_result = vim.fn.system(check_cmd)
		if vim.v.shell_error ~= 0 or check_result == "" then
			return {}
		end

		local ok, diagnostics = pcall(vim.json.decode, check_result)
		if not ok or #diagnostics == 0 then
			return {}
		end

		local diag_list = {}
		for _, d in ipairs(diagnostics) do
			-- 跳过无位置信息的诊断
			if d.location and d.location.row and d.location.column then
				table.insert(diag_list, {
					bufnr = 0,
					lnum = d.location.row - 1, -- Neovim 行号从 0 开始
					col = d.location.column - 1,
					severity = vim.diagnostic.severity.WARN,
					source = "ruff",
					message = string.format("[%s] %s", d.code or "UNKNOWN", d.message),
				})
			end
		end
		return diag_list
	end

	-- 1. 保存前自动格式化 Python 文件（仅操作缓冲区）
	local ruff_augroup = vim.api.nvim_create_augroup("RuffAutoFormat", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = ruff_augroup,
		pattern = "*.py",
		callback = function()
			-- 跳过大型文件（>1MB）
			local file_size = vim.fn.getfsize(vim.fn.expand("%"))
			if file_size and file_size > 1024 * 1024 then
				vim.notify("文件过大，跳过 ruff 格式化", vim.log.levels.WARN)
				return
			end

			-- 步骤1：格式化缓冲区内容（不写磁盘）
			local formatted_content, err = ruff_operate_on_buffer("format")
			if err then
				vim.notify(err, vim.log.levels.ERROR)
				return
			end

			-- 步骤2：写回格式化后的内容到缓冲区
			if formatted_content and formatted_content ~= "" then
				local cursor_pos = vim.api.nvim_win_get_cursor(0)
				vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(formatted_content, "\n"))
				vim.api.nvim_win_set_cursor(0, cursor_pos)
			end

			-- 步骤3：解析并设置诊断信息（基于当前缓冲区内容）
			local current_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
			local diag_list = parse_ruff_diagnostics(current_content)
			local ns = vim.api.nvim_create_namespace("ruff")
			vim.diagnostic.reset(ns, 0)
			if #diag_list > 0 then
				vim.diagnostic.set(ns, 0, diag_list)
			end
		end,
		desc = "保存前用 ruff 格式化 Python 缓冲区",
	})

	-- 2. 手动触发 ruff 操作的快捷键（仅操作缓冲区）
	local opts = { noremap = true, silent = true }

	-- 手动格式化
	vim.keymap.set("n", "<leader>rf", function()
		local formatted_content, err = ruff_operate_on_buffer("format")
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end

		if formatted_content then
			local cursor_pos = vim.api.nvim_win_get_cursor(0)
			vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(formatted_content, "\n"))
			vim.api.nvim_win_set_cursor(0, cursor_pos)
			vim.notify("Ruff 格式化完成（仅缓冲区）", vim.log.levels.INFO)
		end
	end, vim.tbl_extend("force", opts, { desc = "Ruff 格式化当前 Python 缓冲区" }))

	-- 手动修复所有可修复问题
	vim.keymap.set("n", "<leader>rx", function()
		local fixed_content, err = ruff_operate_on_buffer("fix")
		if err then
			vim.notify(err, vim.log.levels.ERROR)
			return
		end

		if fixed_content then
			local cursor_pos = vim.api.nvim_win_get_cursor(0)
			vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(fixed_content, "\n"))
			vim.api.nvim_win_set_cursor(0, cursor_pos)
			-- 修复后重新检查诊断
			local current_content = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
			local diag_list = parse_ruff_diagnostics(current_content)
			local ns = vim.api.nvim_create_namespace("ruff")
			vim.diagnostic.reset(ns, 0)
			if #diag_list > 0 then
				vim.diagnostic.set(ns, 0, diag_list)
			end
			vim.notify("Ruff 自动修复完成（仅缓冲区）", vim.log.levels.INFO)
		end
	end, vim.tbl_extend("force", opts, { desc = "Ruff 自动修复 Python 缓冲区问题" }))

	-- 清除 ruff 诊断提示
	vim.keymap.set("n", "<leader>rc", function()
		local ns = vim.api.nvim_create_namespace("ruff")
		vim.diagnostic.reset(ns, 0)
	end, vim.tbl_extend("force", opts, { desc = "清除 Ruff 诊断提示" }))
end

return M
