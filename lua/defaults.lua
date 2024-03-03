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

-- Size of imaginary boundary near the edges till where the cursor can move.
vim.o.scrolloff = 1

-- In many terminal emulators, the mouse works just fine.  By enabling it, you
-- can position the cursor, visually select, and scroll with the mouse.
-- Only xterm can grab the mouse events when using the shift key, for other
-- terminals use ":", select text and press Esc.
if vim.fn.has("mouse") == 1 then
		-- if vim.o.term:match('xterm') then
		-- 		vim.o.mouse = 'a'
		-- else
				vim.o.mouse = 'nvi'
		-- end
end

-- Do incremental searching when it's possible to timeout.
if vim.fn.has("reltime") == 1 then
		vim.o.incsearch = true
end

if vim.fn.has("gui_running") == 1 then
	-- Switch on highlighting the last used search pattern.
	-- vim.o.syntax = false
	vim.o.hlsearch = true
	-- vim.o.c_comment_strings = 1
end

vim.o.backup = true		-- keep a backup file (restore to previous version)
vim.fn.mkdir(vim.fn.stdpath("data") .. "/backup", "p") -- make dir if it doesnt exist
vim.o.backupdir = vim.fn.stdpath("data") .. "/backup//,."
-- make dir if it doesnt exist
if vim.fn.has('persistent_undo') == 1 then
	vim.o.undofile = true	-- keep an undo file (undo changes after closing)
	vim.fn.mkdir(vim.fn.stdpath("data") .. "/undo", "p")
	vim.o.undodir = vim.fn.stdpath("data") .. "/undo//,."
end
vim.go.undolevels = 10000

-- So that files with unsaved changes in the buffer gets hidden in buffer instead of throwing error asking to save
vim.o.hidden = true

-- changing tab length from 8 to 4
vim.o.tabstop = 4
vim.o.shiftwidth = 0 -- 0 means same as tabstop
vim.o.softtabstop = 0
vim.o.expandtab = false

vim.o.virtualedit = "block" -- allows cursor to go anywhere in visual block mode

vim.o.encoding = "utf-8"

-- line wrap settings
vim.o.wrap = false
-- Break by word and not character
vim.o.linebreak = true
-- set visual indents when long lines are wrapped
vim.o.breakindent = true

-- open horizontal splits below the current window
-- open vertical splits to the right of the current window
vim.o.splitright = true
vim.o.splitbelow = true

-- Use system clipboard for all operations by default
-- vim.o.clipboard = "unnamedplus"

-- Ignore case when searching
vim.o.ignorecase = true
-- Do not ignore case if search pattern contains uppercase characters
vim.o.smartcase = true
-- backslashes do not have special meaning in / search. This sort of decreases RegEx ability of search
vim.o.magic = false

-- Highlight search matches in current buffer itself
vim.o.inccommand = "nosplit"

-- options: "useopen" and/or "split"; which window to use when jumping to a buffer
-- vim.o.switchbuf = "split"

-- for :s command to replace all matches in a line by default, and mention g for replacing just one match
vim.o.gdefault = true

-- when inserting a bracket, briefly jump to its match
vim.o.showmatch = false -- this is annoying

if vim.fn.has("unix") then
	vim.o.shell = "bash"
elseif vim.fn.has("win32") then
	vim.o.shell = "pwsh.exe"
end

-- For avoiding quotes and stuff from disappearing in json and md due to vim
-- conceal being activated by indentLine plugin
-- https://github.com/Yggdroot/indentLine?tab=readme-ov-file#customization
vim.g.vim_json_conceal = 0
-- vim.g.markdown_syntax_conceal = 0

-- For configuring python
if vim.fn.has("win32") then
	vim.g.python3_host_prog = "C:/Users/brian/AppData/Local/Programs/Python/Python312/python.exe"
end
