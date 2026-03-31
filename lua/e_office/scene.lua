local M = {}

local SCENE_WIDTH = 40
local SCENE_HEIGHT = 36

-- Helper to paint a filled rectangle on the grid
local function paint_rect(grid, x, y, w, h, color)
	for dy = 0, h - 1 do
		for dx = 0, w - 1 do
			local gy = y + dy
			local gx = x + dx
			if gy >= 1 and gy <= SCENE_HEIGHT and gx >= 1 and gx <= SCENE_WIDTH then
				grid[gy][gx] = color
			end
		end
	end
end

local function paint_pixel(grid, x, y, color)
	if y >= 1 and y <= SCENE_HEIGHT and x >= 1 and x <= SCENE_WIDTH then
		grid[y][x] = color
	end
end

local function paint_window(grid, x, y)
	-- 9 wide x 7 tall, 4-pane window with cross bar
	paint_rect(grid, x, y, 9, 7, "4") -- frame
	-- Top-left pane
	paint_rect(grid, x + 1, y + 1, 3, 2, "5")
	-- Top-right pane
	paint_rect(grid, x + 5, y + 1, 3, 2, "5")
	-- Bottom-left pane
	paint_rect(grid, x + 1, y + 4, 3, 2, "5")
	-- Bottom-right pane
	paint_rect(grid, x + 5, y + 4, 3, 2, "5")
end

local function paint_desk(grid, x, y)
	-- 8 wide, monitor + desk + legs
	-- Monitor frame (6 wide x 4 tall, centered)
	paint_rect(grid, x + 1, y, 6, 1, "C") -- top frame
	paint_rect(grid, x + 1, y + 3, 6, 1, "C") -- bottom frame
	paint_pixel(grid, x + 1, y + 1, "C") -- left frame
	paint_pixel(grid, x + 1, y + 2, "C")
	paint_pixel(grid, x + 6, y + 1, "C") -- right frame
	paint_pixel(grid, x + 6, y + 2, "C")
	-- Screen (4 wide x 2 tall)
	paint_rect(grid, x + 2, y + 1, 4, 2, "D")
	-- Stand
	paint_rect(grid, x + 3, y + 4, 2, 1, "C")
	-- Desk surface
	paint_rect(grid, x, y + 5, 8, 1, "A")
	-- Keyboard on desk
	paint_rect(grid, x + 2, y + 5, 4, 1, "I")
	-- Desk legs
	paint_rect(grid, x, y + 6, 1, 2, "B")
	paint_rect(grid, x + 7, y + 6, 1, 2, "B")
end

local function paint_chair(grid, x, y)
	-- 4 wide x 2 tall, centered on 8-wide desk area
	paint_rect(grid, x + 2, y, 4, 1, "E")
	paint_pixel(grid, x + 2, y + 1, "E")
	paint_pixel(grid, x + 5, y + 1, "E")
end

local function paint_plant(grid, x, y)
	-- 4 wide x 5 tall
	paint_pixel(grid, x + 1, y, "F")
	paint_pixel(grid, x + 2, y, "F")
	paint_pixel(grid, x, y + 1, "G")
	paint_pixel(grid, x + 1, y + 1, "F")
	paint_pixel(grid, x + 2, y + 1, "F")
	paint_pixel(grid, x + 3, y + 1, "G")
	paint_pixel(grid, x + 1, y + 2, "G")
	paint_pixel(grid, x + 2, y + 2, "G")
	-- Pot
	paint_rect(grid, x, y + 3, 4, 2, "H")
end

function M.get_grid()
	local config = require("e_office.config")
	local workstations = 4
	if config.user_config.office then
		workstations = config.user_config.office.workstations or 4
	end

	local grid = {}

	-- Fill background
	for y = 1, SCENE_HEIGHT do
		grid[y] = {}
		for x = 1, SCENE_WIDTH do
			if y <= 2 then
				grid[y][x] = "0" -- ceiling
			elseif y <= 12 then
				grid[y][x] = "1" -- wall
			elseif y == 13 then
				grid[y][x] = "9" -- baseboard
			else
				-- Floor checkerboard
				grid[y][x] = ((x + y) % 2 == 0) and "7" or "8"
			end
		end
	end

	-- Windows on the wall
	paint_window(grid, 5, 4)
	paint_window(grid, 20, 4)

	-- Workstation desks (each 8 wide, spaced across the floor)
	local desk_xs = { 1, 11, 21, 31 }
	for i = 1, math.min(workstations, 4) do
		paint_desk(grid, desk_xs[i], 14)
		paint_chair(grid, desk_xs[i], 22)
	end

	-- Plant in the right corner
	paint_plant(grid, 36, 28)

	return grid
end

M.WIDTH = SCENE_WIDTH
M.HEIGHT = SCENE_HEIGHT

-- Desk seats: pixel coords (1-indexed) for person sprite top-left when sitting
M.desk_seats = {
	{ x = 3, y = 17 },
	{ x = 13, y = 17 },
	{ x = 23, y = 17 },
	{ x = 33, y = 17 },
}

-- Walkable area for walking/idle people (pixel coordinates)
M.walkable = {
	x_min = 2,
	x_max = 35,
	y_min = 26,
	y_max = 30,
}

return M
