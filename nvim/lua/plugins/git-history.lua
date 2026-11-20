return {
	dir = vim.fn.stdpath("config") .. "/local/git-history",
	config = function()
		vim.keymap.set("n", "<C-S-j>", "<cmd>GitHistoryBack<CR>", { desc = "Git history: older commit" })
		vim.keymap.set("n", "<C-S-k>", "<cmd>GitHistoryForward<CR>", { desc = "Git history: newer commit" })
	end,
}
