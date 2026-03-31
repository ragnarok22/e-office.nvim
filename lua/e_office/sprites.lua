local M = {}

-- Each sprite is a list of rows, each row is a list of { char, hl_group } cells.
-- nil or space char = transparent (background shows through).

local HEAD = "EOfficePersonHead"
local BODY = "EOfficePerson"

-- Sitting and typing at desk (2 rows tall — legs hidden by chair)
M.sitting_typing = {
	-- Frame 0: hands out
	{
		{ { " ", nil }, { "o", HEAD }, { " ", nil } },
		{ { "/", BODY }, { "|", BODY }, { "\\", BODY } },
	},
	-- Frame 1: hands in (typing motion)
	{
		{ { " ", nil }, { "o", HEAD }, { " ", nil } },
		{ { "\\", BODY }, { "|", BODY }, { "/", BODY } },
	},
}

-- Walking (3 rows tall)
M.walking = {
	-- Frame 0: legs apart
	{
		{ { " ", nil }, { "o", HEAD }, { " ", nil } },
		{ { "/", BODY }, { "|", BODY }, { "\\", BODY } },
		{ { "/", BODY }, { " ", nil }, { "\\", BODY } },
	},
	-- Frame 1: legs together
	{
		{ { " ", nil }, { "o", HEAD }, { " ", nil } },
		{ { "/", BODY }, { "|", BODY }, { "\\", BODY } },
		{ { " ", nil }, { "|", BODY }, { " ", nil } },
	},
}

-- Idle / standing (3 rows tall, single frame)
M.idle = {
	{
		{ { " ", nil }, { "o", HEAD }, { " ", nil } },
		{ { "/", BODY }, { "|", BODY }, { "\\", BODY } },
		{ { "/", BODY }, { " ", nil }, { "\\", BODY } },
	},
}

-- Standing at desk (2 rows tall — used during STANDING state before walking)
M.standing_at_desk = {
	{
		{ { " ", nil }, { "o", HEAD }, { " ", nil } },
		{ { "/", BODY }, { "|", BODY }, { "\\", BODY } },
	},
}

M.width = 3

return M
