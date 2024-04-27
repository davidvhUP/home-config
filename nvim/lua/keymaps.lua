-- space bar leader key
vim.g.mapleader = ' '

-- navigate directory
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- yank to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])

