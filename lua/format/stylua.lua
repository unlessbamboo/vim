local M = {}

function M.setup()
	-- 1. 保存前用 stylua 格式化 Lua 文件（核心修复：调整执行顺序）
	local stylua_augroup = vim.api.nvim_create_augroup("StyluaAutoFormat", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = stylua_augroup,
		pattern = "*.lua", -- 仅对 Lua 文件生效
		callback = function()
			-- 跳过大型文件
			local file_size = vim.fn.getfsize(vim.fn.expand("%"))
			if file_size and file_size > 1024 * 1024 then
				vim.notify("文件过大，跳过 stylua 格式化", vim.log.levels.WARN)
				return
			end

			local current_file = vim.api.nvim_buf_get_name(0)
			-- 步骤1：先把缓冲区的修改写入磁盘（关键！避免修改丢失）
			vim.cmd("write")

			-- 步骤2：调用 stylua 格式化磁盘上的最新文件
			local stylua_config = vim.fn.getcwd() .. "/.stylua.toml"

			if not vim.fn.filereadable(stylua_config) then
				stylua_config = vim.fn.expand("~/.config/stylua.toml")
			end
			local cmd = string.format(
				"stylua --config-path %s %s",
				vim.fn.fnameescape(stylua_config),
				vim.fn.fnameescape(current_file)
			)
			-- 执行格式化并捕获错误
			local status = vim.fn.system(cmd)
			if vim.v.shell_error ~= 0 then
				vim.notify("StyLua 格式化失败：" .. status, vim.log.levels.ERROR)
				return
			end

			-- 步骤3：重新加载格式化后的文件（保留光标位置）
			vim.cmd("edit!")
			-- 恢复光标到格式化前的位置
			vim.cmd('normal! g`"')
		end,
		desc = "保存前用 stylua 格式化 Lua 文件",
	})

	-- 2. luacheck 静态检查（修复：仅检查，不修改文件）
	local luacheck_augroup = vim.api.nvim_create_augroup("LuacheckDiagnostics", { clear = true })
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = luacheck_augroup,
		pattern = "*.lua",
		callback = function()
			local current_file = vim.api.nvim_buf_get_name(0)

			-- 1. 执行 luacheck plain 格式检查（文本输出）
			local check_cmd = string.format("luacheck --formatter plain %s", vim.fn.fnameescape(current_file))
			local result = vim.fn.system(check_cmd)

			-- 2. 先检查 luacheck 执行是否失败（比如文件不存在、语法错误）
			if vim.v.shell_error ~= 0 then
				vim.notify("Luacheck 执行失败：" .. result, vim.log.levels.WARN)
				return
			end

			-- 3. 解析 plain 格式的文本输出（核心修改）
			if result ~= "" then
				local diag_list = {}
				local ns = vim.api.nvim_create_namespace("luacheck")
				vim.diagnostic.reset(ns, 0) -- 清空旧诊断

				-- 逐行解析 plain 格式输出
				for line in result:gmatch("[^\n]+") do
					-- 匹配 plain 格式：file.lua:5:10: (612) Trailing space
					-- 捕获：行号、列号、错误码、错误信息
					local lnum_str, col_str, code, msg = line:match(":(%d+):(%d+): %((%d+)%) (.+)")
					if lnum_str and col_str and code and msg then
						-- 转换为数字，且 Neovim 行/列从 0 开始（luacheck 从 1 开始）
						local lnum = tonumber(lnum_str) - 1
						local col = tonumber(col_str) - 1

						table.insert(diag_list, {
							bufnr = 0,
							lnum = lnum,
							col = col,
							-- plain 格式默认都是 warning，若需区分可扩展
							severity = vim.diagnostic.severity.WARN,
							source = "luacheck",
							message = string.format("[%s] %s", code, msg),
						})
					end
				end

				-- 4. 设置新的诊断信息
				if #diag_list > 0 then
					vim.diagnostic.set(ns, 0, diag_list)
				end
			end
		end,
	})

	-- 3. 手动操作快捷键（无冲突）
	local opts = { noremap = true, silent = true }
	-- 手动格式化
	vim.keymap.set("n", "<leader>luaf", function()
		local current_file = vim.api.nvim_buf_get_name(0)
		-- 先保存缓冲区修改
		vim.cmd("write")
		local stylua_config = vim.fn.getcwd() .. "/.stylua.toml"
		if not vim.fn.filereadable(stylua_config) then
			stylua_config = vim.fn.expand("~/.config/stylua.toml")
		end
		local cmd = string.format(
			"stylua --config %s %s",
			vim.fn.fnameescape(stylua_config),
			vim.fn.fnameescape(current_file)
		)
		local status = vim.fn.system(cmd)
		if vim.v.shell_error ~= 0 then
			vim.notify("StyLua 格式化失败：" .. status, vim.log.levels.ERROR)
			return
		end
		vim.cmd("edit!")
		vim.cmd('normal! g`"')
		vim.notify("Stylua 格式化完成", vim.log.levels.INFO)
	end, vim.tbl_extend("force", opts, { desc = "Stylua 格式化当前 Lua 文件" }))

	-- 清除 luacheck 诊断
	vim.keymap.set("n", "<leader>luac", function()
		vim.diagnostic.reset(vim.api.nvim_create_namespace("luacheck"), 0)
	end, vim.tbl_extend("force", opts, { desc = "清除 Luacheck 诊断提示" }))
end

return M
