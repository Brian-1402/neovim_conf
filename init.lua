-- init file whose content is specifically for neovim (and not VS Code neovim)

-- Source the defaults that come with Vim
vim.cmd.source(vim.fn.stdpath("config") .. "/vim_sources/defaults.vim")

-- Load base settings
require("base")

-- Load the plugins
require("lazynvim")

-- Load GUI settings
require("gui")
