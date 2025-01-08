return {
	"sindrets/diffview.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	keys = {
		-- Open current file history in vertical split
		{ "<leader>fh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
	},
	opts = {
		view = {
			default = {
				layout = "diff2_horizontal", -- or "diff2_vertical" if you prefer
				winbar_info = false, -- Cleaner interface
			},
		},
		file_history_panel = {
			win_config = { -- See |diffview-config-win_config|
				height = 6,
			},
		},
		keymaps = {
			view = {
				["J"] = "<cmd>lua require('diffview.actions').select_next_entry()<CR>",
				["K"] = "<cmd>lua require('diffview.actions').select_prev_entry()<CR>",
			},
			file_history_panel = {
				-- Navigate through file history
				["J"] = "<cmd>lua require('diffview.actions').select_next_entry()<CR>",
				["K"] = "<cmd>lua require('diffview.actions').select_prev_entry()<CR>",
				["q"] = "<cmd>lua require('diffview.actions').close()<CR>",
			},
		},
	},
}
