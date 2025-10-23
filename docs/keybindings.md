# Neovim Keybindings

A comprehensive list of all custom keybindings defined in the Neovim configuration.

## Table of Contents
- [General](#general)
- [LSP (Language Server Protocol)](#lsp-language-server-protocol)
- [VSCode Integration](#vscode-integration)
- [Telescope](#telescope)
- [Neo-tree (File Explorer)](#neo-tree-file-explorer)
- [Toggleterm (Terminal)](#toggleterm-terminal)
- [Treesitter](#treesitter)
- [Nvim-cmp (Completions)](#nvim-cmp-completions)
- [Editing & Utilities](#editing--utilities)

---

## General

| Mode(s) | Key | Command / Function | Description |
|---|---|---|---|
| **Normal** | `<C-S>` | `:w<CR>` | Save the current file. |
| **Normal** | `<M-r>` | `:e<CR>` | Refresh (reload) the current buffer. |
| **Normal** | `<leader>v` | `:set paste<CR>"+p:set nopaste<CR>` | Toggle paste mode and paste from the system clipboard. |
| **Normal** | `<leader>cd` | `change_to_file_directory()` | Change current working directory to the directory of the current file. |
| **Visual** | `<C-C>` | `"+y` | Copy selected text to the system clipboard. |
| **Insert** | `<C-BS>` | `<C-w>` | Delete the word backwards from the cursor. |
| **Normal** | `Q` | `gq` | Format code (replaces default Ex mode). |
| **Normal** | `<C-T>n` / `<M-t>` | `:tabnew<CR>` | Open a new tab. |
| **Normal** | `<C-T>c` / `<M-w>` | `:tabclose<CR>` | Close the current tab. |
| **Normal** | `<M-S-w>` | `:qa<CR>` | Close all tabs and quit Neovim. |
| **Normal** | `<C-T>l` / `<M-q>` | `:tabnext<CR>` | Go to the next tab. |
| **Normal** | `<C-T>h` / `<M-S-q>` | `:tabprevious<CR>` | Go to the previous tab. |
| **Normal** | `<C-T>H` | `:-tabmove<CR>` | Move the current tab to the left. |
| **Normal** | `<C-T>L` | `:+tabmove<CR>` | Move the current tab to the right. |
| **Normal** | `<C-T>W` | `MoveWindowToPreviousTab()` | Move the current window to the previous tab in a split. |
| **Normal** | `<leader>b` | `:BCloseNonVisible<CR>` | Close all buffers that are not visible in any window. |

---

## LSP (Language Server Protocol)

| Mode(s) | Key | Command / Function | Description |
|---|---|---|---|
| **Normal** | `gr` | `<cmd>Telescope lsp_references<CR>` | List all references to the symbol under the cursor. |
| **Normal** | `gd` | `Telescope lsp_definitions` | Jump to the definition(s) of the symbol, reusing the current window. |
| **Normal** | `gf` | `vim.lsp.buf.declaration` | Go to the declaration of the symbol. |
| **Normal** | `gD` | `goto_preview_definition` | Open a floating window preview of the symbol’s definition. |
| **Normal** | `gF` | `goto_preview_declaration` | Open a floating preview of the symbol's declaration. |
| **Normal** | `gI` | `Telescope lsp_implementations` | List and jump to implementations of an interface or method. |
| **Normal** | `gy` | `Telescope lsp_type_definitions` | List and jump to the type definition of a symbol. |
| **Normal** | `gK` | `vim.lsp.buf.signature_help` | Show function signature help in a floating window. |
| **Normal** | `K` | `vim.lsp.buf.hover` | Show documentation or hover info for the symbol under the cursor. |
| **Normal, Visual**| `<leader>ca`| `vim.lsp.buf.code_action` / `Telescope lsp_range_code_actions` | Show available code actions (quick-fixes, refactors). |
| **Normal, Visual**| `<leader>cc`| `vim.lsp.codelens.run` | Execute CodeLens actions (e.g., run tests, main). |
| **Normal, Visual**| `<leader>cC`| `vim.lsp.codelens.refresh` | Refresh and display updated CodeLens annotations. |
| **Normal** | `<leader>cA`| `vim.lsp.buf.code_action({ only = { "source" } })` | Apply "source" code actions like organizing imports or lint fixes. |
| **Normal** | `<leader>rn`| Incremental rename via `inc_rename` | Rename the symbol under the cursor with live updates. |
| **Normal** | `<leader>db`| `<cmd>Telescope diagnostics bufnr=0<CR>` | Show diagnostics for the current buffer. |
| **Normal** | `<leader>dD`| `<cmd>Telescope diagnostics<CR>` | Show all diagnostics across the workspace. |
| **Normal** | `<leader>dd`| `vim.diagnostic.open_float` | Show diagnostics for the current line in a floating window. |
| **Normal** | `<leader>dl`| `vim.diagnostic.setloclist` | Populate the location list with buffer diagnostics. |
| **Normal** | `[d` | `vim.diagnostic.goto_prev` | Jump to the previous diagnostic message. |
| **Normal** | `]d` | `vim.diagnostic.goto_next` | Jump to the next diagnostic message. |
| **Normal** | `<leader>rs`| `:LspRestart<CR>` | Restart the current LSP server. |
| **Normal** | `<leader>n` | `require("nvim-navbuddy").open` | Open NavBuddy symbol outline. |
| **Normal** | `gq` / `<leader>=` | Custom `formatter` | Format the entire buffer using `null-ls` or an LSP formatter. |
| **Visual** | `=` | Custom `formatter` | Format the selected region using `null-ls` or an LSP formatter. |

---

## VSCode Integration

These keymaps are active when using Neovim inside VSCode.

| Mode(s) | Key | VSCode Action | Description |
|---|---|---|---|
| **Normal** | `gr` | `editor.action.referenceSearch.trigger` | Show LSP references in the sidebar. |
| **Normal** | `gI` | `editor.action.goToImplementation` | Go to implementation. |
| **Normal** | `gy` | `editor.action.goToTypeDefinition` | Go to type definition. |
| **Normal** | `gK` | `editor.action.triggerParameterHints` | Show LSP signature help. |
| **Normal, Visual**| `<leader>ca`| `editor.action.quickFix` | See available code actions (Quick Fix). |
| **Normal** | `<leader>cA`| `editor.action.sourceAction` | Trigger a source action. |
| **Normal** | `<leader>rn`| `editor.action.rename` | Smart rename symbol. |
| **Normal** | `<leader>dD`| `workbench.actions.view.problems` | Show workspace diagnostics (Problems panel). |
| **Normal** | `<leader>dd`| `editor.action.showHover` | Show line diagnostics on hover. |
| **Normal** | `[d` | `editor.action.marker.prevInFiles` | Go to the previous diagnostic in files. |
| **Normal** | `]d` | `editor.action.marker.nextInFiles` | Go to the next diagnostic in files. |
| **Normal** | `<leader>q`| `workbench.action.problems.focus` | Focus the Problems panel. |
| **Normal** | `<leader>=`| `editor.action.formatDocument` | Format the entire buffer. |
| **Visual** | `<leader>=`| `editor.action.formatSelection` | Format the selected text. |
| **Normal** | `<leader>e` | `workbench.action.toggleSidebarVisibility` | Toggle the primary sidebar visibility. |

---

## Telescope

| Mode(s) | Key | Command / Function | Description |
|---|---|---|---|
| **Normal** | `<leader>ff` | `<cmd>Telescope find_files<cr>` | Find files in the project. |
| **Normal** | `<leader>fg` | `<cmd>Telescope live_grep<cr>` | Search for a string in the project (live grep). |
| **Normal** | `<leader>fb` | `<cmd>Telescope buffers<cr>` | List and switch between open buffers. |
| **Normal** | `<leader>fh` | `<cmd>Telescope help_tags<cr>` | Search Neovim help tags. |
| **Normal** | `<leader>fr` | `<cmd>Telescope frecency...<cr>` | Find recently and frequently used files. |
| **Normal** | `<leader>fc` | `<cmd>Telescope grep_string<cr>` | Search for the string under the cursor in the project. |
| **Normal** | `<leader>T` | `<cmd>Telescope<cr>` | Open the main Telescope picker menu. |
| **Normal** | `<leader>u` | `<cmd>Telescope undo<cr>` | Browse the undo history tree. |
| **Normal** | `<leader>fp` | `<cmd>Telescope projections<cr>` | Search and switch between saved projects. |
| **Insert (Telescope)**| `<C-j>` | `actions.move_selection_next` | Move to the next result. |
| **Insert (Telescope)**| `<C-k>` | `actions.move_selection_previous` | Move to the previous result. |
| **Insert (Telescope)**| `<C-q>` | `actions.send_selected_to_qflist` | Send selected items to the quickfix list. |
| **Insert (Telescope)**| `<C-h>` | `which_key` | Show mappings for the current Telescope picker. |

---

## Neo-tree (File Explorer)

| Mode(s) | Key | Command / Function | Description |
|---|---|---|---|
| **Normal** | `<leader>fe` | `neo-tree` (left) | Toggle file explorer for project root. |
| **Normal** | `<leader>fE` | `neo-tree` (cwd) | Toggle file explorer for current working directory. |
| **Normal** | `<leader>e` | `neo-tree` (float) | Toggle file explorer in a floating window. |
| **Normal** | `<leader>ge` | `neo-tree` (git_status) | Toggle Git status explorer. |

---

## Toggleterm (Terminal)

| Mode(s) | Key | Command / Function | Description |
|---|---|---|---|
| **Normal** | `<c-\>` | `toggleterm` (float) | Toggle the default floating terminal. |
| **Normal, Terminal** | `<M-1>` | `toggleterm` (horizontal) | Toggle a horizontal terminal. |
| **Normal, Terminal** | `<M-2>` | `toggleterm` (vertical) | Toggle a vertical terminal. |
| **Normal, Terminal** | `<M-3>` | `toggleterm` (float) | Toggle a floating terminal. |
| **Terminal** | `<m-h>` | `<C-\><C-n><C-W>h` | Navigate to the window on the left from the terminal. |
| **Terminal** | `<m-j>` | `<C-\><C-n><C-W>j` | Navigate to the window below from the terminal. |
| **Terminal** | `<m-k>` | `<C-\><C-n><C-W>k` | Navigate to the window above from the terminal. |
| **Terminal** | `<m-l>` | `<C-\><C-n><C-W>l` | Navigate to the window on the right from the terminal. |
| **Terminal** | `<C-]>` | `<C-\><C-n>` | Exit terminal mode to normal mode. |

---

## Treesitter

| Mode(s) | Key | Command / Function | Description |
|---|---|---|---|
| **Normal** | `zv` | `incremental_selection.init_selection` | Start incremental selection. |
| **Normal** | `J` | `incremental_selection.node_incremental` | Incrementally expand selection to the next node. |
| **Normal** | `K` | `incremental_selection.node_decremental` | Decrementally shrink selection. |
| **Normal** | `]f` / `[f` | `textobjects.move.goto_next/previous_start` | Move to the start of the next/previous function. |
| **Normal** | `]c` / `[c` | `textobjects.move.goto_next/previous_start` | Move to the start of the next/previous class. |
| **Normal** | `]F` / `[F` | `textobjects.move.goto_next/previous_end` | Move to the end of the next/previous function. |
| **Normal** | `]C` / `[C` | `textobjects.move.goto_next/previous_end` | Move to the end of the next/previous class. |
| **Operator, Visual** | `af` / `if` | `textobjects.select` | Select around/inside a function. |
| **Operator, Visual** | `ac` / `ic` | `textobjects.select` | Select around/inside a class. |
| **Operator, Visual** | `as` / `is` | `textobjects.select` | Select around/inside the current language scope. |
| **Normal** | `<leader>a` | `textobjects.swap.swap_next` | Swap the current parameter with the next one. |
| **Normal** | `<leader>A` | `textobjects.swap.swap_previous` | Swap the current parameter with the previous one. |
| **Normal** | `<space>m` | `treesj.toggle` | Toggle splitting/joining of code blocks (e.g., lists, objects). |
| **Normal, Visual** | `<leader>sr` | `ssr.open()` | Open structural search and replace window. |

---

## Nvim-cmp (Completions)

These keymaps are primarily for **Insert Mode** when the completion menu is visible.

| Mode(s) | Key | Command / Function | Description |
|---|---|---|---|
| **Insert** | `<Tab>` | `cmp.select_next_item` | Select the next completion item. |
| **Insert** | `<S-Tab>` | `cmp.select_prev_item` | Select the previous completion item. |
| **Insert** | `<CR>` | `cmp.mapping.confirm` | Confirm the selected completion. |
| **Insert** | `<C-e>` | `cmp.mapping.abort` | Close the completion menu. |
| **Insert** | `<C-d>` | `cmp.mapping.scroll_docs(4)` | Scroll documentation down. |
| **Insert** | `<C-u>` | `cmp.mapping.scroll_docs(-4)` | Scroll documentation up. |
| **Insert** | `<C-j>` | `luasnip.expand_or_jump` | Expand snippet or jump to the next placeholder. |
| **Insert** | `<C-k>` | `luasnip.jump(-1)` | Jump to the previous snippet placeholder. |
| **Insert** | `<C-Tab>` | `cmp.complete()` | Manually trigger completion menu. |

---

## Editing & Utilities

| Mode(s) | Key | Command / Function | Description |
|---|---|---|---|
| **Normal** | `<C-a>` | `boole.increment` | Increment number or toggle boolean/keyword. |
| **Normal** | `<C-x>` | `boole.decrement` | Decrement number or toggle boolean/keyword. |
| **Normal** | `<leader>sm` | `<cmd>MaximizerToggle<CR>` | Maximize/minimize the current split window. |
| **Normal** | `<leader>t2` | `:set ts=2 \| retab! \| set ts=4` | Temporarily retab with 2 spaces. |
| **Normal** | `<leader>t4` | `:retab!<CR>` | Retab the file with 4 spaces. |
| **Normal** | `<leader>?` | `which-key.show` | Show available keymaps for the current buffer. |
| **Normal** | `<leader>gz` | `<cmd>LazyGit<cr>` | Open LazyGit in a floating terminal. |
| **Normal** | `<leader>cr` | `:Rooter<CR>` | Change CWD to the project root. |
| **Normal, Visual** | `<C-_>` | `gcc` / `gc` | Toggle comments. (`<C-/>` is often read as `<C-_>`). |
| **Normal, Visual**| `cx` / `cxx` | `vim-exchange` | Exchange text regions. |
| **Normal** | `gl` / `gL` | `vim-lion` | Align text by a delimiter. |
| **Normal** | `<leader>q` | `:MacroSave<CR>` | Save the last recorded macro with a name. |
| **Normal** | `<leader>fq` | `:MacroSelect<CR>` | Select a saved macro to play. |
| **Normal** | `<leader>ll` | `<cmd>Leet<cr>` | Open Leetcode problem list. |
| **Normal** | `<leader>lt` | `<cmd>Leet test<cr>` | Test Leetcode solution. |
| **Normal** | `<leader>ls` | `<cmd>Leet submit<cr>` | Submit Leetcode solution. |
| **All** | `<C-u>`, `<C-d>`, `<C-b>`, `<C-f>`, `zt`, `zz`, `zb` | `neoscroll` | Smooth scrolling animations. |
