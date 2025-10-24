## Priorities
- Markdown highlighting to easily write nvim todo and notes here
- working lua formatter
- filepath relative to project root helpful to show. For example in MTP project, opening actor lib.rs just shows lib.rs, can't tell which
  folder it is from
- confused about how rust_analyzer and stylua is running coz they aren't configured anywhere,
  except for mason null-ls ensure installed section


## Fixes
- stylua
  - [x] ignore stylua warning in noice
  - stylua --lsp flag should not be called in the first place
- restoring session not working for help pages
- noice pop ups for command outputs are hard to read, on a translucent pop up which lasts for 2 seconds.
- atleast for lua, some lsp keymaps aren't working. example, formatting.
- No nice enough syntax highlighting for markdown
- nvim doesn't seem to read the path env var like usual bash does. things like win32yank and dos2unix isn't available. figure out why, what env
  setup does nvim's lua environment use
- track down conceallevel settings. It's being set as 2, atleast for help pages which is bad. 
  For ft="help" it should be set as 0. Could make an autocmd for that.
- difference between null-ls refactoring server and primegean refactoring plugin
- figure out what luasnip is supposed to do, and fix it.

## Todo
- gotta make a readme with usage guide so I wont forget neovim-exclusive features and how to use them. list:
    - trouble.nvim - basically "problems" tab in vscode, see all lsp issues in a buffer
    - keybindings for lsp usage
- Conceptually understand the framework of neovim. I want to understand, what context and env autocommands run, or plugins run. I can set up
  bash commands in many different locations in the config and in neovim's "runtime environments", I want to understand the nature of each of
  those.
- Understand how session restore works
- Make a global set of size bounds for different filetypes, and set up such that heavy plugins
  like lsp and treesitter do not activate on such files. esp txt, json, log, etc.
- Specific formatting options per file type/lsp server. 
  As specified in [nvim docs](https://neovim.io/doc/user/lsp.html#vim.lsp.buf.format()) and microsoft [lsp docs](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#formattingOptions)

## More plugins to look into
- [efmls-configs-nvim](https://github.com/creativenull/efmls-configs-nvim): A general LSP
- [confirm.nvim](https://github.com/stevearc/conform.nvim) + [nvim-lint](https://github.com/mfussenegger/nvim-lint): Mostly a much simpler replacement for null-ls/none-ls

