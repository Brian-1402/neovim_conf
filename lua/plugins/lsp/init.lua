local mlsp_server_names = { "typos_lsp", "bashls", "biome", "html", "cssls", "clangd",
	"marksman", "texlab", "lua_ls", "pyright", "vimls", "yamlls", }
local linters = { "selene", }
local formatters = { "stylua", "black", }
local others = {}

local mason_nonlsp_pkgs = vim.tbl_extend( "keep", linters, formatters, others)
local mason_all_pkgs = vim.tbl_extend( "keep", mlsp_server_names, mason_nonlsp_pkgs)

lsp_on_attach = function(event)
	local opts = {buffer = event.buf}
	vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
	vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
	vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
	vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
	vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
	vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
	vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
	vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
	vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
	vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

	vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
	vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
	vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts) 
end


return {

	-- nvim-cmp for autocompletions
	-- depends on it's sources being already loaded
	-- calls lspconfig setup
	{
		'hrsh7th/nvim-cmp',
		event = { "VeryLazy", "InsertEnter", },
		dependencies = {
			'neovim/nvim-lspconfig',
		},
		config = function()
			local cmp = require('cmp')
			cmp.setup {
				sources = {
					{name = 'nvim_lsp'}, --mention other additional sources like copilot, etc
				},
				mapping = cmp.mapping.preset.insert({
					-- enter key confirms completion item
					['<CR>'] = cmp.mapping.confirm({select = false}),

					-- ctrl + space triggers completion menu
					['<C-Space>'] = cmp.mapping.complete(),
				}),
				-- snippet = {
				--	expand = function(args)
				--		require('luasnip').lsp_expand(args.body)
				--	end,
				-- },
			}
		end,
	},

	-- lsp config
	-- calls mason etc
	{
		'neovim/nvim-lspconfig',
		event = "VeryLazy",
		dependencies = {
			{ "folke/neodev.nvim", opts = {} },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			local lspconfig = require('lspconfig')
			local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

			vim.api.nvim_create_autocmd('LspAttach', {
				desc = 'LSP actions',
				callback = lsp_on_attach,
			})

			local default_setup = function(server)
				lspconfig[server].setup({
				capabilities = lsp_capabilities,
				})
			end

			require('mason-lspconfig').setup({
			ensure_installed = mslp_server_names,
			handlers = {default_setup},
			})
		end
	},

	 {
		"williamboman/mason-lspconfig.nvim",
		-- event = "verylazy",
		dependencies = "mason.nvim",
		config = function() end,

	},

	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>mason<cr>", desc = "mason" } },
		build = ":masonupdate",
		opts = {
			ensure_installed = mason_nonlsp_pkgs,
		},
	},
}
