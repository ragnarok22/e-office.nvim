local M = {}

local sprites = require("e_office.sprites")
local scene = require("e_office.scene")
local palette = require("e_office.palette")

local STATES = {
	SITTING_TYPING = "SITTING_TYPING",
	STANDING = "STANDING",
	WALKING = "WALKING",
	IDLE = "IDLE",
}

M.STATES = STATES

local function rand_range(lo, hi)
	return math.random(lo, hi)
end

local function random_walkable_pos()
	local w = scene.walkable
	return rand_range(w.x_min, w.x_max - sprites.width), rand_range(w.y_min, w.y_max)
end

function M.create(id, desk_id)
	local seat = scene.desk_seats[desk_id]
	local num_variants = #palette.person_variants
	return {
		id = id,
		x = seat.x,
		y = seat.y,
		state = STATES.SITTING_TYPING,
		frame = 0,
		desk_id = desk_id,
		color_variant = ((id - 1) % num_variants) + 1,
		target_x = nil,
		target_y = nil,
		ticks_in_state = 0,
		state_duration = rand_range(40, 120),
		direction = 1,
	}
end

function M.get_sprite(person)
	local state = person.state
	local frame = person.frame

	if state == STATES.SITTING_TYPING then
		local frames = sprites.sitting_typing
		return frames[(frame % #frames) + 1]
	elseif state == STATES.STANDING then
		return sprites.standing_at_desk[1]
	elseif state == STATES.WALKING then
		local frames = sprites.walking
		return frames[(frame % #frames) + 1]
	else -- IDLE
		return sprites.idle[1]
	end
end

function M.update(person, typing_speed)
	person.ticks_in_state = person.ticks_in_state + 1

	if person.state == STATES.SITTING_TYPING then
		-- Animate typing
		if person.ticks_in_state % typing_speed == 0 then
			person.frame = person.frame + 1
		end
		-- Transition to standing after duration
		if person.ticks_in_state >= person.state_duration then
			person.state = STATES.STANDING
			person.ticks_in_state = 0
			person.state_duration = rand_range(5, 10)
			person.frame = 0
		end
	elseif person.state == STATES.STANDING then
		if person.ticks_in_state >= person.state_duration then
			-- Decide: walk somewhere or go idle briefly then walk
			if math.random() < 0.7 then
				person.state = STATES.WALKING
				local tx, ty = random_walkable_pos()
				person.target_x = tx
				person.target_y = ty
			else
				person.state = STATES.IDLE
				person.state_duration = rand_range(10, 30)
			end
			person.ticks_in_state = 0
			person.frame = 0
		end
	elseif person.state == STATES.WALKING then
		-- Move toward target
		if person.x < person.target_x then
			person.x = person.x + 1
			person.direction = 1
		elseif person.x > person.target_x then
			person.x = person.x - 1
			person.direction = -1
		end

		if person.y < person.target_y then
			person.y = person.y + 1
		elseif person.y > person.target_y then
			person.y = person.y - 1
		end

		-- Animate walk cycle
		if person.ticks_in_state % 2 == 0 then
			person.frame = person.frame + 1
		end

		-- Arrived at target?
		if person.x == person.target_x and person.y == person.target_y then
			-- If we were heading back to desk, sit down
			local seat = scene.desk_seats[person.desk_id]
			if person.target_x == seat.x and person.target_y == seat.y then
				person.state = STATES.SITTING_TYPING
				person.state_duration = rand_range(40, 120)
			else
				person.state = STATES.IDLE
				person.state_duration = rand_range(10, 30)
			end
			person.ticks_in_state = 0
			person.frame = 0
		end
	elseif person.state == STATES.IDLE then
		if person.ticks_in_state >= person.state_duration then
			-- Go back to desk
			person.state = STATES.WALKING
			local seat = scene.desk_seats[person.desk_id]
			person.target_x = seat.x
			person.target_y = seat.y
			person.ticks_in_state = 0
			person.frame = 0
		end
	end
end

return M
