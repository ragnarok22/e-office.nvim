local config = require("e_office.config")
local people = require("e_office.people")
local scene = require("e_office.scene")

describe("people", function()
	before_each(function()
		config.setup({})
		math.randomseed(42)
	end)

	describe("create", function()
		it("creates a person at the assigned desk", function()
			local person = people.create(1, 1)
			local seat = scene.desk_seats[1]
			assert.are.equal(1, person.id)
			assert.are.equal(1, person.desk_id)
			assert.are.equal(seat.x, person.x)
			assert.are.equal(seat.y, person.y)
		end)

		it("starts in SITTING_TYPING state", function()
			local person = people.create(1, 1)
			assert.are.equal(people.STATES.SITTING_TYPING, person.state)
		end)

		it("starts at frame 0 with 0 ticks", function()
			local person = people.create(1, 1)
			assert.are.equal(0, person.frame)
			assert.are.equal(0, person.ticks_in_state)
		end)

		it("has a positive state_duration", function()
			local person = people.create(1, 1)
			assert.is_true(person.state_duration >= 40)
			assert.is_true(person.state_duration <= 120)
		end)

		it("creates people at different desks", function()
			local p1 = people.create(1, 1)
			local p2 = people.create(2, 3)
			assert.are.equal(scene.desk_seats[1].x, p1.x)
			assert.are.equal(scene.desk_seats[3].x, p2.x)
		end)
	end)

	describe("get_sprite", function()
		it("returns a sprite for SITTING_TYPING", function()
			local person = people.create(1, 1)
			local sprite = people.get_sprite(person)
			assert.is_table(sprite)
			assert.are.equal(2, #sprite)
		end)

		it("returns a sprite for WALKING", function()
			local person = people.create(1, 1)
			person.state = people.STATES.WALKING
			local sprite = people.get_sprite(person)
			assert.is_table(sprite)
			assert.are.equal(3, #sprite)
		end)

		it("returns a sprite for IDLE", function()
			local person = people.create(1, 1)
			person.state = people.STATES.IDLE
			local sprite = people.get_sprite(person)
			assert.is_table(sprite)
			assert.are.equal(3, #sprite)
		end)

		it("returns a sprite for STANDING", function()
			local person = people.create(1, 1)
			person.state = people.STATES.STANDING
			local sprite = people.get_sprite(person)
			assert.is_table(sprite)
			assert.are.equal(2, #sprite)
		end)

		it("alternates sitting_typing frames", function()
			local person = people.create(1, 1)
			person.frame = 0
			local s0 = people.get_sprite(person)
			person.frame = 1
			local s1 = people.get_sprite(person)
			assert.are_not.equal(s0, s1)
		end)
	end)

	describe("update", function()
		it("increments ticks_in_state", function()
			local person = people.create(1, 1)
			people.update(person, 2)
			assert.are.equal(1, person.ticks_in_state)
		end)

		it("advances typing frame on typing_speed interval", function()
			local person = people.create(1, 1)
			people.update(person, 2)
			assert.are.equal(0, person.frame)
			people.update(person, 2)
			assert.are.equal(1, person.frame)
		end)

		it("transitions from SITTING_TYPING to STANDING after duration", function()
			local person = people.create(1, 1)
			person.state_duration = 3
			for _ = 1, 3 do
				people.update(person, 2)
			end
			assert.are.equal(people.STATES.STANDING, person.state)
			assert.are.equal(0, person.ticks_in_state)
		end)

		it("transitions from STANDING to WALKING or IDLE", function()
			local person = people.create(1, 1)
			person.state = people.STATES.STANDING
			person.state_duration = 1
			person.ticks_in_state = 0

			people.update(person, 2)
			local valid = person.state == people.STATES.WALKING or person.state == people.STATES.IDLE
			assert.is_true(valid)
		end)

		it("moves toward target when WALKING", function()
			local person = people.create(1, 1)
			person.state = people.STATES.WALKING
			person.target_x = person.x + 5
			person.target_y = person.y + 3
			local orig_x = person.x
			local orig_y = person.y

			people.update(person, 2)
			assert.are.equal(orig_x + 1, person.x)
			assert.are.equal(orig_y + 1, person.y)
		end)

		it("transitions to IDLE when arriving at non-desk target", function()
			local person = people.create(1, 1)
			person.state = people.STATES.WALKING
			person.target_x = 20
			person.target_y = 10
			person.x = 20
			person.y = 10

			people.update(person, 2)
			assert.are.equal(people.STATES.IDLE, person.state)
		end)

		it("transitions to SITTING_TYPING when arriving back at desk", function()
			local person = people.create(1, 1)
			local seat = scene.desk_seats[1]
			person.state = people.STATES.WALKING
			person.target_x = seat.x
			person.target_y = seat.y
			person.x = seat.x
			person.y = seat.y

			people.update(person, 2)
			assert.are.equal(people.STATES.SITTING_TYPING, person.state)
		end)

		it("IDLE transitions to WALKING back to desk", function()
			local person = people.create(1, 1)
			person.state = people.STATES.IDLE
			person.state_duration = 1
			person.ticks_in_state = 0
			person.x = 20
			person.y = 10

			people.update(person, 2)
			assert.are.equal(people.STATES.WALKING, person.state)
			local seat = scene.desk_seats[1]
			assert.are.equal(seat.x, person.target_x)
			assert.are.equal(seat.y, person.target_y)
		end)

		it("walking sets direction based on movement", function()
			local person = people.create(1, 1)
			person.state = people.STATES.WALKING
			person.target_x = person.x - 10
			person.target_y = person.y

			people.update(person, 2)
			assert.are.equal(-1, person.direction)
		end)
	end)

	describe("full lifecycle", function()
		it("cycles through all states without errors", function()
			local person = people.create(1, 1)
			for _ = 1, 500 do
				people.update(person, 2)
			end
			local valid_states = {
				[people.STATES.SITTING_TYPING] = true,
				[people.STATES.STANDING] = true,
				[people.STATES.WALKING] = true,
				[people.STATES.IDLE] = true,
			}
			assert.is_true(valid_states[person.state] ~= nil)
		end)
	end)
end)
