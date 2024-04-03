
--The below functionality has been replaced with farmergreg/vim-lastplace plugin
vim.cmd([[
	" Put these in an autocmd group, so that you can revert them with:
	" ":augroup vimStartup | exe 'au!' | augroup END"
	augroup vimStartup
		au!
		" When editing a file, always jump to the last known cursor position.
		" Don't do it when the position is invalid, when inside an event handler
		" (happens when dropping a file on gvim) and for a commit message (it's
		" likely a different one than last time).
		autocmd BufReadPost *
			\ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
			\ |		exe "normal! g`\""
			\ | endif

	augroup END
]])

vim.cmd([[
	" Quite a few people accidentally type "q:" instead of ":q" and get confused
	" by the command line window.  Give a hint about how to get out.
	" If you don't like this you can put this in your vimrc:
	" ":augroup vimHints | exe 'au!' | augroup END"
	augroup vimHints
		au!
		autocmd CmdwinEnter *
		\ echohl Todo | 
		\ echo 'You discovered the command-line window! You can close it with ":q".' |
		\ echohl None
	augroup END

]])

-- Convenient command to see the difference between the current buffer and the
-- file it was loaded from, thus the changes you made.
-- Only define it when not defined already.
-- Revert with: ":delcommand DiffOrig".
vim.cmd([[
	if !exists(":DiffOrig")
		command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
				\ | wincmd p | diffthis
	endif
]])

-- Put these in an autocmd group, so that we can delete them easily.
vim.cmd([[
	augroup vimrcEx
		au!

		" For all text files set 'textwidth' to 78 characters.
		autocmd FileType text setlocal textwidth=78
	augroup END
]])

-- To turn on line wrap for text files only
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("WrapText", { clear = true }),
	pattern = { "text" },
	callback = function()
		vim.o.wrap = true
	end,
})

-- To turn on conceal for markdown
vim.api.nvim_create_autocmd("FileType", {
	-- group = vim.api.nvim_create_augroup("Conceal", { clear = true }),
	pattern = { "markdown" },
	callback = function()
		vim.o.conceallevel = 2
		vim.o.wrap = false
		vim.o.concealcursor = ""
	end,
})


-- highlights yanked text
vim.cmd([[
	augroup highlight_yank
		autocmd!
		autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
	augroup END
]])











