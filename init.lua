-- Add lazy.nvim to runtimepath
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", lazypath, })
end
vim.opt.rtp:prepend(lazypath)

-- Load the keymaps
require("keymaps")

-- Load clipboard settings
require("clipboard")

-- Load the plugins
require("lazy").setup("plugins")

-- Load base settings
require("defaults")

-- Load defined commands and autocmds
require("cmds")

-- Load appearance related settings
require("ui")

-- Load GUI settings
require("gui")
