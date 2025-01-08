return {
	"nvim-treesitter/nvim-treesitter-textobjects",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		require("nvim-treesitter.configs").setup({
			textobjects = {
				select = {
					enable = true,
					lookahead = true,
					keymaps = {
						["af"] = "@function.outer",
						["if"] = "@function.inner",
						["ac"] = "@class.outer",
						["ic"] = "@class.inner",
					},
				},
				move = {
					enable = true,
					set_jumps = true,
					goto_next_start = {
						["<leader>mj"] = "@function.outer", -- 'm' for move
						["<leader>mc"] = "@class.outer",
					},
					goto_next_end = {
						["<leader>mJ"] = "@function.outer",
						["<leader>mC"] = "@class.outer",
					},
				},
			},
		})

		vim.defer_fn(function()
			print(vim.inspect(vim.fn.maparg("<leader>mj", "n", false, true)))
		end, 1000)
	end,
}
