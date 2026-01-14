local M = {}

-- Profile metadata
M.name = "tailwind"
M.filetypes = {
	"html",
	"css",
	"javascript",
	"typescript",
	"javascriptreact",
	"typescriptreact",
	"svelte",
	"vue",
	"templ",
	"rust",
}
M.treesitter_parsers = {}

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "tailwindcss",
		config = {
			filetypes = {
				"html",
				"css",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"svelte",
				"vue",
				"templ",
				"rust",
			},
			init_options = {
				userLanguages = {
					templ = "html",
					rust = "html",
					svelte = "html",
				},
			},
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
