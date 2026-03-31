local M = {}

M.ns = vim.api.nvim_create_namespace("e_office")

local hl_cache = {}
local hl_counter = 0

-- Get or create a highlight group for a (fg, bg) color pair
function M.get_hl(fg, bg)
	local key = fg .. "|" .. bg
	if not hl_cache[key] then
		hl_counter = hl_counter + 1
		local name = "EO" .. hl_counter
		vim.api.nvim_set_hl(0, name, { fg = fg, bg = bg })
		hl_cache[key] = name
	end
	return hl_cache[key]
end

function M.apply(buf, highlight_instructions)
	vim.api.nvim_buf_clear_namespace(buf, M.ns, 0, -1)
	for _, hl in ipairs(highlight_instructions) do
		vim.api.nvim_buf_add_highlight(buf, M.ns, hl.hl_group, hl.row, hl.col_start, hl.col_end)
	end
end

function M.clear_cache()
	hl_cache = {}
	hl_counter = 0
end

return M
