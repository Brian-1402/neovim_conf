-- Assuming you have the following tables
-- local plugins = {...} -- list of all plugins used by lazy.nvim
local windows_disabled_plugins = { ... } -- list of plugins to be disabled on Windows
local unix_disabled_plugins = { ... } -- list of plugins to be disabled on Unix
local minimal_setup = { ... } -- list of plugins to be enabled in minimal setup
local is_minimal = true or false -- boolean to indicate if minimal setup is enabled

-- Function to check if a plugin is in a list
local function isInList(list, plugin)
	for _, v in ipairs(list) do
		if v == plugin then
			return true
		end
	end
	return false
end

-- While iterating through plugins, could check whether it is string or table.
-- Can avoid this by making your custom spec normalizing function which runs on all and generates a full spec table of all plugins

-- I'll make a table containing different functions which returns a boolean for each plugin name,
-- depending on certain conditions like whether it is in any of the disable lists etc.
-- There will be a function for OS, another for dependency availability (check if fzf command is available etc.)
-- I'll include cases for vscode, firenvim browsers, wsl, hpc and other remote servers which doesn't have sudo access to install plugin prereqs.

-- Function to disable plugins based on the operating system
local function disablePlugins(plugins, disabled_plugins)
	for _, plugin in ipairs(plugins) do
		if plugin.enabled == nil or plugin.enabled and isInList(disabled_plugins, plugin.name) then
			plugin.enabled = false
		end
	end
end

-- Function to enable only the plugins in the minimal setup
local function enableMinimalSetup(plugins, minimal_setup)
	for _, plugin in ipairs(plugins) do
		if isInList(minimal_setup, plugin.name) then
			plugin.enabled = true
		else
			plugin.enabled = false
		end
	end
end

-- Function to configure plugins based on the operating system and the minimal setup
local function configurePlugins(plugins, windows_disabled_plugins, unix_disabled_plugins, minimal_setup, is_minimal)
	if is_minimal then
		enableMinimalSetup(plugins, minimal_setup)
	else
		if vim.fn.has("win32") == 1 then
			disablePlugins(plugins, windows_disabled_plugins)
		else
			disablePlugins(plugins, unix_disabled_plugins)
		end
	end
end

-- Call the function to configure plugins
configurePlugins(plugins, windows_disabled_plugins, unix_disabled_plugins, minimal_setup, is_minimal)
-- List of paths to Lazy.nvim plugin spec files
local pluginSpecFiles = {
	"plugins.alpha",
	"plugins.cmp",
	"plugins.editing",
	"plugins.ibl",
	"plugins.lsp",
	"plugins.neoscroll",
	"plugins.neo-tree",
	"plugins.nvim-scrollbar",
	"plugins.telescope",
	"plugins.treesitter",
	"plugins.ui",
	"plugins.utils",
}

-- -- Will replace the above with below automated script
-- local function getLuaFiles(directory)
--     local files = {}
--     local i = 0
--     for name, type in vim.loop.fs_scandir(directory) do
--         local path = directory .. '/' .. name
--         if type == 'file' and name:match("%.lua$") then
--             i = i + 1
--             files[i] = path
--         elseif type == 'directory' then
--             local init_path = path .. '/init.lua'
--             if vim.loop.fs_stat(init_path) then
--                 i = i + 1
--                 files[i] = init_path
--             end
--         end
--     end
--     return files
-- en

-- Load and modify each plugin spec file
local mergedPluginSpec = {}
for _, filePath in ipairs(pluginSpecFiles) do
	local modifiedSpec = loadAndModifySpec(filePath)
	table.insert(mergedPluginSpec, modifiedSpec)
	-- There's prolly a vim function to do this. Something like vim.tbl_***() for merging
end
