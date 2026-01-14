local M = {}

-- Example .nvim-profile.lua configuration
-- Copy this file to .nvim-profile.lua in your project root and customize it

-- Profile metadata
M.name = "my-project"

-- Base profiles to load from nvim/lua/profiles/
-- These are the pre-configured language profiles
M.base_profiles = {
	"go",
	"templ",
	"html",
	"typescript",
	"tailwind",
}

-- Profile metadata (combined from base profiles + custom)
M.filetypes = {}
M.treesitter_parsers = {
	-- Example: Add additional parsers beyond base profiles
	-- "markdown",
	-- "yaml",
}

-- LSP servers configuration (extends base profiles)
M.lsp_servers = {
	-- Example: Add a custom LSP server
	-- {
	-- 	name = "my_custom_lsp",
	-- 	config = {
	-- 		settings = {
	-- 			-- LSP-specific settings
	-- 		},
	-- 	},
	-- },
}

-- Special server configurations (for cross-language servers)
M.special_servers = {
	-- Example: Configure tailwind for specific filetypes
	tailwindcss = {
		filetypes = { "html", "templ", "javascript", "typescript", "typescriptreact", "javascriptreact" },
		init_options = {
			userLanguages = {
				templ = "html",
			},
		},
	},
}

-- Formatters for conform.nvim (extends base profiles)
M.formatters = {
	-- Example: Override or add formatters for a filetype
	-- markdown = { "prettierd" },
}

-- Linters (extends base profiles)
M.linters = {
	-- Example: Add linters for a filetype
	-- javascript = { "eslint" },
}

-- Custom filetype associations
M.filetype_extensions = {
	-- Example: Associate file extensions with filetypes
	-- mdx = "markdown",
}

-- Telescope ignore patterns (extends base profiles)
M.telescope_ignore_patterns = {
	-- Example: Add custom patterns to ignore
	-- "*.log",
	-- "tmp/",
}

-- Custom setup hook (optional)
-- This function is called after the profile is loaded
-- M.custom_setup = function(opts, lsp_config)
-- 	-- Custom setup code here
-- 	-- Example: Set up additional keymaps, autocommands, etc.
-- end

return M
