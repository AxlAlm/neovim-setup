return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				lua = { "stylua" },
				python = { "isort", "black" },
				go = { "gopls", "goimports", "golines" },
				templ = { "templ", "prettierd" },
				php = { "php" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
			formatters = {
				php = {
					command = "php-cs-fixer",
					args = {
						"fix",
						"$FILENAME",
						"--config=/your/path/to/config/file/[filename].php",
						"--allow-risky=yes", -- if you have risky stuff in config, if not you dont need it.
					},
					stdin = false,
				},
			},
		})

		vim.keymap.set("", "<leader>f", function()
			require("conform").format({ async = true, lsp_fallback = true })
		end)
	end,
}
