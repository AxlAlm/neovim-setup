local M = {}

-- Profile metadata
M.name = "html"
M.filetypes = { "html" }
M.treesitter_parsers = { "html" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "html",
		config = {},
	},
}

-- Special server configurations
M.special_servers = {}

-- Formatters for conform.nvim
M.formatters = {
	html = { "prettierd" },
}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

return M
