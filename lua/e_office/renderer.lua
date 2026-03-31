local M = {}

local scene = require("e_office.scene")
local people_mod = require("e_office.people")

-- Convert scene lines to a mutable grid of single-byte chars
-- For multi-byte UTF-8 chars, we work at the string level instead
-- Strategy: render by overlaying sprite characters onto line strings

function M.render(people_list)
	-- Start with the static scene lines
	local lines = scene.get_lines()
	local highlights = scene.get_highlights()

	-- For each person, overlay their sprite onto the lines
	for _, person in ipairs(people_list) do
		local sprite = people_mod.get_sprite(person)
		if sprite then
			for row_offset, sprite_row in ipairs(sprite) do
				local line_idx = person.y + row_offset - 1
				if line_idx >= 1 and line_idx <= #lines then
					local line = lines[line_idx]
					-- Convert line to a table of UTF-8 characters for safe indexing
					local chars = M._utf8_chars(line)
					for col_offset, cell in ipairs(sprite_row) do
						local char = cell[1]
						local hl = cell[2]
						if char and char ~= " " then
							local col_idx = person.x + col_offset - 1
							if col_idx >= 1 and col_idx <= #chars then
								chars[col_idx] = char
								if hl then
									-- Calculate byte offset for highlight
									local byte_start = M._char_byte_offset(chars, col_idx)
									local byte_end = byte_start + #char
									table.insert(highlights, {
										row = line_idx - 1,
										col_start = byte_start,
										col_end = byte_end,
										hl_group = hl,
									})
								end
							end
						end
					end
					lines[line_idx] = table.concat(chars)
				end
			end
		end
	end

	return lines, highlights
end

-- Split a UTF-8 string into a table of individual characters
function M._utf8_chars(str)
	local chars = {}
	for _, code in utf8.codes(str) do
		table.insert(chars, utf8.char(code))
	end
	return chars
end

-- Get the byte offset of the nth UTF-8 character (0-indexed bytes)
function M._char_byte_offset(chars, n)
	local offset = 0
	for i = 1, n - 1 do
		offset = offset + #chars[i]
	end
	return offset
end

return M
