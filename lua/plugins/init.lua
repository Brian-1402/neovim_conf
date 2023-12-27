-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return {
	-- Vimscript plugins

	{
		'bluz71/vim-nightfly-colors', name = 'nightfly', lazy = false, priority = 1000,
		config = function() vim.cmd.colorscheme("nightfly") end,
	}, -- Color theme

	{
		"oxfist/night-owl.nvim", lazy = false, priority = 1000,
		config = function() vim.cmd.colorscheme("night-owl") end,
		enabled = false,
	},

	{
		'dstein64/vim-startuptime', -- Plugin to measure startup times
		cmd = "StartupTime",
	},

	{
		'takac/vim-hardtime', -- Puts time delay for hjkl keys
		enabled = false,
		event = "VeryLazy",
		config = function()
			vim.g.hardtime_default_on = 0 -- Set it to be off by default
		end,
	},

	{
		'lervag/vimtex', -- Latex features
	},

	{
		'tpope/vim-surround',
		event = "VeryLazy",
	},

	{
		'tpope/vim-fugitive', -- Git support
		cmd = "Git",
	},

	{
		'tpope/vim-rhubarb', -- GitHub support
		cmd = "GBrowse",
	},

	{
		'tpope/vim-unimpaired',
		enabled = false,
		event = "VeryLazy",
	},

	{
		'tpope/vim-commentary', -- Adding comments feature
		event = "VeryLazy",
	},

	{
		'tpope/vim-sensible', -- Add some basic default vim configs
		enabled = false,
		event = "VeryLazy",
	},

	{
		'tpope/vim-abolish', -- Search shortcuts
		enabled = false,
		event = "VeryLazy",
	},

	{
		'Konfekt/FastFold', -- For making vim folds faster
		event = "VeryLazy",
	},

	{
		'tmhedberg/SimpylFold', -- Folds for python
		ft = {'python'},
	},

	{
		'unblevable/quick-scope', -- Highlights unique letter in each word for faster f
		event = "VeryLazy",
	},

	{
		'dense-analysis/ale',
		enabled = false,
		ft = { 'c', 'cpp', 'markdown', 'vim', 'tex'},
		cmd = 'ALEEnable',
		config = function() vim.cmd([[ALEEnable]]) end,
	},

	-- Lua plugins

	{
		"debugloop/telescope-undo.nvim",
		enabled = false,
		dependencies = { -- note how they're inverted to above example
			"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		keys = {
			{ -- lazy style key map
				"<leader>u",
				"<cmd>Telescope undo<cr>",
				desc = "undo history",
			},
		},
		config = function(_, opts)
			-- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
			-- configs for us. We won't use data, as everything is in it's own namespace (telescope
			-- defaults, as well as each extension).
			require("telescope").setup(opts)
			require("telescope").load_extension("undo")
		end,
	},

	{
		'iamcco/markdown-preview.nvim',
		build = 'cd app && npm install',
		init = function() vim.g.mkdp_filetypes = { 'markdown' } end,
		ft = { 'markdown' },
	},

	-- Status line plugin
	{
		'nvim-lualine/lualine.nvim',
		event = "VeryLazy",
		priority = 100,
		dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true, },
		opts = {
			options = { theme = 'nightfly' },
		},
	},

	-- Neovim interface in browser text boxes
	{
		'glacambre/firenvim',
		enabled = false, -- We need to later make a separate init.lua for browser text windows
		-- Lazy load firenvim
		-- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
		lazy = not vim.g.started_by_firenvim,
		build = function()
			vim.fn["firenvim#install"](0)
		end
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

	{
		"kdheepak/lazygit.nvim",
		enabled = false,
		-- event = "VeryLazy",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
	},
}

