local M = {}

-- Scene palette: single-char keys → hex colors
M.scene = {
	["0"] = "#2D1F14", -- ceiling
	["1"] = "#8B5E3C", -- wall
	["4"] = "#4A5568", -- window frame
	["5"] = "#87CEEB", -- glass
	["7"] = "#D4B896", -- floor light
	["8"] = "#C0A478", -- floor dark
	["9"] = "#5C4033", -- baseboard
	["A"] = "#A88040", -- desk surface
	["B"] = "#7A5A28", -- desk leg
	["C"] = "#2A2A2A", -- monitor frame
	["D"] = "#22CC55", -- screen
	["E"] = "#505050", -- chair
	["F"] = "#33AA33", -- plant leaf
	["G"] = "#1A7A1A", -- plant dark
	["H"] = "#8B5A3A", -- pot
	["I"] = "#787878", -- keyboard
}

-- Person color variants (keys used in sprite strings)
-- h=hair, s=skin, x=shirt, p=pants, n=shoes
M.person_variants = {
	{
		h = "#4A3728",
		s = "#FFDAB9",
		x = "#CC4444",
		p = "#555566",
		n = "#333333",
	},
	{
		h = "#2A1F14",
		s = "#FFDAB9",
		x = "#3366AA",
		p = "#555566",
		n = "#333333",
	},
	{
		h = "#8B6914",
		s = "#FFDAB9",
		x = "#338833",
		p = "#665544",
		n = "#333333",
	},
	{
		h = "#1A1A2E",
		s = "#DEB887",
		x = "#666666",
		p = "#444455",
		n = "#222222",
	},
}

return M
