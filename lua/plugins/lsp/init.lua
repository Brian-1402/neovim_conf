local mlsp_server_names = { "typos_lsp", "bashls", "biome", "html", "cssls", "clangd",
	"marksman", "texlab", "lua_ls", "pyright", "vimls", "yamlls", }
local linters = { "selene", }
local formatters = { "stylua", "black", }
local others = {}

local mason_nonlsp_pkgs = vim.tbl_extend( "keep", linters, formatters, others)
local mason_all_pkgs = vim.tbl_extend( "keep", mlsp_server_names, mason_nonlsp_pkgs)


return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
	event = "VeryLazy",
		lazy = true,
		config = false,
		init = function()
			-- Disable automatic setup, we are doing it manually
			vim.g.lsp_zero_extend_cmp = 0
			vim.g.lsp_zero_extend_lspconfig = 0
		end,
	},
	{
		'williamboman/mason.nvim',
	event = "VeryLazy",
		config = true,
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		event = 'InsertEnter',
		dependencies = {
			{ 'L3MON4D3/LuaSnip', event = "VeryLazy"},
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
		},
		config = function()
			-- Here is where you configure the autocompletion settings.
			local lsp_zero = require('lsp-zero')
			lsp_zero.extend_cmp()

			-- And you can configure cmp even more, if you want to.
			local cmp = require('cmp')
			local cmp_action = lsp_zero.cmp_action()

			cmp.setup({
				sources = {
					{name = 'nvim_lsp'},
					{name = 'buffer'},
					{name = 'path'},
					{name = 'cmdline'},
				},
				formatting = lsp_zero.cmp_format(),
				mapping = cmp.mapping.preset.insert({
						-- `Enter` key to confirm completion
					['<CR>'] = cmp.mapping.confirm({select = false}),
					-- ['<Esc>'] = cmp.mapping.abort(),
					['<C-Tab>'] = cmp.mapping.complete(),
					['<Tab>'] = cmp.mapping.select_next_item({behavior = 'select'}),
					['<S-Tab>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
					['<C-f>'] = cmp_action.luasnip_jump_forward(),
					['<C-b>'] = cmp_action.luasnip_jump_backward(),
				})
			})
		end
	},

	-- LSP
	{
		'neovim/nvim-lspconfig',
		cmd = {'LspInfo', 'LspInstall', 'LspStart'},
		event = {'BufReadPre', 'BufNewFile'},
		dependencies = {
			{'hrsh7th/cmp-nvim-lsp'},
			{'williamboman/mason-lspconfig.nvim'},
			{'williamboman/mason.nvim'},
			{ "folke/neodev.nvim", opts = {} },
			"SmiteshP/nvim-navic",
		},
		config = function()
			-- This is where all the LSP shenanigans will live
			local lsp_zero = require('lsp-zero')
			lsp_zero.extend_lspconfig()

			lsp_zero.on_attach(function(client, bufnr)
				-- see :help lsp-zero-keybindings
				-- to learn the available actions
				lsp_zero.default_keymaps({buffer = bufnr})
			end)

			require('mason-lspconfig').setup({
				ensure_installed = mlsp_server_names,
				handlers = {
					lsp_zero.default_setup,
				}
			})
		end
	},

	{
		"SmiteshP/nvim-navic",
		-- event = "VeryLazy",
		lazy = true,
		dependencies = {"neovim/nvim-lspconfig",},
	},
}
