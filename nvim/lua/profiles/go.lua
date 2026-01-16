local M = {}

-- Profile metadata
M.name = "go"
M.filetypes = { "go", "gomod", "gowork" }
M.treesitter_parsers = { "go", "gomod", "gowork" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "gopls",
		config = {},
	},
}

-- Special server configurations
M.special_servers = {}

-- Formatters for conform.nvim
M.formatters = {
	go = { "goimports", "golines" },
}

-- Linters (for future use)
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

-- Telescope ignore patterns
M.telescope_ignore_patterns = {
	"vendor",
}

return M
