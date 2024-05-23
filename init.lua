-- Add lazy.nvim to runtimepath
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({ "git", "clone", "--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", lazypath, })
end
vim.opt.rtp:prepend(lazypath)

-- Function to reload configuration and plugins
function _G.ReloadConfig()
  -- Unload Lua modules
  for name,_ in pairs(package.loaded) do
    if name:match('^plugins') or name:match('^keymaps') or name:match('^cmd') or name:match('^defaults') then
      package.loaded[name] = nil
    end
  end

  -- Reload the main configuration file
  dofile(vim.env.MYVIMRC)

  -- Reload plugins with lazy.nvim
  require('lazy').sync()

  print("Configuration and plugins reloaded!")
end

-- Load the keymaps
require("keymaps")

-- Map the function to a keybinding (for example, <leader>r)
vim.api.nvim_set_keymap('n', '<leader>r', ':lua ReloadConfig()<CR>', { noremap = true, silent = true })

-- Load the clipboard settings
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
