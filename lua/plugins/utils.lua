return {

	{
		'lervag/vimtex', -- Latex features
		config = function()
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
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},

	{
		"epwalsh/obsidian.nvim",
		enabled = false,
		version = "*", -- recommended, use latest release instead of latest commit
		lazy = true,
		-- ft = "markdown",
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
			-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
			"VeryLazy",
			"BufReadPre C:/Users/brian/My Files/Study/Work/_Obsidian study notes/**.md",
			-- "BufNewFile C:/Users/brian/AppData/Roaming/Portable Chrome/Obsidian/Mind Map/**.md",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				-- {
				--	name = "work",
				--	path = "C:/Users/brian/My Files/Study/Work/_Obsidian study notes",
				--	-- Absolute path of workspace in windows format causes errors when same config is used in wsl
				-- },
				-- {
				--	name = "work",
				--	path = "~/vaults/work",
				-- },
			},
		},
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 1000
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	},

	-- Window to show all errors and warnings
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = "VeryLazy",
		cmd = "TroubleToggle",
		config = function()
			require("trouble").setup {
				vim.keymap.set("n", "<leader>xx", function() require("trouble").toggle() end)
			}
		end
	},

	-- Markdown preview directly in terminal
	{
		"ellisonleao/glow.nvim",
		config = true,
		cmd = "Glow",
	},

	-- Automatically creates directories needed
	{
		'jghauser/mkdir.nvim',
		event = "VeryLazy",
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
		'tpope/vim-obsession', -- Autosave sessions
		cmd = "Obsess",
	},

	{
		'tpope/vim-rhubarb', -- GitHub support
		cmd = "GBrowse",
	},

	-- Coding usage tracking
	{
		'wakatime/vim-wakatime',
		enabled = false,
		event = "VeryLazy",
	},

	-- For highlighting outer matching parentheses
	{
		"utilyre/sentiment.nvim",

		-- cond required to avoid error when lazy.nvim popup closes to leave a blank file.
		cond = function()
			local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
			if buftype == 'nofile' then -- In the beginning of file loading, the lazy popup sets this value, even though later on it's value is of the opened file.
				return false
			else
				return true
			end
		end,
		version = "*",
		-- lazy = true,
		event = "VeryLazy", -- keep for lazy loading
		opts = {
			included_buftypes = {
				[""] = true,
				["nofile"] = false,
			},
			excluded_filetypes = {
				["lazy"] = true,
			},
		},
		init = function()
			-- `matchparen.vim` needs to be disabled manually in case of lazy loading
			vim.g.loaded_matchparen = 1
		end,
	},

	{
		'airblade/vim-rooter', -- Changes vim directory to project directory
		enabled = false,
		event = "VeryLazy",
	},

	-- Neovim interface in browser text boxes
	{
		'glacambre/firenvim',
		enabled = false,
		-- Lazy load firenvim
		-- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
		lazy = not vim.g.started_by_firenvim,
		build = function()
			vim.fn["firenvim#install"](0)
		end
	},

	{
		"kdheepak/lazygit.nvim",
		-- enabled = false,
		event = "VeryLazy",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{ "<leader>gz", "<cmd>LazyGit<cr>", desc = "LazyGit" },
		},
		cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
		-- config = function ()
		--		vim.api.nvim_set_keymap("n", "<leader>gz", "<cmd>LazyGit<CR>", { noremap = true, silent = true })
		-- end
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		opts = {
			show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
			debug = false,    -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
			disable_extra_info = 'no', -- Disable extra information (e.g: system prompt) in the response.
			-- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
		},
		build = function()
			vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
		end,
		event = "VeryLazy",
		keys = {
			{ "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>cct", "<cmd>CopilotChatTests<cr>",   desc = "CopilotChat - Generate tests" },
			{
				"<leader>ccv",
				":CopilotChatVisual",
				mode = "x",
				desc = "CopilotChat - Open in vertical split",
			},
			{
				"<leader>ccx",
				":CopilotChatInPlace<cr>",
				mode = "x",
				desc = "CopilotChat - Run in-place code",
			},
			{
				"<leader>ccf",
				"<cmd>CopilotChatFixDiagnostic<cr>", -- Get a fix for the diagnostic message under the cursor.
				desc = "CopilotChat - Fix diagnostic",
			},
			{
				"<leader>ccr",
				"<cmd>CopilotChatReset<cr>", -- Reset chat history and clear buffer.
				desc = "CopilotChat - Reset chat history and clear buffer",
			}
		},
	},

	{
		"christoomey/vim-tmux-navigator",
		enabled = false,
		-- enabled = function ()
		--	return vim.fn.has("unix")
		-- end,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},

	-- ActivityWatch plugin for monitoring usage
	{
		"ActivityWatch/aw-watcher-vim",
		enabled = function()
			if vim.fn.has("unix") then
				return false
			else
				return true
			end
		end,
		config = function()
			vim.g.aw_hostname = "Brian-HP"
		end,
	},

	-- To manage sessions and projects
	{
		"gnikdroy/projections.nvim",
		enabled = false,
		event = "VeryLazy",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			-- -- Below are for activating fzf-lua-projections.nvim
			-- 'ibhagwan/fzf-lua',
			-- 'nyngwang/fzf-lua-projections.nvim',
		},
		branch = "pre_release",
		opts = {

			-- show_preview = true,
			-- -- If projections will try to auto restore sessions when you start neovim, boolean
			-- auto_restore = true,
			-- -- The behaviour is as follows:
			-- -- 1) If vim was started with arguments, do nothing
			-- -- 2) If in some project's root, attempt to restore that project's session
			-- -- 3) If not, restore last stored session


			store_hooks = {
				pre = function()
					-- -- if you use neo-tree.nvim, add these two lines to the `pre` of `store_hooks`.
					-- vim.cmd('tabd Neotree close')
					-- vim.cmd('tabn')

					-- Below are to close nvim-tree and neo-tree otherwise it'll cause errors when storing sessions
					-- nvim-tree
					local nvim_tree_present, api = pcall(require, "nvim-tree.api")
					if nvim_tree_present then api.tree.close() end

					-- neo-tree
					if pcall(require, "neo-tree") then vim.cmd [[Neotree action=close]] end
				end,
			},

		},
		config = function(_, opts)
			require("projections").setup(opts)

			-- -- Below are to close nvim-tree and neo-tree otherwise it'll cause errors when storing sessions
			-- vim.api.nvim_create_autocmd("User", {
			--	pattern = "ProjectionsPreStoreSession",
			--	callback = function()
			--		-- nvim-tree
			--		local nvim_tree_present, api = pcall(require, "nvim-tree.api")
			--		if nvim_tree_present then api.tree.close() end
			--
			--		-- neo-tree
			--		if pcall(require, "neo-tree") then vim.cmd [[Neotree action=close]] end
			--	end
			-- })

			-- Save localoptions to session file
			vim.opt.sessionoptions:append("localoptions")


			-- Bind <leader>fp to Telescope projections
			require('telescope').load_extension('projections')
			vim.keymap.set("n", "<leader>fp", function() vim.cmd("Telescope projections") end)

			-- -- for fzf-lua-projections.nvim
			-- vim.keymap.set('n', '<Leader>cp', function () require('fzf-lua-projections').projects() end, NOREF_NOERR_TRUNC)

			-- Autostore session on VimExit
			local Session = require("projections.session")
			vim.api.nvim_create_autocmd({ 'VimLeavePre' }, {
				callback = function() Session.store(vim.loop.cwd()) end,
			})

			-- Switch to project if vim was started in a project dir
			local switcher = require("projections.switcher")
			vim.api.nvim_create_autocmd({ "VimEnter" }, {
				callback = function()
					if vim.fn.argc() == 0 then switcher.switch(vim.loop.cwd()) end
				end,
			})

			-- If vim was started with arguments, do nothing
			-- If in some project's root, attempt to restore that project's session
			-- If not, also do nothing, I'll restore last session manually. Default was to restore last session
			-- If no sessions, do nothing
			vim.api.nvim_create_autocmd({ "VimEnter" }, {
				callback = function()
					if vim.fn.argc() ~= 0 then return end
					local session_info = Session.info(vim.loop.cwd())
					if session_info == nil then
						-- Session.restore_latest()
						return
					else
						Session.restore(vim.loop.cwd())
					end
				end,
				desc = "Restore last session automatically"
			})

			-- The following lines register two commands StoreProjectSession and RestoreProjectSession.
			-- Both of them attempt to store/restore the session if cwd is a project directory
			vim.api.nvim_create_user_command("StoreProjectSession", function()
				Session.store(vim.loop.cwd())
			end, {})

			vim.api.nvim_create_user_command("RestoreProjectSession", function()
				Session.restore(vim.loop.cwd())
			end, {})

			-- The following example creates a AddWorkspace user command which adds the current directory to workspaces json file. Default set of patterns is used.
			local Workspace = require("projections.workspace")
			-- Add workspace command
			vim.api.nvim_create_user_command("AddWorkspace", function()
				Workspace.add(vim.loop.cwd())
			end, {})
		end
	},

	{
		"natecraddock/sessions.nvim",
		enabled = false,
		event = "VeryLazy",
		opts = {
			events = { "WinEnter" },
			-- session_filepath = ".nvim/session",
			session_filepath = vim.fn.stdpath("data") .. "/sessions",
			absolute = true,
		}
	},

	{
		"natecraddock/workspaces.nvim",
		event = "VeryLazy",
		dependencies = {
			-- "natecraddock/sessions.nvim",
			"Shatur/neovim-session-manager",
			"nvim-telescope/telescope.nvim",
		},
		opts = {
			hooks = {
				open_pre = {
					-- If recording, save current session state and stop recording
					-- "SessionsStop",

					-- delete all buffers (does not save changes)
					"silent %bdelete!",
				},
				-- open = function()
				--	-- require("sessions").load(nil, { --[[ silent = true ]] })
				--	require('session_manager').save_current_session()
				-- end,
				open = {
					"SessionManager load_current_dir_session",
				},
				add = {
					"SessionManager save_current_session",
				},
				-- Workspace remove not exactly deleting the session properly via SessionManager
				remove = {
					"SessionManager delete_session",
				},

			}
		},
		config = function(_, opts)
			require("workspaces").setup(opts)
			require("telescope").load_extension("workspaces")
			-- vim.keymap.set("n", "<leader>fw", function() vim.cmd("Telescope workspaces") end)
		end,
	},

	-- Works as saving projects and sessions, can select and load sessions using telescope also
	-- Downside is we can't name the sessions, it is only per directory name
	{
		"Shatur/neovim-session-manager",
		-- event = "VeryLazy",
		dependencies = {
			-- Can use telescope for the selection UI, but it's not necessary
			-- "nvim-telescope/telescope.nvim",
			-- "nvim-telescope/telescope-ui-select.nvim",
			"nvim-lua/plenary.nvim",
		},
		config = function()
			-- local Path = require('plenary.path')
			local config = require('session_manager.config')
			require('session_manager').setup({
				autoload_mode = config.AutoloadMode.CurrentDir,
				autosave_ignore_dirs = {
					[[C:\Users\brian\scoop\apps\neovide\current]],
					[[C:\Users\brian\scoop\apps\nvy\current]],
					[[C:\WINDOWS\system32]],
				},
				-- autosave_ignore_buftypes = {"terminal", "term"},
				autosave_ignore_filetypes = { "terminal", "term" },
				-- autosave_only_in_session = true, -- Always autosaves session. If true, only autosaves after a session is active.
			})

			vim.keymap.set("n", "<leader>fw", function() vim.cmd("SessionManager load_session") end)

			local config_group = vim.api.nvim_create_augroup('MyConfigGroup', {}) -- A global group for all your config autocommands
			-- Close nvim-tree and neo-tree before saving session
			vim.api.nvim_create_autocmd({ 'User' }, {
				pattern = "SessionSavePre",
				group = config_group,
				callback = function()
					-- Below are to close nvim-tree and neo-tree otherwise it'll cause errors when storing sessions
					-- nvim-tree
					local nvim_tree_present, api = pcall(require, "nvim-tree.api")
					if nvim_tree_present then api.tree.close() end
					-- neo-tree
					if pcall(require, "neo-tree") then vim.cmd [[Neotree action=close]] end
				end,
			})

			-- Auto save session
			vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
				group = config_group,
				callback = function()
					for _, buf in ipairs(vim.api.nvim_list_bufs()) do
						-- Don't save while there's any 'nofile' buffer open.
						if vim.api.nvim_get_option_value("buftype", { buf = buf }) == 'nofile' then
							return
						end
					end
					require('session_manager').save_current_session()
				end
			})
		end
	},

	-- Tool for better appearances of diffs. Already supports git diff capabilities as commands.
	{
		"sindrets/diffview.nvim",
		event = "VeryLazy",
	},

	{
		"kawre/leetcode.nvim",
		build = ":TSUpdate html",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim", -- required by telescope
			"MunifTanjim/nui.nvim",

			-- optional
			"nvim-treesitter/nvim-treesitter",
			"rcarriga/nvim-notify",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			-- configuration goes here
		},
	},
}
