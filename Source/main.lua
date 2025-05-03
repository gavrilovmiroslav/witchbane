local cauldron <const> = import "cauldron"

local gfx <const> = cauldron.graphics
local fsm <const> = cauldron.fsm
local cut <const> = cauldron.cutscene
local sav <const> = cauldron.save

local function default_save()
	return {
		score = 0,
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
end

local function load_fonts()
	gfx.load_font("small", "font//topaz_11")
	gfx.load_font("big", "font//Mini Sans 2X")
	gfx.load_image("boss", "images//boss.png")
end

local function load_cutscenes()
	cut.load("intro", "cutscenes//intro")
end

local function load_game_fsm()
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
		local saved_game_exists, _ = sav.load(default_save())

		if saved_game_exists then
			game:follow("start->menu")
		else
			game:follow("start->intro")
		end
	end)

	game:add_link("start", "intro", "start->intro", function()
		cut.play("intro", function()
			game:follow("intro->menu")
		end)
	end)

	game:add_link("start", "menu", "start->menu")
	game:add_link("intro", "menu", "intro->menu")

	game:init()
end

function cauldron.load()
	sav.init("witchbane_savefile", true)

	load_fonts()
	load_cutscenes()
	load_game_fsm()
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