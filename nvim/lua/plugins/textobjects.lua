return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	config = function()
		require("nvim-treesitter.configs").setup({
			textobjects = {
				select = {
					enable = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist
					goto_next_start = {
						["]m"] = "@function.outer",
						["]c"] = "@class.outer",
					},
					goto_next_end = {
						["]M"] = "@function.outer",
						["]C"] = "@class.outer",
					},
					goto_previous_start = {
						["[m"] = "@function.outer",
						["[c"] = "@class.outer",
					},
					goto_previous_end = {
						["[M"] = "@function.outer",
						["[C"] = "@class.outer",
					},
				},
			},
		})
	end,
}
