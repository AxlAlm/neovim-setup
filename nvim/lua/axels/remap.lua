vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move selected code
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- -- toggle tree
-- vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<cr>")


vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)


vim.keymap.set("n", "<leader>t", "<cmd>TroubleToggle<cr>",
    { silent = true, noremap = true }
)
