return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			textobjects = {
				select = {
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
					},
				},
			},
		})
	end,
}
