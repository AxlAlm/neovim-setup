return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"stevearc/conform.nvim",
		},
		config = function()
			-- Initialize the profile system
			local profiles = require("profiles").init()

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
					profiles.auto_load()
				end,
				desc = "Auto-load profiles from .nvim-profiles",
			})

			-- -- Create user commands for loading profiles
			-- vim.api.nvim_create_user_command("LoadProfile", function(opts)
			-- 	profiles.load(opts.args)
			-- end, {
			-- 	nargs = 1,
			-- 	complete = function()
			-- 		return profiles.list_available()
			-- 	end,
			-- 	desc = "Load a profile",
			-- })

			-- vim.api.nvim_create_user_command("LoadProfiles", function(opts)
			-- 	local profile_list = vim.split(opts.args, " ", { trimempty = true })
			-- 	profiles.load_many(profile_list)
			-- end, {
			-- 	nargs = "+",
			-- 	complete = function()
			-- 		return profiles.list_available()
			-- 	end,
			-- 	desc = "Load multiple profiles",
			-- })

			vim.api.nvim_create_user_command("ListProfiles", function()
				local loaded = profiles.list_loaded()

				print("=== Base Profiles ===")
				if #loaded > 0 then
					print(table.concat(loaded, ", "))
				else
					print("None")
				end

				-- Show custom profile if loaded
				if profiles.custom_profile then
					print("")
					print("=== Custom Profile ===")
					print(profiles.custom_profile.path)
				end
			end, {
				desc = "List loaded profiles",
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
