local vscode = require('vscode-neovim')
local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Show LSP references
opts.desc = "Show LSP references"
keymap.set("n", "gr", function()
	-- vscode.action('references-view.findReferences')
	vscode.action('editor.action.referenceSearch.trigger')
end, opts)

-- Go to declaration
opts.desc = "Go to declaration"
keymap.set("n", "gD", function()
	vscode.action('editor.action.revealDeclaration')
end, opts)

-- Show LSP definitions
opts.desc = "Show LSP definitions"
keymap.set("n", "gd", function()
	vscode.action('editor.action.revealDefinition')
end, opts)

-- Show LSP implementations
opts.desc = "Show LSP implementations"
keymap.set("n", "gI", function()
	vscode.action('editor.action.goToImplementation')
end, opts)

-- Show LSP type definitions
opts.desc = "Show LSP type definitions"
keymap.set("n", "gy", function()
	vscode.action('editor.action.goToTypeDefinition')
end, opts)

-- Show LSP signature help
opts.desc = "Show LSP signature help"
keymap.set("n", "gK", function()
	vscode.action('editor.action.triggerParameterHints')
end, opts)

-- See available code actions
opts.desc = "See available code actions"
keymap.set({ "n", "v" }, "<leader>ca", function()
	vscode.action('editor.action.quickFix')
end, opts)

-- Run Codelens
opts.desc = "Run Codelens"
keymap.set({ "n", "v" }, "<leader>cc", function()
	vscode.action('editor.action.codelensAction')
end, opts)

-- Refresh & Display Codelens
opts.desc = "Refresh & Display Codelens"
keymap.set({ "n", "v" }, "<leader>cC", function()
	vscode.action('editor.action.codelensAction')
end, opts)

-- Source action
opts.desc = "Source action"
keymap.set("n", "<leader>cA", function()
	vscode.action('editor.action.sourceAction', {
		args = {
			context = {
				only = { "source" },
				diagnostics = {}
			}
		}
	})
end, opts)

-- Smart rename
opts.desc = "Smart rename"
keymap.set("n", "<leader>rn", function()
	vscode.action('editor.action.rename')
end, opts)

-- Show buffer diagnostics
opts.desc = "Show buffer diagnostics"
keymap.set("n", "<leader>D", function()
	vscode.action('workbench.actions.view.problems')
end, opts)

-- Show line diagnostics
opts.desc = "Show line diagnostics"
keymap.set("n", "<leader>d", function()
	vscode.action('editor.action.showHover')
end, opts)

-- Go to previous diagnostic
opts.desc = "Go to previous diagnostic"
keymap.set("n", "[d", function()
	vscode.action('editor.action.marker.prevInFiles')
end, opts)

-- Go to next diagnostic
opts.desc = "Go to next diagnostic"
keymap.set("n", "]d", function()
	vscode.action('editor.action.marker.nextInFiles')
end, opts)

-- Show documentation for what is under cursor
opts.desc = "Show documentation for what is under cursor"
keymap.set("n", "K", function()
	vscode.action('editor.action.showHover')
end, opts)

-- Set location list to diagnostics
opts.desc = "Set location list to diagnostics"
keymap.set("n", "<leader>q", function()
	vscode.action('workbench.action.problems.focus')
end, opts)

-- Format buffer
opts.desc = "Format buffer"
keymap.set("n", "<leader>=", function()
	vscode.action('editor.action.formatDocument')
end, opts)
