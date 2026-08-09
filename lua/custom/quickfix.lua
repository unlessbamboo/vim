-- 推荐：绑定 <leader>q 到原生 :cclose 命令（最稳定）
vim.keymap.set("n", "<leader>qfix", ":cclose<CR>", {
	noremap = true,
	silent = true,
	desc = "关闭 quickfix 窗口（原生命令）",
})

-- 终极方案：quickfix 窗口中触发跳转后立即关闭
vim.api.nvim_create_augroup("QuickfixAutoClose", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = "QuickfixAutoClose",
	pattern = "qf", -- 仅匹配 quickfix 缓冲区
	callback = function(args)
		local qf_bufnr = args.buf

		-- 关闭所有 quickfix 窗口
		local function close_qf_windows()
			local all_wins = vim.fn.getwininfo()
			for _, win in ipairs(all_wins) do
				if win.quickfix == 1 and vim.api.nvim_win_is_valid(win.winid) then
					vim.api.nvim_win_close(win.winid, true)
				end
			end
		end

		-- 跳到光标所在条目（等价于内置回车跳转）
		-- 注意：
		--   1. :normal! <CR> 里的 <CR> 不会被翻译成回车键，跳转无效
		--   2. feedkeys 默认会重新映射按键，必须加 'n' 避免再次触发本映射造成递归
		local function jump_qf_entry()
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "nx", false)
		end

		-- 1. 监听 quickfix 窗口的回车按键（选中条目）
		vim.keymap.set("n", "<CR>", function()
			jump_qf_entry()
			close_qf_windows()
		end, { buffer = qf_bufnr, noremap = true, silent = true })

		-- 2. 监听 quickfix 窗口的鼠标点击（选中条目）
		vim.keymap.set("n", "<LeftMouse>", function()
			-- 映射会取代默认点击行为，先把光标移到点击行，再跳转
			local lnum = vim.v.mouse_lnum
			if lnum and lnum > 0 then
				vim.api.nvim_win_set_cursor(0, { lnum, 0 })
				jump_qf_entry()
				close_qf_windows()
			end
		end, { buffer = qf_bufnr, noremap = true, silent = true })

		-- 3. 兼容 :cc/:cn 等命令跳转（保留原有逻辑）
		local qf_cmd_group = vim.api.nvim_create_augroup("QuickfixCmdAutoClose", { clear = true })
		vim.api.nvim_create_autocmd("QuickFixCmdPost", {
			group = qf_cmd_group,
			pattern = { "cc", "cn", "cp", "cnext", "cprev", "cfirst", "clast" },
			callback = function()
				local close_qf = function()
					local all_wins = vim.fn.getwininfo()
					for _, win in ipairs(all_wins) do
						if win.quickfix == 1 and vim.api.nvim_win_is_valid(win.winid) then
							vim.api.nvim_win_close(win.winid, true)
						end
					end
				end
				vim.defer_fn(close_qf, 10)
			end,
			desc = "Quickfix 命令跳转后关闭窗口",
		})
	end,
	desc = "Quickfix 窗口交互后自动关闭",
})

-- 可选：自定义快捷键（一键跳转+关闭）
vim.keymap.set("n", "<leader>cq", function()
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, false, true), "nx", false)
	local all_wins = vim.fn.getwininfo()
	for _, win in ipairs(all_wins) do
		if win.quickfix == 1 and vim.api.nvim_win_is_valid(win.winid) then
			vim.api.nvim_win_close(win.winid, true)
		end
	end
end, { desc = "跳转到 quickfix 条目并关闭窗口" })
