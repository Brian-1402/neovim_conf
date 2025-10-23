	-- Scrollbar
return {
	"petertriho/nvim-scrollbar",
	enabled = true,
	event = { "UIEnter", "VeryLazy",},

	dependencies = {
		-- hlslens for scrollbar
		{
			"kevinhwang91/nvim-hlslens",
			config = function()
				-- require('hlslens').setup() -- is not required
				require("scrollbar.handlers.search").setup({
					-- override_lens = function() end,
				})
			end,
		},

		-- Gitsigns for displaying in scrollbar
		{
			"lewis6991/gitsigns.nvim",
			config = function()
				require('gitsigns').setup()
				require("scrollbar.handlers.gitsigns").setup()
			end
		},
	},

	opts = {
		excluded_buftypes = {
			"terminal",
			"lazy",
		},
		excluded_filetypes = {
			"cmp_docs",
			"cmp_menu",
			"noice",
			"prompt",
			"TelescopePrompt",
			"lazy",
		},
	}
}
