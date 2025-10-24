# Error logs observed

## When lazy runs at startup if a new plugin is installed
```
Failed to run `config` for nvim-lspconfig

...azy/nvim-scrollbar/lua/scrollbar/handlers/diagnostic.lua:28: Invalid buffer id: 2

# stacktrace:
  - /snap/nvim/4424/usr/share/nvim/runtime/lua/vim/diagnostic.lua:2146 _in_ **show**
  - /snap/nvim/4424/usr/share/nvim/runtime/lua/vim/diagnostic.lua:1148 _in_ **config**
  - ~/.config/nvim/lua/plugins/lsp.lua:260 _in_ **config**
```

## CPP project treesitter errors
### Every moment in `C:\Users\brian\Code\_old\COL331\COL331_Project`
- Maybe something to do with cpp highlighting? still pops up in telescope window as well
```
Error in decoration provider "line" (ns=nvim.treesitter.highlighter):
Error executing lua: ...nvim-treesitter/lua/nvim-treesitter/query_predicates.lua:80: attempt to call method 'parent' (a nil value)
stack traceback:
	...nvim-treesitter/lua/nvim-treesitter/query_predicates.lua:80: in function 'handler'
	...4424/usr/share/nvim/runtime/lua/vim/treesitter/query.lua:884: in function '_match_predicates'
	...4424/usr/share/nvim/runtime/lua/vim/treesitter/query.lua:1013: in function 'iter'
	...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:385: in function 'fn'
	...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:239: in function 'for_each_highlight_state'
	...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:358: in function 'on_line_impl'
	...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:457: in function <...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:451>
	[builtin#36]: at 0x5628a8086100
	...4/usr/share/nvim/runtime/lua/vim/lsp/semantic_tokens.lua:307: in function
```
- Interesting example:
```cpp
#include <iostream>

int func1() { return 1; };

int main() {
  std::cout << "Hello, World!" << std::endl;
  // std::cout << func1() << std::endl;
  // int a = func1();
  return 0;
}
```
In the above example, there's no issue. But the moment I uncomment any of the lines which calls func1, the error shows up constantly

## in rust reactor workspace, opening telescope with kanagawa theme active
```
1 line less; before #1  20 seconds ago
kanagawa
Error executing vim.schedule lua callback: .../nvim/4424/usr/share/nvim/runtime/lua/vim/treesitter.lua:111: Parser could not be created for buffer 90 and language "tsx"
stack traceback:
	[C]: in function 'error'
	.../nvim/4424/usr/share/nvim/runtime/lua/vim/treesitter.lua:111: in function 'get_parser'
	...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:141: in function 'ts_highlighter'
	...m/lazy/telescope.nvim/lua/telescope/previewers/utils.lua:119: in function 'highlighter'
	...scope.nvim/lua/telescope/previewers/buffer_previewer.lua:247: in function ''
	vim/_editor.lua: in function <vim/_editor.lua:0>
```
## Running LspStop
```
  Info  12:06:18 notify.info Invalid server name 'null-ls'
```

## Showed up while scrolling telescope files in MTP rust project
```
Error in decoration provider "line" (ns=nvim.treesitter.highlighter):
Error executing lua: ...nvim-treesitter/lua/nvim-treesitter/query_predicates.lua:80: attempt to call method 'parent' (a nil value)
stack traceback:
	...nvim-treesitter/lua/nvim-treesitter/query_predicates.lua:80: in function 'handler'
	...4424/usr/share/nvim/runtime/lua/vim/treesitter/query.lua:884: in function '_match_predicates'
	...4424/usr/share/nvim/runtime/lua/vim/treesitter/query.lua:1013: in function 'iter'
	...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:385: in function 'fn'
	...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:239: in function 'for_each_highlight_state'
	...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:358: in function 'on_line_impl'
	...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:457: in function <...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:451>
Error in decoration provider "line" (ns=nvim.treesitter.highlighter):
Error executing lua: ...nvim-treesitter/lua/nvim-treesitter/query_predicates.lua:80: attempt to call method 'parent' (a nil value)
stack traceback:
	...nvim-treesitter/lua/nvim-treesitter/query_predicates.lua:80: in function 'handler'
	...4424/usr/share/nvim/runtime/lua/vim/treesitter/query.lua:884: in function '_match_predicates'
	...4424/usr/share/nvim/runtime/lua/vim/treesitter/query.lua:1013: in function 'iter'
	...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:385: in function 'fn'
	...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:239: in function 'for_each_highlight_state'
	...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:358: in function 'on_line_impl'
	...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:457: in function <...sr/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:451>
```

## LSP warnings observed, when doing gd
```
  Warn  13:37:29 notify.warn position_encoding param is required in vim.lsp.util.make_position_params. Defaulting to position encoding of the first client.
  Warn  13:37:29 notify.warn warning: multiple different client offset_encodings detected for buffer, vim.lsp.util._get_offset_encoding() uses the offset_encoding from the first client
vim.lsp.util.jump_to_location is deprecated. Run ":checkhealth vim.deprecated" for more information
```

## LSP warnings observed, when doing gr in lua
```
  Warn  18:52:28 notify.warn position_encoding param is required in vim.lsp.util.make_position_params. Defaulting to position encoding of the first client.
```
