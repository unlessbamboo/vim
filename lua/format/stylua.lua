local M = {}

function M.setup()
	-- 1. 保存前用 stylua 格式化 Lua 文件（核心修复：仅操作缓冲区）
	local stylua_augroup = vim.api.nvim_create_augroup("StyluaAutoFormat", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = stylua_augroup,
		pattern = "*.lua",
		callback = function()
			-- 跳过大型文件
			local file_size = vim.fn.getfsize(vim.fn.expand("%"))
			if file_size and file_size > 1024 * 1024 then
				vim.notify("文件过大，跳过 stylua 格式化", vim.log.levels.WARN)
				return
			end

			local bufnr = vim.api.nvim_get_current_buf()
			-- 关键1：读取缓冲区内容（不写磁盘）
			local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
			if content == "" then
				return
			end

			-- 查找 stylua 配置文件
			local stylua_config = vim.fn.getcwd() .. "/.stylua.toml"
			if not vim.fn.filereadable(stylua_config) then
				stylua_config = vim.fn.expand("~/.config/stylua.toml")
			end

			-- 关键2：通过管道传递缓冲区内容给 stylua（仅操作内存）
			local cmd = string.format(
				"echo %s | stylua --config-path %s -",
				vim.fn.shellescape(content),
				vim.fn.fnameescape(stylua_config)
			)

			-- 执行格式化并捕获错误
			local formatted_content = vim.fn.system(cmd)
			if vim.v.shell_error ~= 0 then
				vim.notify("StyLua 格式化失败：" .. formatted_content, vim.log.levels.ERROR)
				return
			end

			-- 关键3：将格式化后的内容写回缓冲区（不重载文件）
			if formatted_content ~= "" then
				-- 保存光标位置
				local cursor_pos = vim.api.nvim_win_get_cursor(0)
				-- 写入格式化内容到缓冲区
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(formatted_content, "\n"))
				-- 恢复光标位置
				vim.api.nvim_win_set_cursor(0, cursor_pos)
			end
		end,
		desc = "保存前用 stylua 格式化 Lua 缓冲区（无重复写文件）",
	})

	-- 2. luacheck 静态检查（保留功能，优化错误处理）
	local luacheck_augroup = vim.api.nvim_create_augroup("LuacheckDiagnostics", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = luacheck_augroup,
		pattern = "*.lua",
		callback = function()
			local current_file = vim.api.nvim_buf_get_name(0)
			if current_file == "" then
				return
			end

			-- 执行 luacheck plain 格式检查（仅读取，不修改文件）
			local check_cmd = string.format("luacheck --formatter plain %s", vim.fn.fnameescape(current_file))
			local result = vim.fn.system(check_cmd)

			-- 优化：区分「luacheck 不存在」和「代码有问题」
			if vim.v.shell_error ~= 0 then
				if result:find("command not found") then
					vim.notify(
						"Luacheck 未安装，请先安装：luarocks install --local luacheck",
						vim.log.levels.ERROR
					)
				else
					vim.notify("Luacheck 检查失败：" .. result, vim.log.levels.WARN)
				end
				return
			end

			-- 解析 plain 格式的文本输出（原有逻辑保留，无写文件操作）
			if result ~= "" then
				local diag_list = {}
				local ns = vim.api.nvim_create_namespace("luacheck")
				vim.diagnostic.reset(ns, 0)

				for line in result:gmatch("[^\n]+") do
					local lnum_str, col_str, code, msg = line:match(":(%d+):(%d+): %((%d+)%) (.+)")
					if lnum_str and col_str and code and msg then
						local lnum = tonumber(lnum_str) - 1
						local col = tonumber(col_str) - 1

						table.insert(diag_list, {
							bufnr = 0,
							lnum = lnum,
							col = col,
							severity = vim.diagnostic.severity.WARN,
							source = "luacheck",
							message = string.format("[%s] %s", code, msg),
						})
					end
				end

				if #diag_list > 0 then
					vim.diagnostic.set(ns, 0, diag_list)
				end
			end
		end,
	})

	-- 3. 手动操作快捷键（修复：仅操作缓冲区，无 write + edit!）
	local opts = { noremap = true, silent = true }
	-- 手动格式化（仅改缓冲区，不写磁盘）
	vim.keymap.set("n", "<leader>luaf", function()
		local bufnr = vim.api.nvim_get_current_buf()
		local content = table.concat(vim.api.nvim_buf_get_lines(bufnr, 0, -1, false), "\n")
		if content == "" then
			vim.notify("缓冲区为空，无需格式化", vim.log.levels.INFO)
			return
		end

		local stylua_config = vim.fn.getcwd() .. "/.stylua.toml"
		if not vim.fn.filereadable(stylua_config) then
			stylua_config = vim.fn.expand("~/.config/stylua.toml")
		end

		-- 管道传递缓冲区内容，不写磁盘
		local cmd = string.format(
			"echo %s | stylua --config %s -",
			vim.fn.shellescape(content),
			vim.fn.fnameescape(stylua_config)
		)

		local formatted_content = vim.fn.system(cmd)
		if vim.v.shell_error ~= 0 then
			vim.notify("StyLua 格式化失败：" .. formatted_content, vim.log.levels.ERROR)
			return
		end

		-- 写回缓冲区，恢复光标
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, vim.split(formatted_content, "\n"))
		vim.api.nvim_win_set_cursor(0, cursor_pos)

		vim.notify("Stylua 格式化完成（仅缓冲区）", vim.log.levels.INFO)
	end, vim.tbl_extend("force", opts, { desc = "Stylua 格式化当前 Lua 缓冲区" }))

	-- 清除 luacheck 诊断（原有逻辑保留，无问题）
	vim.keymap.set("n", "<leader>luac", function()
		local ns = vim.api.nvim_create_namespace("luacheck")
		vim.diagnostic.reset(ns, 0)
	end, vim.tbl_extend("force", opts, { desc = "清除 Luacheck 诊断提示" }))
end

return M
