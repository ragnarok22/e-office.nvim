local config = require("e_office.config")
local scene = require("e_office.scene")

describe("scene", function()
	before_each(function()
		config.setup({})
	end)

	describe("get_grid", function()
		it("returns a grid with correct height", function()
			local grid = scene.get_grid()
			assert.are.equal(scene.HEIGHT, #grid)
		end)

		it("returns a grid with correct width", function()
			local grid = scene.get_grid()
			for y = 1, #grid do
				assert.are.equal(scene.WIDTH, #grid[y], "row " .. y .. " should have correct width")
			end
		end)

		it("fills every cell with a palette key", function()
			local grid = scene.get_grid()
			for y = 1, #grid do
				for x = 1, #grid[y] do
					assert.is_string(grid[y][x], "cell at " .. x .. "," .. y .. " should be a string")
					assert.are.equal(1, #grid[y][x], "palette key should be 1 char at " .. x .. "," .. y)
				end
			end
		end)

		it("has ceiling in top rows", function()
			local grid = scene.get_grid()
			assert.are.equal("0", grid[1][1])
			assert.are.equal("0", grid[2][20])
		end)

		it("has wall below ceiling", function()
			local grid = scene.get_grid()
			assert.are.equal("1", grid[3][1])
		end)

		it("has baseboard at row 13", function()
			local grid = scene.get_grid()
			assert.are.equal("9", grid[13][1])
		end)

		it("has floor pattern below baseboard", function()
			local grid = scene.get_grid()
			local cell = grid[14][1]
			assert.is_true(cell == "7" or cell == "8")
		end)

		it("returns a fresh copy each call", function()
			local a = scene.get_grid()
			local b = scene.get_grid()
			assert.are_not.equal(a, b)
			-- Modify a, b should be unaffected
			a[1][1] = "Z"
			assert.are_not.equal("Z", b[1][1])
		end)

		it("paints monitor screen pixels", function()
			local grid = scene.get_grid()
			-- Desk 1 starts at x=1, monitor screen at x+2, y+1 = (3, 15)
			assert.are.equal("D", grid[15][3])
		end)

		it("paints window glass pixels", function()
			local grid = scene.get_grid()
			-- Window 1 at (5,4), glass pane at (6, 5)
			assert.are.equal("5", grid[5][6])
		end)
	end)

	describe("desk_seats", function()
		it("has 4 seats", function()
			assert.are.equal(4, #scene.desk_seats)
		end)

		it("each seat has x and y within scene bounds", function()
			for _, seat in ipairs(scene.desk_seats) do
				assert.is_number(seat.x)
				assert.is_number(seat.y)
				assert.is_true(seat.x >= 1 and seat.x <= scene.WIDTH)
				assert.is_true(seat.y >= 1 and seat.y <= scene.HEIGHT)
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
			assert.is_true(w.x_max <= scene.WIDTH)
			assert.is_true(w.y_min >= 1)
			assert.is_true(w.y_max <= scene.HEIGHT)
		end)
	end)
end)
