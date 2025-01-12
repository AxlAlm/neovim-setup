return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		vim.filetype.add({
			pattern = {
				[".*%.blade%.php"] = "blade",
			},
		})
		require("nvim-treesitter.configs").setup({

			ensure_installed = {
				"c",
				"lua",
				"vim",
				"vimdoc",
				"query",
				"python",
				"go",
				"javascript",
				"typescript",
				"rust",
				"html",
				"sql",
				"bash",
				"tsx",
				"css",
				"templ",
				"php",
				"blade",
				"php_only",
			},

			sync_install = false,
			auto_install = true,

			context_commentstring = {
				enable = true,
			},

			highlight = {
				enable = true,
				-- additional_vim_regex_highlighting = false,
			},
		})

		local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
		parser_config.blade = {
			install_info = {
				url = "https://github.com/EmranMR/tree-sitter-blade",
				files = { "src/parser.c" },
				branch = "main",
			},
			filetype = "blade",
		}
	end,
}
