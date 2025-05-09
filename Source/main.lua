cauldron = import "cauldron"

local gfx <const> = cauldron.graphics
local fsm <const> = cauldron.fsm
local cut <const> = cauldron.cutscene
local mus <const> = cauldron.music
local sfx <const> = cauldron.sfx
local sav <const> = cauldron.save

local game <const> = fsm.new("game")

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
end

local function load_images()
	gfx.load_image("seal", "images//secret_seal.png")
end

local function load_cutscenes()
	cut.load("intro", "cutscenes//intro")
end

local function load_music()
	mus.prepare({
		{ name = "intro", path = "music//intro.mp3", rate = 0.7 },
		{ name = "fight", path = "music//phase1.mp3" },
		{ name = "boss", path = "music//phase2.mp3" },
		{ name = "sanctuary", path = "music//sanctuary.mp3" }
	})

	sfx.prepare({
		{ name = "start", path = "sfx//ack.wav" },
		{ name = "laugh", path = "sfx//evil_laugh.wav" },
		{ name = "collect", path = "sfx//blop.wav" },
		{ name = "break", path = "sfx//orb_break.wav" },
		{ name = "full", path = "sfx//orb_full.wav", volume = 0.5 },
		{ name = "summon", path = "sfx//summon.wav", volume = 0.5 },
		{ name = "scream", path = "sfx//crush.wav", volume = 0.4 },
	})
end

local function load_game_fsm()
	game:add_state("game start")
	game:add_state("intro")
	game:add_state("menu")
	import "title_screen"
	game:add_state("run start")
	import "sanctuary_screen"
	game:add_state("demon intro")
	game:add_state("bullethell")
	game:add_state("demon dialogue")
	game:add_state("demon shaming")
	game:add_state("reward screen")
	game:add_state("seal select")
	game:add_state("item description")
	game:add_state("win cue")
	game:add_state("credits")

	game:add_on_enter_hook("game start", function()
		mus.play("intro")
		local saved_game_exists, _ = sav.load(default_save())

		if saved_game_exists then
			game:follow("game start->menu")
		else
			game:follow("game start->intro")
		end
	end)

	game:add_link("game start", "intro", "game start->intro", function()
		cut.play("intro", function()
			game:follow("intro->menu")
		end)
	end)

	game:add_link("game start", "menu", "game start->menu")
	game:add_link("intro", "menu", "intro->menu")

	game:add_link("menu", "run start", "menu->run start")
	game:init()
end

function cauldron.load()
	playdate.display.setRefreshRate(30)
	sav.init("witchbane_savefile", true)

	load_fonts()
	load_images()
	load_music()
	load_cutscenes()
	load_game_fsm()
end

function cauldron.debug(message)
end

function cauldron.update()
	game:update()
end

function cauldron.draw()
	game:draw()
end

cauldron.init()