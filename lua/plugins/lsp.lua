local mlsp_server_names =
{ "bashls", "biome", "clangd", "autotools_ls", "marksman", "lua_ls", "pyright", "vimls", "jsonls" }
-- local nvim_jdtls_servers = {"jdtls", "java-test", "java-debug-adapter",}
--
local others = { "rust_analyzer" }

local null_ls_servers = {
	"codespell",
	"proselint",

	"shellcheck",
	"beautysh",

	"pylint",
	"isort",
	"black",

	"selene",
	"stylua",

	"clang-format",
	"cppcheck", -- Not avalable in mason

	"prettier",
}

local mason_nonlsp_pkgs = vim.tbl_extend("keep", others, null_ls_servers)
local mason_all_pkgs = vim.tbl_extend("keep", mlsp_server_names, mason_nonlsp_pkgs)
local mason_ensure_installed = mlsp_server_names

-- Custom config opts for each server
local lsp_opts = {}

-- Add empty opts for each server already not having any
for _, pkg in ipairs(mlsp_server_names) do
	if not lsp_opts[pkg] then
		lsp_opts[pkg] = {}
	end
end

-- LSP requires to be loaded before buffer to get attached, but this prevents it to be lazy loaded.
-- As a workaround, this function allows LSP to be lazy loaded, and when it loads, it attaches to already loaded buffers.
-- https://www.reddit.com/r/neovim/comments/15s3fxk/comment/jwdgdcp/
local attach_lsp_to_existing_buffers = vim.schedule_wrap(function()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		local valid = vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buflisted")
		if valid and vim.bo[bufnr].buftype == "" then
			local augroup_lspconfig = vim.api.nvim_create_augroup("lspconfig", { clear = false })
			vim.api.nvim_exec_autocmds("FileType", { group = augroup_lspconfig, buffer = bufnr })
		end
	end
end)

local function async_lsp_format(input)
	local name
	local async = input.bang
	if input.args ~= "" then
		name = input.args
	end
	vim.lsp.buf.format({ async = async, name = name })
end

