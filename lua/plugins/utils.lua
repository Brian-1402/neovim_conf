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
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},

	{
		"epwalsh/obsidian.nvim",
		enabled = false,
		version = "*",	-- recommended, use latest release instead of latest commit
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
			vim.o.timeoutlen = 2000
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
		cond = function ()
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
		enabled = false,
		-- event = "VeryLazy",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
	},

	{
		"CopilotC-Nvim/CopilotChat.nvim",
		opts = {
			show_help = "yes", -- Show help text for CopilotChatInPlace, default: yes
			debug = false, -- Enable or disable debug mode, the log file will be in ~/.local/state/nvim/CopilotChat.nvim.log
			disable_extra_info = 'no', -- Disable extra information (e.g: system prompt) in the response.
			-- proxy = "socks5://127.0.0.1:3000", -- Proxies requests via https or socks.
		},
		build = function()
			vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
		end,
		event = "VeryLazy",
		keys = {
			{ "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{ "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
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
		-- 	return vim.fn.has("unix")
		-- end,
		cmd = {
			"TmuxNavigateLeft",
			"TmuxNavigateDown",
			"TmuxNavigateUp",
			"TmuxNavigateRight",
			"TmuxNavigatePrevious",
		},
		keys = {
			{ "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
			{ "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
			{ "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
			{ "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
			{ "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
		},
	},

	-- ActivityWatch plugin for monitoring usage
	{
		"ActivityWatch/aw-watcher-vim",
		enabled = function ()
			return vim.fn.has("win32")
		end,
		config = function ()
			vim.g.aw_hostname = "Brian-HP"
		end,
	},
}
