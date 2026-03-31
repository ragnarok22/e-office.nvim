local M = {}

M.ns = vim.api.nvim_create_namespace("e_office")

local groups = {
	EOfficeWall = { fg = "#8B8682" },
	EOfficeFloor = { fg = "#D2B48C" },
	EOfficeCarpet = { fg = "#8B4513" },
	EOfficeDesk = { fg = "#A0522D" },
	EOfficeScreen = { fg = "#00FF00", bold = true },
	EOfficeMonitor = { fg = "#333333" },
	EOfficeChair = { fg = "#4A4A4A" },
	EOfficePerson = { fg = "#FFD700" },
	EOfficePersonHead = { fg = "#FFDAB9" },
	EOfficePlant = { fg = "#228B22" },
	EOfficeTitle = { fg = "#4169E1", bold = true },
	EOfficeDecor = { fg = "#CD853F" },
}

function M.define()
	for name, opts in pairs(groups) do
		opts.default = true
		vim.api.nvim_set_hl(0, name, opts)
	end
end

function M.apply(buf, highlight_instructions)
	vim.api.nvim_buf_clear_namespace(buf, M.ns, 0, -1)
	for _, hl in ipairs(highlight_instructions) do
		vim.api.nvim_buf_add_highlight(buf, M.ns, hl.hl_group, hl.row, hl.col_start, hl.col_end)
	end
end

return M
