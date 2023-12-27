-- Config for GUIs:
if vim.g.neovide then
	vim.o.guifont = "Consolas Nerd Font:h11"
	-- vim.o.guifont = "CaskaydiaMono Nerd Font:h12"

	vim.g.neovide_hide_mouse_when_typing = true
	-- vim.g.neovide_refresh_rate = 144
	vim.g.neovide_remember_window_size = true
	vim.g.neovide_cursor_animation_length = 0.03
	-- vim.g.neovide_cursor_trail_size = 0.5
	-- vim.g.neovide_scroll_animation_length = 0.9
	vim.g.neovide_cursor_animate_in_insert_mode = true
	vim.g.neovide_cursor_animate_command_line = true
	vim.g.neovide_cursor_unfocused_outline_width = 0.125

elseif vim.g.nvy then
	vim.o.guifont = "Consolas Nerd Font:h11:w55"
	vim.api.nvim_set_keymap('i', '<C-H>', '<C-W>', {noremap = true})
	-- The Ctrl-Bskp keymap still isn't working
end
