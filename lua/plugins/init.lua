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
		config = function ()
			-- vimtex config
			vim.g.tex_flavor = 'latex'
			vim.g.vimtex_quickfix_mode = 0
			vim.o.conceallevel = 0
			vim.g.tex_conceal = 'admgs'
			-- -- Setting vimtex default pdf viewer as sumatrapdf
			-- vim.g.vimtex_view_general_viewer = 'SumatraPDF'
			-- vim.g.vimtex_view_general_options = '-reuse-instance -forward-search @tex @line @pdf'
			-- -- vimtex config for okular
			-- vim.g.vimtex_view_general_viewer = 'zathura'
		end

	},

	{
		'chrisbra/matchit',
		event = "VeryLazy",
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
		'airblade/vim-rooter', -- Changes vim directory to project directory
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

	-- Coding usage tracking
	{
		'wakatime/vim-wakatime',
		event = "VeryLazy",
	},

	-- To improve the UI used by other plugins like telescope etc.
	{
		'stevearc/dressing.nvim',
		event = "VeryLazy",
		opts = {},
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

