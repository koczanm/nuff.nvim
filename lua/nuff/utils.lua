local M = {}

function M.info(msg)
	vim.notify(msg, vim.log.levels.INFO, { title = "Nuff.nvim" })
end

function M.warn(msg)
	vim.notify(msg, vim.log.levels.WARN, { title = "Nuff.nvim" })
end

function M.error(msg)
	vim.notify(msg, vim.log.levels.ERROR, { title = "Nuff.nvim" })
end

return M
