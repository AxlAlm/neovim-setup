return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"stevearc/conform.nvim",
		},
		config = function()
			-- Initialize the language profile system
			local langs = require("langs").init()

			-- Setup conform with base formatters
			local conform = require("conform")
			conform.setup({
				formatters_by_ft = {
					-- Base formatters that apply globally
					-- Language-specific formatters are added by profiles
					json = { "prettierd" },
					yaml = { "prettierd" },
					markdown = { "prettierd" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
			})

			-- Auto-load profiles from .nvim-profiles file on startup
			vim.api.nvim_create_autocmd("VimEnter", {
				callback = function()
					langs.auto_load()
				end,
				desc = "Auto-load language profiles from .nvim-profiles",
			})

			-- Create user commands for loading profiles
			vim.api.nvim_create_user_command("LoadLanguage", function(opts)
				langs.load(opts.args)
			end, {
				nargs = 1,
				complete = function()
					return langs.list_available()
				end,
				desc = "Load a language profile",
			})

			vim.api.nvim_create_user_command("LoadLanguages", function(opts)
				local languages = vim.split(opts.args, " ", { trimempty = true })
				langs.load_many(languages)
			end, {
				nargs = "+",
				complete = function()
					return langs.list_available()
				end,
				desc = "Load multiple language profiles",
			})

			vim.api.nvim_create_user_command("ListLanguageProfiles", function()
				local available = langs.list_available()
				local loaded = langs.list_loaded()

				print("Available profiles: " .. table.concat(available, ", "))
				print("Loaded profiles: " .. table.concat(loaded, ", "))
			end, {
				desc = "List available and loaded language profiles",
			})

			vim.api.nvim_create_user_command("InstallTreesitterParsers", function(opts)
				local parsers = vim.split(opts.args, " ", { trimempty = true })
				for _, parser in ipairs(parsers) do
					pcall(vim.cmd, "TSInstall " .. parser)
				end
			end, {
				nargs = "+",
				desc = "Install treesitter parsers manually",
			})
		end,
	},
}
