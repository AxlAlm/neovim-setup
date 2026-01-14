local M = {}

-- Profile metadata
M.name = "rust"
M.filetypes = { "rust" }
M.treesitter_parsers = { "rust" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "rust_analyzer",
		config = {
			settings = {
				["rust-analyzer"] = {
					cargo = {},
					procMacro = {
						ignored = {
							leptos_macro = {},
						},
					},
				},
			},
		},
	},
}

-- Special server configurations
M.special_servers = {
	tailwindcss = {
		filetypes = { "rust" },
		init_options = {
			userLanguages = {
				rust = "html",
			},
		},
	},
}

-- Formatters for conform.nvim
M.formatters = {
	rust = { "rustfmt" },
}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

return M
