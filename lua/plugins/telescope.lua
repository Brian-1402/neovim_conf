return {

	{
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' },
		event = "VeryLazy",

		opts = {
			-- extensions = {
			-- 	fzf = { },
			-- 	agrolens = { },
			-- },
		},

		keys = {
			{ -- lazy style key map
			"<leader>ff",
			"<cmd>Telescope find_files<cr>",
			desc = "Telescope: find files",
			},
			{ -- lazy style key map
			"<leader>fg",
			"<cmd>Telescope live_grep<cr>",
			desc = "Telescope: live grep",
			},
			{ -- lazy style key map
			"<leader>fb",
			"<cmd>Telescope buffers<cr>",
			desc = "Telescope: buffers",
			},
			{ -- lazy style key map
			"<leader>fh",
			"<cmd>Telescope help_tags<cr>",
			desc = "Telescope: help tags",
			},
			{ -- lazy style key map
			"<leader>fp",
			"<cmd>Telescope projects<cr>",
			desc = "Telescope: projects",
			},
		},

		config = function (_, opts)
			-- local builtin = require('telescope.builtin')
			-- local extensions = require'telescope'.extensions
			-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
			-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
			-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
			-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
			-- vim.keymap.set('n', '<leader>fp', extensions.projects.projects, {})
			require('telescope').setup(opts)
		end
	},

	{
		'nvim-telescope/telescope-fzf-native.nvim',
		dependencies = { "nvim-telescope/telescope.nvim", },
		-- build = 'make',
		build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
		event = "VeryLazy",
		config = function ()
			require('telescope').load_extension('fzf')
		end
	},

	{
		"debugloop/telescope-undo.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", },
		event = "VeryLazy",
		keys = {
			{ -- lazy style key map
				"<leader>u",
				"<cmd>Telescope undo<cr>",
				desc = "undo history",
			},
		},
		config = function()
			require("telescope").load_extension("undo")
			-- vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<cr>")
		end,
	},


	{
		"cljoly/telescope-repo.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", },
		event = "VeryLazy",
		config = function()
			require("telescope").load_extension("repo")
		end,
	},

	{
		-- Automatically cd to project root. This supports telescope extension
		"ahmedkhalf/project.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", },
		event = "VeryLazy",
		config = function()
			require("project_nvim").setup { }
			require('telescope').load_extension('projects')
		end
	},

	{
		"LukasPietzschmann/telescope-tabs",
		dependencies = { "nvim-telescope/telescope.nvim", },
		event = "VeryLazy",
		config = function()
			require("telescope-tabs").setup { }
		end
	},

	{
		"olimorris/persisted.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", },
		event = "VeryLazy",
		config = function()
			require("persisted").setup { }
			require('telescope').load_extension('persisted')
		end
	},

	{
		"desdic/agrolens.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", },
		event = "VeryLazy",
		config = function()
			require("telescope").load_extension("agrolens")
		end,
	},
}
