return {

	{
		'takac/vim-hardtime', -- Puts time delay for hjkl keys
		enabled = false,
		event = "VeryLazy",
		config = function()
			vim.g.hardtime_default_on = 0 -- Set it to be off by default
		end,
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

}
