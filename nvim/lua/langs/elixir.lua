local M = {}

-- Profile metadata
M.name = "elixir"
M.filetypes = { "elixir", "eex", "heex" }
M.treesitter_parsers = { "elixir", "eex", "heex" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "elixirls",
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
