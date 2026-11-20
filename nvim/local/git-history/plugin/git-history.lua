vim.api.nvim_create_user_command("GitHistoryBack", function()
	require("git-history").back()
end, { desc = "Show the previous commit of the current file" })

vim.api.nvim_create_user_command("GitHistoryForward", function()
	require("git-history").forward()
end, { desc = "Show the next commit of the current file" })
