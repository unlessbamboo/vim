-- 推荐：绑定 <leader>q 到原生 :cclose 命令（最稳定）
vim.keymap.set("n", "<leader>qfix", ":cclose<CR>", {
	noremap = true,
	silent = true,
	desc = "关闭 quickfix 窗口（原生命令）",
})

-- 终极方案：quickfix 窗口中触发跳转后立即关闭
vim.api.nvim_create_autocmd("FileType", {
	pattern = "qf", -- 仅匹配 quickfix 缓冲区
	callback = function(args)
		local qf_bufnr = args.buf

		-- 1. 监听 quickfix 窗口的回车按键（选中条目）
		vim.keymap.set("n", "<CR>", function()
			-- 先执行默认的回车跳转逻辑
			vim.cmd("normal! <CR>")
			-- 立即关闭所有 quickfix 窗口
			local all_wins = vim.fn.getwininfo()
			for _, win in ipairs(all_wins) do
				if win.quickfix == 1 and vim.api.nvim_win_is_valid(win.winid) then
					vim.api.nvim_win_close(win.winid, true)
				end
			end
		end, { buffer = qf_bufnr, noremap = true, silent = true })

		-- 2. 监听 quickfix 窗口的鼠标点击（选中条目）
		vim.keymap.set("n", "<LeftMouse>", function()
			-- 先执行默认的鼠标点击跳转逻辑
			vim.cmd("normal! <LeftMouse>")
			-- 立即关闭所有 quickfix 窗口
			local all_wins = vim.fn.getwininfo()
			for _, win in ipairs(all_wins) do
				if win.quickfix == 1 and vim.api.nvim_win_is_valid(win.winid) then
					vim.api.nvim_win_close(win.winid, true)
				end
			end
		end, { buffer = qf_bufnr, noremap = true, silent = true })

		-- 3. 兼容 :cc/:cn 等命令跳转（保留原有逻辑）
		vim.api.nvim_create_autocmd("QuickFixCmdPost", {
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
vim.keymap.set("n", "<leader>cc", function()
	vim.cmd("cc")
	local all_wins = vim.fn.getwininfo()
	for _, win in ipairs(all_wins) do
		if win.quickfix == 1 and vim.api.nvim_win_is_valid(win.winid) then
			vim.api.nvim_win_close(win.winid, true)
		end
	end
end, { desc = "跳转到 quickfix 条目并关闭窗口" })
