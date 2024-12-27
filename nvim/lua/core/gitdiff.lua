local M = {}

local function get_file_history()
	local file = vim.fn.expand("%")
	local handle = io.popen("git log --format=%H " .. file)
	if handle == nil then
		return {}
	end

	local result = handle:read("*a")
	handle:close()

	local commits = {}
	for hash in result:gmatch("[^\n]+") do
		table.insert(commits, hash)
	end
	return commits
end

M.current_commit_index = 1
M.commits = {}
M.relative_path = nil
M.diff_buffers = {} -- Store buffer numbers for diff view

function M.open_diff()
	M.relative_path = vim.fn.expand("%")
	local current_content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local filetype = vim.bo.filetype

	M.commits = get_file_history()
	M.current_commit_index = 1

	-- Create new tab
	vim.cmd("tabnew")
	vim.cmd("vsplit")

	-- Left window (git history)
	vim.cmd("wincmd h")
	vim.cmd("enew")
	vim.cmd("setlocal buftype=nofile")
	vim.cmd("setlocal modifiable")
	vim.cmd("read !git show HEAD:./" .. M.relative_path)
	vim.cmd("1delete")
	vim.cmd("setlocal nomodifiable")
	vim.bo.filetype = filetype
	vim.cmd("TSBufEnable highlight")
	vim.cmd("diffthis")
	-- Store left buffer number
	M.diff_buffers.left = vim.api.nvim_get_current_buf()

	-- Right window (current file)
	vim.cmd("wincmd l")
	vim.cmd("enew")
	vim.cmd("setlocal buftype=nofile")
	vim.cmd("setlocal modifiable")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, current_content)
	vim.cmd("setlocal nomodifiable") -- Make right pane non-editable
	vim.bo.filetype = filetype
	vim.cmd("TSBufEnable highlight")
	vim.cmd("diffthis")
	-- Store right buffer number
	M.diff_buffers.right = vim.api.nvim_get_current_buf()

	-- Set up local keymaps for this tab only
	local opts = { buffer = true, desc = "Previous commit in diff view" }
	vim.keymap.set("n", "J", function()
		M.prev_commit()
	end, opts)

	vim.keymap.set("n", "K", function()
		M.next_commit()
	end, { buffer = true, desc = "Next commit in diff view" })
end

function M.prev_commit()
	-- Check if we're in a diff buffer
	local current_buf = vim.api.nvim_get_current_buf()
	if current_buf ~= M.diff_buffers.left and current_buf ~= M.diff_buffers.right then
		return
	end

	if M.current_commit_index < #M.commits then
		M.current_commit_index = M.current_commit_index + 1
		local commit = M.commits[M.current_commit_index]
		local filetype = vim.bo.filetype

		vim.cmd("wincmd h")
		vim.cmd("setlocal modifiable")
		vim.cmd("%delete")
		vim.cmd("read !git show " .. commit .. ":./" .. M.relative_path)
		vim.cmd("1delete")
		vim.cmd("setlocal nomodifiable")
		vim.bo.filetype = filetype
		vim.cmd("TSBufEnable highlight")
		vim.cmd("diffthis")

		vim.cmd("wincmd l")
	end
end

function M.next_commit()
	-- Check if we're in a diff buffer
	local current_buf = vim.api.nvim_get_current_buf()
	if current_buf ~= M.diff_buffers.left and current_buf ~= M.diff_buffers.right then
		return
	end

	if M.current_commit_index > 1 then
		M.current_commit_index = M.current_commit_index - 1
		local commit = M.commits[M.current_commit_index]
		local filetype = vim.bo.filetype

		vim.cmd("wincmd h")
		vim.cmd("setlocal modifiable")
		vim.cmd("%delete")
		vim.cmd("read !git show " .. commit .. ":./" .. M.relative_path)
		vim.cmd("1delete")
		vim.cmd("setlocal nomodifiable")
		vim.bo.filetype = filetype
		vim.cmd("TSBufEnable highlight")
		vim.cmd("diffthis")

		vim.cmd("wincmd l")
	end
end

function M.setup()
	vim.keymap.set("n", "<leader>df", function()
		M.open_diff()
	end, { desc = "Open file diff view" })

	vim.keymap.set("n", "<leader>fD", function()
		vim.cmd("tabclose")
	end, { desc = "Close diff view" })
end

return M
