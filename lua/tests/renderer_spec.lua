local config = require("e_office.config")
local renderer = require("e_office.renderer")
local people = require("e_office.people")
local scene = require("e_office.scene")

describe("renderer", function()
	before_each(function()
		config.setup({})
		math.randomseed(42)
	end)

	describe("render", function()
		it("returns correct number of lines (half of scene height)", function()
			local lines = renderer.render({})
			assert.are.equal(scene.HEIGHT / 2, #lines)
		end)

		it("each line has correct byte length (width * 3 for halfblock)", function()
			local lines = renderer.render({})
			for i, line in ipairs(lines) do
				assert.are.equal(scene.WIDTH * 3, #line, "line " .. i .. " byte length")
			end
		end)

		it("returns highlight instructions", function()
			local _, highlights = renderer.render({})
			assert.is_true(#highlights > 0)
		end)

		it("has one highlight per cell", function()
			local _, highlights = renderer.render({})
			-- Total cells = width * (height/2) lines
			local expected = scene.WIDTH * (scene.HEIGHT / 2)
			assert.are.equal(expected, #highlights)
		end)

		it("highlight instructions have required fields", function()
			local _, highlights = renderer.render({})
			for _, hl in ipairs(highlights) do
				assert.is_number(hl.row)
				assert.is_number(hl.col_start)
				assert.is_number(hl.col_end)
				assert.is_string(hl.hl_group)
			end
		end)

		it("highlight byte offsets are multiples of 3", function()
			local _, highlights = renderer.render({})
			for _, hl in ipairs(highlights) do
				assert.are.equal(0, hl.col_start % 3)
				assert.are.equal(0, hl.col_end % 3)
			end
		end)

		it("renders with people without error", function()
			local p1 = people.create(1, 1)
			local p2 = people.create(2, 2)
			local lines, highlights = renderer.render({ p1, p2 })
			assert.are.equal(scene.HEIGHT / 2, #lines)
			assert.is_true(#highlights > 0)
		end)

		it("renders walking person without error", function()
			local person = people.create(1, 1)
			person.state = people.STATES.WALKING
			person.x = 10
			person.y = 27
			person.target_x = 15
			person.target_y = 27
			local lines = renderer.render({ person })
			assert.are.equal(scene.HEIGHT / 2, #lines)
		end)

		it("all lines contain only halfblock characters", function()
			local lines = renderer.render({})
			local halfblock = "\xe2\x96\x80"
			for _, line in ipairs(lines) do
				for i = 1, #line, 3 do
					local ch = line:sub(i, i + 2)
					assert.are.equal(halfblock, ch)
				end
			end
		end)

		it("renders all 4 people without error", function()
			local people_list = {}
			for i = 1, 4 do
				table.insert(people_list, people.create(i, i))
			end
			local lines = renderer.render(people_list)
			assert.are.equal(scene.HEIGHT / 2, #lines)
		end)
	end)
end)
