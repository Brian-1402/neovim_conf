return {

	-- Returns cursor to the previous position.
	{
		"farmergreg/vim-lastplace",
		enabled = false, -- Doesn't seem to work
		event = "VeryLazy",
	},

	-- For auto closing brackets
	{
		"windwp/nvim-autopairs",
		event = { "InsertEnter" },
		dependencies = {
			"hrsh7th/nvim-cmp",
		},
		config = function()
			-- import nvim-autopairs
			local autopairs = require("nvim-autopairs")

			-- configure autopairs
			autopairs.setup({
				check_ts = true, -- enable treesitter
				ts_config = {
					lua = { "string" }, -- don't add pairs in lua string treesitter nodes
					javascript = { "template_string" }, -- don't add pairs in javscript template_string treesitter nodes
					java = false, -- don't check treesitter on java
				},
			})

			-- import nvim-autopairs completion functionality
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")

			-- import nvim-cmp plugin (completions plugin)
			local cmp = require("cmp")

			-- make autopairs and completion work together
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
	},

	-- For peeking lines when mentioning them in command line
	{
		"nacro90/numb.nvim",
		event = "VeryLazy",
		config = true,
	},

	{
		"takac/vim-hardtime", -- Puts time delay for hjkl keys
		enabled = false,
		event = "VeryLazy",
		config = function()
			vim.g.hardtime_default_on = 0 -- Set it to be off by default
		end,
	},

	-- The default vim % feature, added here for lazy loading
	{
		"chrisbra/matchit",
		enabled = false, -- Replaced by vim-matchup
		event = "VeryLazy",
	},

	{
		"tpope/vim-unimpaired",
		enabled = false,
		event = "VeryLazy",
	},

	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		config = function()
			require("Comment").setup({ ignore = "^$", })
			local ft = require("Comment.ft")
			ft.set("ahk", ";")
			-- Remap Ctrl-/ to comment
			vim.keymap.set("n", "<C-/>", "gcc", { remap = true, silent = true, desc = "Line comment" })
			vim.keymap.set("v", "<C-/>", "gc", { remap = true, silent = true, desc = "Comment selected lines" })
		end,
	},

	{
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = true,
	},

	{
		"tpope/vim-abolish", -- Search shortcuts
		enabled = false,
		event = "VeryLazy",
	},

	{
		"Konfekt/FastFold", -- For making vim folds faster
		event = "VeryLazy",
	},

	{
		"tmhedberg/SimpylFold", -- Folds for python
		enabled = false,
		ft = { "python" },
		config = function()
			vim.wo.foldenable = false
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "SimpylFold#FoldExpr(v:lnum)"
		end,
	},

	{ -- Extend the <C-a> and <C-x> to work with more increment/decrement featuers and boolean switches
		"nat-418/boole.nvim",
		event = "VeryLazy",
		config = function()
			require("boole").setup({
				mappings = {
					increment = "<C-a>",
					decrement = "<C-x>",
				},
				-- User defined loops
				additions = {
					{ "Foo", "Bar" },
					{ "tic", "tac", "toe" },
				},
				allow_caps_additions = {
					{ "enable", "disable" },
					-- enable → disable
					-- Enable → Disable
					-- ENABLE → DISABLE
				},
			})
		end,
	},

	{ -- Support exhanges using cx, cxx, X(after visual selection)
		"tommcdo/vim-exchange",
		event = "VeryLazy",
	},

	{ -- Align text using gl and gL
		"tommcdo/vim-lion",
		event = "VeryLazy",
	},

	{ -- For persistent storage support for other plugins
		"kkharji/sqlite.lua",
		event = "VeryLazy",
		config = function()
			if not vim.fn.has("linux") then
				vim.g.sqlite_clib_path = "C:/Program Files/sqlite/sqlite3.dll"
			end
		end,
	},
}
