--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
	return function(str)
		local win_width = vim.fn.winwidth(0)
		if hide_width and win_width < hide_width then
			return ''
		elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
			return str:sub(1, trunc_len) .. (no_ellipsis and '' or '...')
		end
		return str
	end
end



-- Got from https://www.reddit.com/r/neovim/comments/o4bguk/comment/h2kcjxa
local function lsp_progress()
	local messages = vim.lsp.util.get_progress_messages()
	if #messages == 0 then
		return
	end
	local status = {}
	for _, msg in pairs(messages) do
		table.insert(status, (msg.percentage or 0) .. "%% " .. (msg.title or ""))
	end
	local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
	local ms = vim.loop.hrtime() / 1000000
	local frame = math.floor(ms / 120) % #spinners
	return table.concat(status, " | ") .. " " .. spinners[frame + 1]
end

--------------------------------------------------------------------------------

-- lightweight replacement for fidget.nvim
local progressText = ""
local function lspProgress() return progressText end

vim.api.nvim_create_autocmd("LspProgress", {
	callback = function(ctx)
		local clientName = vim.lsp.get_client_by_id(ctx.data.client_id).name
		local progress = ctx.data.params
			.value ---@type {percentage: number, title: string, kind: string, message: string}
		local firstWord = vim.split(progress.title, " ")[1]:lower() -- shorter for statusline
		local icon = ""
		local text = table.concat({ icon, clientName, firstWord, progress.message or "" }, " ")
		progressText = progress.kind == "end" and "" or text
	end,
})

-- wrapper to not require navic directly
local function navicBreadcrumbs()
	if vim.bo.filetype == "css" or not require("nvim-navic").is_available() then return "" end
	return require("nvim-navic").get_location()
end

return {
	{ -- Status line plugin
		"nvim-lualine/lualine.nvim",
		event = { "UIEnter", "VeryLazy" },
		dependencies = {
			{ "nvim-tree/nvim-web-devicons", lazy = true },
			"folke/noice.nvim",    -- For noice integration
			"AndreM222/copilot-lualine", -- For copilot status
			"arkav/lualine-lsp-progress", -- For lsp progress
			"meuter/lualine-so-fancy.nvim", -- Fancier icons, lot more support
			"ecthelionvi/NeoComposer.nvim", -- For macros status
		},
		config = function()
			vim.opt.showmode = false
			-- local noice = require("noice")
			require("lualine").setup({
				options = {
					theme = "nightfly",
					ignore_focus = {
						"DressingInput", "DressingSelect", "lspinfo", "ccc-ui", "TelescopePrompt",
						"checkhealth", "noice", "lazy", "mason", "qf",
					},
				},
				tabline = {
					lualine_a = {
						-- { -- clock if window is maximized
						-- 	"datetime",
						-- 	style = " %H:%M:%S",
						-- 	cond = function() return vim.o.columns > 120 end,
						-- 	fmt = function(time)
						-- 		local timeWithBlinkingColon = os.time() % 2 == 0 and time or time:gsub(":", " ")
						-- 		return timeWithBlinkingColon
						-- 	end,
						-- 	padding = { left = 0, right = 1 },
						-- },

						"fancy_cwd",

						{ -- using lualine's tab display, cause it looks better than vim's
							"tabs",
							mode = 1,
							cond = function() return vim.fn.tabpagenr("$") > 1 end,
						},
					},
					lualine_b = {
						navicBreadcrumbs,
					},
					lualine_c = {
						-- HACK spacer so the tabline is never empty (in which case vim adds its ugly tabline)
						{ function() return " " end, padding = { left = 0, right = 0 } },
					},
					lualine_x = {
						lspProgress,
						"fancy_lsp_servers"
					},
					lualine_y = {
						-- { -- recording status
						-- 	function() return ("雷Recording to [%s]…"):format(vim.fn.reg_recording()) end,
						-- 	cond = function() return vim.fn.reg_recording() ~= "" end,
						-- 	-- color = function() return { fg = u.getHighlightValue("Error", "fg") } end,
						-- },
						{ require("NeoComposer.ui").status_recording },
					},
				},
				sections = {
					lualine_a = { { "fancy_mode", width = 8, fmt = trunc(0, 0, 30, true) } },
					lualine_b = {
						{ "fancy_branch", fmt = trunc(0, 0, 60, true) },
						{ -- VENV indicator
							function() return "󱥒" end,
							cond = function() return vim.env.VIRTUAL_ENV and vim.bo.ft == "python" end,
							padding = { left = 1, right = 0 },
							fmt = trunc(0, 0, 100, true),
						},
						{ "fancy_diff",   fmt = trunc(0, 0, 85, true) },
						"filename",
					},
					lualine_c = {},
					lualine_x = {
						-- { noice.api.statusline.mode.get, cond = noice.api.statusline.mode.has, color = { fg = "#ff9e64" } }, -- For macro recording
						-- "fancy_macro",
						{ "fancy_searchcount", fmt = trunc(0, 0, 95, true) },
						{ "fancy_diagnostics", fmt = trunc(0, 0, 70, true) },
						-- "copilot",
						{ "fileformat",        fmt = trunc(0, 0, 80, true) },
						{ "filetype",          fmt = trunc(0, 0, 50, true) },
					},
					lualine_y = {
					},
					lualine_z = {
						{ "location", fmt = trunc(0, 0, 45, true) },
					}
				},
			})
		end
	},
}
