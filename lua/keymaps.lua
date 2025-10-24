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

local opts = { noremap = true, silent = true }

-- To prevent pasting from being messed up by autoindent, etc
opts.desc = "Toggle paste mode and paste from clipboard"
vim.keymap.set("n", "<leader>v", ':set paste<CR>"+p:set nopaste<CR>', opts)

-- To make jumping between windows easier
-- opts.desc = "Jump between windows"
-- vim.keymap.set("n", "<leader>w", "<C-w>", opts)

-- Remap Ctrl-s to save
opts.desc = "Save file"
vim.keymap.set("n", "<C-S>", ":w<CR>", opts)

opts.desc = "Copy selected text"
vim.keymap.set("v", "<C-C>", '"+y', opts)

-- For setting ctrl backspace remap in insert mode for Neovim-qt
opts.desc = "Delete word backwards in insert mode"
vim.keymap.set("i", "<C-BS>", "<C-w>", opts)

-- For quickly reformatting tabspaces
opts.desc = "Reformat tab spaces to 2 spaces"
vim.keymap.set("n", "<leader>t2", ":set ts=2<CR>:retab!<CR>:set ts=4<CR>", opts)

opts.desc = "Reformat tab spaces to 4 spaces"
vim.keymap.set("n", "<leader>t4", ":retab!<CR>", opts)

-- ctrl-t prefix for tab manipulation shortcuts in normal mode

opts.desc = "Open a new tab"
vim.keymap.set("n", "<C-T>n", ":tabnew<CR>", opts)
vim.keymap.set("n", "<M-t>", ":tabnew<CR>", opts)

opts.desc = "Close the current tab"
vim.keymap.set("n", "<C-T>c", ":tabclose<CR>", opts)
vim.keymap.set("n", "<M-w>", ":tabclose<CR>", opts)

opts.desc = "Close all tabs"
vim.keymap.set("n", "<M-S-w>", ":qa<CR>", opts)

opts.desc = "Go to the next tab"
vim.keymap.set("n", "<C-T>l", ":tabnext<CR>", opts)
vim.keymap.set("n", "<M-q>", ":tabnext<CR>", opts)

opts.desc = "Go to the previous tab"
vim.keymap.set("n", "<C-T>h", ":tabprevious<CR>", opts)
vim.keymap.set("n", "<M-S-q>", ":tabprevious<CR>", opts)

opts.desc = "Move the current tab to the left"
vim.keymap.set("n", "<C-T>H", ":-tabmove<CR>", opts)

opts.desc = "Move the current tab to the right"
vim.keymap.set("n", "<C-T>L", ":+tabmove<CR>", opts)

opts.desc = "Refresh current buffer"
vim.keymap.set("n", "<M-r>", ":e<CR>", opts)

-- Define a Lua function to move the current window to the previous tab
function MoveWindowToPreviousTab()
	local current_tab = vim.fn.tabpagenr()
	if current_tab > 1 then
		-- Get the current buffer number
		local current_buffer = vim.api.nvim_get_current_buf()

		-- Check if the current tab only has one window
		local is_last_window = vim.fn.winnr("$") == 1

		-- Close the current window (and tab if it's the last window)
		vim.cmd("close")

		-- If the original tab had only one window, we are now in the previous tab
		if is_last_window then
			-- Create a vertical split and move the saved buffer to it
			vim.cmd("vsplit")
			vim.cmd("buffer " .. current_buffer)
		else
			-- Move to the previous tab if not already there
			vim.cmd("tabprevious")

			-- Create a vertical split and move the saved buffer to it
			vim.cmd("vsplit")
			vim.cmd("buffer " .. current_buffer)
		end

		-- Highlight the new window
		HighlightWindow()
	else
		print("No previous tab available")
	end
end

-- Define a function to highlight the current window
function HighlightWindow()
	-- Create a highlight group for the window
	vim.api.nvim_set_hl(0, "WindowHighlight", { bg = "#FFD700" })

	-- Set the highlight for the current window
	vim.wo.winhighlight = "Normal:WindowHighlight"

	-- Remove highlight after a short delay
	vim.defer_fn(function()
		vim.wo.winhighlight = ""
	end, 200)
end

opts.desc = "Move the current window to the previous tab"
vim.keymap.set("n", "<C-T>W", MoveWindowToPreviousTab, opts)

-- Function to change the current working directory to the directory of the current file
local function change_to_file_directory()
	local current_file = vim.fn.expand("%:p")
	if current_file == "" then
		print("No file loaded")
		return
	end
	local file_directory = vim.fn.fnamemodify(current_file, ":p:h")
	vim.cmd("cd " .. file_directory)
	print("Changed directory to " .. file_directory)
end

-- Create a command for the function
vim.api.nvim_create_user_command("CdFileDir", change_to_file_directory, {})

opts.desc = "cd to current file's directory"
vim.keymap.set("n", "<leader>cd", change_to_file_directory, opts)
