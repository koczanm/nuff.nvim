local Menu = require("nui.menu")

local config = require("nuff.config").get_config()
local utils = require("nuff.utils")

local M = {}

local function create_menu(title, items, events, opts)
	local menu_opts = vim.tbl_deep_extend("force", config.popupmenu, opts or {})
	menu_opts.border.text.top = " " .. title .. " "
	local lines = vim.tbl_map(function(item)
		return Menu.item(item)
	end, items)
	local menu = Menu(menu_opts, vim.tbl_extend("error", events, { lines = lines }))
	menu:mount()
end

function M.show_session_menu(pomodoro)
	local title = "Session completed"
	local items = { "Take a break", "Quit" }
	local events = {
		on_submit = function(item)
			if item.text == "Take a break" then
				pomodoro:start_break()
			end
		end,
	}
	create_menu(title, items, events)
end

function M.show_break_menu(pomodoro)
	local title = "End of break"
	local items = { "Stay focused", "Quit" }
	local events = {
		on_submit = function(item)
			if item.text == "Stay focused" then
				pomodoro:start_session()
			end
		end,
	}
	create_menu(title, items, events)
end

function M.show_status_notification(pomodoro)
  pomodoro.status()
end

return M
