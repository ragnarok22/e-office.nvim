local config = require("e_office.config")
local scene = require("e_office.scene")

describe("scene", function()
	before_each(function()
		config.setup({})
	end)

	describe("get_lines", function()
		it("returns 15 lines", function()
			local lines = scene.get_lines()
			assert.are.equal(15, #lines)
		end)

		it("returns strings for each line", function()
			local lines = scene.get_lines()
			for i, line in ipairs(lines) do
				assert.is_string(line, "line " .. i .. " should be a string")
			end
		end)

		it("returns a fresh copy each call", function()
			local a = scene.get_lines()
			local b = scene.get_lines()
			assert.are_not.equal(a, b)
			assert.are.same(a, b)
		end)

		it("first line starts with top-left corner", function()
			local lines = scene.get_lines()
			assert.is_truthy(lines[1]:find("^┌"))
		end)

		it("last line starts with bottom-left corner", function()
			local lines = scene.get_lines()
			assert.is_truthy(lines[15]:find("^└"))
		end)
	end)

	describe("get_highlights", function()
		it("returns a non-empty list", function()
			local hls = scene.get_highlights()
			assert.is_true(#hls > 0)
		end)

		it("each highlight has required fields", function()
			local hls = scene.get_highlights()
			for _, hl in ipairs(hls) do
				assert.is_number(hl.row)
				assert.is_number(hl.col_start)
				assert.is_number(hl.col_end)
				assert.is_string(hl.hl_group)
				assert.is_true(hl.col_end > hl.col_start, "col_end must be > col_start")
			end
		end)

		it("row indices are 0-based and within bounds", function()
			local hls = scene.get_highlights()
			for _, hl in ipairs(hls) do
				assert.is_true(hl.row >= 0 and hl.row < 15)
			end
		end)
	end)

	describe("desk_seats", function()
		it("has 4 seats", function()
			assert.are.equal(4, #scene.desk_seats)
		end)

		it("each seat has x and y", function()
			for _, seat in ipairs(scene.desk_seats) do
				assert.is_number(seat.x)
				assert.is_number(seat.y)
			end
		end)

		it("seats are within scene bounds", function()
			for _, seat in ipairs(scene.desk_seats) do
				assert.is_true(seat.x >= 1 and seat.x <= 40)
				assert.is_true(seat.y >= 1 and seat.y <= 15)
			end
		end)
	end)

	describe("walkable", function()
		it("defines a valid rectangle", function()
			local w = scene.walkable
			assert.is_true(w.x_min < w.x_max)
			assert.is_true(w.y_min < w.y_max)
		end)

		it("is inside the scene bounds", function()
			local w = scene.walkable
			assert.is_true(w.x_min >= 1)
			assert.is_true(w.x_max <= 40)
			assert.is_true(w.y_min >= 1)
			assert.is_true(w.y_max <= 15)
		end)
	end)
end)
