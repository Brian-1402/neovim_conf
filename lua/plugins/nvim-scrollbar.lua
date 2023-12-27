	-- Scrollbar
return {
	"petertriho/nvim-scrollbar",
	event = "VeryLazy",
	priority = 100,

	dependencies = {
		-- hlslens for scrollbar
		{
			"kevinhwang91/nvim-hlslens",
			config = function()
				-- require('hlslens').setup() is not required
				require("scrollbar.handlers.search").setup({
					override_lens = function() end,
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

	config = function()
		require("scrollbar").setup()
	end,
}
