local M = {}

-- Profile metadata
M.name = "elixir"
M.filetypes = { "elixir", "eex", "heex" }
M.treesitter_parsers = { "elixir", "eex", "heex" }

-- LSP servers configuration
M.lsp_servers = {
	{
		name = "elixirls",
		config = {},
	},
}

-- Special server configurations
M.special_servers = {}

-- Formatters for conform.nvim
M.formatters = {}

-- Linters
M.linters = {}

-- Custom filetype associations
M.filetype_extensions = {}

-- Profile activation function
function M.setup(opts)
	opts = opts or {}
	local lsp_config = require("langs").get_lsp_config()

	if not lsp_config then
		vim.notify("LSP config not initialized. Call require('langs').init() first.", vim.log.levels.ERROR)
		return
	end

	-- Setup each LSP server
	for _, server in ipairs(M.lsp_servers) do
		local server_config = vim.tbl_deep_extend("force", lsp_config.default_config, server.config or {})

		vim.lsp.config[server.name] = server_config
		vim.lsp.enable(server.name)
	end

	-- Setup special/additional servers
	if M.special_servers and next(M.special_servers) then
		for server_name, server_config in pairs(M.special_servers) do
			local is_main_server = false
			for _, server in ipairs(M.lsp_servers) do
				if server.name == server_name then
					is_main_server = true
					break
				end
			end

			if not is_main_server then
				local config = vim.tbl_deep_extend("force", lsp_config.default_config, server_config)
				vim.lsp.config[server_name] = config
				vim.lsp.enable(server_name)
			end
		end
	end

	-- Register formatters with conform
	local ok, conform = pcall(require, "conform")
	if ok and M.formatters and next(M.formatters) then
		local current_formatters = conform.formatters_by_ft or {}
		for ft, formatters in pairs(M.formatters) do
			current_formatters[ft] = formatters
		end
		conform.setup({ formatters_by_ft = current_formatters })
	end

	-- Install treesitter parsers if requested
	if opts.install_treesitter == true and M.treesitter_parsers then
		local ok_ts, _ = pcall(require, "nvim-treesitter.configs")
		if ok_ts then
			for _, parser in ipairs(M.treesitter_parsers) do
				pcall(vim.cmd, "TSInstall " .. parser)
			end
		end
	end

	-- Register custom filetypes
	if M.filetype_extensions and next(M.filetype_extensions) then
		vim.filetype.add({ extension = M.filetype_extensions })
	end
end

return M