return {
	-- lsp config
	{
		"neovim/nvim-lspconfig",
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		-- event = {"BufReadPre", "BufNewFile"},
		event = "VeryLazy",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason-lspconfig.nvim",
			"williamboman/mason.nvim",
			{ "folke/trouble.nvim",   config = true, dependencies = "nvim-lua/plenary.nvim" },

			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				config = function()
					require("nvim-navbuddy").setup({ lsp = { auto_attach = true } })
					vim.keymap.set(
						"n",
						"<leader>n",
						require("nvim-navbuddy").open,
						{ noremap = true, silent = true, desc = "Open NavBuddy" }
					)
				end,
			},

			{
				"nvimtools/none-ls.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"nvimtools/none-ls-extras.nvim",
					"gbprod/none-ls-shellcheck.nvim",
				},
				opt = false,
			},
			{
				"smjonas/inc-rename.nvim",
				config = function()
					require("inc_rename").setup({})
				end,
			},
			{ -- For peeking in floating window
				"rmagatti/goto-preview",
				config = function()
					require("goto-preview").setup({})
				end,
			},
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						"lazy.nvim",
						{ path = "luvit-meta/library", words = { "vim%.uv" } },
					},
				},
			},
			{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typing
		},

		config = function()
			local lspconfig = require("lspconfig")
			local navic = require("nvim-navic")
			local navbuddy = require("nvim-navbuddy")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local preview = require("goto-preview")

			lspconfig.util.on_setup = lspconfig.util.add_hook_after(
				lspconfig.util.on_setup,
				function(config, user_config)
					config.capabilities = vim.tbl_deep_extend(
						"force",
						config.capabilities,
						cmp_nvim_lsp.default_capabilities(),
						vim.tbl_get(user_config, "capabilities") or {}
					)
				end
			)

			-- local keymap = vim.keymap -- for conciseness
			local opts = { noremap = true, silent = true }

			local lsp_on_attach = function(event)
				local bufnr = event.buf

				-- vim.api.nvim_buf_create_user_command(
				-- 	bufnr,
				-- 	"LspFormat",
				-- 	lsp_format,
				-- 	{
				-- 		bang = true,
				-- 		nargs = "?",
				-- 		desc = "Format buffer with language server"
				-- 	}
				-- )

				opts.buffer = bufnr

				-- set keybinds
				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd", function()
					require("telescope.builtin").lsp_definitions({ reuse_win = true })
				end, opts) -- show lsp definitions

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gf", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Peek LSP definitions"
				vim.keymap.set("n", "gD", preview.goto_preview_definition, opts) -- show lsp definitions

				opts.desc = "Peek declaration"
				vim.keymap.set("n", "gF", preview.goto_preview_declaration, opts) -- go to declaration

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gI", function()
					require("telescope.builtin").lsp_implementations({ reuse_win = true })
				end, opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gy", function()
					require("telescope.builtin").lsp_type_definitions({ reuse_win = true })
				end, opts) -- show lsp type definitions

				opts.desc = "Show LSP signature help"
				vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)

				opts.desc = "See available code actions"
				vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, opts)      -- see available code actions, in visual mode will apply to selection
				vim.keymap.set({ "v" }, "<leader>ca", ":'<,'>Telescope lsp_range_code_actions<CR>", opts) -- see available code actions, in visual mode will apply to selection
				-- vim.keymap.set({ "v" }, "<leader>ca", vim.lsp.buf.range_code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Run Codelens"
				vim.keymap.set({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, opts)

				opts.desc = "Refresh & Display Codelens"
				vim.keymap.set({ "n", "v" }, "<leader>cC", vim.lsp.codelens.refresh, opts)

				opts.desc = "Source action"
				vim.keymap.set("n", "<leader>cA", function()
					vim.lsp.buf.code_action({
						context = { only = { "source" }, diagnostics = {} },
					})
				end, opts)

				opts.desc = "Smart rename"
				-- keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
				vim.keymap.set("n", "<leader>rn", function()
					local inc_rename = require("inc_rename")
					return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
				end, vim.tbl_deep_extend("keep", opts, { expr = true })) -- smart rename

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>db", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show	diagnostics for file

				opts.desc = "Show all buffers diagnostics"
				vim.keymap.set("n", "<leader>dD", "<cmd>Telescope diagnostics<CR>", opts) -- show	diagnostics for file
				-- vim.keymap.set("n", "<leader>dD", function() require("trouble").toggle("workspace_diagnostics") end)

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>dd", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Set location list to diagnostics"
				vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist, opts)

				opts.desc = "Go to previous diagnostic"
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

				-- The workspace functions aren"t really useful.
				--[[

				opts.desc = "Add workspace folder"
				keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)

				opts.desc = "Remove workspace folder"
				keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)

				local list_workspace_folders = function()
					local folders = vim.lsp.buf.list_workspace_folders()
					require("telescope.pickers").new({}, {
						prompt_title = "Workspace Folders",
						finder = require("telescope.finders").new_table({
							results = folders,
							entry_maker = function(entry)
								return {
									value = entry,
									display = entry,
									ordinal = entry,
								}
							end,
						}),
						sorter = require("telescope.config").values.generic_sorter({})
					}):find()
				end

				opts.desc = "List workspace folders"
				keymap.set("n", "<leader>wl", list_workspace_folders, opts)

				]]
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = lsp_on_attach,
			})

			vim.diagnostic.config({
				float = { border = "rounded" },
			})

			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

			-- local command = vim.api.nvim_create_user_command
			--
			-- command("LspWorkspaceAdd", function()
			-- 	vim.lsp.buf.add_workspace_folder()
			-- end, { desc = "Add folder to workspace" })
			--
			-- command("LspWorkspaceList", function()
			-- 	vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			-- end, { desc = "List workspace folders" })
			--
			-- command("LspWorkspaceRemove", function()
			-- 	vim.lsp.buf.remove_workspace_folder()
			-- end, { desc = "Remove folder from workspace" })

			-- local navic_on_attach = function(client, bufnr)
			-- 	if client.server_capabilities.documentSymbolProvider then
			-- 		navic.attach(client, bufnr)
			-- 	end
			-- end

			local null_ls_formatting = function(bufnr)
				vim.lsp.buf.format({
					filter = function(client)
						-- apply whatever logic you want (in this example, we'll only use null-ls)
						return client.name == "null-ls"
					end,
					bufnr = bufnr,
				})
			end

			local function is_null_ls_formatting_enabled(bufnr)
				local file_type = vim.api.nvim_buf_get_option(bufnr, "filetype")
				local generators = require("null-ls.generators").get_available(
					file_type,
					require("null-ls.methods").internal.FORMATTING
				)
				return #generators > 0
			end

			local function fix_formatexpr(client, bufnr)
				if client.name == "null-ls" and is_null_ls_formatting_enabled(bufnr) or client.name ~= "null-ls" then
					vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
					-- vim.keymap.set("n", "<leader>gq", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", keymap_opts)
					vim.keymap.set("n", "gq", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", keymap_opts)
				else
					vim.bo[bufnr].formatexpr = nil
				end
			end

			local function formatting_on_attach(client, bufnr)
				-- fallback to default lsp formatting
				local formatter = function()
					vim.lsp.buf.format({ async = true })
				end

				-- if client.name == "null-ls" and is_null_ls_formatting_enabled(bufnr) then
				if is_null_ls_formatting_enabled(bufnr) then
					formatter = null_ls_formatting
				end

				local keymap_opts = { noremap = true, silent = true }
				keymap_opts.desc = "Format buffer"
				vim.keymap.set("n", "<leader>=", formatter, keymap_opts)
				keymap_opts.desc = "Format selection"
				vim.keymap.set("v", "=", formatter, keymap_opts)
			end

			local function format_on_save_callback(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							null_ls_formatting(bufnr)
						end,
					})
				end
			end

			-- Final on_attach function
			local function common_on_attach(client, bufnr)
				if client.server_capabilities.documentFormattingProvider then
					navic.attach(client, bufnr)
				end
				navbuddy.attach(client, bufnr)
				formatting_on_attach(client, bufnr)
				fix_formatexpr(client, bufnr)
			end

			-- Add the on_attach function to each server config
			for _, opts2 in pairs(lsp_opts) do
				if type(opts2) == "table" then
					opts2.on_attach = common_on_attach
				end
			end

			-- Custom lsp opts
			lsp_opts["clangd"] = {
				on_attach = common_on_attach,
				inlay_hints = { enabled = true },
				capabilities = cmp_nvim_lsp.default_capabilities(),
				cmd = {
					"clangd",
					"--offset-encoding=utf-16",
				},
			}

			-- disabled since it is handled by rustaceanvim
			-- lsp_opts["rust_analyzer"] = {
			-- 	on_attach = on_attach,
			-- 	settings = {
			-- 		['rust-analyzer'] = {
			-- 			check = {
			-- 				command = "clippy",
			-- 			},
			-- 			diagnostics = {
			-- 				enable = true,
			-- 			}
			-- 		}
			-- 	}
			-- }

			local default_setup = function(server)
				lspconfig[server].setup(lsp_opts[server])
				-- lspconfig[server].setup()
			end

			-- Call setup for each server
			for _, server in pairs(mlsp_server_names) do
				default_setup(server)
			end


			require("mason-lspconfig").setup({
				ensure_installed = mason_ensure_installed,
				-- Adding as handler making it call lspconfig[server].setup() would work but it gets run for every mason installed package.
				-- Some packages we may not need to call setup intentionally (eg jdtls), therefore have commented out the below lines.
				-- handlers = {
				--	default_setup,
				-- },
			})

			attach_lsp_to_existing_buffers()
		end,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		lazy = true,
		dependencies = "mason.nvim",
		-- config = function() end,
	},

	{
		"williamboman/mason.nvim",
		lazy = true,
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		config = true,
	},

	{
		"jay-babu/mason-null-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			require("mason-null-ls").setup({
				ensure_installed = mason_nonlsp_pkgs,
				automatic_installation = true,
			})

			null_ls.setup({
				sources = {
					-- General
					-- null_ls.builtins.completion.spell, -- spell check
					null_ls.builtins.code_actions.proselint, -- An English prose linter, default md and tex.
					null_ls.builtins.code_actions.refactoring, -- Code refactoring, for lua, python, go, js, ts

					-- bash
					null_ls.builtins.formatting.shellharden,
					null_ls.builtins.formatting.shfmt,

					-- Python
					-- null_ls.builtins.diagnostics.pylint.with({
					-- 	diagnostics_postprocess = function(diagnostic)
					-- 		diagnostic.code = diagnostic.message_id
					-- 	end,
					-- }), -- python diagnostics
					null_ls.builtins.formatting.isort, -- orders imports
					null_ls.builtins.formatting.black, -- python formatter

					-- Lua
					-- null_ls.builtins.diagnostics.selene, -- lua diagnostics
					null_ls.builtins.formatting.stylua, -- lua formatter

					-- C/C++
					null_ls.builtins.formatting.clang_format, -- C/C++ formatter
					null_ls.builtins.diagnostics.cppcheck, -- More refined C/C++ diagnostics

					-- WebDev
					null_ls.builtins.formatting.prettierd, -- js, ts, css, html formatter
					-- null_ls.builtins.formatting.biome,
				},
			})
		end,
	},
	-- Java LSP and other features
	-- {
	--	"mfussenegger/nvim-jdtls",
	--	filetypes = { "java" },
	--	config = false,
	-- },

	-- {
	-- 	"AckslD/swenv.nvim",
	-- 	-- event = "Verylazy",
	-- 	lazy = true,
	-- 	cmd = "PickPythonEnv",
	-- 	filetypes = { "python" },
	-- 	depedencies = "plenary.nvim",
	-- 	config = function()
	-- 		require("swenv").setup()
	-- 		vim.api.nvim_create_user_command("PickPythonEnv", function()
	-- 			require("swenv.api").pick_venv()
	-- 		end, { desc = "Pick python virtual env" })
	-- 	end,
	-- },
	{
		"linux-cultist/venv-selector.nvim",
		branch = "regexp",
		dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
		opts = {
			-- Your options go here
			-- name = { "venv", "env", ".venv", ".env" },
			auto_refresh = true,
		},
		event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
	},
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("refactoring").setup()
		end,
	},
}
