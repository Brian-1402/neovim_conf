return {

	{
		'bluz71/vim-nightfly-colors',
		name = 'nightfly',
		lazy = false,
		priority = 1000,
		config = function() vim.cmd.colorscheme("nightfly") end,
	}, -- Color theme. oxfist/night-owl.nvim is also a good alternative

	{
		"catppuccin/nvim",
		name = "catppuccin",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("catppuccin") end,
	},

	{
		"utilyre/barbecue.nvim",
		name = "barbecue",
		enabled = false, -- Giving E36:Not enough room error everytime I scroll. But that error started recently only,
		-- probably conflicting with some recent settings changes. I think it's the treesitter top scope previewer bar.
		event = "UIEnter",
		version = "*",
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons", -- optional dependency
		},
		opts = {
			-- configurations go here
		},
	},

	-- Makes window separations colorful
	{
		"nvim-zh/colorful-winsep.nvim",
		event = { "WinNew" },
		opt = {
			no_exec_files = {
				"TelescopePrompt",
				"alpha",
				"dashboard",
				"neo-tree",
				"Trouble",
				"lazy",
				"terminal",
				"neogitstatus",
				"mason",
			},
		},
	},

	{
		'unblevable/quick-scope', -- Highlights unique letter per word for faster f
		event = "VeryLazy",
	},

	{
		'akinsho/bufferline.nvim',
		enabled = false,
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		event = "VeryLazy",
		opts = {
			-- diagnostics = "nvim_lsp",
		},
		config = function(_, opts)
			vim.opt.termguicolors = true
			require("bufferline").setup(opts)
		end
	},

	-- To improve the UI used by other plugins like telescope etc.
	{
		'stevearc/dressing.nvim',
		event = "VeryLazy",
		opts = {},
	},

	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			require("telescope").load_extension("notify")
		end,
	},

	-- A minimap plugin
	{
		'gorbit99/codewindow.nvim',
		enabled = false,
		-- event = "VeryLazy",
		keys = { "<leader>mo", "<leader>mc", "<leader>mf", "<leader>mm", },
		config = function()
			local codewindow = require('codewindow')
			codewindow.setup({
				-- use_lsp = false, -- Use the builtin LSP to show errors and warnings
				-- use_treesitter = false, -- Use nvim-treesitter to highlight the code
			})
			codewindow.apply_default_keybinds()
			vim.api.nvim_set_hl(0, 'CodewindowBorder', { fg = '#012b4d' }) -- Doesn't seem to work
		end
	},

	-- Toggle maximise a split window
	{
		"szw/vim-maximizer",
		-- by default, it sets keymap as F3. put "let g:maximizer_set_default_mapping = 1" to disable it.
		keys = {
			{
				"<leader>sm",
				"<cmd>MaximizerToggle<CR>",
				desc = "Maximize/minimize a split",
			},
		},
		config = function()
			vim.g.maximizer_set_default_mapping = 0
			-- vim.g.maximizer_default_mapping_key = '<leader>sm'
			-- Above setting not working
		end,
	},

	{ -- Toggle relative numbering only for active window in normal mode, absolute when insert, etc.
		"sitiom/nvim-numbertoggle",
		event = "VeryLazy",
	},

	{ -- Displays file name and more in a small hover window
		'b0o/incline.nvim',
		event = 'VeryLazy',
		dependencies = {
			"SmiteshP/nvim-navic",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			local helpers = require 'incline.helpers'
			local navic = require 'nvim-navic'
			local devicons = require 'nvim-web-devicons'
			require('incline').setup {
				window = {
					padding = 0,
					margin = { horizontal = 1, vertical = 0 },
					overlap = {
						borders = false,
						statusline = false,
						tabline = false,
						winbar = false
					},
				},
				render = function(props)
					local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
					if filename == '' then
						filename = '[No Name]'
					end
					local ft_icon, ft_color = devicons.get_icon_color(filename)
					local modified = vim.bo[props.buf].modified
					local res = {
						ft_icon and { ' ', ft_icon, ' ', guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or
						'',
						' ',
						{ filename, gui = modified and 'bold,italic' or 'bold' },
						guibg = '#44406e',
					}
					if props.focused then
						for _, item in ipairs(navic.get_data(props.buf) or {}) do
							table.insert(res, {
								{ ' > ',     group = 'NavicSeparator' },
								{ item.icon, group = 'NavicIcons' .. item.type },
								{ item.name, group = 'NavicText' },
							})
						end
					end
					table.insert(res, ' ')
					return res
				end,
			}
		end,
	},
}
