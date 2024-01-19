local mlsp_server_names = { "bashls", "biome", "html", "cssls", "clangd",
	"marksman", "texlab", "lua_ls", "pyright", "vimls", "yamlls", }
local linters = { "selene", }
local formatters = { "stylua", "black", }
local others = {}

local mason_nonlsp_pkgs = vim.tbl_extend( "keep", linters, formatters, others)
local mason_all_pkgs = vim.tbl_extend( "keep", mlsp_server_names, mason_nonlsp_pkgs)

-- Custom config opts for each server
local lsp_opts = {
	-- grammarly = {
	-- 	filetypes = { "markdown", "text" },
	-- },
}

-- Add empty opts for each server already not having any
for _, pkg in ipairs(mlsp_server_names) do
	if not lsp_opts[pkg] then
		lsp_opts[pkg] = {}
	end
end

-- LSP requires to be loaded before buffer to get attached, but this prevents it to be lazy loaded.
-- As a workaround, this function allows LSP to be lazy loaded, and when it loads, it attaches to already loaded buffers.
-- https://www.reddit.com/r/neovim/comments/15s3fxk/comment/jwdgdcp/
local attach_lsp_to_existing_buffers = vim.schedule_wrap(function()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
	local valid = vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_option(bufnr, 'buflisted')
	if valid and vim.bo[bufnr].buftype == "" then
		local augroup_lspconfig = vim.api.nvim_create_augroup('lspconfig', { clear = false })
		vim.api.nvim_exec_autocmds("FileType", { group = augroup_lspconfig, buffer = bufnr })
	end
	end
end)

local function lsp_settings()
	vim.diagnostic.config({
		float = {border = 'rounded'},
	})

	vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{border = 'rounded'}
	)

	vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
		vim.lsp.handlers.signature_help,
		{border = 'rounded'}
	)

	local command = vim.api.nvim_create_user_command

	command('LspWorkspaceAdd', function()
		vim.lsp.buf.add_workspace_folder()
	end, {desc = 'Add folder to workspace'})

	command('LspWorkspaceList', function()
		vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, {desc = 'List workspace folders'})

	command('LspWorkspaceRemove', function()
		vim.lsp.buf.remove_workspace_folder()
	end, {desc = 'Remove folder from workspace'})
end

local function lsp_format(input)
	local name
	local async = input.bang

	if input.args ~= '' then
		name = input.args
	end

	vim.lsp.buf.format({async = async, name = name})
end

local lsp_on_attach = function(event)
	local bufnr = event.buf
	local map = function(m, lhs, rhs)
		local opts = {buffer = bufnr}
		vim.keymap.set(m, lhs, rhs, opts)
	end

	vim.api.nvim_buf_create_user_command(
		bufnr,
		'LspFormat',
		lsp_format,
		{
			bang = true,
			nargs = '?',
			desc = 'Format buffer with language server'
		}
	)

	-- LSP actions
	map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
	map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
	map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
	map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
	map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
	map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
	map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
	map('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
	map({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
	map('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
	map('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')

	-- Diagnostics
	map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
	map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
	map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
end

return {
	-- lsp config
	{
		'neovim/nvim-lspconfig',
		cmd = {'LspInfo', 'LspInstall', 'LspStart'},
		-- event = {'BufReadPre', 'BufNewFile'},
		event = {'VeryLazy'},
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason-lspconfig.nvim",
			"williamboman/mason.nvim",
			{ "folke/neodev.nvim", config = true, },
			"SmiteshP/nvim-navic",
		},

		config = function()
			require("neodev").setup()
			local lspconfig = require('lspconfig')
			local navic = require('nvim-navic')

			lspconfig.util.on_setup = lspconfig.util.add_hook_after(
				lspconfig.util.on_setup,
				function(config, user_config)
					config.capabilities = vim.tbl_deep_extend(
						'force',
						config.capabilities,
						require('cmp_nvim_lsp').default_capabilities(),
						vim.tbl_get(user_config, 'capabilities') or {}
					)
				end
			)

			vim.api.nvim_create_autocmd('LspAttach', {
				desc = 'LSP actions',
				callback = lsp_on_attach,
			})

			lsp_settings()

			local navic_on_attach = function(client, bufnr)
				if client.server_capabilities.documentSymbolProvider then
					navic.attach(client, bufnr)
				end
			end

			-- Add the on_attach function to each server config
			for _, opts in pairs(lsp_opts) do
				if type(opts) == "table" then
					opts.on_attach = navic_on_attach
				end
			end

			local default_setup = function(server)
				lspconfig[server].setup(lsp_opts[server])
			end

			require('mason-lspconfig').setup({
				ensure_installed = mason_all_pkgs,
				handlers = {
					default_setup,
				},
			})

			attach_lsp_to_existing_buffers()

		end
	},

	{
		"williamboman/mason-lspconfig.nvim",
		lazy = true,
		dependencies = "mason.nvim",
		-- config = function() end,
	},

	{
		"williamboman/mason.nvim",
		lazy = true,
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		config = true,
	},

}
