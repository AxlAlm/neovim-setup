vim.g.mapleader = " "

-- move selected code
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- -- close all tabs
-- vim.keymap.set("n", "<leader>ct", ":tabclose<CR>", { desc = "Close all tabs" })

-- open terminal in a different tab
-- vim.keymap.set("n", "<leader>ot", function()
-- 	vim.cmd("tabnew")
-- 	vim.cmd("terminal")
-- end, { desc = "Open terminal in new tab" })

-- -- Map Command+h to navigate to previous tab
-- vim.keymap.set("n", "<D-h>", ":tabprevious<CR>")

-- -- Map Command+l to navigate to next tab
-- vim.keymap.set("n", "<D-l>", ":tabnext<CR>")
