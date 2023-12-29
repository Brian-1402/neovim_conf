return {

	-- Returns cursor to the previous position. Works better than the autocmd
	{
		"farmergreg/vim-lastplace",
		enabled = false, -- Doesn't seem to work
		event = "VeryLazy",
	},

	-- For auto closing brackets
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {} -- this is equalent to setup({}) function
	},

	-- For peeking lines when mentioning them in command line
	{
		"nacro90/numb.nvim",
		event = "VeryLazy",
		config = true,
	},

	{
		'takac/vim-hardtime', -- Puts time delay for hjkl keys
		enabled = false,
		event = "VeryLazy",
		config = function()
			vim.g.hardtime_default_on = 0 -- Set it to be off by default
		end,
	},

	-- The default vim % feature, added here for lazy loading
	{
		'chrisbra/matchit',
		event = "VeryLazy",
	},

	{
		'tpope/vim-surround',
		event = "VeryLazy",
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
		config = function()
			vim.wo.foldenable = false
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "SimpylFold#FoldExpr(v:lnum)"
		end,
	},

}
