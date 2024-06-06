vim.keymap.set("n", "<leader>pf", ":Telescope find_files<cr>") vim.keymap.set("n", "<C-g>", ":Telescope git_files<cr>")
vim.keymap.set("n", "<leader>ps", ":Telescope live_grep<cr>")

-- tree
vim.keymap.set("n", "<leader>ft", ":NvimTreeFindFileToggle<cr>")

-- buffers
vim.keymap.set("n", "<leader>n", ":bn<cr>")
vim.keymap.set("n", "<leader>p", ":bp<cr>")
vim.keymap.set("n", "<leader>x", ":bd<cr>")

-- debugger
vim.keymap.set("n", "<leader>dt", ":lua require('dapui').toggle()<cr>")
vim.keymap.set("n", "<leader>db", ":DapToggleBreakpoint<cr>")
vim.keymap.set("n", "<leader>dc", ":DapContinue<cr>")
vim.keymap.set("n", "<leader>da", ":DapContinue<cr>")

-- co-pilot
vim.keymap.set({ 'n', 'v' }, '<leader>g', ':Gen<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gc', ':Gen Chat<CR>')
vim.keymap.set({ 'n', 'v' }, '<leader>gr', ':Gen Review_Code<CR>')

-- obsidian
vim.keymap.set({ 'n' }, '<leader>ot', ':ObsidianToday<CR>')
vim.keymap.set({ 'n' }, '<leader>onc', ':ObsidianTemplate Coding notes.md<CR>')

-- Gitsigns
vim.keymap.set("n", "<leader>gs", ":Gitsigns preview_hunk_inline<CR>", {})

-- Dismiss Noice Messages
vim.keymap.set("n", "<leader>nd", ":Noice dismiss<CR>", {desc = "Dismiss Noice Message"})

