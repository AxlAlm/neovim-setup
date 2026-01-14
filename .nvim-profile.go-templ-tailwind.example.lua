local M = {}

-- Example .nvim-profile.lua for a Go + Templ + Tailwind CSS project
-- Copy this to .nvim-profile.lua in your Go project root

-- Profile metadata
M.name = "go-templ-tailwind"

-- Base profiles to load from nvim/lua/profiles/
M.base_profiles = {
	"go", -- Go language support
	"templ", -- Templ templating engine
	"html", -- HTML support (templ files contain HTML)
	"tailwind", -- Tailwind CSS (needs configuration below)
}

-- Profile metadata (combined from base profiles + custom)
M.filetypes = {}
M.treesitter_parsers = {}

-- LSP servers configuration (extends base profiles)
M.lsp_servers = {}

-- Special server configurations (configure tailwind for our filetypes)
M.special_servers = {
	tailwindcss = {
		filetypes = { "html", "templ" },
		init_options = {
			userLanguages = {
				templ = "html",
			},
		},
	},
}

-- Formatters for conform.nvim (extends base profiles)
M.formatters = {}

-- Linters (extends base profiles)
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

-- Telescope ignore patterns (extends base profiles)
M.telescope_ignore_patterns = {
	-- Example: ignore additional directories
	-- "tmp/",
	-- "dist/",
}

return M
