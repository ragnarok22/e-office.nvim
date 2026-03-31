local config = require("e_office.config")

describe("config", function()
	before_each(function()
		config.user_config = {}
	end)

	describe("setup", function()
		it("uses defaults when called with no arguments", function()
			config.setup()
			assert.are.equal(40, config.user_config.window.width)
			assert.are.equal(15, config.user_config.window.height)
			assert.are.equal("rounded", config.user_config.window.border)
			assert.are.equal(4, config.user_config.animation.fps)
			assert.are.equal(2, config.user_config.animation.typing_speed)
			assert.are.equal(3, config.user_config.office.num_people)
			assert.are.equal(4, config.user_config.office.workstations)
			assert.is_false(config.user_config.auto_start)
		end)

		it("uses defaults when called with empty table", function()
			config.setup({})
			assert.are.equal(40, config.user_config.window.width)
			assert.are.equal(3, config.user_config.office.num_people)
		end)

		it("merges user overrides with defaults", function()
			config.setup({
				window = { width = 60 },
				office = { num_people = 2 },
			})
			assert.are.equal(60, config.user_config.window.width)
			assert.are.equal(15, config.user_config.window.height)
			assert.are.equal(2, config.user_config.office.num_people)
			assert.are.equal(4, config.user_config.office.workstations)
		end)

		it("clamps num_people to 1-4", function()
			config.setup({ office = { num_people = 0 } })
			assert.are.equal(1, config.user_config.office.num_people)

			config.setup({ office = { num_people = 10 } })
			assert.are.equal(4, config.user_config.office.num_people)
		end)

		it("clamps workstations to 1-4", function()
			config.setup({ office = { workstations = -1 } })
			assert.are.equal(1, config.user_config.office.workstations)

			config.setup({ office = { workstations = 99 } })
			assert.are.equal(4, config.user_config.office.workstations)
		end)

		it("clamps fps to 1-30", function()
			config.setup({ animation = { fps = 0 } })
			assert.are.equal(1, config.user_config.animation.fps)

			config.setup({ animation = { fps = 100 } })
			assert.are.equal(30, config.user_config.animation.fps)
		end)

		it("does not mutate the default config", function()
			local orig_width = config.default_config.window.width
			config.setup({ window = { width = 80 } })
			assert.are.equal(orig_width, config.default_config.window.width)
		end)
	end)
end)
