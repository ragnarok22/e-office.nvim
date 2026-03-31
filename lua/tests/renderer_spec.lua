local config = require("e_office.config")
local renderer = require("e_office.renderer")
local people = require("e_office.people")
local scene = require("e_office.scene")

describe("renderer", function()
	before_each(function()
		config.setup({})
		math.randomseed(42)
	end)

	describe("_utf8_chars", function()
		it("splits ASCII string correctly", function()
			local chars = renderer._utf8_chars("hello")
			assert.are.equal(5, #chars)
			assert.are.equal("h", chars[1])
			assert.are.equal("o", chars[5])
		end)

		it("splits multi-byte UTF-8 correctly", function()
			local chars = renderer._utf8_chars("a┌b")
			assert.are.equal(3, #chars)
			assert.are.equal("a", chars[1])
			assert.are.equal("┌", chars[2])
			assert.are.equal("b", chars[3])
		end)

		it("handles all box-drawing characters", function()
			local str = "┌──┐│└┘"
			local chars = renderer._utf8_chars(str)
			assert.are.equal(7, #chars)
			assert.are.equal("┌", chars[1])
			assert.are.equal("┘", chars[7])
		end)

		it("handles empty string", function()
			local chars = renderer._utf8_chars("")
			assert.are.equal(0, #chars)
		end)

		it("handles block characters", function()
			local chars = renderer._utf8_chars("█▓░")
			assert.are.equal(3, #chars)
			assert.are.equal("█", chars[1])
			assert.are.equal("▓", chars[2])
			assert.are.equal("░", chars[3])
		end)
	end)

	describe("_char_byte_offset", function()
		it("returns 0 for first character", function()
			local chars = { "a", "b", "c" }
			assert.are.equal(0, renderer._char_byte_offset(chars, 1))
		end)

		it("returns correct offset for ASCII", function()
			local chars = { "a", "b", "c" }
			assert.are.equal(1, renderer._char_byte_offset(chars, 2))
			assert.are.equal(2, renderer._char_byte_offset(chars, 3))
		end)

		it("returns correct offset for multi-byte chars", function()
			local chars = { "┌", "─", "┐" }
			-- ┌ is 3 bytes (UTF-8 box drawing)
			assert.are.equal(3, renderer._char_byte_offset(chars, 2))
			assert.are.equal(6, renderer._char_byte_offset(chars, 3))
		end)

		it("handles mixed ASCII and multi-byte", function()
			local chars = { "a", "┌", "b" }
			assert.are.equal(0, renderer._char_byte_offset(chars, 1))
			assert.are.equal(1, renderer._char_byte_offset(chars, 2))
			assert.are.equal(4, renderer._char_byte_offset(chars, 3))
		end)
	end)

	describe("render", function()
		it("returns 15 lines with no people", function()
			local lines, highlights = renderer.render({})
			assert.are.equal(15, #lines)
			assert.is_true(#highlights > 0)
		end)

		it("lines match scene when no people present", function()
			local rendered_lines = renderer.render({})
			local scene_lines = scene.get_lines()
			for i = 1, 15 do
				assert.are.equal(scene_lines[i], rendered_lines[i])
			end
		end)

		it("renders a sitting person onto the scene", function()
			local person = people.create(1, 1)
			local seat = scene.desk_seats[1]
			local lines = renderer.render({ person })

			-- The head 'o' should appear in the line at person.y
			local head_line = lines[seat.y]
			local chars = renderer._utf8_chars(head_line)
			-- person.x is 4, head is at col_offset 2 (center of 3-wide sprite)
			assert.are.equal("o", chars[seat.x + 1])
		end)

		it("adds highlight instructions for person sprites", function()
			local person = people.create(1, 1)
			local _, highlights = renderer.render({ person })

			local person_hls = {}
			for _, hl in ipairs(highlights) do
				if hl.hl_group == "EOfficePersonHead" or hl.hl_group == "EOfficePerson" then
					table.insert(person_hls, hl)
				end
			end
			assert.is_true(#person_hls > 0)
		end)

		it("does not corrupt scene lines for next render", function()
			local person = people.create(1, 1)
			renderer.render({ person })
			local clean_lines = renderer.render({})
			local scene_lines = scene.get_lines()
			for i = 1, 15 do
				assert.are.equal(scene_lines[i], clean_lines[i])
			end
		end)

		it("renders multiple people without error", function()
			local p1 = people.create(1, 1)
			local p2 = people.create(2, 2)
			local p3 = people.create(3, 3)
			local lines, highlights = renderer.render({ p1, p2, p3 })
			assert.are.equal(15, #lines)
			assert.is_true(#highlights > 0)
		end)

		it("renders walking person with 3-row sprite", function()
			local person = people.create(1, 1)
			person.state = people.STATES.WALKING
			person.x = 10
			person.y = 9
			person.target_x = 15
			person.target_y = 9
			local lines = renderer.render({ person })
			-- Head should be on line 9
			local chars = renderer._utf8_chars(lines[9])
			assert.are.equal("o", chars[11]) -- x=10, col_offset=2 -> col_idx=11
		end)
	end)
end)