-- vim.api.nvim_create_autocmd("FileType", {
--	pattern = "java",
--	callback = function()
--		local keymap = vim.keymap
--		local cmp_nvim_lsp = require "cmp_nvim_lsp"
--
--		local function lsp_keymaps(bufnr)
--			local opts = { buffer = bufnr, silent = true }
--
--			-- set keybinds
--			opts.desc = "Show LSP references"
--			keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references
--
--			opts.desc = "Go to declaration"
--			keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
--
--			opts.desc = "Show LSP definitions"
--			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions
--
--			opts.desc = "Show LSP implementations"
--			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations
--
--			-- opts.desc = "Show LSP type definitions"
--			-- keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions
--
--			opts.desc = "See available code actions"
--			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
--
--			opts.desc = "Smart rename"
--			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
--
--			opts.desc = "Show buffer diagnostics"
--			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show	diagnostics for file
--
--			opts.desc = "Show line diagnostics"
--			keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line
--
--			opts.desc = "Go to previous diagnostic"
--			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer
--
--			opts.desc = "Go to next diagnostic"
--			keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer
--
--			opts.desc = "Show documentation for what is under cursor"
--			keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor
--
--			opts.desc = "Restart LSP"
--			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
--
--		end
--
--		-- Highlight symbol under cursor
--		local function lsp_highlight(client, bufnr)
--			if client.supports_method "textDocument/documentHighlight" then
--			vim.api.nvim_create_augroup("lsp_document_highlight", {
--				clear = false,
--			})
--			vim.api.nvim_clear_autocmds {
--				buffer = bufnr,
--				group = "lsp_document_highlight",
--			}
--			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--				group = "lsp_document_highlight",
--				buffer = bufnr,
--				callback = vim.lsp.buf.document_highlight,
--			})
--			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--				group = "lsp_document_highlight",
--				buffer = bufnr,
--				callback = vim.lsp.buf.clear_references,
--			})
--			end
--		end
--
--		local function jdlts_on_attach (client, bufnr)
--			lsp_keymaps(bufnr)
--			lsp_highlight(client, bufnr)
--		end
--
--		local status_ok, jdtls = pcall(require, "jdtls")
--		if not status_ok then
--			return
--		end
--
--		local bufnr = vim.api.nvim_get_current_buf()
--
--		local java_debug_path = vim.fn.stdpath "data" .. "/mason/packages/java-debug-adapter/"
--		local java_test_path = vim.fn.stdpath "data" .. "/mason/packages/java-test/"
--		local jdtls_path = vim.fn.stdpath "data" .. "/mason/packages/jdtls/"
--
--		local bundles = {
--			vim.fn.glob(java_debug_path .. "extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
--		}
--		vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "extension/server/*.jar", 1), "\n"))
--
--		-- NOTE: Decrease the amount of files to improve speed(Experimental).
--		-- INFO: It's annoying to edit the version again and again.
--		local equinox_path = vim.split(vim.fn.glob(vim.fn.stdpath "data" .. "/mason/packages/jdtls/plugins/*jar"), "\n")
--		local equinox_launcher = ""
--
--		for _, file in pairs(equinox_path) do
--			if file:match "launcher_" then
--				equinox_launcher = file
--				break
--			end
--		end
--
--		WORKSPACE_PATH = vim.fn.stdpath "data" .. "/workspace/"
--		if vim.fn.has "mac" == 1 then
--			OS_NAME = "mac"
--		elseif vim.fn.has "unix" == 1 then
--			OS_NAME = "linux"
--		elseif vim.fn.has "win32" == 1 then
--			OS_NAME = "win"
--		else
--			vim.notify("Unsupported OS", vim.log.levels.WARN, { title = "Jdtls" })
--		end
--
--		local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
--
--		local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
--
--		local workspace_dir = WORKSPACE_PATH .. project_name
--
--		local config = {
--			cmd = {
--				-- 💀
--				"java", -- or '/path/to/java17_or_newer/bin/java'
--				-- depends on if `java` is in your $PATH env variable and if it points to the right version.
--
--				"-Declipse.application=org.eclipse.jdt.ls.core.id1",
--				"-Dosgi.bundles.defaultStartLevel=4",
--				"-Declipse.product=org.eclipse.jdt.ls.core.product",
--				"-Dlog.protocol=true",
--				"-Dlog.level=ALL",
--				"-javaagent:" .. jdtls_path .. "/lombok.jar",
--				"-Xms1g",
--				"--add-modules=ALL-SYSTEM",
--				"--add-opens",
--				"java.base/java.util=ALL-UNNAMED",
--				"--add-opens",
--				"java.base/java.lang=ALL-UNNAMED",
--				-- 💀
--				"-jar",
--				equinox_launcher,
--				-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^																			 ^^^^^^^^^^^^^^
--				-- Must point to the																										 Change this to
--				-- eclipse.jdt.ls installation																					 the actual version
--				-- 💀
--				"-configuration",
--				jdtls_path .. "config_" .. OS_NAME,
--				-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^				^^^^^^
--				-- Must point to the											Change to one of `linux`, `win` or `mac`
--				-- eclipse.jdt.ls installation						Depending on your system.
--
--				"-data",
--				workspace_dir,
--			},
--			on_attach = jdlts_on_attach,
--			capabilities = cmp_nvim_lsp.default_capabilities(),
--			-- 💀
--			-- This is the default if not provided, you can remove it. Or adjust as needed.
--			-- One dedicated LSP server & client will be started per unique root_dir
--			root_dir = require("jdtls.setup").find_root(root_markers),
--			init_options = {
--				bundles = bundles,
--			},
--			settings = {
--				eclipse = {
--					downloadSources = true,
--				},
--				maven = {
--					downloadSources = true,
--				},
--				implementationsCodeLens = {
--					enabled = true,
--				},
--				referencesCodeLens = {
--					enabled = true,
--				},
--				references = {
--					includeDecompiledSources = true,
--				},
--
--				signatureHelp = { enabled = true },
--				extendedClientCapabilities = require("jdtls").extendedClientCapabilities,
--				sources = {
--					organizeImports = {
--						starThreshold = 9999,
--						staticStarThreshold = 9999,
--					},
--				},
--			},
--			flags = {
--				allow_incremental_sync = true,
--			},
--		}
--
--		local keymap = vim.keymap.set
--
--		keymap("n", "A-o", ":lua require'jdtls'.organize_imports()<cr>", { silent = true, buffer = bufnr })
--		keymap("n", "crv", ":lua require'jdtls'.extract_variable()<cr>", { silent = true, buffer = bufnr })
--		keymap("v", "crv", "<Esc>:lua require'jdtls'.extract_variable(true)<cr>", { silent = true, buffer = bufnr })
--		keymap("n", "crc", ":lua require'jdtls'.extract_constant()<cr>", { silent = true, buffer = bufnr })
--		keymap("v", "crc", "<Esc>:lua require'jdtls'.extract_constant(true)<cr>", { silent = true, buffer = bufnr })
--		keymap("v", "crm", "<Esc>:lua require'jdtls'.extract_method(true)<cr>", { silent = true, buffer = bufnr })
--
--		vim.cmd [[
--		command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)
--		command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_set_runtime JdtSetRuntime lua require('jdtls').set_runtime(<f-args>)
--		command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()
--		command! -buffer JdtJol lua require('jdtls').jol()
--		command! -buffer JdtBytecode lua require('jdtls').javap()
--		command! -buffer JdtJshell lua require('jdtls').jshell()
--		command! -buffer JavaTestCurrentClass lua require('jdtls').test_class()
--		command! -buffer JavaTestNearestMethod lua require('jdtls').test_nearest_method()
--		]]
--
--		-- This starts a new client & server,
--		-- or attaches to an existing client & server depending on the `root_dir`.
--		jdtls.start_or_attach(config)
--	end,
-- })
