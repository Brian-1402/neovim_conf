-- vimrc base file

-- Some default code which came with the Vim installation
vim.cmd( [[
function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction
]] )

-- Use the internal diff if available.
-- Otherwise use the special 'diffexpr' for Windows.
vim.cmd( [[
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '--' . arg1 . '--' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '--' . arg2 . '--' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '--' . arg3 . '--' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '--' . $VIMRUNTIME . '\diff--'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '-- ', '') . '\diff--'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction
]] )
-- -- vimrc_example.vim START

if tonumber(vim.o.t_Co) > 2 or vim.fn.has("gui_running") == 1 then
	-- Switch on highlighting the last used search pattern.
	vim.o.syntax = false
	vim.o.hlsearch = true
	vim.o.c_comment_strings = 1
end

---- -- Put these in an autocmd group, so that we can delete them easily.
---- augroup vimrcEx
----   au!

----   -- For all text files set 'textwidth' to 78 characters.
----   autocmd FileType text setlocal textwidth=78
---- augroup END

---- Add optional packages.
----
---- The matchit plugin makes the % command work better, but it is not backwards
---- compatible.
---- The ! means the package won't be loaded right away but when plugins are
---- loaded during initialization.

if vim.fn.has('syntax') and vim.fn.has('eval') then
  vim.cmd('packadd! matchit')
end
---- -- vimrc_example.vim END

vim.o.backup = true		-- keep a backup file (restore to previous version)
vim.o.backupdir = vim.fn.stdpath("data") .. "/backup//,."
if vim.fn.has('persistent_undo') == 1 then
	vim.o.undofile = true	-- keep an undo file (undo changes after closing)
	vim.o.undodir = vim.fn.stdpath("data") .. "/undo//,."
end

-- nightfly theme configuration
if vim.fn.has("termguicolors") then
	vim.o.termguicolors = true
end
vim.cmd.colorscheme( "nightfly" )
vim.g.nightflyCursorColor = true --Doesn't seem to make any difference though

-- So that files with unsaved changes in the buffer gets hidden in buffer instead of throwing error asking to save
vim.o.hidden = true

-- Display line numbers
vim.o.number = true
vim.o.norelativenumber = true

-- Highlight the cursor horizontal line
vim.o.cursorline = true
-- vim.opt.highlight = { "CursorLine", "cterm=underline" }

-- changing tab length from 8 to 4
vim.o.tabstop = 4
vim.o.softtabstop = 0
vim.o.noexpandtab = true
vim.o.shiftwidth = 4

vim.o.encoding = "utf-8"

-- HardTime customizations
vim.g.hardtime_default_on = 0 -- Set it to be off by default

-- vimtex config
vim.g.tex_flavor = 'latex'
vim.g.vimtex_quickfix_mode = 0
vim.o.conceallevel = 1
-- vim.g.tex_conceal = 'abdmg'
-- -- Setting vimtex default pdf viewer as sumatrapdf
-- vim.g.vimtex_view_general_viewer = 'SumatraPDF'
-- vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
-- -- vimtex config for okular
-- vim.g.vimtex_view_general_viewer = 'zathura'

-- I think the below is for fixing cursor and making it always block in normal
-- and line in insert mode
if vim.g.neovide == 0 then
	vim.o.noshowmode = true
	vim.o.t_SI = [[\<Esc>[6 q]]
	vim.o.t_SR = [[\<Esc>[3 q]]
	vim.o.t_EI = [[\<Esc>[2 q]]
end

-- Highlight matching parentheses
vim.o.showmatch = true

---- disable startup message
vim.opt.shortmess:append({ I = true })

-- show invisible characters
vim.o.list = true
vim.opt.listchars = {
	tab = "▏ ",
	-- space = "⋅"
	-- eol = "¬",
	trail = "·",
	lead = "·",
	extends = "»",
	precedes = "«",
	-- nbsp = "░",
}

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

---- To prevent pasting from being messed up by autoindent, etc
-- vim.o.pastetoggle = "<F3>"
vim.keymap.set("n", "<Leader>v", ':set paste<CR>"+p:set nopaste<CR>')
-- nnoremap <silent> <leader>v ":set paste<CR>--+p:set nopaste<CR>"

vim.g.mapleader = ' '
