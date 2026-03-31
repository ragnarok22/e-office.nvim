local sprites = require("e_office.sprites")

describe("sprites", function()
	it("has width of 3", function()
		assert.are.equal(3, sprites.width)
	end)

	local function validate_sprite_set(name, sprite_set, expected_height)
		describe(name, function()
			it("has at least 1 frame", function()
				assert.is_true(#sprite_set >= 1)
			end)

			for frame_idx, frame in ipairs(sprite_set) do
				describe("frame " .. frame_idx, function()
					it("has " .. expected_height .. " rows", function()
						assert.are.equal(expected_height, #frame)
					end)

					it("each row has 3 cells", function()
						for row_idx, row in ipairs(frame) do
							assert.are.equal(3, #row, "row " .. row_idx .. " should have 3 cells")
						end
					end)

					it("each cell has a string character", function()
						for _, row in ipairs(frame) do
							for _, cell in ipairs(row) do
								assert.is_table(cell)
								assert.is_string(cell[1])
								assert.are.equal(1, #cell[1], "char should be single character")
							end
						end
					end)

					it("head is in first row center", function()
						local head_cell = frame[1][2]
						assert.are.equal("o", head_cell[1])
						assert.are.equal("EOfficePersonHead", head_cell[2])
					end)
				end)
			end
		end)
	end

	validate_sprite_set("sitting_typing", sprites.sitting_typing, 2)
	validate_sprite_set("walking", sprites.walking, 3)
	validate_sprite_set("idle", sprites.idle, 3)
	validate_sprite_set("standing_at_desk", sprites.standing_at_desk, 2)

	it("sitting_typing has 2 frames for animation", function()
		assert.are.equal(2, #sprites.sitting_typing)
	end)

	it("walking has 2 frames for animation", function()
		assert.are.equal(2, #sprites.walking)
	end)
end)
