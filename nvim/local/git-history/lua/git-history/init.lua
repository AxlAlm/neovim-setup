local M = {}

local sessions = {}

local function git(dir, args)
	local cmd = { "git", "-C", dir, "-c", "core.quotePath=false" }
	vim.list_extend(cmd, args)
	local result = vim.system(cmd, { text = true }):wait()
	if result.code ~= 0 then
		return nil
	end
	return result.stdout
end

local function load_commits(dir, name)
	local out = git(dir, {
		"log",
		"--follow",
		"--name-only",
		"--date=short",
		"--format=%x01%H%x02%h%x02%ad%x02%an%x02%s",
		"--",
		name,
	})
	local commits = {}
	for _, line in ipairs(vim.split(out or "", "\n", { plain = true })) do
		if line:sub(1, 1) == "\1" then
			local hash, short, date, author, subject = line:match("^\1(.-)\2(.-)\2(.-)\2(.-)\2(.*)$")
			commits[#commits + 1] = { hash = hash, short = short, date = date, author = author, subject = subject }
		elseif line ~= "" and #commits > 0 then
			commits[#commits].path = line
		end
	end
	return vim.tbl_filter(function(commit)
		return commit.path ~= nil
	end, commits)
end

local function read(history, index)
	local commit = history.commits[index]
	if not commit.lines then
		local out = git(history.dir, { "show", commit.hash .. ":" .. commit.path })
		if not out then
			return nil
		end
		local lines = vim.split(out, "\n", { plain = true })
		if lines[#lines] == "" then
			table.remove(lines)
		end
		commit.lines = lines
	end
	return commit.lines
end

local function open(buf)
	local file = vim.bo[buf].buftype == "" and vim.uv.fs_realpath(vim.api.nvim_buf_get_name(buf))
	if not file then
		vim.notify("git-history: not a file", vim.log.levels.WARN)
		return nil
	end
	local dir = vim.fs.dirname(file)
	local commits = load_commits(dir, vim.fs.basename(file))
	if #commits == 0 then
		vim.notify("git-history: no history for this file", vim.log.levels.WARN)
		return nil
	end
	local history = {
		dir = dir,
		file = file,
		commits = commits,
		origin = buf,
		filetype = vim.bo[buf].filetype,
		first = 1,
	}
	local newest = read(history, 1)
	if #commits > 1 and newest and vim.deep_equal(newest, vim.api.nvim_buf_get_lines(buf, 0, -1, false)) then
		history.first = 2
	end
	return history
end

local function show(history, index)
	local lines = read(history, index)
	if not lines then
		vim.notify("git-history: could not read commit", vim.log.levels.ERROR)
		return
	end
	local commit = history.commits[index]
	local view = vim.fn.winsaveview()
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].modifiable = false
	pcall(vim.api.nvim_buf_set_name, buf, ("git-history://%s/%s"):format(commit.short, commit.path))
	sessions[buf] = { history = history, index = index }
	vim.api.nvim_create_autocmd("BufWipeout", {
		buffer = buf,
		once = true,
		callback = function()
			sessions[buf] = nil
		end,
	})
	vim.api.nvim_win_set_buf(0, buf)
	vim.bo[buf].filetype = history.filetype
	vim.fn.winrestview(view)
	local message = ("[%d/%d] %s %s %s: %s"):format(
		index,
		#history.commits,
		commit.short,
		commit.date,
		commit.author,
		commit.subject
	)
	vim.api.nvim_echo({ { vim.fn.strcharpart(message, 0, vim.v.echospace) } }, false, {})
end

local function close(history)
	local view = vim.fn.winsaveview()
	if vim.api.nvim_buf_is_valid(history.origin) then
		vim.api.nvim_win_set_buf(0, history.origin)
	else
		vim.cmd.edit(vim.fn.fnameescape(history.file))
	end
	vim.fn.winrestview(view)
	vim.api.nvim_echo({ { "working copy" } }, false, {})
end

local function step(delta)
	local session = sessions[vim.api.nvim_get_current_buf()]
	if not session then
		if delta < 0 then
			vim.notify("git-history: already at working copy")
			return
		end
		local history = open(vim.api.nvim_get_current_buf())
		if history then
			show(history, history.first)
		end
		return
	end
	local history, index = session.history, session.index + delta
	if index > #history.commits then
		vim.notify("git-history: already at oldest commit")
	elseif index < history.first then
		close(history)
	else
		show(history, index)
	end
end

function M.status()
	local session = sessions[vim.api.nvim_get_current_buf()]
	if not session then
		return ""
	end
	local commit = session.history.commits[session.index]
	return commit.short .. " " .. commit.subject
end

function M.back()
	step(1)
end

function M.forward()
	step(-1)
end

return M
