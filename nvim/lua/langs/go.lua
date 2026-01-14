local M = {}

-- Profile metadata
M.name = "go"
M.filetypes = { "go", "gomod", "gowork", "gotmpl", "templ" }
M.treesitter_parsers = { "go", "gomod", "gowork", "templ" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "gopls",
		config = {
			settings = {
				gopls = {
					-- buildFlags = { "-tags=integration,e2e" },
				},
			},
		},
	},
	{
		name = "templ",
		config = {},
	},
}

-- Special server configurations (cross-language servers)
M.special_servers = {
	html = {
		filetypes = { "html", "templ" },
	},
	tailwindcss = {
		filetypes = { "templ" },
		init_options = {
			userLanguages = {
				templ = "html",
			},
		},
	},
}

-- Formatters for conform.nvim
M.formatters = {
	go = { "gopls", "goimports", "golines" },
	templ = { "templ", "prettierd" },
}

-- Linters (for future use)
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {
	templ = "templ",
}

return M
