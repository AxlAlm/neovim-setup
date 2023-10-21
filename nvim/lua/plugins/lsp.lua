return {
	"VonHeikemen/lsp-zero.nvim",
	branch = "v3.x",
	dependencies = {
		"neovim/nvim-lspconfig",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local lsp_zero = require("lsp-zero")

		lsp_zero.on_attach(function(client, bufnr)
			local opts = { buffer = bufnr, remap = false }
			vim.keymap.set("n", "gd", function()
				vim.lsp.buf.definition()
			end, opts)
			vim.keymap.set("n", "K", function()
				vim.lsp.buf.hover()
			end, opts)
			vim.keymap.set("n", "<leader>ca", function()
				vim.lsp.buf.code_action()
			end, opts)
			vim.keymap.set("n", "<leader>rn", function()
				vim.lsp.buf.rename()
			end, opts)
			vim.keymap.set("n", "<leader>d", function()
				vim.diagnostic.open_float()
			end, opts)
		end)

		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")

		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		local lang_servers = {
			"pyright",
			"gopls",
			"tsserver",
			"html",
			"cssls",
			"tailwindcss",
			"lua_ls",
			-- "json-lsp",
			-- "html-lsp",
			-- "htmx-lsp",
			"rust_analyzer",
		}

		mason_lspconfig.setup({
			ensure_installed = lang_servers,
			automatic_installation = true,
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"goimports", -- go import fomratter
				"golines", -- go formatter for long lines
				"prettierd", -- prettier formatter (for yaml, ts etc)
				"stylua", -- lua formatter
				"isort", -- python formatter
				"black", -- python formatter
				"ruff", -- python linter
				-- "eslint_d", -- js linter
			},
		})

		lsp_zero.setup_servers(lang_servers)

		local cmp = require("cmp")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		cmp.setup({
			sources = {
				{ name = "path" },
				{ name = "nvim_lsp" },
				{ name = "nvim_lua" },
			},
			formatting = lsp_zero.cmp_format(),
			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping.confirm({ select = true }),
				["<C-Space>"] = cmp.mapping.complete(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(cmp_select),
				["<Tab>"] = cmp.mapping.select_next_item(cmp_select),
			}),
		})
	end,
}
