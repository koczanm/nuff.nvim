local Popup = require("nui.popup")

local Config = require("nuff.config").get_config()

local M = {}

local Widget = {}
Widget.__index = Widget

function Widget:new(pomodoro)
	local opts = {
		size = { width = 5, height = 1 },
		focusable = false,
		buf_options = {
			modifiable = true,
			readonly = false,
		},
	}
	local widget_opts = vim.tbl_deep_extend("force", Config.widget, opts)
	local this = {
		pomodoro = pomodoro,
		popup = Popup(widget_opts),
		visible = false,
		timer = vim.loop.new_timer(),
	}

	setmetatable(this, self)
	return this
end

function Widget:show()
	if self.visible then
		return
	end

	self.visible = true
	self.popup:mount()
	self.timer:start(
		0,
		1000,
		vim.schedule_wrap(function()
			self:render()
		end)
	)
end

function Widget:hide()
	if not self.visible then
		return
	end

	self.visible = false
	self.timer:stop()
	self.popup:unmount()
end

function Widget:render()
	local time_str = os.date("!%0M:%0S", self.pomodoro:get_remaining_time())
	vim.api.nvim_buf_set_lines(self.popup.bufnr, 0, 1, false, { time_str })
end

local widget = nil

function M.toggle_timer(pomodoro)
	widget = widget or Widget:new(pomodoro)
	if widget.visible then
		widget:hide()
	else
		widget:show()
	end
end

return M
