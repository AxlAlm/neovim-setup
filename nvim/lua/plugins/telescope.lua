return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependecies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				path_display = { "truncate " },
				file_ignore_patterns = {
					"node_modules",
					".git/",
					".cache",
					".aws",
				},
			},
			pickers = {
				find_files = {
					hidden = true,
				},
			},
		})

		local keymap = vim.keymap
		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })

		-- vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
		-- vim.keymap.set('n', '<C-p>', builtin.git_files, {})
		-- vim.keymap.set('n', '<leader>ps', function()
		--     builtin.grep_string({ search = vim.fn.input("Grep > ") });
		-- end)
	end,
}
