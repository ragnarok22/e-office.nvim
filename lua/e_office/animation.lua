local M = {}

local config = require("e_office.config")
local window = require("e_office.window")
local people_mod = require("e_office.people")
local renderer = require("e_office.renderer")
local highlights = require("e_office.highlights")

local state = {
	timer = nil,
	running = false,
	people = {},
	tick_count = 0,
}

local function tick()
	if not state.running then
		return
	end

	local buf = window.get_buf()
	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		M.stop()
		return
	end

	-- Update all people
	local typing_speed = config.user_config.animation.typing_speed
	for _, person in ipairs(state.people) do
		people_mod.update(person, typing_speed)
	end

	-- Render
	local lines, hl_instructions = renderer.render(state.people)

	-- Push to buffer
	vim.api.nvim_set_option_value("modifiable", true, { buf = buf })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_set_option_value("modifiable", false, { buf = buf })

	-- Apply highlights
	highlights.apply(buf, hl_instructions)

	state.tick_count = state.tick_count + 1
end

function M.start()
	if state.running then
		return
	end

	-- Seed RNG
	math.randomseed(os.time())

	-- Create people
	state.people = {}
	local num = config.user_config.office.num_people
	local ws = config.user_config.office.workstations
	num = math.min(num, ws)
	for i = 1, num do
		table.insert(state.people, people_mod.create(i, i))
	end

	-- Open window
	window.open()

	-- Start timer
	state.running = true
	state.tick_count = 0
	local interval = math.floor(1000 / config.user_config.animation.fps)

	state.timer = vim.loop.new_timer()
	state.timer:start(
		0,
		interval,
		vim.schedule_wrap(function()
			local ok, err = pcall(tick)
			if not ok then
				vim.schedule(function()
					vim.notify("[e-office] animation error: " .. tostring(err), vim.log.levels.ERROR)
				end)
				M.stop()
			end
		end)
	)
end

function M.stop()
	state.running = false
	if state.timer then
		if not state.timer:is_closing() then
			state.timer:stop()
			state.timer:close()
		end
		state.timer = nil
	end
	window.close()
	state.people = {}
end

function M.is_running()
	return state.running
end

return M
