return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		local telescope = require("telescope")

		local action_state = require("telescope.actions.state")

		-- Custom action to add file to harpoon
		local harpoon_add = function()
			local selection = action_state.get_selected_entry()
			local mark = require("harpoon.mark")
			mark.add_file(selection.path or selection.filename or selection.value)
			print("Added to Harpoon: " .. (selection.path or selection.filename or selection.value))
		end

		telescope.setup({
			defaults = {
				path_display = { "truncate " },
				file_ignore_patterns = {
					"node_modules",
					".git/",
					".cache",
					".aws",
					"target",
					"vendor",
					"storage",
					-- elixir
					"deps",
					"_build",
					".elixir_ls",
				},
				mappings = {
					n = {
						["fa"] = harpoon_add,
					},
				},
				cache_picker = {
					num_pickers = 20, -- Keep history of last 20 pickers
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
		keymap.set("n", "<leader>fp", "<cmd>Telescope resume<cr>", { desc = "Resume previous telescope picker" })
		keymap.set("n", "<leader>fh", "<cmd>Telescope pickers<cr>", { desc = "List all previous telescope pickers" })
	end,
}
