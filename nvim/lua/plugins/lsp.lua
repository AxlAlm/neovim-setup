return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"stevearc/conform.nvim",
		},
		config = function()
			local language_configs = {
				lua = {
					server = "lua_ls",
					formatters = { "stylua" },
					linters = {},
					server_config = {
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					},
				},

				go = {
					server = "gopls",
					formatters = { "goimports", "golines" },
					linters = {},
					server_config = {
						cmd_env = { GOFLAGS = "-tags=integration,e2e,wireinject" },
					},
					additional_servers = { "templ" },
				},

				-- also for javascript
				typescript = {
					server = "ts_ls",
					formatters = { "prettierd" },
					linters = {},
					server_config = {},
					additional_servers = { "html", "cssls", "tailwindcss" },
				},

				svelte = {
					server = "svelte",
					formatters = { "prettierd" },
					linters = {},
					server_config = {},
				},

				python = {
					server = "pyright",
					formatters = { "isort", "black" },
					linters = { "ruff" },
					server_config = {},
				},

				elixir = {
					server = "elixirls",
					formatters = {},
					linters = {},
					server_config = {
						cmd = { vim.fn.expand("$HOME/.local/share/nvim/mason/bin/elixir-ls") },
					},
				},

				php = {
					server = "intelephense",
					formatters = { "pint" },
					linters = {},
					server_config = {},
				},

				rust = {
					server = "rust_analyzer",
					formatters = {},
					linters = {},
					server_config = {
						settings = {
							["rust-analyzer"] = {
								cargo = {
									features = { "ssr", "hydrate" },
								},
								-- for auto-complete within leptos
								procMacro = {
									ignored = {
										leptos_macro = {
											-- optional: --
											-- "component",
											-- "server",
										},
									},
								},
							},
						},
					},
				},
			}

			local servers_to_install = {}
			local tools_to_install = {}
			for _, config in pairs(language_configs) do
				table.insert(servers_to_install, config.server)

				if config.additional_servers then
					for _, server in ipairs(config.additional_servers) do
						table.insert(servers_to_install, server)
					end
				end

				for _, formatter in ipairs(config.formatters) do
					table.insert(tools_to_install, formatter)
				end

				for _, linter in ipairs(config.linters) do
					table.insert(tools_to_install, linter)
				end
			end

			-- Server-specific configurations (outside of language configs)
			local special_server_configs = {
				html = {
					filetypes = { "html", "templ" },
				},
				tailwindcss = {
					filetypes = { "templ", "javascript", "typescript", "rust", "svelte" },
					init_options = {
						userLanguages = {
							templ = "html",
							svelte = "html",
							rust = "html", -- This tells tailwind to treat Rust files like HTML
						},
					},
				},
			}

			-- Setup on_attach function (assuming it's defined elsewhere)
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

			require("mason-lspconfig").setup({
				ensure_installed = servers_to_install,
				automatic_installation = true,
			})

			require("mason-tool-installer").setup({
				ensure_installed = tools_to_install,
			})

			local lspconfig = require("lspconfig")
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local default_config = {
				on_attach = on_attach,
				capabilities = capabilities,
			}

			-- Setup all language servers
			for _, config in pairs(language_configs) do
				-- Setup main server for the language
				local server_config = vim.tbl_deep_extend(
					"force",
					default_config,
					config.server_config or {},
					special_server_configs[config.server] or {}
				)

				-- vim.lsp.enable(config.server)
				-- vim.lsp.config(config.server, server_config)
				lspconfig[config.server].setup(server_config)

				-- Setup additional servers if any
				if config.additional_servers then
					for _, server in ipairs(config.additional_servers) do
						local additional_config =
							vim.tbl_deep_extend("force", default_config, special_server_configs[server] or {})

						-- vim.lsp.config(server, additional_config)
						lspconfig[server].setup(additional_config)
					end
				end
			end

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
					rust = { "rustfmt" },
					php = { "pint" },
					-- blade = { "blade-formatter" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
			})

			-- Add filetype for templ
			vim.filetype.add({ extension = { templ = "templ" } })

			-- add filetype for svelte
			vim.filetype.add({
				extension = {
					svelte = "svelte",
				},
			})
		end,
	},
}
