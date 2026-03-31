local M = {}

local config = require("e_office.config")
local highlights = require("e_office.highlights")
local animation = require("e_office.animation")

function M.setup(user_config)
	config.setup(user_config)

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = vim.api.nvim_create_augroup("EOfficeHighlights", { clear = true }),
		callback = function()
			highlights.clear_cache()
		end,
	})

	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = vim.api.nvim_create_augroup("EOfficeCleanup", { clear = true }),
		callback = function()
			animation.stop()
		end,
	})

	if config.user_config.auto_start then
		animation.start()
	end
end

function M.start()
	animation.start()
end

function M.stop()
	animation.stop()
end

function M.toggle()
	if animation.is_running() then
		animation.stop()
	else
		animation.start()
	end
end

local function show_help()
	local lines = {
		"e-office.nvim - Virtual pixel office for Neovim",
		"",
		"Commands:",
		"  :EOffice          Toggle the office window on/off",
		"  :EOffice start    Open the office and start animation",
		"  :EOffice stop     Close the office and stop animation",
		"  :EOffice help     Show this help message",
		"",
		"Lua API:",
		"  require('e_office').setup(opts)  Configure the plugin",
		"  require('e_office').toggle()     Toggle on/off",
		"  require('e_office').start()      Start the office",
		"  require('e_office').stop()       Stop the office",
		"",
		"Configuration (defaults):",
		"  {",
		"    window = { width = 40, height = 18, border = 'rounded' },",
		"    animation = { fps = 4, typing_speed = 2 },",
		"    office = { num_people = 3, workstations = 4 },",
		"    auto_start = false,",
		"  }",
	}
	for _, line in ipairs(lines) do
		vim.api.nvim_echo({ { line, "Normal" } }, false, {})
	end
end

vim.api.nvim_create_user_command("EOffice", function(opts)
	local subcmd = opts.fargs[1]
	if subcmd == "start" then
		M.start()
	elseif subcmd == "stop" then
		M.stop()
	elseif subcmd == "help" then
		show_help()
	else
		M.toggle()
	end
end, {
	nargs = "?",
	complete = function()
		return { "start", "stop", "help" }
	end,
	desc = "Toggle the virtual pixel office",
})

return M
