local M = {}

-- Profile metadata
M.name = "svelte"
M.filetypes = { "svelte" }
M.treesitter_parsers = { "svelte" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "svelte",
		config = {},
	},
}

-- Special server configurations
M.special_servers = {
	tailwindcss = {
		filetypes = { "svelte" },
		init_options = {
			userLanguages = {
				svelte = "html",
			},
		},
	},
}

-- Formatters for conform.nvim
M.formatters = {
	svelte = { "prettierd" },
}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {
	svelte = "svelte",
}

return M
