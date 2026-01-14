local M = {}

-- Profile metadata
M.name = "neovim-setup"

-- Base profiles to load from nvim/lua/profiles/
M.base_profiles = {
	"lua",
}

-- Profile metadata (combined from base profiles + custom)
M.filetypes = {}
M.treesitter_parsers = {
	"markdown",
	"json",
	"yaml",
	"toml",
	"vim",
	"vimdoc",
}

-- LSP servers configuration (extends base profiles)
M.lsp_servers = {}

-- Special server configurations
M.special_servers = {}

-- Formatters for conform.nvim (extends base profiles)
M.formatters = {
	markdown = { "prettierd" },
	json = { "prettierd" },
	yaml = { "prettierd" },
}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

-- Telescope ignore patterns (extends base profiles)
M.telescope_ignore_patterns = {}

return M
