" vimrc base file

" Some default code which came with the Vim installation

function! Cond(cond, ...)
  let opts = get(a:000, 0, {})
  return a:cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
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

" -- vimrc_example.vim START

if &t_Co > 2 || has("gui_running")
	" Switch on highlighting the last used search pattern.
	set hlsearch
endif

" " Put these in an autocmd group, so that we can delete them easily.
" augroup vimrcEx
"   au!

"   " For all text files set 'textwidth' to 78 characters.
"   autocmd FileType text setlocal textwidth=78
" augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
	packadd! matchit
endif

" -- vimrc_example.vim END

if has("vms")
	set nobackup		" do not keep a backup file, use versions instead
else
	set backupdir=~/vimfiles/backup//,.  "Windows specific, for directory name
	set backup		" keep a backup file (restore to previous version)
	if has('persistent_undo')
		set undodir=~/vimfiles/undo//,.     "directory where the undo files will be stored
		set undofile	" keep an undo file (undo changes after closing)
		if has('nvim')
			set undodir=~/AppData/Local/nvim-data/undo//,.
		endif
	endif
endif

" nightfly theme configuration
if (has("termguicolors"))
	set termguicolors
endif
colorscheme nightfly
let g:nightflyCursorColor = v:true "Doesn't seem to make any difference though

" So that files with unsaved changes in the buffer gets hidden in buffer instead of throwing error asking to save
set hidden

" Display line numbers
set number norelativenumber

" Highlight the cursor horizontal line
set cursorline
" highlight CursorLine cterm=underline

" changing tab length from 8 to 4
set tabstop=4
set softtabstop=0 noexpandtab
set shiftwidth=4

set encoding=utf-8

" HardTime customizations
let g:hardtime_default_on = 0 " Set it to be off by default

" vimtex config
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
set conceallevel=1
" let g:tex_conceal='abdmg'
" Setting vimtex default pdf viewer as sumatrapdf
" let g:vimtex_view_general_viewer = 'SumatraPDF'
" let g:vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
" vimtex config for okular
" let g:vimtex_view_general_viewer = 'zathura'

let g:vim_json_conceal=0
" let g:markdown_syntax_conceal=0

" I think the below is for fixing cursor and making it always block in normal
" and line in insert mode
if !exists("g:neovide")
	set noshowmode
	let &t_SI = "\<Esc>[6 q"
	let &t_SR = "\<Esc>[3 q"
	let &t_EI = "\<Esc>[2 q"
endif

" To use ALE for autocomplete
" set omnifunc=ale#completion#OmniFunc
" let g:ale_lint_on_enter=1

" Highlight matching parentheses
set showmatch

" disable startup message
set shortmess+=I

" show invisible characters
set list
set listchars=
set listchars+=tab:▏  
" set listchars+=space:⋅
" set listchars+=eol:¬
set listchars+=trail:·
set listchars+=lead:·
set listchars+=extends:»
set listchars+=precedes:«
" set listchars+=nbsp:░

" line wrap settings
" Activate wrapping
set wrap
" Break by word and not character
set linebreak
" set visual indents when long lines are wrapped
set breakindent

" let g:indentLine_leadingSpaceEnabled = 1
" let g:indentLine_leadingSpaceChar = '·'
" let mapleader =" "
" Maps leader key from backslash to space

" For MarkdownPreview plugin
source ~/vimrc_sources/MarkdownPreview-defaults.vim

" For avoiding quotes and stuff from disappearing in json and md due to vim
" conceal being activated by indentLine plugin
" https://github.com/Yggdroot/indentLine?tab=readme-ov-file#customization
" let g:vim_json_conceal=0
" let g:markdown_syntax_conceal=0

" Utilnips config
let g:UltiSnipsExpandTrigger="<S-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" To prevent pasting from being messed up by autoindent, etc
set pastetoggle=<F3>
nnoremap <silent> <leader>v :set paste<CR>"+p:set nopaste<CR>
