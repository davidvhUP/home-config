-- space bar leader key
vim.g.mapleader = ' '

-- navigate directory
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- yank to clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])

-- (ok) move file in current buffer to 'fleeting notes'
vim.keymap.set("n", "<leader>ok", ":!mv '%:p' /mnt/d/Google\\ Drive/Obsidian\\ vault/Fleeting\\ notes<cr>bd:<cr>")

-- (odd) delete file in current buffer
vim.keymap.set("n", "<leader>odd", ":!rm '%:p' <cr>:bd<cr>")
