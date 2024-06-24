local vscode = require('vscode-neovim')
local opts = { noremap = true, silent = true }

-- Show LSP references
opts.desc = "Show LSP references"
vim.keymap.set("n", "gr", function()
	-- vscode.action('references-view.findReferences')
	vscode.action('editor.action.referenceSearch.trigger')
end, opts)

--[[
--These are already implemented by vscode-neovim

-- Show LSP definitions
opts.desc = "Show LSP definitions"
keymap.set("n", "gd", function()
	vscode.action('editor.action.revealDefinition')
end, opts)

-- Go to declaration
opts.desc = "Go to declaration"
keymap.set("n", "gf", function()
	vscode.action('editor.action.revealDeclaration')
end, opts)

-- Peek LSP definitions
opts.desc = "Peek LSP definitions"
keymap.set("n", "gD", function()
	vscode.action('editor.action.peekDefinition')
end, opts)

-- Peek declaration
opts.desc = "Peek declaration"
keymap.set("n", "gF", function()
	vscode.action('editor.action.peekDeclaration')
end, opts)
]]

-- Show LSP implementations
opts.desc = "Show LSP implementations"
vim.keymap.set("n", "gI", function()
	vscode.action('editor.action.goToImplementation')
end, opts)

-- Show LSP type definitions
opts.desc = "Show LSP type definitions"
vim.keymap.set("n", "gy", function()
	vscode.action('editor.action.goToTypeDefinition')
end, opts)

-- Show LSP signature help
opts.desc = "Show LSP signature help"
vim.keymap.set("n", "gK", function()
	vscode.action('editor.action.triggerParameterHints')
end, opts)

-- See available code actions
opts.desc = "See available code actions"
vim.keymap.set({ "n", "v" }, "<leader>ca", function()
	vscode.action('editor.action.quickFix')
end, opts)

-- -- Run Codelens
-- opts.desc = "Run Codelens"
-- keymap.set({ "n", "v" }, "<leader>cc", function()
-- 	vscode.action('editor.action.codelensAction')
-- end, opts)

-- -- Refresh & Display Codelens
-- opts.desc = "Refresh & Display Codelens"
-- keymap.set({ "n", "v" }, "<leader>cC", function()
-- 	vscode.action('editor.action.codelensAction')
-- end, opts)

-- Source action
opts.desc = "Source action"
vim.keymap.set("n", "<leader>cA", function()
	vscode.action('editor.action.sourceAction', {
		-- args = {
		-- 	context = {
		-- 		only = { "source" },
		-- 		diagnostics = {}
		-- 	}
		-- }
	})
end, opts)

-- Smart rename
opts.desc = "Smart rename"
vim.keymap.set("n", "<leader>rn", function()
	vscode.action('editor.action.rename')
end, opts)

-- Show buffer diagnostics
opts.desc = "Show all buffers diagnostics"
vim.keymap.set("n", "<leader>dD", function()
	vscode.action('workbench.actions.view.problems')
end, opts)

-- Show line diagnostics
opts.desc = "Show line diagnostics"
vim.keymap.set("n", "<leader>dd", function()
	vscode.action('editor.action.showHover')
end, opts)

-- Go to previous diagnostic
opts.desc = "Go to previous diagnostic"
vim.keymap.set("n", "[d", function()
	vscode.action('editor.action.marker.prevInFiles')
end, opts)

-- Go to next diagnostic
opts.desc = "Go to next diagnostic"
vim.keymap.set("n", "]d", function()
	vscode.action('editor.action.marker.nextInFiles')
end, opts)

-- Already implemented by vscode-neovim
-- -- Show documentation for what is under cursor
-- opts.desc = "Show documentation for what is under cursor"
-- keymap.set("n", "K", function()
-- 	vscode.action('editor.action.showHover')
-- end, opts)

-- Set location list to diagnostics
opts.desc = "Set location list to diagnostics"
vim.keymap.set("n", "<leader>q", function()
	vscode.action('workbench.action.problems.focus')
end, opts)

-- Format buffer
opts.desc = "Format buffer"
vim.keymap.set("n", "<leader>=", function()
	vscode.action('editor.action.formatDocument')
end, opts)

-- Format selection
opts.desc = "Format selection"
vim.keymap.set("v", "<leader>=", function()
	vscode.action('editor.action.formatSelection')
end, opts)


-- Telescope equivalent keymaps

opts.desc = "Telescope: find files"
vim.keymap.set("n", "<leader>ff", function()
	vscode.action('workbench.action.quickOpen')
end, opts)

opts.desc = "Telescope: live grep"
vim.keymap.set("n", "<leader>fg", function()
	vscode.action('workbench.action.findInFiles')
end, opts)

opts.desc = "Telescope: buffers"
vim.keymap.set("n", "<leader>fb", function()
	vscode.action('workbench.action.showAllEditors')
end, opts)

-- opts.desc = "Telescope: help tags"
-- vim.keymap.set("n", "<leader>fh", function()
-- 	vscode.action('workbench.action.showCommands')
-- end, opts)

-- opts.desc = "Telescope: recent files"
-- vim.keymap.set("n", "<leader>fr", function()
-- 	vscode.action('workbench.action.openRecent')
-- end, opts)

-- opts.desc = "Find string under cursor in cwd"
-- vim.keymap.set("n", "<leader>fc", function()
-- 	vscode.action('workbench.action.findInFiles')
-- end, opts)

opts.desc = "Telescope: workspaces"
vim.keymap.set("n", "<leader>fw", function()
	vscode.action('workbench.action.openRecent')
end, opts)



-- Other mappings

-- Toggle primary sidebar with <leader>e
opts.desc = "Toggle primary sidebar"
vim.keymap.set("n", "<leader>e", function()
	vscode.action('workbench.action.toggleSidebarVisibility')
end, opts)

-- -- Open lazygit in terminal fullscreen with <leader>gz
-- -- First open terminal, then maximize panel, then send lazygit command
-- opts.desc = "Open lazygit"
-- vim.keymap.set("n", "<leader>gz", function()
-- 	vscode.action('workbench.action.terminal.toggleTerminal')
-- 	vscode.action('workbench.action.toggleMaximizedPanel')
-- 	-- vscode.action('workbench.action.terminal.focus')
-- 	vscode.action('workbench.action.terminal.sendSequence', {
-- 		text = "lazygit\n",
-- 	}) -- this part doesn't seem to work
-- end, opts)
