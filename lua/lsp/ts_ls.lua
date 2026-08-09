local lsp_init = require("lsp.init")

vim.lsp.config["ts_ls"] = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	autostart = true,
	single_file_support = true,
	capabilities = lsp_init.capabilities,
	on_attach = lsp_init.on_attach,
}

vim.lsp.enable("ts_ls")
