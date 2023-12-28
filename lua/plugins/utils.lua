return {

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
		'iamcco/markdown-preview.nvim',
		build = 'cd app && npm install',
		init = function() vim.g.mkdp_filetypes = { 'markdown' } end,
		ft = { 'markdown' },
	},

	{
		'dstein64/vim-startuptime', -- Plugin to measure startup times
		cmd = "StartupTime",
	},

	{
		'tpope/vim-fugitive', -- Git support
		cmd = "Git",
	},

	{
		'tpope/vim-rhubarb', -- GitHub support
		cmd = "GBrowse",
	},

	-- Coding usage tracking
	{
		'wakatime/vim-wakatime',
		event = "VeryLazy",
	},

	{
		'airblade/vim-rooter', -- Changes vim directory to project directory
		enabled = false,
		event = "VeryLazy",
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
