## Status info
- current nvim version: v0.11.4

## Useful links
- [dotfyle](https://dotfyle.com/) - kind of an nvim plugins/themes/config marketplace


## Useful nvim debug tips
- can use `:map <hotkey>` or `:verbose command <cmd_name>` to diagnose where it was defined
- `:profile` and `plenary.profile()`
- `:Telescope keymaps` to search through keymaps


## Setup notes
for clipboard in wsl, win32yank is the way to go. Weirdly nvim doesn't recognize in path by default, so gotta give the full windows path in
the config.
clipboard in windows neovim seems to work seamlessly, no plugin or setting needed


## Plugins guide
### LSP
- trouble.nvim - basically "problems" tab in vscode, see all lsp issues in a buffer
### Visuals
- nvim-hlslens: hovering highlight on search targets when using / search feature
- which-key: Shows available keybindings. Pops up when you click an incomplete sequence of keybindings and shows what options you have
- noice.nvim: Pop-up UI, top right corner, or transparent pop ups etc.
### Navigation
- neo-tree filesystem map. leader-e, same as vs code files

## Future plugin candidates
> another list of plugins I can add/look into in the future. Whatever existing plugins you've disabled coz not working, add that also to this list
