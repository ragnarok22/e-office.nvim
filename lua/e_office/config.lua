local M = {}

M.default_config = {
	window = {
		width = 40,
		height = 15,
		border = "rounded",
		row_offset = 1,
		col_offset = 1,
	},
	animation = {
		fps = 4,
		typing_speed = 2,
	},
	office = {
		num_people = 3,
		workstations = 4,
	},
	auto_start = false,
}

M.user_config = {}

function M.setup(user_config)
	M.user_config = vim.tbl_deep_extend("force", vim.deepcopy(M.default_config), user_config or {})
	M.user_config.office.num_people = math.max(1, math.min(4, M.user_config.office.num_people))
	M.user_config.office.workstations = math.max(1, math.min(4, M.user_config.office.workstations))
	M.user_config.animation.fps = math.max(1, math.min(30, M.user_config.animation.fps))
end

return M
