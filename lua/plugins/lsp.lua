local mlsp_server_names = { "bashls", "biome", "clangd", "autotools_ls",
	"marksman", "lua_ls", "pyright", "vimls", }
-- local nvim_jdtls_servers = {"jdtls", "java-test", "java-debug-adapter",}
local linters = { "selene", }
local formatters = { "stylua", "black", }
local others = {}

local mason_nonlsp_pkgs = vim.tbl_extend("keep", linters, formatters, others)
local mason_all_pkgs = vim.tbl_extend("keep", mlsp_server_names, mason_nonlsp_pkgs)

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
		local valid = vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_get_option(bufnr, 'buflisted')
		if valid and vim.bo[bufnr].buftype == "" then
			local augroup_lspconfig = vim.api.nvim_create_augroup('lspconfig', { clear = false })
			vim.api.nvim_exec_autocmds("FileType", { group = augroup_lspconfig, buffer = bufnr })
		end
	end
end)

local function lsp_format(input)
	local name
	local async = input.bang

	if input.args ~= '' then
		name = input.args
	end

	vim.lsp.buf.format({ async = async, name = name })
end


return {
	-- lsp config
	{
		'neovim/nvim-lspconfig',
		cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
		-- event = {'BufReadPre', 'BufNewFile'},
		event = { 'VeryLazy' },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason-lspconfig.nvim",
			"williamboman/mason.nvim",
			{ "folke/neodev.nvim", config = true, },
			"SmiteshP/nvim-navic",
			{
				"smjonas/inc-rename.nvim",
				config = function()
					require("inc_rename").setup({ input_buffer_type = "dressing" })
				end,
			},
			{ -- For peeking in floating window
				'rmagatti/goto-preview',
				config = function()
					require('goto-preview').setup {}
				end
			}
		},

		config = function()
			require("neodev").setup()
			local lspconfig = require('lspconfig')
			local navic = require('nvim-navic')
			local cmp_nvim_lsp = require('cmp_nvim_lsp')
			local preview = require('goto-preview')

			lspconfig.util.on_setup = lspconfig.util.add_hook_after(
				lspconfig.util.on_setup,
				function(config, user_config)
					config.capabilities = vim.tbl_deep_extend(
						'force',
						config.capabilities,
						cmp_nvim_lsp.default_capabilities(),
						vim.tbl_get(user_config, 'capabilities') or {}
					)
				end
			)

			-- local keymap = vim.keymap -- for conciseness
			local opts = { noremap = true, silent = true }

			local lsp_on_attach = function(event)
				local bufnr = event.buf

				vim.api.nvim_buf_create_user_command(
					bufnr,
					'LspFormat',
					lsp_format,
					{
						bang = true,
						nargs = '?',
						desc = 'Format buffer with language server'
					}
				)

				opts.buffer = bufnr


				-- set keybinds
				opts.desc = "Show LSP references"
				vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

				opts.desc = "Show LSP definitions"
				vim.keymap.set("n", "gd",
					function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,
					opts) -- show lsp definitions

				opts.desc = "Go to declaration"
				vim.keymap.set("n", "gf", vim.lsp.buf.declaration, opts) -- go to declaration

				opts.desc = "Peek LSP definitions"
				vim.keymap.set("n", "gD", preview.goto_preview_definition, opts) -- show lsp definitions

				opts.desc = "Peek declaration"
				vim.keymap.set("n", "gF", preview.goto_preview_declaration, opts) -- go to declaration

				opts.desc = "Show LSP implementations"
				vim.keymap.set("n", "gI",
					function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, opts) -- show lsp implementations

				opts.desc = "Show LSP type definitions"
				vim.keymap.set("n", "gy",
					function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, opts) -- show lsp type definitions

				opts.desc = "Show LSP signature help"
				vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, opts)

				opts.desc = "See available code actions"
				vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

				opts.desc = "Run Codelens"
				vim.keymap.set({ "n", "v" }, "<leader>cc", vim.lsp.codelens.run, opts)

				opts.desc = "Refresh & Display Codelens"
				vim.keymap.set({ "n", "v" }, "<leader>cC", vim.lsp.codelens.refresh, opts)

				opts.desc = "Source action"
				vim.keymap.set("n", "<leader>cA",
					function()
						vim.lsp.buf.code_action({
							context = {
								only = {
									"source",
								},
								diagnostics = {},
							},
						})
					end,
					opts
				)

				opts.desc = "Smart rename"
				-- keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
				vim.keymap.set("n", "<leader>rn",
					function()
						local inc_rename = require("inc_rename")
						return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
					end,
					vim.tbl_deep_extend("keep", opts, { expr = true })
				) -- smart rename

				opts.desc = "Show buffer diagnostics"
				vim.keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show	diagnostics for file

				opts.desc = "Show line diagnostics"
				vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

				opts.desc = "Go to previous diagnostic"
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

				opts.desc = "Set location list to diagnostics"
				vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

				local formatter = function() vim.lsp.buf.format({ async = true }) end

				opts.desc = "Format buffer"
				vim.keymap.set("n", "<leader>=", formatter, opts)

				opts.desc = "Format selection"
				vim.keymap.set("v", "=", formatter, opts)


				-- The workspace functions aren't really useful.
				--[[

				opts.desc = "Add workspace folder"
				keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)

				opts.desc = "Remove workspace folder"
				keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)

				local list_workspace_folders = function()
					local folders = vim.lsp.buf.list_workspace_folders()
					require('telescope.pickers').new({}, {
						prompt_title = 'Workspace Folders',
						finder = require('telescope.finders').new_table({
							results = folders,
							entry_maker = function(entry)
								return {
									value = entry,
									display = entry,
									ordinal = entry,
								}
							end,
						}),
						sorter = require('telescope.config').values.generic_sorter({})
					}):find()
				end

				opts.desc = "List workspace folders"
				keymap.set("n", "<leader>wl", list_workspace_folders, opts)

				]]
			end

			vim.api.nvim_create_autocmd('LspAttach', {
				desc = 'LSP actions',
				callback = lsp_on_attach,
			})

			vim.diagnostic.config({
				float = { border = 'rounded' },
			})

			vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
				vim.lsp.handlers.hover,
				{ border = 'rounded' }
			)

			vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
				vim.lsp.handlers.signature_help,
				{ border = 'rounded' }
			)

			local command = vim.api.nvim_create_user_command

			command('LspWorkspaceAdd', function()
				vim.lsp.buf.add_workspace_folder()
			end, { desc = 'Add folder to workspace' })

			command('LspWorkspaceList', function()
				vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, { desc = 'List workspace folders' })

			command('LspWorkspaceRemove', function()
				vim.lsp.buf.remove_workspace_folder()
			end, { desc = 'Remove folder from workspace' })

			local navic_on_attach = function(client, bufnr)
				if client.server_capabilities.documentSymbolProvider then
					navic.attach(client, bufnr)
				end
			end

			-- Add the on_attach function to each server config
			-- for _, opts in pairs(lsp_opts) do
			--	if type(opts) == "table" then
			--		opts.on_attach = navic_on_attach
			--	end
			-- end


			-- Custom lsp opts
			lsp_opts["clangd"] = {
				on_attach = function(client, bufnr)
					navic.attach(client, bufnr)
				end,
				inlay_hints = { enabled = true },
				capabilities = cmp_nvim_lsp.default_capabilities(),
				cmd = {
					"clangd",
					"--offset-encoding=utf-16",
				},
			}

			local default_setup = function(server)
				lspconfig[server].setup(lsp_opts[server])
				-- lspconfig[server].setup()
			end

			-- Call setup for each server
			for _, server in pairs(mlsp_server_names) do
				default_setup(server)
			end

			require('mason-lspconfig').setup({
				ensure_installed = mason_all_pkgs,
				-- Adding as handler making it call lspconfig[server].setup() would work but it gets run for every mason installed package.
				-- Some packages we may not need to call setup intentionally (eg jdtls), therefore have commented out the below lines.
				-- handlers = {
				--	default_setup,
				-- },
			})

			attach_lsp_to_existing_buffers()
		end
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

	-- Java LSP and other features
	-- {
	--	"mfussenegger/nvim-jdtls",
	--	filetypes = { "java" },
	--	config = false,
	-- },

	{
		"AckslD/swenv.nvim",
		-- event = "Verylazy",
		lazy = true,
		cmd = "PickPythonEnv",
		filetypes = { "python" },
		depedencies = "plenary.nvim",
		config = function()
			require("swenv").setup()
			vim.api.nvim_create_user_command('PickPythonEnv', function()
				require('swenv.api').pick_venv()
			end, { desc = 'Pick python virtual env' })
		end,
	},
}
