return {

	{
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' },
		event = "VeryLazy",

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
			"<leader>fr",
			"<cmd>Telescope oldfiles<cr>",
			desc = "Telescope: recent files",
			},
			{ -- lazy style key map
			"<leader>fc",
			"<cmd>Telescope grep_string<cr>",
			desc = "Find string under cursor in cwd",
			},
			-- { -- lazy style key map
			-- "<leader>fw",
			-- "<cmd>Telescope workspaces<cr>",
			-- desc = "Telescope: workspaces",
			-- },
		},

		config = function ()
			-- local builtin = require('telescope.builtin')
			-- local extensions = require'telescope'.extensions
			-- vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
			-- vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
			-- vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
			-- vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
			-- vim.keymap.set('n', '<leader>fp', extensions.projects.projects, {})

			local telescope = require("telescope")
			local actions = require("telescope.actions")

			telescope.setup({
			  defaults = {
				path_display = { "truncate " },
				mappings = {
				  -- For insert mode,
				  i = {
					["<C-k>"] = actions.move_selection_previous, -- move to prev result
					["<C-j>"] = actions.move_selection_next, -- move to next result

					-- Send telescope results to the quickfix list
					["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

					-- Show mappings for current picker
					["<C-h>"] = "which_key"
				  },
				},
			  },
			})
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
		enabled = false,
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
		enabled = false,
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

	{
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", },
		event = "VeryLazy",
		config = function()
			require("telescope").load_extension("ui-select")
		end,
	},
}
