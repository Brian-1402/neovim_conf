
--The below functionality has been replaced with farmergreg/vim-lastplace plugin
vim.cmd([[
	" Put these in an autocmd group, so that you can revert them with:
	" ":augroup vimStartup | exe 'au!' | augroup END"
	augroup vimStartup
		au!
		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid, when inside an event handler
		" (happens when dropping a file on gvim) and for a commit message (it's
		" likely a different one than last time).
		autocmd BufReadPost *
			\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
			\ |		exe "normal! g`\""
			\ | endif

	augroup END
]])

vim.cmd([[
	" Quite a few people accidentally type "q:" instead of ":q" and get confused
	" by the command line window.  Give a hint about how to get out.
	" If you don't like this you can put this in your vimrc:
	" ":augroup vimHints | exe 'au!' | augroup END"
	augroup vimHints
		au!
		autocmd CmdwinEnter *
		\ echohl Todo | 
		\ echo 'You discovered the command-line window! You can close it with ":q".' |
		\ echohl None
	augroup END

]])

-- Convenient command to see the difference between the current buffer and the
-- file it was loaded from, thus the changes you made.
-- Only define it when not defined already.
-- Revert with: ":delcommand DiffOrig".
vim.cmd([[
	if !exists(":DiffOrig")
		command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
				\ | wincmd p | diffthis
	endif
]])

-- Put these in an autocmd group, so that we can delete them easily.
vim.cmd([[
	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=78
	augroup END
]])

-- To turn on line wrap for text files only
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("WrapText", { clear = true }),
	pattern = { "text" },
	callback = function()
		vim.o.wrap = true
	end,
})
