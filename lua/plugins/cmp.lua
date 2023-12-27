local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
	{
		'hrsh7th/nvim-cmp',
		event = { "InsertEnter", "VeryLazy"},
		dependencies = {
			'neovim/nvim-lspconfig',
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline'
		},
		config = function()
			local cmp = require('cmp')
			local luasnip = require("luasnip")

			cmp.setup {
				sources = {
					{name = 'nvim_lsp'}, --mention other additional sources like copilot, etc
					{name = 'luasnip'},
					{name = 'buffer'},
					{name = 'path'},
					{name = 'cmdline'},
				},

				-- mapping guide: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
				mapping = cmp.mapping.preset.insert({

					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
					-- ['<C-f>'] = cmp_action.luasnip_jump_forward(),
					-- ['<C-b>'] = cmp_action.luasnip_jump_backward(),

					-- ['<C-Tab>'] = cmp.mapping(function ()
					--	if not cmp.visible() then
					--		cmp.complete() -- trigger opening completion menu
					--	end
					-- end),

					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item({behavior = 'insert'}) -- Select and also insert entry
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item({behavior = 'insert'})
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),

					-- confirm selection
					['<CR>'] = cmp.mapping.confirm({select = false}),

					-- cancel completion
					['<S-Esc>'] = cmp.mapping.abort(),
				}),
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
			}
		end,
	},

	{
		'saadparwaiz1/cmp_luasnip',
		event = "VeryLazy",
		dependencies = {
			{'L3MON4D3/LuaSnip', build = "make install_jsregexp",},
		},
	},
}
