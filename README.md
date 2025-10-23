## Status info
- current nvim version: v0.11.4

## Fixes
- stylua
  - [x] ignore stylua warning in noice
  - stylua --lsp flag should not be called in the first place
- Running LspRestart fails with warning `Invalid server name 'null-ls'`
- neoscroll zz not working. check other stuff too
- restoring session not working for tabs and help pages
- noice pop ups for command outputs are hard to read, on a translucent pop up which lasts for 2 seconds.
- atleast for lua, some lsp keymaps aren't working. example, formatting.
- No nice enough syntax highlighting for markdown
- nvim doesn't seem to read the path like usual bash does. things like win32yank and dos2unix isn't available. figure out why, what env
  setup does nvim's lua environment use

## Todo
- gotta make a readme with usage guide so I wont forget neovim-exclusive features and how to use them. list:
    - trouble.nvim - basically "problems" tab in vscode, see all lsp issues in a buffer
    - keybindings for lsp usage
- Conceptually understand the framework of neovim. I want to understand, what context and env autocommands run, or plugins run. I can set up
  bash commands in many different locations in the config and in neovim's "runtime environments", I want to understand the nature of each of
  those.


## Useful nvim debug tips
- can use `:map <hotkey>` or `:verbose command <cmd_name>` to diagnose where it was defined
- `:profile` and `plenary.profile()`
- `:Telescope keymaps` to search through keymaps


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


## Plugin keybindings
### LSP
| Mode(s) | Key | Command / Function | Description |
|----------|-----|--------------------|--------------|
| **Normal** | `gr` | `Telescope lsp_references` | List all references to the symbol under cursor. |
| **Normal** | `gd` | `Telescope lsp_definitions` | Jump to definition(s) of symbol, reusing current window. |
| **Normal** | `gf` | `vim.lsp.buf.declaration` | Go to the declaration of the symbol. |
| **Normal** | `gD` | `goto_preview_definition` | Open floating window preview of the symbol’s definition. |
| **Normal** | `gF` | `goto_preview_declaration` | Open floating preview of declaration. |
| **Normal** | `gI` | `Telescope lsp_implementations` | List and jump to implementations of interface or method. |
| **Normal** | `gy` | `Telescope lsp_type_definitions` | List and jump to type definition of symbol. |
| **Normal** | `gK` | `vim.lsp.buf.signature_help` | Show function signature help in floating window. |
| **Normal, Visual** | `<leader>ca` | `vim.lsp.buf.code_action` / `Telescope lsp_range_code_actions` | Show available code actions (contextual quick-fixes, refactors). |
| **Normal, Visual** | `<leader>cc` | `vim.lsp.codelens.run` | Execute CodeLens actions (e.g., test, run main). |
| **Normal, Visual** | `<leader>cC` | `vim.lsp.codelens.refresh` | Refresh and display updated CodeLens annotations. |
| **Normal** | `<leader>cA` | `vim.lsp.buf.code_action({ only = { "source" } })` | Apply “source” code actions like organize imports or lint fixes. |
| **Normal** | `<leader>rn` | Incremental rename via `inc_rename` | Rename symbol under cursor with live updates. |
| **Normal** | `<leader>db` | `Telescope diagnostics bufnr=0` | Show diagnostics for current buffer. |
| **Normal** | `<leader>dD` | `Telescope diagnostics` | Show all diagnostics across workspace. |
| **Normal** | `<leader>dd` | `vim.diagnostic.open_float` | Show diagnostics for the current line in floating window. |
| **Normal** | `<leader>dl` | `vim.diagnostic.setloclist` | Populate location list with buffer diagnostics. |
| **Normal** | `[d` | `vim.diagnostic.goto_prev` | Jump to previous diagnostic message. |
| **Normal** | `]d` | `vim.diagnostic.goto_next` | Jump to next diagnostic message. |
| **Normal** | `K` | `vim.lsp.buf.hover` | Show documentation or hover info for symbol under cursor. |
| **Normal** | `<leader>rs` | `:LspRestart` | Restart current LSP server. |
| **Normal** | `<leader>=` | Custom `formatter` | Format entire buffer using `null-ls` or LSP formatter. |
| **Visual** | `=` | Custom `formatter` | Format selected region using `null-ls` or LSP formatter. |



## Future plugin candidates
> another list of plugins I can add/look into in the future. Whatever existing plugins you've disabled coz not working, add that also to this list
- https://github.com/MeanderingProgrammer/render-markdown.nvim, an alternative to Glow.nvim and markdownpreview
- https://github.com/folke/tokyonight.nvim
