return {

	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",

		keys = {
			{
				"<leader>ff",
				"<cmd>Telescope find_files<cr>",
				desc = "Telescope: find files",
			},
			{
				"<leader>fg",
				"<cmd>Telescope live_grep<cr>",
				desc = "Telescope: live grep",
			},
			{
				"<leader>fb",
				"<cmd>Telescope buffers<cr>",
				desc = "Telescope: buffers",
			},
			{
				"<leader>fh",
				"<cmd>Telescope help_tags<cr>",
				desc = "Telescope: help tags",
			},
			{
				"<leader>fr",
				"<cmd>Telescope oldfiles<cr>",
				desc = "Telescope: recent files",
			},
			{
				"<leader>fc",
				"<cmd>Telescope grep_string<cr>",
				desc = "Find string under cursor in cwd",
			},
			{
				"<leader>fm",
				"<cmd>Telescope macros<cr>",
				desc = "Telescope: browse macros",
			},
			-- {
			-- "<leader>fw",
			-- "<cmd>Telescope workspaces<cr>",
			-- desc = "Telescope: workspaces",
			-- },
			{
				"<leader>T",
				"<cmd>Telescope<cr>",
				desc = "Choose telescope picker",
			},
		},

		config = function()
			-- local builtin = require("telescope.builtin")
			-- local extensions = require"telescope".extensions
			-- vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			-- vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			-- vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
			-- vim.keymap.set("n", "<leader>fp", extensions.projects.projects, {})

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
		"nvim-telescope/telescope-fzf-native.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", },
		-- build = "make",
		build =
		"cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
		event = "VeryLazy",
		config = function()
			require("telescope").load_extension("fzf")
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
			require("project_nvim").setup {}
			require("telescope").load_extension("projects")
		end
	},

	{
		"LukasPietzschmann/telescope-tabs",
		dependencies = { "nvim-telescope/telescope.nvim", },
		event = "VeryLazy",
		config = function()
			require("telescope-tabs").setup {}
		end
	},

	{
		"olimorris/persisted.nvim",
		enabled = false,
		dependencies = { "nvim-telescope/telescope.nvim", },
		event = "VeryLazy",
		config = function()
			require("persisted").setup {}
			require("telescope").load_extension("persisted")
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

	-- Allows telescope to check out keymappings
	{
		"gregorias/nvim-mapper",
		dependencies = "nvim-telescope/telescope.nvim",
		opts = {
			-- search_path = vim.fn.stdpath("config") .. "/lua",
		},
		config = function(_, opts)
			require("nvim-mapper").setup(opts)
		end,
	},

	{
		"LukasPietzschmann/telescope-tabs",
		dependencies = "nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		config = function()
			require("telescope").load_extension "telescope-tabs"
			require("telescope-tabs").setup {}
		end,
	},

	{ -- Macro management

		-- Edit your macros in a more comprehensive way with the `:EditMacros` command
		-- Clear the list of macros with the `:ClearNeoComposer` command
		-- For complex macros over large counts, you can toggle a delay between macro playback using the `:ToggleDelay` command

		"ecthelionvi/NeoComposer.nvim",
		dependencies = {
			"kkharji/sqlite.lua",
			"nvim-telescope/telescope.nvim",
		},
		event = "VeryLazy",
		opts = {
			notify = true,
			delay_timer = 150,
			queue_most_recent = false,
			window = {
				width = 60,
				height = 10,
				border = "rounded",
				winhl = {
					Normal = "ComposerNormal",
				},
			},
			colors = {
				bg = "#011626",
				fg = "#011626",
				red = "#ec5f67",
				blue = "#5fb3b3",
				green = "#99c794",
			},
			keymaps = {
				play_macro = "Q",
				yank_macro = "yq", -- Yank the currently selected macro, in human readable format into the default register
				stop_macro = "cq",
				toggle_record = "q",
				cycle_next = "<c-n>",
				cycle_prev = "<c-p>",
				toggle_macro_menu = false,
			},
		},
		config = function(_, opts)
			require("telescope").load_extension("macros")
			require("NeoComposer").setup(opts)
		end,
	},
}
