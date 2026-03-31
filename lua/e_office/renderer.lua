local M = {}

local scene = require("e_office.scene")
local people_mod = require("e_office.people")
local palette = require("e_office.palette")
local highlights = require("e_office.highlights")

local HALFBLOCK = "\xe2\x96\x80" -- ▀ (UTF-8: E2 96 80)
local HALFBLOCK_BYTES = 3

function M.render(people_list)
	-- Build scene grid (palette keys)
	local grid = scene.get_grid()
	local height = scene.HEIGHT
	local width = scene.WIDTH

	-- Resolve scene palette to hex colors
	local color_grid = {}
	for y = 1, height do
		color_grid[y] = {}
		for x = 1, width do
			color_grid[y][x] = palette.scene[grid[y][x]] or "#000000"
		end
	end

	-- Overlay person sprites
	for _, person in ipairs(people_list) do
		local sprite = people_mod.get_sprite(person)
		if sprite then
			local variant = palette.person_variants[person.color_variant]
			for row_idx, row_str in ipairs(sprite) do
				local gy = person.y + row_idx - 1
				if gy >= 1 and gy <= height then
					for col_idx = 1, #row_str do
						local key = row_str:sub(col_idx, col_idx)
						if key ~= "." then
							local gx = person.x + col_idx - 1
							if gx >= 1 and gx <= width and variant[key] then
								color_grid[gy][gx] = variant[key]
							end
						end
					end
				end
			end
		end
	end

	-- Render to half-block lines
	local lines = {}
	local hl_instructions = {}
	local line_idx = 0

	for y = 1, height, 2 do
		local chars = {}
		for x = 1, width do
			local top = color_grid[y][x]
			local bot = (y + 1 <= height) and color_grid[y + 1][x] or top
			chars[x] = HALFBLOCK

			local hl_group = highlights.get_hl(top, bot)
			table.insert(hl_instructions, {
				row = line_idx,
				col_start = (x - 1) * HALFBLOCK_BYTES,
				col_end = x * HALFBLOCK_BYTES,
				hl_group = hl_group,
			})
		end
		table.insert(lines, table.concat(chars))
		line_idx = line_idx + 1
	end

	return lines, hl_instructions
end

return M
