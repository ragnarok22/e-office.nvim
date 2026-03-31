local M = {}

-- Each cell: { char, hl_group }
-- The scene is 40 chars wide x 15 rows tall

local W = "EOfficeWall"
local F = "EOfficeFloor"
local C = "EOfficeCarpet"
local D = "EOfficeDesk"
local S = "EOfficeScreen"
local MO = "EOfficeMonitor"
local CH = "EOfficeChair"
local P = "EOfficePlant"
local T = "EOfficeTitle"
local DC = "EOfficeDecor"

-- Raw scene lines with per-character highlight info
-- Format: string line + highlight ranges for that line
local scene_template = {
	{
		str = "┌──────────────────────────────────────┐",
		hl = { { 0, 40, W } },
	},
	{
		str = "│ ♣       E - O F F I C E          ♣  │",
		hl = {
			{ 0, 1, W },
			{ 2, 3, P },
			{ 9, 30, T },
			{ 35, 36, P },
			{ 39, 40, W },
		},
	},
	{
		str = "│──────────────────────────────────────│",
		hl = { { 0, 40, W } },
	},
	-- Row 3: monitor tops (4 workstations)
	{
		str = "│  ┌───┐  ┌───┐  ┌───┐  ┌───┐        │",
		hl = {
			{ 0, 1, W },
			{ 3, 8, MO },
			{ 11, 16, MO },
			{ 19, 24, MO },
			{ 27, 32, MO },
			{ 39, 40, W },
		},
	},
	-- Row 4: monitor screens
	{
		str = "│  │▓▓▓│  │▓▓▓│  │▓▓▓│  │▓▓▓│        │",
		hl = {
			{ 0, 1, W },
			{ 3, 4, MO },
			{ 4, 7, S },
			{ 7, 8, MO },
			{ 11, 12, MO },
			{ 12, 15, S },
			{ 15, 16, MO },
			{ 19, 20, MO },
			{ 20, 23, S },
			{ 23, 24, MO },
			{ 27, 28, MO },
			{ 28, 31, S },
			{ 31, 32, MO },
			{ 39, 40, W },
		},
	},
	-- Row 5: monitor bases
	{
		str = "│  └─┬─┘  └─┬─┘  └─┬─┘  └─┬─┘        │",
		hl = {
			{ 0, 1, W },
			{ 3, 8, MO },
			{ 11, 16, MO },
			{ 19, 24, MO },
			{ 27, 32, MO },
			{ 39, 40, W },
		},
	},
	-- Row 6: desks
	{
		str = "│ ████████ ████████ ████████ ████████  │",
		hl = {
			{ 0, 1, W },
			{ 2, 10, D },
			{ 11, 19, D },
			{ 20, 28, D },
			{ 29, 37, D },
			{ 39, 40, W },
		},
	},
	-- Row 7: chairs (people sit here)
	{
		str = "│   ╚╝      ╚╝      ╚╝      ╚╝       │",
		hl = {
			{ 0, 1, W },
			{ 4, 6, CH },
			{ 13, 15, CH },
			{ 22, 24, CH },
			{ 31, 33, CH },
			{ 39, 40, W },
		},
	},
	-- Row 8: walkway
	{ str = "│                                      │", hl = { { 0, 1, W }, { 1, 39, F }, { 39, 40, W } } },
	-- Row 9: carpet
	{
		str = "│  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │",
		hl = {
			{ 0, 1, W },
			{ 3, 37, C },
			{ 39, 40, W },
		},
	},
	-- Row 10-11: walkway
	{ str = "│                                      │", hl = { { 0, 1, W }, { 1, 39, F }, { 39, 40, W } } },
	{ str = "│                                      │", hl = { { 0, 1, W }, { 1, 39, F }, { 39, 40, W } } },
	-- Row 12: decorations
	{
		str = "│  ♨                             ♣     │",
		hl = {
			{ 0, 1, W },
			{ 3, 4, DC },
			{ 34, 35, P },
			{ 39, 40, W },
		},
	},
	-- Row 13: walkway
	{ str = "│                                      │", hl = { { 0, 1, W }, { 1, 39, F }, { 39, 40, W } } },
	-- Row 14: bottom wall
	{
		str = "└──────────────────────────────────────┘",
		hl = { { 0, 40, W } },
	},
}

M.desk_seats = {
	{ x = 4, y = 6 }, -- above desk row, where the person sprite top goes
	{ x = 13, y = 6 },
	{ x = 22, y = 6 },
	{ x = 31, y = 6 },
}

M.walkable = {
	x_min = 2,
	x_max = 37,
	y_min = 8,
	y_max = 13,
}

function M.get_lines()
	local lines = {}
	for i, row in ipairs(scene_template) do
		lines[i] = row.str
	end
	return lines
end

function M.get_highlights()
	local hls = {}
	for row_idx, row in ipairs(scene_template) do
		for _, hl in ipairs(row.hl) do
			table.insert(hls, {
				row = row_idx - 1,
				col_start = hl[1],
				col_end = hl[2],
				hl_group = hl[3],
			})
		end
	end
	return hls
end

function M.get_workstation_count()
	local config = require("e_office.config")
	return config.user_config.office and config.user_config.office.workstations or 4
end

return M
