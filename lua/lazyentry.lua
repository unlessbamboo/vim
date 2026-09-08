-- ========================================
-- 2. Lazy.nvim 初始化（先安装 Lazy 后启用）
-- ========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- ========================================
-- 3. Lazy.nvim 插件配置（替代原 vim-plug 配置）
-- ========================================
-- lazy.nvim 不支持重复执行 setup（会警告 "Re-sourcing your config is not supported"）。
-- 重载配置（,ss）时会再次 require 本文件，这里用 lazy_did_setup 跳过重复初始化。
if not vim.g.lazy_did_setup then
	require("lazy").setup({
		-- 基础
		require("plugins.basic"),
		require("plugins.fzf"),
		require("plugins.filetree"),
		require("plugins.gitsigns"),
		require("plugins.lualine"),
		require("plugins.outline"),
		-- 语言/语法支持
		require("plugins.language"),
		-- 代码补全（LSP + cmp）
		require("plugins.lspconfig"),
		require("plugins.cmp"),
		require("plugins.autopairs"),
		-- AI 补全与助手
		require("plugins.minuet"),
		require("plugins.avante"),
		-- 格式化和检查
		require("plugins.conform"),
		require("plugins.lint"),
		-- 工具管理
		require("plugins.mason"),
		-- treesitter
		require("plugins.treesitter"),
		-- markdown
		require("plugins.markdown"),
		require("plugins.comment"),
	}, {
		install = {
			missing = true, -- 自动安装缺失插件
		},
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})
end

-- ========================================
-- 4. 补充
-- ========================================
