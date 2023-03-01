local commands = require("nuff.commands")
local config = require("nuff.config")
local pomodoro = require("nuff.pomodoro")

local M = {}

function M.setup(user_config)
	config.setup(user_config)
	pomodoro.setup()
	commands.setup()
end

return M
