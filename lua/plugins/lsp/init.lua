local mlsp_server_names = { "typos_lsp", "bashls", "biome", "html", "cssls", "clangd",
	"marksman", "texlab", "lua_ls", "pyright", "vimls", "yamlls", }
local linters = { "selene", }
local formatters = { "stylua", "black", }
local others = {}

local mason_nonlsp_pkgs = vim.tbl_extend( "keep", linters, formatters, others)
local mason_all_pkgs = vim.tbl_extend( "keep", mlsp_server_names, mason_nonlsp_pkgs)

-- local Util = require("lazyvim.util")
local mlsp_server_configs = {}
for i, server_name in ipairs(mlsp_server_names) do
	mlsp_server_configs[server_name] = {}
end

return {

	{
		'neovim/nvim-lspconfig',
		event = "VeryLazy",
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = false, dependencies = { "nvim-lspconfig" } },
			{ "folke/neodev.nvim", opts = {} },
			"mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},

		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			},
			inlay_hints = {
				enabled = false,
			},
			servers = mlsp_server_configs,
			setup = {}, -- You can add more configs here as <server_name> = { other settings } pairs.
		},

		config = function(_, opts)

			local servers = opts.servers

			-- For cmp
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				opts.capabilities or {}
			)

			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				elseif opts.setup["*"] then
					if opts.setup["*"](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end

			-- get all the servers that are available through mason-lspconfig
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
					if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
						-- does lsp setup for non-mason servers
						setup(server)
					else
						ensure_installed[#ensure_installed + 1] = server
					end
				end
			end

			if have_mason then
				mlsp.setup({
						ensure_installed = ensure_installed,
						handlers = { setup } , -- This handles lspconfig[server].setup for mason installed servers
						automatic_installation = true,
				})
			end




		end
	},

	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		build = ":MasonUpdate",
		opts = {
			ensure_installed = mason_nonlsp_pkgs,
		},
		---@param opts MasonSettings | {ensure_installed: string[]}
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},

}
