local cauldron <const> = import "cauldron"

local gfx <const> = cauldron.graphics
local fsm <const> = cauldron.fsm
local cut <const> = cauldron.cutscene

function cauldron.load()
	gfx.load_font("small", "font//topaz_11")
	gfx.load_font("big", "font//Mini Sans 2X")
	gfx.load_image("boss", "images//boss.png")

	cut.load("test", "cutscenes//test")

	local game = fsm.new("game")
	game:add_state("start")
	game:add_state("intro")
	game:add_state("menu")
	game:add_state("run start")
	game:add_state("demon intro")
	game:add_state("bullethell")
	game:add_state("demon dialogue")
	game:add_state("demon shaming")
	game:add_state("reward screen")
	game:add_state("seal select")
	game:add_state("item description")
	game:add_state("win cue")
	game:add_state("credits")

	game:add_on_enter_hook("start", function()
		local savefile = playdate.datastore.read("witchbane_savefile")
		if savefile == nil then
			local save = {
				version = 1,
				premonition = false,
				fourth_seal = false,
				fifth_seal = false,
				sixth_seal = false,
				crossroads = false,
				blindfold = false,
				shackles = false,
				oomancy = false,
				shroud = false,
				trunk = false,
			}
			playdate.datastore.write(save, "witchbane_savefile", false)
			game:follow("start->intro")
		else
			game:follow("start->menu")
		end
	end)

	game:add_link("start", "intro", "start->intro", function()
		cut.play("test", function()
			game:follow("intro->menu")
		end)
	end)

	game:add_link("start", "menu", "start->menu", function() print("BAR") end)
	game:add_link("intro", "menu", "intro->menu", function() print("BAZ") end)

	game:init()
end

function cauldron.debug(message)
end

function cauldron.update()
end

function cauldron.draw()
	gfx.clear()
	gfx.set_font("big")
	gfx.draw_text(10, 10, "Hello world")
	gfx.draw_image(100, 100, "boss")
end

cauldron.init()