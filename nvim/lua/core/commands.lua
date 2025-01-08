function RenameFile(old_name, new_name)
	local current_dir = vim.fn.expand("%:p:h")
	local old_path = current_dir .. "/" .. old_name
	local new_path = current_dir .. "/" .. new_name
	local success, err = os.rename(old_path, new_path)
	if success then
		print("File renamed successfully to " .. new_name)
		vim.cmd("e " .. new_path)
	else
		print("Error renaming file: " .. err)
	end
end

function RenameCurrentFile(new_name)
	local old_name = vim.fn.expand("%:t")
	RenameFile(old_name, new_name)
end

vim.keymap.set("n", "<leader>rnf", ":lua RenameCurrentFile(vim.fn.input('New name: '))<CR>")

-- copy current file to smae dir but ask for new name

function CopyFile(old_name, new_name)
	local current_dir = vim.fn.expand("%:p:h")
	local old_path = current_dir .. "/" .. old_name
	local new_path = current_dir .. "/" .. new_name
	local success, err = os.execute("cp " .. old_path .. " " .. new_path)
	if success then
		print("File copied successfully to " .. new_name)
		vim.cmd("e " .. new_path)
	else
		print("Error copying file: " .. err)
	end
end

function CopyCurrentFile(new_name)
	local old_name = vim.fn.expand("%:t")
	CopyFile(old_name, new_name)
end

vim.keymap.set("n", "<leader>cpf", ":lua CopyCurrentFile(vim.fn.input('New name: '))<CR>")

--- new file in the same location as the current file in buffering
function NewFileInSameLocation()
	local current_dir = vim.fn.expand("%:p:h")
	vim.cmd("e " .. current_dir .. "/")
end

vim.keymap.set("n", "<leader>nf", ":lua NewFileInSameLocation()<CR>")

-- delete current file
function DeleteFile()
	local current_dir = vim.fn.expand("%:p:h")
	local file_name = vim.fn.expand("%:t")
	local success, err = os.remove(current_dir .. "/" .. file_name)
	if success then
		print("File deleted successfully")
		vim.cmd("bd")
	else
		print("Error deleting file: " .. err)
	end
end

vim.keymap.set("n", "<leader>fd", ":lua DeleteFile()<CR>")

vim.api.nvim_create_user_command("Gitshow", function(opts)
	local git_path
	-- Check if the argument contains a colon (indicating full path is provided)
	if string.find(opts.args, ":") then
		git_path = opts.args
	else
		local current_file = vim.fn.expand("%")
		git_path = opts.args .. ":" .. current_file
	end

	vim.cmd("tabnew")
	vim.cmd("read !git show " .. git_path)
	-- Extract filename for filetype detection
	local filename = git_path:match("[^:]*:?(.+)$")
	vim.bo.filetype = vim.filetype.match({ filename = filename })
	vim.cmd("TSBufEnable highlight")
end, { nargs = 1 })
