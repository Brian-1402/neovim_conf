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

-- To turn on conceal for markdown
vim.api.nvim_create_autocmd("FileType", {
	-- group = vim.api.nvim_create_augroup("Conceal", { clear = true }),
	pattern = { "markdown" },
	callback = function()
		vim.o.conceallevel = 2
		vim.o.wrap = false
		vim.o.concealcursor = ""
	end,
})


-- highlights yanked text
vim.cmd([[
	augroup highlight_yank
		autocmd!
		autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
	augroup END
]])



-- For handling closing off unused buffers

local id = vim.api.nvim_create_augroup("startup", {
	clear = false
})

local persistbuffer = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	vim.fn.setbufvar(bufnr, 'buf_touched', 1)
	vim.fn.setbufvar(bufnr, 'buf_opened', 1)
end

vim.api.nvim_create_autocmd({ "BufRead" }, {
	group = id,
	pattern = { "*" },
	callback = function()
		vim.api.nvim_create_autocmd({ "InsertEnter", "BufModifiedSet" }, {
			buffer = 0,
			once = true,
			callback = function()
				persistbuffer()
			end
		})
	end
})

-- vim.keymap.set('n', '<Leader>b',
-- 	function()
-- 		local curbufnr = vim.api.nvim_get_current_buf()
-- 		local buflist = vim.api.nvim_list_bufs()
-- 		for _, bufnr in ipairs(buflist) do
-- 			if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, 'buf_touched') ~= 1) then
-- 				-- vim.cmd('bd ' .. tostring(bufnr))
-- 				require('bufdelete').bufdelete(bufnr)
-- 			end
-- 		end
-- 	end, { silent = true, desc = 'Close unused buffers' })


vim.api.nvim_create_user_command('BCloseUntouched', function()
	local curbufnr = vim.api.nvim_get_current_buf()
	local buflist = vim.api.nvim_list_bufs()
	for _, bufnr in ipairs(buflist) do
		if vim.bo[bufnr].buflisted and bufnr ~= curbufnr and (vim.fn.getbufvar(bufnr, 'buf_touched') ~= 1) then
			vim.cmd('bd ' .. tostring(bufnr))
		end
	end
end, { desc = 'Close unused buffers' })

vim.api.nvim_create_user_command('BCloseNonVisible', function()
	local tabpage_list = vim.api.nvim_list_tabpages()
	local winbufs = {}

	-- Get list of buffers currently displayed in any window of any tab
	for _, tabpage in ipairs(tabpage_list) do
		local win_list = vim.api.nvim_tabpage_list_wins(tabpage)
		for _, win in ipairs(win_list) do
			local bufnr = vim.api.nvim_win_get_buf(win)
			winbufs[bufnr] = true
		end
		end

	-- Close buffers that are not in the window list
	local buflist = vim.api.nvim_list_bufs()
	for _, bufnr in ipairs(buflist) do
		if vim.bo[bufnr].buflisted and not winbufs[bufnr] then
			-- Attempt to close the buffer, let Neovim handle unsaved changes warning
			vim.cmd('confirm bd ' .. tostring(bufnr))
		end
	end
end, { desc = 'Close buffers not in a tab or window' })

-- vim.keymap.set('n', '<Leader>b', ':BCloseUntouched<CR>', { silent = true, desc = 'Close unused buffers' })
vim.keymap.set('n', '<Leader>b', ':BCloseNonVisible<CR>', { silent = true, desc = 'Close buffers not in a tab or window' })
