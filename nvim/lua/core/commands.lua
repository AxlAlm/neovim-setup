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

-- -- delete current file
-- function DeleteFile()
-- 	local current_dir = vim.fn.expand("%:p:h")
-- 	local file_name = vim.fn.expand("%:t")
-- 	local success, err = os.remove(current_dir .. "/" .. file_name)
-- 	if success then
-- 		print("File deleted successfully")
-- 		vim.cmd("bd")
-- 	else
-- 		print("Error deleting file: " .. err)
-- 	end
-- end

-- vim.keymap.set("n", "<leader>fd", ":lua DeleteFile()<CR>")

-- -- soft delete - move to /tmp/.deleted directory
-- function SoftDeleteFile()
-- 	local file_path = vim.fn.expand("%:p")
-- 	local file_name = vim.fn.expand("%:t")

-- 	-- Create .deleted directory in /tmp
-- 	local deleted_dir = "/tmp/.deleted"
-- 	vim.fn.mkdir(deleted_dir, "p")

-- 	-- Add timestamp to avoid naming conflicts
-- 	local timestamp = os.date("%Y%m%d_%H%M%S")
-- 	local new_path = deleted_dir .. "/" .. timestamp .. "_" .. file_name

-- 	-- Move the file
-- 	local result = vim.fn.rename(file_path, new_path)

-- 	if result == 0 then
-- 		print("File moved to " .. deleted_dir)
-- 		vim.cmd("bd!")
-- 	else
-- 		print("Error moving file")
-- 	end
-- end
-- vim.keymap.set("n", "<leader>fd", ":lua SoftDeleteFile()<CR>")
