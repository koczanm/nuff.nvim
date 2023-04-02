local Pomodoro = require("nuff.pomodoro")

local M = {}

M.commands = {}

function M.command(cmd)
	if M.commands[cmd] then
		M.commands[cmd]()
	else
		M.commands.focus()
	end
end

function M.setup()
	M.commands = {
		["focus"] = function()
			Pomodoro.start_session()
		end,
		["break"] = function()
			Pomodoro.start_break()
		end,
		["status"] = function()
			Pomodoro.status()
		end,
		["timer"] = function()
			Pomodoro.toggle_timer()
		end,
	}

	vim.api.nvim_create_user_command("Nuff", function(args)
		local cmd = vim.trim(args.args or "")
		M.command(cmd)
	end, {
		nargs = "?",
		desc = "Nuff",
		complete = function(_, line)
			local prefix = line:match("^%s*Nuff (%w*)$") or ""
			return vim.tbl_filter(function(key)
				return key:find(prefix) == 1
			end, vim.tbl_keys(M.commands))
		end,
	})
end

return M
