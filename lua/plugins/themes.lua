-- Set colorscheme only for specific filetypes
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = { "lua", "vim", "python" }, -- Add desired filetypes here
-- 	callback = function()
-- 		vim.cmd.colorscheme("night-owl")
-- 	end,
-- })

return {

	{
		'bluz71/vim-nightfly-colors',
		name = 'nightfly',
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("nightfly") end,
	}, -- Color theme. oxfist/night-owl.nvim is also a good alternative

	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		config = function() 
			require("catppuccin").setup({
				auto_integrations = true,
				lsp_styles = {
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
						ok = { "undercurl" },
					},
				},
			})
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	{
		"rebelot/kanagawa.nvim",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("kanagawa-wave") end,
	},

	{
		"rose-pine/neovim",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("rose-pine") end,
	},

	{
		"navarasu/onedark.nvim",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("onedark") end,
		-- config = function()
			-- require('onedark').setup {
			-- 	style = 'darker'
			-- }
			-- Enable theme
			-- require('onedark').load()
		-- end
	},

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("tokyonight-storm") end,
	},

	{
		"tiagovla/tokyodark.nvim",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("tokyodark") end,
	},

	{
		"ribru17/bamboo.nvim",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("bamboo") end,
	},

	{
		"oxfist/night-owl.nvim",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("night-owl") end,
	},

	{
		"eldritch-theme/eldritch.nvim",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("eldritch-dark") end,
	},

	{
		"EdenEast/nightfox.nvim",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("nightfox") end,
	},

	{
		"scottmckendry/cyberdream.nvim",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("cyberdream") end,
	},

	{
		"sample-usr/rakis.nvim",
		lazy = false,
		priority = 1000,
		-- config = function() vim.cmd.colorscheme("rakis") end,
	},
}
