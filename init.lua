-- init file whose content is specifically for neovim (and not VS Code neovim)
-- vim.loader.enable() -- Enables faster plugin loading
-- Source the defaults that come with Vim
vim.cmd.source(vim.fn.stdpath("config") .. "/vim_sources/defaults.vim")

-- Load base settings
require("base")

-- Load the plugins
-- require("packer_plugins")
require("lazynvim")
-- require("lsp_setup")

-- For setting ctrl backspace remap in insert mode for Neovim-qt
vim.keymap.set('i', '<C-BS>', '<C-w>', { noremap = true, silent = true })

-- Config for GUIs:
if vim.g.neovide then
	require("gui.neovide")
	vim.o.guifont = "Consolas Nerd Font:h11"
	-- vim.o.guifont = "Consolas NF:h12"
	-- vim.o.guifont = "CaskaydiaMono Nerd Font:h12"
	-- vim.cmd( [[ set guifont=Consolas\ NF:h12 ]] )
elseif vim.g.nvy then
	vim.o.guifont = "Consolas Nerd Font:h12:w55"
	-- vim.o.guifont = "Consolas NF:h12:w55"
	vim.api.nvim_set_keymap('i', '<C-H>', '<C-W>', {noremap = true})
end

-- For configuring python
-- vim.g.python3_host_prog = "C:/Users/brian/AppData/Local/Programs/Python/Python312/python.exe"

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("WrapText", { clear = true }),
  pattern = { "text" },
  callback = function()
  vim.o.wrap = true
	  -- vim.opt_local.conceallevel = 0
    -- vim.opt_local.textwidth = 80
    -- vim.opt_local.wrap = true
    -- vim.opt_local.spell = true
    -- vim.opt_local.tabstop = 2
    -- vim.opt_local.softtabstop = 2
    -- vim.opt_local.shiftwidth = 2
    -- vim.opt_local.expandtab = true
  end,
})
