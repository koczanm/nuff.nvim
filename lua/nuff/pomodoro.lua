local config = require("nuff.config").get_config()
local ui = require("nuff.ui")
local utils = require("nuff.utils")

local M = {}

local state = {
	stopped = 0,
	started = 1,
	at_break = 2,
}

local Pomodoro = {}
Pomodoro.__index = Pomodoro

function Pomodoro:new()
	local this = {
		state = state.stopped,
		sessions_completed = 0,
		session_started_at = nil,
		break_started_at = nil,
		timer = vim.loop.new_timer(),
	}

	setmetatable(this, self)
	return this
end

function Pomodoro:get_break_duration()
	if self.sessions_completed == config.pomodoro.session_planned then
		return config.pomodoro.long_break
	else
		return config.pomodoro.short_break
	end
end

function Pomodoro:get_remaining_focus_time()
	return config.pomodoro.focus_session * 60 - os.difftime(os.time(), self.session_started_at)
end

function Pomodoro:get_remaining_break_time()
	return self:get_break_duration() * 60 - os.difftime(os.time(), self.session_started_at)
end

function Pomodoro:start_session()
	if self.state ~= state.stopped then
		utils.warn("Pomodoro is currently running")
		return
	end
	local session_ms = config.pomodoro.focus_session * 60 * 1000
	self.timer:start(
		session_ms,
		0,
		vim.schedule_wrap(function()
			ui.show_session_menu(self)
			self.sessions_completed = self.sessions_completed + 1
			self.state = state.stopped
		end)
	)
	utils.info("Let's focus!")
	self.session_started_at = os.time()
	self.state = state.started
end

function Pomodoro:start_break()
	if self.state ~= state.stopped then
		utils.warn("Pomodoro is currently running")
		return
	end
	local break_ms = self:get_break_duration() * 60 * 1000
	self.timer:start(
		break_ms,
		0,
		vim.schedule_wrap(function()
			ui.show_break_menu(self)
			self.state = state.stopped
		end)
	)
	utils.info("Take a break!")
	self.break_started_at = os.time()
	self.state = state.at_break
end

function Pomodoro:status()
	if self.state == state.started then
		utils.info(os.date("!%0M mins %0S secs", self:get_remaining_focus_time()) .. " of focus left")
	elseif self.state == state.at_break then
		utils.info(os.date("!%0M mins %0S secs", self:get_remaining_break_time()) .. " of break left")
	else
		utils.info("Not running")
	end
end

local pomodoro = nil

function M.setup()
	pomodoro = pomodoro or Pomodoro:new()
end

function M.start_session()
	pomodoro:start_session()
end

function M.start_break()
	pomodoro:start_break()
end

function M.status()
	pomodoro:status()
end

return M
