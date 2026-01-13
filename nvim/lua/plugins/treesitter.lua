return {
	"nvim-treesitter/nvim-treesitter",
    tag = "v0.10.0",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			-- Only essential parsers installed globally
			-- Language-specific parsers are installed by profiles
			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"bash",
				"json",
				"yaml",
				"markdown",
			},

			sync_install = false,
			auto_install = false,

			highlight = {
				enable = true,
			},
		})
	end,
}
