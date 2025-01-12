return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			local on_attach = function(_, bufnr)
				local opts = { buffer = bufnr, remap = false }
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				-- diagnostics
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
			end

			-- Setup mason
			require("mason").setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			local servers = {
				"pyright",
				"gopls",
				"ts_ls",
				"html",
				"cssls",
				"tailwindcss",
				"lua_ls",
				"rust_analyzer",
				"templ",
				"phpactor",
			}

			-- Setup mason-lspconfig
			require("mason-lspconfig").setup({
				ensure_installed = servers,
				automatic_installation = true,
			})

			-- Setup mason-tool-installer
			require("mason-tool-installer").setup({
				ensure_installed = {
					"goimports",
					"golines",
					"prettierd",
					"stylua",
					"isort",
					"black",
					"ruff",
					"html",
					"templ",
					"php-cs-fixer",
				},
			})

			-- Configure LSP servers
			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Default configuration for all servers
			local default_config = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- Server-specific configurations
			local server_configs = {
				html = {
					filetypes = { "html", "templ" },
				},
				tailwindcss = {
					filetypes = { "templ", "javascript", "typescript" },
					init_options = { userLanguages = { templ = "html" } },
				},
				gopls = {
					cmd_env = { GOFLAGS = "-tags=integration,integration_external,e2e,wireinject" },
				},
			}

			-- Setup servers
			for _, server in ipairs(servers) do
				local config = vim.tbl_deep_extend("force", default_config, server_configs[server] or {})
				lspconfig[server].setup(config)
			end

			-- Add filetype for templ
			vim.filetype.add({ extension = { templ = "templ" } })
		end,
	},
}
