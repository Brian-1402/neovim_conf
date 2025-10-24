-- File: ~/minimal_init.lua

-- Set a standard path for plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Configure and install plugins
require("lazy").setup({
	-- LSP essentials
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",

	-- The LSP config plugin itself
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Diagnostic print to prove this code is running
			print("--- MINIMAL LSP CONFIG IS RUNNING ---")

			-- Define server configurations
			local servers = {
				clangd = {
					cmd = {
						"clangd",
						"--background-index",
						"--clang-tidy",
						"--completion-style=detailed",
						"--header-insertion=never",
						"--query-driver=/usr/bin/g++",
						"--offset-encoding=utf-16",
					},
				},
			}

			-- Setup mason so it can install the server
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
			})

			-- Configure servers using the new API
			for server_name, server_opts in pairs(servers) do
				print("Configuring server: " .. server_name)
				vim.lsp.config(server_name, server_opts)
			end

			-- Enable all configured language servers
			vim.lsp.enable(vim.tbl_keys(servers))
		end,
	},
})
