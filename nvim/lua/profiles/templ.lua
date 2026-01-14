local M = {}

-- Profile metadata
M.name = "templ"
M.filetypes = { "templ" }
M.treesitter_parsers = { "templ" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "templ",
		config = {},
	},
}

-- Special server configurations
M.special_servers = {}

-- Formatters for conform.nvim
M.formatters = {
	templ = { "templ", "prettierd" },
}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {
	templ = "templ",
}

-- Telescope ignore patterns
M.telescope_ignore_patterns = {
	"_templ%.go$", -- Generated templ files
}

return M
