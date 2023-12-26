-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Vimscript plugins

	use { 'bluz71/vim-nightfly-colors', as = 'nightfly' } -- Color theme
	use 'dstein64/vim-startuptime' -- Plugin to measure startup times
	use 'takac/vim-hardtime' -- Puts time delay for hjkl keys
	use 'lervag/vimtex' -- Latex features
	-- use {'bfrg/vim-cpp-modern', ft = {'cpp'} } -- C++ better syntax highlighting
	-- use 'octol/vim-cpp-enhanced-highlight' -- Same as above

	use 'tpope/vim-surround'
	use 'tpope/vim-fugitive' -- Git support
	-- use 'tpope/vim-rhubarb'
	-- use 'tpope/vim-unimpaired'
	use 'tpope/vim-commentary' -- Adding comments feature
	-- use 'tpope/vim-sensible' -- Add some basic default vim configs
	-- use 'tpope/vim-abolish' -- Search shortcuts

	-- use 'luochen1990/rainbow' -- rainbow brackets
	-- use 'ctrlpvim/ctrlp.vim' -- File finding
	use 'Konfekt/FastFold' -- For making vim folds faster
	use {'tmhedberg/SimpylFold', ft = {'python'} } -- Folds for python
	-- use 'dense-analysis/ale' -- Real-time linting while editing
	use 'unblevable/quick-scope' -- Highlights unique letter in each word for faster f

	-- To visualize undos
	use 'mbbill/undotree'

	use {
		'dense-analysis/ale',
		ft = {'sh', 'zsh', 'bash', 'c', 'cpp', 'cmake', 'html', 'markdown', 'racket', 'vim', 'tex'},
		cmd = 'ALEEnable',
		config = 'vim.cmd[[ALEEnable]]',
		disable = true,
	}

	-- Lua plugins

	use "nvim-lua/plenary.nvim"

	-- To show indent lines and levels
	use {
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("config.ibl")
		end,
	}

	use 'HiPhish/rainbow-delimiters.nvim'

	-- Smooth scrolling
	use {
		"karb94/neoscroll.nvim",
		config = function()
			require("config.neoscroll")
		end,
	}

	-- Scrollbar
	use {
		"petertriho/nvim-scrollbar",
		config = function()
			require("scrollbar").setup()
			-- require("config.scrollbar")
		end,
	}

	-- hlslens for scrollbar
	use {
		"kevinhwang91/nvim-hlslens",
		config = function()
			-- require('hlslens').setup() is not required
			require("scrollbar.handlers.search").setup({
				override_lens = function() end,
			})
		end,
	}

	-- Gitsigns for displaying in scrollbar
	use {
		"lewis6991/gitsigns.nvim",
		config = function()
			require('gitsigns').setup()
			require("scrollbar.handlers.gitsigns").setup()
		end
	}

	use {
		'iamcco/markdown-preview.nvim', run = 'cd app && npm install',
		setup = function() vim.g.mkdp_filetypes = { 'markdown' } end, ft = { 'markdown' },
	}

	-- File explorer
	use 'nvim-tree/nvim-tree.lua'

	-- For Utilsnips, Track the engine.
	-- use 'SirVer/ultisnips'
	-- Snippets are separated from the engine. Add this if you want them:
	-- use 'honza/vim-snippets'

	-- Status line plugin
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'nvim-tree/nvim-web-devicons', opt = true },
		config = function()
			require('lualine').setup {options = { theme = 'nightfly' } }
		end
	}

	-- Neovim interface in browser text boxes
	use {
		'glacambre/firenvim',
		run = function() vim.fn['firenvim#install'](0) end,
		disable = true,
	}

	-- use 'ycm-core/YouCompleteMe'
	-- use 'psliwka/vim-smoothie' -- smooth scrolling

	-- General lua dev setup, not sure. Requires setup(), called in lsp_setup.lua
	use "folke/neodev.nvim"

	-- Tree-sitter
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate',
		config = function()
			require('config.treesitter')
		end
	}

	-- A minimap plugin
	use {
		'gorbit99/codewindow.nvim',
		config = function()
			local codewindow = require('codewindow')
			codewindow.setup({
			use_lsp = false, -- Use the builtin LSP to show errors and warnings
			-- use_treesitter = false, -- Use nvim-treesitter to highlight the code
			})
			codewindow.apply_default_keybinds()
			vim.api.nvim_set_hl(0, 'CodewindowBorder', {fg = '#012b4d'}) -- Doesn't seem to work
		end
	}

	-- Neovim package manager
	use "williamboman/mason.nvim"

	-- Mason helper for installing LSP servers
	use "williamboman/mason-lspconfig.nvim"

	-- LSP Config
	use 'neovim/nvim-lspconfig'

	-- GitHub Copilot support
	use {
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function() require("copilot").setup({}) end,
		disable = true,
	}

	use {
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		requires = {
			"nvim-lua/plenary.nvim",
		},
		-- cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile", "LazyGitFilter", "LazyGitFilterCurrentFile" },
		disable = true,
	}
end)
