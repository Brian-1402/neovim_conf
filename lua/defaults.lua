-- Allow backspacing over everything in insert mode.
vim.o.backspace = "indent,eol,start"

vim.o.history = 500			 -- keep 200 lines of command line history
vim.o.ruler = true			 -- show the cursor position all the time
vim.o.showcmd = true		 -- display incomplete commands
vim.o.wildmenu = true		 -- display completion matches in a status line

vim.o.ttimeout = true		 -- time out for key codes
vim.o.ttimeoutlen = 100  -- wait up to 100ms after Esc for special key

-- Show @@@ in the last line if it is truncated.
vim.o.display = "truncate"

-- Show a few lines of context around the cursor.
vim.o.scrolloff = 1

-- Do incremental searching when it's possible to timeout.
if vim.fn.has("reltime") == 1 then
		vim.o.incsearch = true
end

-- In many terminal emulators, the mouse works just fine.  By enabling it, you
-- can position the cursor, visually select, and scroll with the mouse.
-- Only xterm can grab the mouse events when using the shift key, for other
-- terminals use ":", select text and press Esc.
if vim.fn.has("mouse") == 1 then
		if vim.o.term:match('xterm') then
				vim.o.mouse = 'a'
		else
				vim.o.mouse = 'nvi'
		end
end

if tonumber(vim.o.t_Co) > 2 or vim.fn.has("gui_running") == 1 then
	-- Switch on highlighting the last used search pattern.
	-- vim.o.syntax = false
	vim.o.hlsearch = true
	vim.o.c_comment_strings = 1
end

vim.o.backup = true		-- keep a backup file (restore to previous version)
vim.o.backupdir = vim.fn.stdpath("data") .. "/backup//,."
if vim.fn.has('persistent_undo') == 1 then
	vim.o.undofile = true	-- keep an undo file (undo changes after closing)
	vim.o.undodir = vim.fn.stdpath("data") .. "/undo//,."
end

-- So that files with unsaved changes in the buffer gets hidden in buffer instead of throwing error asking to save
vim.o.hidden = true

-- changing tab length from 8 to 4
vim.o.tabstop = 4
vim.o.softtabstop = 0
vim.o.noexpandtab = true
vim.o.shiftwidth = 4

vim.o.encoding = "utf-8"

-- line wrap settings
-- Activate wrapping
vim.o.wrap = false
-- Break by word and not character
vim.o.linebreak = true
-- set visual indents when long lines are wrapped
vim.o.breakindent = true

-- For avoiding quotes and stuff from disappearing in json and md due to vim
-- conceal being activated by indentLine plugin
-- https://github.com/Yggdroot/indentLine?tab=readme-ov-file#customization
vim.g.vim_json_conceal = 0
-- vim.g.markdown_syntax_conceal = 0

-- For configuring python
vim.g.python3_host_prog = "C:/Users/brian/AppData/Local/Programs/Python/Python312/python.exe"
