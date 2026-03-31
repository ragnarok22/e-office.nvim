local M = {}

-- Pixel art sprites using person palette keys:
-- h=hair, s=skin, x=shirt, p=pants, n=shoes, .=transparent
-- Each frame is a list of row strings. Each character is one pixel.

-- Sitting and typing at desk (5 wide x 6 tall, 2 frames)
M.sitting_typing = {
	{ -- Frame 0: arms in
		"..h..",
		".hsh.",
		".xxx.",
		".xxx.",
		"..x..",
		"..p..",
	},
	{ -- Frame 1: arms out (typing)
		"..h..",
		".hsh.",
		".xxx.",
		".xxx.",
		".x.x.",
		"..p..",
	},
}

-- Walking (5 wide x 7 tall, 2 frames)
M.walking = {
	{ -- Frame 0: left leg forward
		"..h..",
		".hsh.",
		".xxx.",
		".xxx.",
		"..p..",
		".p...",
		"..n..",
	},
	{ -- Frame 1: right leg forward
		"..h..",
		".hsh.",
		".xxx.",
		".xxx.",
		"..p..",
		"...p.",
		"..n..",
	},
}

-- Idle / standing (5 wide x 7 tall, 1 frame)
M.idle = {
	{
		"..h..",
		".hsh.",
		".xxx.",
		".xxx.",
		"..p..",
		".p.p.",
		".n.n.",
	},
}

-- Standing at desk before walking away (5 wide x 6 tall, 1 frame)
M.standing_at_desk = {
	{
		"..h..",
		".hsh.",
		".xxx.",
		".xxx.",
		"..x..",
		"..p..",
	},
}

M.width = 5

return M
