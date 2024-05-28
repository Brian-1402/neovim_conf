-- Setting leader key as Space
vim.g.mapleader = " "

-- Don't use Q for Ex mode, use it for formatting.	Except for Select mode.
-- Revert with ":unmap Q".
vim.api.nvim_set_keymap("n", "Q", "gq", { noremap = true })
vim.api.nvim_set_keymap("x", "Q", "gq", { noremap = true })
vim.api.nvim_set_keymap("s", "Q", "gq", { noremap = true })

-- CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
-- so that you can undo CTRL-U after inserting a line break.
-- Revert with ":iunmap <C-U>".
vim.api.nvim_set_keymap("i", "<C-U>", "<C-G>u<C-U>", { noremap = true })


-- To prevent pasting from being messed up by autoindent, etc
vim.keymap.set("n", "<leader>v", ':set paste<CR>"+p:set nopaste<CR>', { noremap = true, silent = true })
vim.keymap.set("v", "<leader>v", ':set paste<CR>"+p:set nopaste<CR>', { noremap = true, silent = true })
-- vim.keymap.set("n", "<leader>c", ""+y", { noremap = true, silent = true }) -- For normal mode
-- vim.keymap.set("v", "<leader>c", ""+y", { noremap = true, silent = true }) -- For visual mode

-- To make jumping between windows easier
-- vim.keymap.set("n", "<leader>w", "<C-w>", { noremap = true, silent = true })

-- Remap Ctrl-s to save
vim.keymap.set("n", "<C-S>", ":w<CR>", { noremap = true, silent = true })

-- For setting ctrl backspace remap in insert mode for Neovim-qt
vim.keymap.set("i", "<C-BS>", "<C-w>", { noremap = true, silent = true })

-- For quickly reformatting tabspaces
vim.keymap.set("n", "<leader>t2", ":set ts=2<CR>:retab!<CR>:set ts=4<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>t4", ":retab!<CR>", { noremap = true, silent = true })
