return {

	{
		'bluz71/vim-nightfly-colors', name = 'nightfly', lazy = false, priority = 1000,
		config = function() vim.cmd.colorscheme("nightfly") end,
	}, -- Color theme. oxfist/night-owl.nvim is also a good alternative

	-- Status line plugin
	{
		'nvim-lualine/lualine.nvim',
		event = {"UIEnter", "VeryLazy"},
		dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true, },
		opts = {
			options = { theme = 'nightfly' },
		},
		config = function(_, opts)
			vim.opt.showmode = false
			require('lualine').setup(opts)
		end
	},

	{
		'unblevable/quick-scope', -- Highlights unique letter in each word for faster f
		event = "VeryLazy",
	},

	{
		'akinsho/bufferline.nvim',
		enabled = false,
		version = "*", dependencies = 'nvim-tree/nvim-web-devicons',
		event = "VeryLazy",
		opts = {
			-- diagnostics = "nvim_lsp",
		},
		config = function (_, opts)
			vim.opt.termguicolors = true
			require("bufferline").setup(opts)
		end
	},

	-- To improve the UI used by other plugins like telescope etc.
	{
		'stevearc/dressing.nvim',
		event = "VeryLazy",
		opts = {},
	},

	-- A minimap plugin
	{
		'gorbit99/codewindow.nvim',
		enabled = false,
		-- event = "VeryLazy",
		keys = { "<leader>mo", "<leader>mc", "<leader>mf", "<leader>mm", },
		config = function()
			local codewindow = require('codewindow')
			codewindow.setup({
			-- use_lsp = false, -- Use the builtin LSP to show errors and warnings
			-- use_treesitter = false, -- Use nvim-treesitter to highlight the code
			})
			codewindow.apply_default_keybinds()
			vim.api.nvim_set_hl(0, 'CodewindowBorder', {fg = '#012b4d'}) -- Doesn't seem to work
		end
	},

}
