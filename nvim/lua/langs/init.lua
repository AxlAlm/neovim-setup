local M = {}

-- Track loaded profiles
M.loaded_profiles = {}

-- Shared LSP configuration
local lsp_config = nil

-- Initialize the profile system
function M.init()
	-- Setup base LSP configuration
	local on_attach = function(_, bufnr)
		local opts = { buffer = bufnr, remap = false }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>dn", vim.diagnostic.goto_next, opts)
	end

	local capabilities = require("cmp_nvim_lsp").default_capabilities()

	lsp_config = {
		on_attach = on_attach,
		capabilities = capabilities,
		default_config = {
			on_attach = on_attach,
			capabilities = capabilities,
		},
	}

	return M
end

-- Get LSP config for profiles to use
function M.get_lsp_config()
	return lsp_config
end

-- Common setup function for language profiles
local function setup_profile(profile, opts)
	opts = opts or {}

	if not lsp_config then
		vim.notify("LSP config not initialized. Call require('langs').init() first.", vim.log.levels.ERROR)
		return
	end

	-- Setup each LSP server
	if profile.lsp_servers then
		for _, server in ipairs(profile.lsp_servers) do
			local server_config = vim.tbl_deep_extend("force", lsp_config.default_config, server.config or {})
			vim.lsp.config[server.name] = server_config
			vim.lsp.enable(server.name)
		end
	end

	-- Setup special/additional servers
	if profile.special_servers and next(profile.special_servers) then
		for server_name, server_config in pairs(profile.special_servers) do
			local is_main_server = false
			if profile.lsp_servers then
				for _, server in ipairs(profile.lsp_servers) do
					if server.name == server_name then
						is_main_server = true
						break
					end
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
	if profile.formatters and next(profile.formatters) then
		local ok, conform = pcall(require, "conform")
		if ok then
			local current_formatters = conform.formatters_by_ft or {}
			for ft, formatters in pairs(profile.formatters) do
				current_formatters[ft] = formatters
			end
			conform.setup({ formatters_by_ft = current_formatters })
		end
	end

	-- Install treesitter parsers if requested
	if opts.install_treesitter == true and profile.treesitter_parsers then
		local ok_ts, ts_parsers = pcall(require, "nvim-treesitter.parsers")
		if ok_ts then
			for _, parser in ipairs(profile.treesitter_parsers) do
				-- Only install if not already installed
				if not ts_parsers.has_parser(parser) then
					pcall(vim.cmd, "TSInstall " .. parser)
				end
			end
		end
	end

	-- Register custom filetypes
	if profile.filetype_extensions and next(profile.filetype_extensions) then
		vim.filetype.add({ extension = profile.filetype_extensions })
	end

	-- Call custom setup hook if defined
	if profile.custom_setup then
		profile.custom_setup(opts, lsp_config)
	end
end

-- Load a language profile
function M.load(language, opts)
	opts = opts or {}

	-- Enable treesitter installation by default
	if opts.install_treesitter == nil then
		opts.install_treesitter = true
	end

	-- Check if already loaded
	if M.loaded_profiles[language] then
		if not opts.quiet then
			print("Profile already loaded: " .. language)
		end
		return true
	end

	-- Try to load the profile module
	local ok, profile = pcall(require, "langs." .. language)
	if not ok then
		vim.notify("Language profile not found: " .. language, vim.log.levels.ERROR)
		return false
	end

	-- Setup the profile using common setup function
	setup_profile(profile, opts)

	-- Mark as loaded
	M.loaded_profiles[language] = true

	if not opts.quiet then
		print("Loaded language profile: " .. language)
	end

	return true
end

-- Load multiple profiles at once
function M.load_many(languages, opts)
	opts = opts or {}
	local loaded = {}
	local failed = {}

	for _, lang in ipairs(languages) do
		local success = M.load(lang, vim.tbl_extend("force", opts, { quiet = true }))
		if success then
			table.insert(loaded, lang)
		else
			table.insert(failed, lang)
		end
	end

	-- Print summary
	if #loaded > 0 then
		print("Loaded profiles: " .. table.concat(loaded, ", "))
	end
	if #failed > 0 then
		vim.notify("Failed to load profiles: " .. table.concat(failed, ", "), vim.log.levels.WARN)
	end
end

-- List available profiles
function M.list_available()
	local langs_path = vim.fn.stdpath("config") .. "/lua/langs"
	local profiles = {}

	for name, ftype in vim.fs.dir(langs_path) do
		if ftype == "file" and name:match("%.lua$") and name ~= "init.lua" then
			table.insert(profiles, (name:gsub("%.lua$", "")))
		end
	end

	table.sort(profiles)
	return profiles
end

-- List loaded profiles
function M.list_loaded()
	local loaded = {}
	for name, _ in pairs(M.loaded_profiles) do
		table.insert(loaded, name)
	end
	table.sort(loaded)
	return loaded
end

-- Find project root directory
function M.find_project_root()
	-- Try to find git root first
	local git_root = vim.fs.find(".git", {
		upward = true,
		stop = vim.loop.os_homedir(),
		path = vim.fn.getcwd(),
	})[1]

	if git_root then
		return vim.fn.fnamemodify(git_root, ":h")
	end

	-- Try to find .nvim-profiles file
	local nvim_profiles = vim.fs.find(".nvim-profiles", {
		upward = true,
		stop = vim.loop.os_homedir(),
		path = vim.fn.getcwd(),
	})[1]

	if nvim_profiles then
		return vim.fn.fnamemodify(nvim_profiles, ":h")
	end

	-- Fall back to current working directory
	return vim.fn.getcwd()
end

-- Parse .nvim-profiles file and return list of profiles
local function parse_profiles_file(filepath)
	local profiles = {}

	local file = io.open(filepath, "r")
	if not file then
		return profiles
	end

	for line in file:lines() do
		-- Trim whitespace
		line = line:match("^%s*(.-)%s*$")

		-- Skip empty lines and comments
		if line ~= "" and not line:match("^#") then
			-- Remove inline comments
			line = line:match("^([^#]+)"):match("^%s*(.-)%s*$")
			if line ~= "" then
				table.insert(profiles, line)
			end
		end
	end

	file:close()
	return profiles
end

-- Load profiles from .nvim-profiles file
function M.load_from_file(filepath)
	local profiles = parse_profiles_file(filepath)

	if #profiles == 0 then
		return false
	end

	M.load_many(profiles)
	return true
end

-- Auto-load profiles from .nvim-profiles in project root
function M.auto_load()
	local project_root = M.find_project_root()
	local profiles_file = project_root .. "/.nvim-profiles"

	-- Check if file exists
	if vim.fn.filereadable(profiles_file) == 1 then
		M.load_from_file(profiles_file)
	end
end

return M
