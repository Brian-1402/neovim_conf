-- Function to recursively print a table for debugging purposes
local function printTable(tbl, indent)
	indent = indent or 0

	for key, value in pairs(tbl) do
		if type(value) == "table" then
			print(string.rep("  ", indent) .. key .. " = {")
			printTable(value, indent + 1)
			print(string.rep("  ", indent) .. "}")
		else
			print(string.rep("  ", indent) .. key .. " = " .. tostring(value))
		end
	end
end

-- List of paths to Lazy.nvim plugin spec files
local pluginSpecFiles = {
	'plugins.editing',
	'plugins.treesitter',
	'vscode.plugin_extras',
}

-- Function to load and modify a plugin spec file
local function loadAndModifySpec(filePath)
	local pluginSpec = require(filePath)

	-- Modify the values in the loaded table as needed
	for _, plugin in ipairs(pluginSpec) do
		-- Plugin specific modifications
		if plugin[1] == 'nvim-treesitter/nvim-treesitter' then
			plugin.opts.highlight.enable = false
		end
		if plugin[1] == 'andymass/vim-matchup' then
			plugin.enabled = false -- causing a bug which makes multiple brackets and completions on Esc
		end
	end
	return pluginSpec
end

-- Load and modify each plugin spec file
local mergedPluginSpec = {}
for _, filePath in ipairs(pluginSpecFiles) do
	local modifiedSpec = loadAndModifySpec(filePath)
	table.insert(mergedPluginSpec, modifiedSpec)
end

-- printTable(mergedPluginSpec[1])


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Pass the merged plugin spec to lazy.setup
require('lazy').setup(mergedPluginSpec)
