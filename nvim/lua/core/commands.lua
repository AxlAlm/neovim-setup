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

-- new file in the same location as the current file in buffer
function NewFileInSameLocation()
	local current_dir = vim.fn.expand("%:p:h")
	local filename = vim.fn.input("New file name: ")
	if filename ~= "" then
		vim.cmd("e " .. current_dir .. "/" .. filename)
	end
end
vim.keymap.set("n", "<leader>nf", ":lua NewFileInSameLocation()<CR>")


function CopyCurrentFileName()
  local name = vim.fn.expand("%:t")
  vim.fn.setreg("+", name)
  vim.notify("Copied: " .. name)
end
vim.keymap.set("n", "<leader>cfn", ":lua CopyCurrentFileName()<CR>")


function CopyCurrentFilePath()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end
vim.keymap.set("n", "<leader>cfp", ":lua CopyCurrentFilePath()<CR>")
