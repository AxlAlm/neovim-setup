vim.g.mapleader = " "

-- move selected code
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- -- toggle tree
vim.keymap.set("n", "<leader>å", ":NvimTreeToggle<cr>")

vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap("i", "<C-J>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

function RenameFile(old_name, new_name)
	current_dir = vim.fn.expand("%:p:h")
	old_path = current_dir .. "/" .. old_name
	new_path = current_dir .. "/" .. new_name
	local success, err = os.rename(old_path, new_path)
	if success then
		print("File renamed successfully to " .. new_name)
		vim.cmd("e " .. new_path)
	else
		print("Error renaming file: " .. err)
	end
end

function RenameCurrentFile(new_name)
	old_name = vim.fn.expand("%:t")
	RenameFile(old_name, new_name)
end

vim.keymap.set("n", "<leader>rnf", ":lua RenameCurrentFile(vim.fn.input('New name: '))<CR>")

-- copy current file to smae dir but ask for new name

function CopyFile(old_name, new_name)
	current_dir = vim.fn.expand("%:p:h")
	old_path = current_dir .. "/" .. old_name
	new_path = current_dir .. "/" .. new_name
	local success, err = os.execute("cp " .. old_path .. " " .. new_path)
	if success then
		print("File copied successfully to " .. new_name)
		vim.cmd("e " .. new_path)
	else
		print("Error copying file: " .. err)
	end
end

function CopyCurrentFile(new_name)
	old_name = vim.fn.expand("%:t")
	CopyFile(old_name, new_name)
end

vim.keymap.set("n", "<leader>cpf", ":lua CopyCurrentFile(vim.fn.input('New name: '))<CR>")

--- new file in the same location as the current file in buffering
function NewFileInSameLocation()
	current_dir = vim.fn.expand("%:p:h")
	vim.cmd("e " .. current_dir .. "/")
end

vim.keymap.set("n", "<leader>nf", ":lua NewFileInSameLocation()<CR>")

-- delete current file
function DeleteFile()
	current_dir = vim.fn.expand("%:p:h")
	file_name = vim.fn.expand("%:t")
	local success, err = os.remove(current_dir .. "/" .. file_name)
	if success then
		print("File deleted successfully")
		vim.cmd("bd")
	else
		print("Error deleting file: " .. err)
	end
end

vim.keymap.set("n", "<leader>fd", ":lua DeleteFile()<CR>")
