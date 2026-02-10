local M = {}

-- Profile metadata
M.name = "psql"
M.filetypes = { "sql" }
M.treesitter_parsers = { "sql" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "postgres-language-server",
		config = {},
	},
}

-- Special server configurations
M.special_servers = {}

-- Formatters for conform.nvim
M.formatters = {
	sql = { "pg_format" },
}

-- Linters (for future use)
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

-- Telescope ignore patterns
M.telescope_ignore_patterns = {}

return M
