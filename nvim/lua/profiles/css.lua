local M = {}

-- Profile metadata
M.name = "css"
M.filetypes = { "css", "scss", "sass", "less" }
M.treesitter_parsers = { "css", "scss" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "cssls",
		config = {},
	},
}

-- Special server configurations
M.special_servers = {}

-- Formatters for conform.nvim
M.formatters = {
	css = { "prettierd" },
	scss = { "prettierd" },
	sass = { "prettierd" },
	less = { "prettierd" },
}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

return M
