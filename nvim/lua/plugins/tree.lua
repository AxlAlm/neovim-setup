return {
		'nvim-tree/nvim-tree.lua',
		depdendecies = {
			'nvim-tree/nvim-web-devicons',
		},
		config = function()
			require("nvim-tree").setup {}
		end
}
