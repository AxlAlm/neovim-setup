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
M.special_servers = {}

-- Formatters for conform.nvim
M.formatters = {
	rust = { "rustfmt" },
}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

-- Telescope ignore patterns
M.telescope_ignore_patterns = {
	"target",
}

return M
