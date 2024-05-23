return {

	{
		'bluz71/vim-nightfly-colors',
		name = 'nightfly',
		lazy = false,
		priority = 1000,
		config = function() vim.cmd.colorscheme("nightfly") end,
	}, -- Color theme. oxfist/night-owl.nvim is also a good alternative

	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("catppuccin") end,
	},

	-- Status line plugin
	{
		'nvim-lualine/lualine.nvim',
		event = { "UIEnter", "VeryLazy" },
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
		"utilyre/barbecue.nvim",
		name = "barbecue",
		enabled = false, -- Giving E36:Not enough room error everytime I scroll. But that error started recently only,
		-- probably conflicting with some recent settings changes. I think it's the treesitter top scope previewer bar.
		event = "UIEnter",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {
			-- configurations go here
		},
	},

	-- Makes window separations colorful
	{
		"nvim-zh/colorful-winsep.nvim",
		event = { "WinNew" },
		opt = {
			no_exec_files = {
				"TelescopePrompt",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"terminal",
				"neogitstatus",
				"mason",
			},
		},
	},

	{
		'unblevable/quick-scope', -- Highlights unique letter per word for faster f
		event = "VeryLazy",
	},

	{
		'akinsho/bufferline.nvim',
		enabled = false,
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		event = "VeryLazy",
		opts = {
			-- diagnostics = "nvim_lsp",
		},
		config = function(_, opts)
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
			vim.api.nvim_set_hl(0, 'CodewindowBorder', { fg = '#012b4d' }) -- Doesn't seem to work
		end
	},

	-- Toggle maximise a split window
	{
		"szw/vim-maximizer",
		-- by default, it sets keymap as F3. put "let g:maximizer_set_default_mapping = 1" to disable it.
		keys = {
			{
				"<leader>sm",
				"<cmd>MaximizerToggle<CR>",
				desc = "Maximize/minimize a split",
			},
		},
		config = function()
			vim.g.maximizer_set_default_mapping = 0
			-- vim.g.maximizer_default_mapping_key = '<leader>sm'
			-- Above setting not working
		end,
	},
}
