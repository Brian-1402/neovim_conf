return {
	{
		'nvim-treesitter/nvim-treesitter',
		tag = "v0.9.2",
		build = ':TSUpdate',
		event = { "VeryLazy" },

		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
			require("nvim-treesitter.query_predicates")
		end,

		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			"RRethy/nvim-treesitter-textsubjects",
		},

		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },

		opts = {

			-- A list of parser names, or "all" (the five listed parsers should always be installed)
			ensure_installed = { "c", "cpp", "comment", "gitignore", "html", "java", "javascript",
				"json", "latex", "lua", "make", "markdown", "markdown_inline", "python",
				"query", "regex", "vim", "vimdoc" },
			-- ensure_installed = "all",
			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			-- List of parsers to ignore installing (or "all")
			-- ignore_install = { "javascript" },

			---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
			-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

			highlight = {
				enable = true,

				-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
				-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
				-- the name of the parser)
				-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
				disable = function(lang, buf)
					local max_filesize = 50 * 1024 -- 50 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
					local all_disabled = {"latex", }
					local win32_disabled = { --[[ "make", ]] }
					-- Disabling latex because vimtex provides highlighting. 
					-- Disabling make because the current windows parser seems to give an error constantly
					if vim.fn.has("win32") and vim.tbl_contains( win32_disabled, lang ) then
						return true
					elseif vim.tbl_contains( all_disabled, lang ) then
						return true
					end
				end,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = { "latex" },
			},

			indent = {
				enable = false
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "zv", -- set to `false` to disable one of the mappings
					node_incremental = "J",
					scope_incremental = false,
					node_decremental = "K",
				},
			},

			textobjects = {
				move = {
					enable = true,
					set_jumps = true, -- whether to set jumps in the jumplist

					-- goto_next_start = {
					-- 	["]m"] = "@function.outer",
					-- 	["]]"] = { query = "@class.outer", desc = "Next class start" },
					-- 	--
					-- 	-- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
					-- 	["]o"] = "@loop.*",
					-- 	-- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
					-- 	--
					-- 	-- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
					-- 	-- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
					-- 	["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
					-- 	["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					-- },

					goto_next_start = {
						["]f"] = "@function.outer",
						["]c"] = "@class.outer",
						["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
					},

					goto_next_end = {
						["]F"] = "@function.outer",
						["]C"] = "@class.outer",
					},
					goto_previous_start = {
						["[f"] = "@function.outer",
						["[c"] = "@class.outer",
						["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
					},
					goto_previous_end = {
						["[F"] = "@function.outer",
						["[C"] = "@class.outer",
					},

					-- Below will go to either the start or the end, whichever is closer.
					-- Use if you want more granular movements
					-- Make it even more gradual by adding multiple queries and regex.
					-- goto_next = {
					-- 	["]d"] = "@conditional.outer",
					-- },
					-- goto_previous = {
					-- 	["[d"] = "@conditional.outer",
					-- },
					-- -- Commented the above coz [d and ]d is used by LSP for diagnostics
				},

				select = {
					enable = true,

					-- Automatically jump forward to textobj, similar to targets.vim
					lookahead = true,

					keymaps = {
						-- You can use the capture groups defined in textobjects.scm
						-- You can optionally set descriptions to the mappings (used in the desc parameter of
						-- nvim_buf_set_keymap) which plugins like which-key display
						["af"] = { query = "@function.outer", desc = "Select the outer part of a function region" },
						["if"] = { query = "@function.inner", desc = "Select the inner part of a function region" },
						["ac"] = { query = "@class.outer", desc = "Select the outer part of a class region" },
						["ic"] = { query = "@class.inner", desc = "Select the inner part of a class region" },
						-- You can also use captures from other query groups like `locals.scm`
						["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
						["is"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
					},
					-- You can choose the select mode (default is charwise 'v')
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * method: eg 'v' or 'o'
					-- and should return the mode ('v', 'V', or '<c-v>') or a table
					-- mapping query_strings to modes.
					selection_modes = {
						['@parameter.outer'] = 'v', -- charwise
						-- ['@function.outer'] = 'V', -- linewise
						-- ['@class.outer'] = '<c-v>', -- blockwise
						['@function.outer'] = 'v',
						['@class.outer'] = 'v',
					},
					-- If you set this to `true` (default is `false`) then any textobject is
					-- extended to include preceding or succeeding whitespace. Succeeding
					-- whitespace has priority in order to act similarly to eg the built-in
					-- `ap`.
					--
					-- Can also be a function which gets passed a table with the keys
					-- * query_string: eg '@function.inner'
					-- * selection_mode: eg 'v'
					-- and should return true of false
					include_surrounding_whitespace = false,

				},

				swap = {
					enable = true,
					swap_next = {
						["<leader>a"] = "@parameter.inner",
					},
					swap_previous = {
						["<leader>A"] = "@parameter.inner",
					},
				},
			},

			textsubjects = {
				enable = true,
				prev_selection = '<BS>', -- (Optional) keymap to select the previous selection
				keymaps = {
					['<CR>'] = 'textsubjects-smart',
					['aC'] = 'textsubjects-container-outer',
					['iC'] = { 'textsubjects-container-inner', desc = "Select inside containers (classes, functions, etc.)" },
				},
			},

			matchit = {
				enable = true,
			},
		},

		config = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				---@type table<string, boolean>
				local added = {}
				opts.ensure_installed = vim.tbl_filter(function(lang)
					if added[lang] then
						return false
					end
					added[lang] = true
					return true
				end, opts.ensure_installed)
			end

			-- For setting treesitter folding
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
			vim.wo.foldenable = false

			require 'nvim-treesitter.install'.prefer_git = false -- Use curl instead. Git is slower and overloads the RAM during multiple installations
			require("nvim-treesitter.configs").setup(opts)
		end,
	},


	-- Show context of the current function on the top of the editor
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",
		opts = { mode = "cursor", max_lines = 3 },
		config = function (_, opts)
			vim.keymap.set("n", "[C", function()
					require("treesitter-context").go_to_context(vim.v.count1)
				end, { silent = true })
			require'treesitter-context'.setup(opts)
		end,
	},

	-- Toggles splitting and joining blocks of code
	{
		'Wansmer/treesj',
		event = "VeryLazy",
		keys = { '<space>m'},
		-- leader m for toggling
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('treesj').setup({--[[ your config ]]})
		end,
	},

	-- Extended support for highlighting matching items. Replaces matchit and matchparen
	-- Uses treesitter integration
	{
		'andymass/vim-matchup',
		-- It has to load before the rtp plugins (matchit, matchparen) loads, so BufReadPre event is not enough, it should be non-lazy
		lazy = false,
		enabled = false,
		config = function()
			vim.g.loaded_matchit = 1
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end
	},

	-- Automatically add closing tags for HTML and JSX
	{
		"windwp/nvim-ts-autotag",
		event = "VeryLazy",
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		opts = {},
	},

	-- Adds treesitter based context to comments, and decides style of comment accordingly
	{
		'JoosepAlviste/nvim-ts-context-commentstring',
		event = "VeryLazy",
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
			'numToStr/Comment.nvim',
		},
		opts = {
			enable_autocmd = false,
		},
		config = function(_, opts)
			require('ts_context_commentstring').setup(opts)
			require('Comment').setup {
				pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
			}
		end
	},

	-- Structural search and replace
	{
		"cshuaimin/ssr.nvim",
		name = "ssr",
		event = "VeryLazy",
		config = function()
			-- require("ssr").setup() -- optional
			vim.keymap.set({ "n", "x" }, "<leader>sr", function() require("ssr").open() end)
		end
	},

	-- Provides treesitter into heredocs
	{
		'AckslD/nvim-FeMaco.lua',
		event = "VeryLazy",
		config = true,
	},
}
