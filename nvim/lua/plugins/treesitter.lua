return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({

			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"python",
				"go",
				"javascript",
				"typescript",
				"rust",
				"html",
				"sql",
				"bash",
				"tsx",
				"css",
				"templ",
			},

			sync_install = false,

			auto_install = false,

			context_commentstring = {
				enable = true,
			},

			highlight = {
				enable = true,
				-- additional_vim_regex_highlighting = false,
			},
		})
	end,
}
