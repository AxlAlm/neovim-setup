local M = {}

-- Profile metadata
M.name = "php"
M.filetypes = { "php" }
M.treesitter_parsers = { "php" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "intelephense",
		config = {},
	},
}

-- Special server configurations
M.special_servers = {}

-- Formatters for conform.nvim
M.formatters = {
	php = { "pint" },
}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

-- Telescope ignore patterns
M.telescope_ignore_patterns = {
	"vendor",
	"storage",
}

return M
