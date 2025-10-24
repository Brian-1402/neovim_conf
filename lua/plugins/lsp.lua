local mlsp_server_names = {
	"bashls",
	"biome",
	"clangd",
	"marksman",
	"lua_ls",
	"pyright",
	"rust_analyzer",
	"vimls",
	"jsonls",
}

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

-- Custom config opts for each server
local mlsp_servers_opts = {
	clangd = {
		cmd = {
			"clangd",
			"--background-index",
			"--clang-tidy",
			"--completion-style=detailed",
			"--header-insertion=never",
			"--query-driver=/usr/bin/g++",
			"--offset-encoding=utf-16",
		},
		filetypes = { "c", "cpp", "objc", "objcpp" },
	},
}

-- Add empty opts for each server already not having any
for _, pkg in ipairs(mlsp_server_names) do
	if not mlsp_servers_opts[pkg] then
		mlsp_servers_opts[pkg] = {}
	end
end

-- LSP requires to be loaded before buffer to get attached, but this prevents it to be lazy loaded.
-- As a workaround, this function allows LSP to be lazy loaded, and when it loads, it attaches to already loaded buffers.
-- [source](https://www.reddit.com/r/neovim/comments/15s3fxk/comment/jwdgdcp/)
-- local attach_lsp_to_existing_buffers = vim.schedule_wrap(function()
-- 	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
-- 		local valid = vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_get_option_value("buflisted", {buf = bufnr})
-- 		if valid and vim.bo[bufnr].buftype == "" then
-- 			local augroup_lspconfig = vim.api.nvim_create_augroup("lspconfig", { clear = false })
-- 			vim.api.nvim_exec_autocmds("FileType", { group = augroup_lspconfig, buffer = bufnr })
-- 		end
-- 	end
-- end)

return {
	-- lsp config
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		cmd = { "LspInfo", "LspInstall", "LspStart" },
		-- event = {"BufReadPre", "BufNewFile"},
		-- event = "VeryLazy",
		-- ft = { "c", "cpp", "lua", "python", "bash", "sh", "json", "markdown", "vim", "rust" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"williamboman/mason-lspconfig.nvim",
			"williamboman/mason.nvim",
			{ "folke/trouble.nvim", config = true, dependencies = "nvim-lua/plenary.nvim" },
			"SmiteshP/nvim-navbuddy",
			"SmiteshP/nvim-navic",
			"nvimtools/none-ls.nvim",
			"rmagatti/goto-preview",
		},

		config = function()
			local navic = require("nvim-navic")
			local navbuddy = require("nvim-navbuddy")
			local cmp_nvim_lsp = require("cmp_nvim_lsp")
			local preview = require("goto-preview")

			-- local keymap = vim.keymap -- for conciseness
			local opts = { noremap = true, silent = true }

			local function lsp_on_attach(event)
				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentSymbolProvider then
					navic.attach(client, event.buf)
					navbuddy.attach(client, event.buf)
				end

				local bufnr = event.buf
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
				vim.keymap.set({ "n" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection
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
				-- vim.keymap.set("n", "[d", vim.diagnostic.jump({count = 1, float = true}), opts) -- jump to previous diagnostic in buffer

				opts.desc = "Go to next diagnostic"
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

				opts.desc = "Show documentation for what is under cursor"
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

				opts.desc = "Format current buffer (async)"
				vim.keymap.set("n", "<leader>=", function()
					vim.lsp.buf.format({
						async = false,
						filter = function(client)
							print("Formatting with:", client.name)
							return true
						end,
					})
				end, opts)
			end

			vim.api.nvim_create_autocmd("LspAttach", {
				desc = "LSP actions",
				callback = lsp_on_attach,
			})

			-- vim.api.nvim_create_user_command("LspRestart", function()
			-- 	local null_ls = require("null-ls")
			-- 	local had_null_ls = false

			-- 	for _, client in pairs(vim.lsp.get_clients()) do
			-- 		if client.name == "null-ls" then
			-- 			had_null_ls = true
			-- 		else
			-- 			vim.lsp.stop_client(client.id)
			-- 		end
			-- 	end

			-- 	vim.cmd("edit") -- reopen buffer to trigger LspAttach

			-- 	-- if had_null_ls then
			-- 	--	null_ls.reload() -- ERROR no such field exists?
			-- 	-- end
			-- end, { desc = "Restart all LSPs and reload null-ls" })

			vim.diagnostic.config({
				float = { border = "rounded" },
			})
			vim.lsp.buf.hover({ border = "rounded" })
			vim.lsp.buf.signature_help({ border = "rounded" })

			-- Configure LSP servers.

			local capabilities = cmp_nvim_lsp.default_capabilities()

			local servers_to_enable = {}
			for server_name, server_opts in pairs(mlsp_servers_opts) do
				server_opts.capabilities = vim.tbl_deep_extend("force", capabilities, server_opts.capabilities or {})

				vim.lsp.config(server_name, server_opts)
				table.insert(servers_to_enable, server_name)
			end

			vim.lsp.enable(servers_to_enable)

			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = servers_to_enable,
			})

			-- attach_lsp_to_existing_buffers()
		end,
	},

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
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvimtools/none-ls-extras.nvim",
			"gbprod/none-ls-shellcheck.nvim",
		},
		opt = false,
	},

	{
		"smjonas/inc-rename.nvim",
		dependencies = "neovim/nvim-lspconfig",
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

	{
		"williamboman/mason-lspconfig.nvim",
		lazy = true,
		dependencies = "mason.nvim",
		config = false,
	},

	{
		"williamboman/mason.nvim",
		lazy = true,
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
	},

	{
		"jay-babu/mason-null-ls.nvim",
		lazy = false,
		-- event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			require("mason-null-ls").setup({
				ensure_installed = null_ls_servers,
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
					--	diagnostics_postprocess = function(diagnostic)
					--		diagnostic.code = diagnostic.message_id
					--	end,
					-- }), -- python diagnostics
					--
					null_ls.builtins.formatting.isort, -- orders imports
					null_ls.builtins.formatting.black, -- python formatter

					-- Lua
					-- null_ls.builtins.diagnostics.selene, -- lua diagnostics
					-- lua formatter
					null_ls.builtins.formatting.stylua,
					-- Use below if getting stylua errors like "unknown flag --lsp"
					-- null_ls.builtins.formatting.stylua.with({
					-- 	command = "stylua",
					-- 	args = { "--stdin-filepath", "$FILENAME", "-" },
					-- }),

					-- C/C++
					null_ls.builtins.formatting.clang_format, -- C/C++ formatter
					null_ls.builtins.diagnostics.cppcheck, -- More refined C/C++ diagnostics

					-- WebDev
					null_ls.builtins.formatting.prettierd, -- js, ts, css, html formatter
					-- null_ls.builtins.formatting.biome,
				},
			})

			-- Keybindings for LSP/Null-ls inspection and formatting tracing
			local opts = { noremap = true, silent = true }

			opts.desc = "List active LSP clients"
			vim.keymap.set("n", "<leader>la", function()
				print("active lsp clients:")
				for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
					print(client.name)
				end
			end, opts)

			-- 2. Show which clients provide formatting
			opts.desc = "Show LSP clients that provide formatting"
			vim.keymap.set("n", "<leader>lf", function()
				for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
					if client.server_capabilities.documentFormattingProvider then
						print(client.name .. " provides formatting")
					end
				end
			end, opts)

			-- 3. Trigger format + trace which client runs

			-- 4. Open Null-ls info window (if available)
			vim.keymap.set("n", "<leader>ln", "<cmd>NullLsInfo<CR>", opts)
		end,
	},

	-- {
	-- 	"linux-cultist/venv-selector.nvim",
	-- 	enabled = false,
	-- 	branch = "regexp",
	-- 	dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
	-- 	opts = {
	-- 		-- Your options go here
	-- 		-- name = { "venv", "env", ".venv", ".env" },
	-- 		auto_refresh = true,
	-- 	},
	-- 	event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
	-- },

	-- {
	-- 	"ThePrimeagen/refactoring.nvim",
	-- 	enabled = false,
	-- 	event = "VeryLazy",
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- 	config = function()
	-- 		require("refactoring").setup()
	-- 	end,
	-- },
}
