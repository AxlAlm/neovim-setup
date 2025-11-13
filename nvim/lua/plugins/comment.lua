return {
	"numToStr/Comment.nvim",
	config = function()
		require("Comment").setup({
			ignore = "^$",
			pre_hook = function(ctx)
				if vim.bo.filetype == "templ" then
					vim.bo.commentstring = "// %s"
				end
			end,
		})
	end,
}
