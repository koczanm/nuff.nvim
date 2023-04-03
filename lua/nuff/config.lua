local M = {}

M.defaults = {
	pomodoro = {
		focus_session = 25,
		short_break = 5,
		long_break = 15,
		session_planned = 4,
	},
	menu = {
		border = {
			padding = { 0, 1 },
			style = "rounded",
			text = {
				top_align = "center",
			},
		},
		relaitve = "editor",
		position = "50%",
		size = {
			width = "20",
		},
		win_options = {
			winhighlight = "Normal:Pmenu,CursorLine:PmenuSel,Search:PmenuSel",
		},
	},
	widget = {
		boder = {
			style = "none",
		},
		relative = "editor",
		position = { row = "99%", col = "100%" },
		win_options = {
			winhighlight = "Normal:,FloatBorder:",
		},
	},
}

local config = nil

function M.get_config()
	return config or M.defaults
end

function M.setup(user_config)
	user_config = user_config or {}
	config = vim.tbl_deep_extend("force", M.defaults, user_config)
end

return M
