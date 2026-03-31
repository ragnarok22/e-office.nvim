local M = {}

local config = require("e_office.config")

local state = {
	buf = nil,
	win = nil,
	augroup = nil,
}

local function is_valid_win()
	return state.win and vim.api.nvim_win_is_valid(state.win)
end

local function is_valid_buf()
	return state.buf and vim.api.nvim_buf_is_valid(state.buf)
end

local function win_config()
	local cfg = config.user_config.window
	return {
		relative = "editor",
		width = cfg.width,
		height = cfg.height,
		col = vim.o.columns - cfg.width - cfg.col_offset,
		row = cfg.row_offset,
		style = "minimal",
		border = cfg.border,
		focusable = false,
		zindex = 20,
	}
end

function M.open()
	if is_valid_win() then
		return state.buf, state.win
	end

	if not is_valid_buf() then
		state.buf = vim.api.nvim_create_buf(false, true)
		vim.api.nvim_set_option_value("buftype", "nofile", { buf = state.buf })
		vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = state.buf })
		vim.api.nvim_set_option_value("swapfile", false, { buf = state.buf })
	end

	state.win = vim.api.nvim_open_win(state.buf, false, win_config())
	vim.api.nvim_set_option_value("wrap", false, { win = state.win })
	vim.api.nvim_set_option_value("number", false, { win = state.win })
	vim.api.nvim_set_option_value("relativenumber", false, { win = state.win })
	vim.api.nvim_set_option_value("cursorline", false, { win = state.win })
	vim.api.nvim_set_option_value("signcolumn", "no", { win = state.win })

	-- Reposition on resize
	state.augroup = vim.api.nvim_create_augroup("EOfficeWindow", { clear = true })
	vim.api.nvim_create_autocmd("VimResized", {
		group = state.augroup,
		callback = function()
			if is_valid_win() then
				vim.api.nvim_win_set_config(state.win, win_config())
			end
		end,
	})

	return state.buf, state.win
end

function M.close()
	if is_valid_win() then
		vim.api.nvim_win_close(state.win, true)
	end
	state.win = nil
	state.buf = nil
	if state.augroup then
		vim.api.nvim_del_augroup_by_id(state.augroup)
		state.augroup = nil
	end
end

function M.is_open()
	return is_valid_win()
end

function M.get_buf()
	return state.buf
end

return M
