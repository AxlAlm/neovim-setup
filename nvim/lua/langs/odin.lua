local M = {}

-- Profile metadata
M.name = "odin"
M.filetypes = { "odin" }
M.treesitter_parsers = { "odin" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "ols",
		config = {},
	},
}

-- Special server configurations
M.special_servers = {}

-- Formatters for conform.nvim
M.formatters = {}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

return M
