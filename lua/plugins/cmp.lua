local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		dependencies = {
			"neovim/nvim-lspconfig",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"onsails/lspkind.nvim",
			"micangl/cmp-vimtex",
		},

		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")

			-- Setup luasnip
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				sources = { -- For regular insert mode global setup. For filetype specific or cmdline etc, see further below
					{ name = "lazydev", group_index = 0 }, -- Just for lua
					{ name = "luasnip", group_index = 1 },
					{ name = "nvim_lsp", group_index = 2 },
					{ name = "copilot", group_index = 3 },
					{ name = "buffer", group_index = 4 },
				},

				-- mapping guide: https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
				mapping = cmp.mapping.preset.insert({

					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-d>"] = cmp.mapping.scroll_docs(4),
					-- ['<C-f>'] = cmp_action.luasnip_jump_forward(),
					-- ['<C-b>'] = cmp_action.luasnip_jump_backward(),

					-- ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
					-- ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion

					["<C-e>"] = cmp.mapping.abort(), -- close completion window

					["<C-Tab>"] = cmp.mapping(function(fallback)
						if not cmp.visible() then
							cmp.complete() -- trigger opening completion menu
						else
							fallback()
						end
					end),

					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then -- and has_words_before() then
							cmp.select_next_item({ behavior = "insert" }) -- Select and also insert entry
						else
							fallback()
						end
					end, { "i", "s" }),

					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then -- and has_words_before() then
							cmp.select_prev_item({ behavior = "insert" })
						else
							fallback()
						end
					end, { "i", "s" }),

					["<C-j>"] = cmp.mapping(function(fallback)
						-- if cmp.visible() then -- and has_words_before() then
						-- 	cmp.select_next_item({behavior = 'insert'}) -- Select and also insert entry
						if luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
							-- elseif has_words_before() then
							-- 	cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),

					["<C-k>"] = cmp.mapping(function(fallback)
						-- if cmp.visible() then
						-- 	cmp.select_prev_item({behavior = 'insert'})
						if luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),

					-- confirm selection
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = false,
					}),

					-- cancel completion
					-- ['<S-Esc>'] = cmp.mapping.abort(),
				}),

				formatting = {
					expandable_indicator = true,
					fields = { "abbr", "kind", "menu" },
					format = lspkind.cmp_format({
						mode = "symbol",
						max_width = 50,
						ellipsis_char = "...",
						symbol_map = { Copilot = "" },
					}),
				},

				sorting = {
					priority_weight = 2,
					comparators = {
						require("copilot_cmp.comparators").prioritize,

						-- Below is the default comparator list and order for nvim-cmp
						cmp.config.compare.offset,
						-- cmp.config.compare.scopes, --this is commented in nvim-cmp too
						cmp.config.compare.exact,
						cmp.config.compare.score,
						cmp.config.compare.recently_used,
						cmp.config.compare.locality,
						cmp.config.compare.kind,
						cmp.config.compare.sort_text,
						cmp.config.compare.length,
						cmp.config.compare.order,
					},
				},

				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
			})

			cmp.setup.filetype("tex", {
				sources = {
					{ name = "copilot", group_index = 2 },
					{ name = "vimtex" },
					{ name = "luasnip" },
					{ name = "buffer" },
				},
			})

			-- `/` cmdline setup.
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				completion = { autocomplete = false },
				sources = {
					{ name = "buffer" },
				},
			})

			-- `:` cmdline setup.
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				-- completion = { autocomplete = false }, -- To prevent completion in cmdline to pop up always. comment it for always autocomplete.
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})
		end,
	},

	{
		"saadparwaiz1/cmp_luasnip",
		lazy = true,
		dependencies = {
			{ "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
		},
	},

	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		dependencies = { "rafamadriz/friendly-snippets" },
	},

	{
		"zbirenbaum/copilot-cmp",
		lazy = true,
		dependencies = { "zbirenbaum/copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},

	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				suggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	},
}
