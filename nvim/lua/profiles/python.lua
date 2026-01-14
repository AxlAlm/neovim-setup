local M = {}

-- Profile metadata
M.name = "python"
M.filetypes = { "python" }
M.treesitter_parsers = { "python" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "pyright",
		config = {},
	},
}

-- Special server configurations
M.special_servers = {}

-- Formatters for conform.nvim
M.formatters = {
	python = { "isort", "black" },
}

-- Linters
M.linters = {
	python = { "ruff" },
}

-- Custom filetype associations
M.filetype_extensions = {}

return M
