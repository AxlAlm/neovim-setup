local M = {}

-- Profile metadata
M.name = "lua"
M.filetypes = { "lua" }
M.treesitter_parsers = { "lua" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "lua_ls",
		config = {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
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
	lua = { "stylua" },
}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

return M
