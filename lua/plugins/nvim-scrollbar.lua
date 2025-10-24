	-- Scrollbar
return {
	"petertriho/nvim-scrollbar",
	enabled = true,
	event = { "UIEnter", "VeryLazy",},

	dependencies = {
		"kevinhwang91/nvim-hlslens", -- hlslens for scrollbar
		"lewis6991/gitsigns.nvim", -- Gitsigns for displaying in scrollbar
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
	},
	config = function(_, opts)
		require("scrollbar").setup(opts)

		-- For hlslens
		-- require('hlslens').setup() -- is not required
		require("scrollbar.handlers.search").setup({
			-- override_lens = function() end,
		})

		-- For gitsigns
		require('gitsigns').setup()
		require("scrollbar.handlers.gitsigns").setup()
	end,
}
