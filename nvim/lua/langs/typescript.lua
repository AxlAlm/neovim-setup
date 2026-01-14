local M = {}

-- Profile metadata
M.name = "typescript"
M.filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "tsx", "jsx" }
M.treesitter_parsers = { "javascript", "typescript", "tsx" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "ts_ls",
		config = {},
	},
	{
		name = "html",
		config = {},
	},
	{
		name = "cssls",
		config = {},
	},
	{
		name = "tailwindcss",
		config = {
			filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
		},
	},
}

-- Special server configurations
M.special_servers = {}

-- Formatters for conform.nvim
M.formatters = {
	javascript = { "prettierd" },
	typescript = { "prettierd" },
	javascriptreact = { "prettierd" },
	typescriptreact = { "prettierd" },
	css = { "prettierd" },
	html = { "prettierd" },
}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

return M
