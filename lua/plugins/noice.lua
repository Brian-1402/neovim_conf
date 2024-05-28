return {
	"folke/noice.nvim",
	-- event = { "UIEnter", "VeryLazy" },
	event = "VeryLazy",
	opts = {
		-- add any options here
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--	 `nvim-notify` is only needed, if you want to use the notification view.
		--	 If not available, we use `mini` as the fallback
		"rcarriga/nvim-notify",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("noice").setup({
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = false, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = true, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
			},
			routes = {
				-- { view = "notify", filter = { event = "msg_showmode" } }, -- Show @recording messages

				{ -- Ignore certain lsp servers for progress messages
					filter = {
						event = "lsp",
						kind = "progress",
						cond = function(message)
							local client = vim.tbl_get(message.opts, "progress", "client")
							return client == "lua_ls"
							-- Can otherwise check with a more general lsp_ignore_list also.
						end,
					},
					opts = { skip = true },
				},
				-- { filter = { find = "E162" },                                   view = "mini" },
				-- { filter = { find = "E37" },                                    view = "mini" }, --   No write since last change (add ! to override)
				{ filter = { event = "msg_show", kind = "", find = "written" }, view = "mini" },
				{ filter = { event = "msg_show", find = "after" },              view = "mini" },
				{ filter = { event = "msg_show", find = "before" },             view = "mini" },
				{ filter = { event = "msg_show", find = "fewer lines" },        view = "mini" },
				{ filter = { event = "msg_show", find = "more lines" },         view = "mini" },
				{ filter = { find = "No signature help" },                      view = "mini" },
				{ filter = { event = "msg_show", find = "search hit BOTTOM" },  skip = true },
				{ filter = { event = "msg_show", find = "search hit TOP" },     skip = true },
				{ filter = { find = "Config Change Detected. Reloading..." },   skip = true },
			},

			-- Bring back classic command line
			cmdline = {
				view = "cmdline",
				format = {
					search_down = {
						view = "cmdline",
					},
					search_up = {
						view = "cmdline",
					},
				},
			},
		})
	end
}
