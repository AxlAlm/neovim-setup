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
}

-- Special server configurations
M.special_servers = {}

-- Formatters for conform.nvim
M.formatters = {
	javascript = { "prettierd" },
	typescript = { "prettierd" },
	javascriptreact = { "prettierd" },
	typescriptreact = { "prettierd" },
}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

-- Telescope ignore patterns
M.telescope_ignore_patterns = {
	"node_modules",
}

return M
