return {
	'folke/tokyonight.nvim',
    config = function() 
        color = color or "tokyonight"
        vim.cmd.colorscheme(color)
        --vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    end 
}
