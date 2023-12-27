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
		-- config = function() require("plugins.lsp.lsp_setup") end,
		config = function() end,
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
		config = function() end,
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
