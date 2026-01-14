local M = {}

-- Example .nvim-profile.lua for a TypeScript/React + Tailwind CSS project
-- Copy this to .nvim-profile.lua in your TypeScript project root

-- Profile metadata
M.name = "typescript-tailwind"

-- Base profiles to load from nvim/lua/profiles/
M.base_profiles = {
	"typescript", -- TypeScript/JavaScript support
	"html", -- HTML support
	"css", -- CSS support
	"tailwind", -- Tailwind CSS (needs configuration below)
}

-- Profile metadata (combined from base profiles + custom)
M.filetypes = {}
M.treesitter_parsers = {
	-- Example: add JSDoc support
	-- "jsdoc",
}

-- LSP servers configuration (extends base profiles)
M.lsp_servers = {}

-- Special server configurations (configure tailwind for our filetypes)
M.special_servers = {
	tailwindcss = {
		filetypes = {
			"html",
			"css",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
		},
	},
}

-- Formatters for conform.nvim (extends base profiles)
M.formatters = {}

-- Linters (extends base profiles)
M.linters = {
	-- Example: add eslint
	-- javascript = { "eslint" },
	-- typescript = { "eslint" },
	-- javascriptreact = { "eslint" },
	-- typescriptreact = { "eslint" },
}

-- Custom filetype associations
M.filetype_extensions = {}

-- Telescope ignore patterns (extends base profiles)
M.telescope_ignore_patterns = {
	-- Example: ignore build directories
	-- "dist/",
	-- "build/",
	-- ".next/",
}

return M
