local M = {}

-- Profile metadata
M.name = "tailwind"
M.filetypes = {}
M.treesitter_parsers = {}

-- LSP servers configuration
-- Note: This is a basic configuration. For language-specific filetypes,
-- configure them in your .nvim-profile.lua file
M.lsp_servers = {
	{
		name = "tailwindcss",
		config = {
			-- Filetypes should be configured in your custom profile
			-- This allows you to only enable tailwind for the languages you use
		},
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
