-- nightfly theme configuration
if vim.fn.has("termguicolors") then
	vim.o.termguicolors = true
end
vim.cmd.colorscheme( "nightfly" )
vim.g.nightflyCursorColor = true --Doesn't seem to make any difference though

-- Display line numbers
vim.o.number = true
vim.o.norelativenumber = true

-- Highlight the cursor horizontal line
vim.o.cursorline = true
-- vim.opt.highlight = { "CursorLine", "cterm=underline" }

-- disable startup message
vim.opt.shortmess:append({ I = true })

-- Highlight matching parentheses
vim.o.showmatch = true

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
