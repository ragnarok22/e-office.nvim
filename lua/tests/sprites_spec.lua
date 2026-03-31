local sprites = require("e_office.sprites")

describe("sprites", function()
	it("has width of 5", function()
		assert.are.equal(5, sprites.width)
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

					it("each row has correct width", function()
						for row_idx, row in ipairs(frame) do
							assert.are.equal(
								sprites.width,
								#row,
								"row " .. row_idx .. " should be " .. sprites.width .. " chars wide"
							)
						end
					end)

					it("uses only valid palette keys", function()
						local valid_keys = { h = true, s = true, x = true, p = true, n = true, ["."] = true }
						for _, row in ipairs(frame) do
							for i = 1, #row do
								local ch = row:sub(i, i)
								assert.is_true(valid_keys[ch] ~= nil, "invalid key '" .. ch .. "' in row")
							end
						end
					end)

					it("has hair at top center", function()
						local top_row = frame[1]
						assert.are.equal("h", top_row:sub(3, 3))
					end)
				end)
			end
		end)
	end

	validate_sprite_set("sitting_typing", sprites.sitting_typing, 6)
	validate_sprite_set("walking", sprites.walking, 7)
	validate_sprite_set("idle", sprites.idle, 7)
	validate_sprite_set("standing_at_desk", sprites.standing_at_desk, 6)

	it("sitting_typing has 2 frames for animation", function()
		assert.are.equal(2, #sprites.sitting_typing)
	end)

	it("walking has 2 frames for animation", function()
		assert.are.equal(2, #sprites.walking)
	end)

	it("typing frames differ in arm position", function()
		local f0 = sprites.sitting_typing[1]
		local f1 = sprites.sitting_typing[2]
		-- Frames should differ somewhere (arm row)
		local differ = false
		for i = 1, #f0 do
			if f0[i] ~= f1[i] then
				differ = true
				break
			end
		end
		assert.is_true(differ)
	end)
end)
