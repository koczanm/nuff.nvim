local pomodoro = require("nuff.pomodoro")

local M = {}

M.commands = {}

function M.command(cmd)
	if M.commands[cmd] then
		M.commands[cmd]()
	else
		M.commands.start_session()
	end
end

function M.setup()
	M.commands = {
		start_session = function()
			pomodoro.start_session()
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
