local Config = require("nuff.config")
local Cmds = require("nuff.commands")
local Pomodoro = require("nuff.pomodoro")

local M = {}

function M.setup(user_config)
	Config.setup(user_config)
	Pomodoro.setup()
	Cmds.setup()
end

return M
