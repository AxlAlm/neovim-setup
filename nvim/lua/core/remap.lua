vim.g.mapleader = " "

-- move selected code
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- close all tabs
vim.keymap.set("n", "<leader>to", ":tabclose<CR>", { desc = "Close all tabs" })
