local lsp_init = require("lsp.init")

vim.lsp.config["html"] = {
	cmd = { "vscode-html-language-server", "--stdio" },
	filetypes = { "html" },
	root_markers = { "package.json", ".git" },
	autostart = true,
	single_file_support = true,
	capabilities = lsp_init.capabilities,
	on_attach = lsp_init.on_attach,
}

vim.lsp.config["cssls"] = {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	root_markers = { "package.json", ".git" },
	autostart = true,
	single_file_support = true,
	capabilities = lsp_init.capabilities,
	on_attach = lsp_init.on_attach,
}

vim.lsp.enable("html")
vim.lsp.enable("cssls")
