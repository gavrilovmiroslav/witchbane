import "CoreLibs/ui"

import "music"
import "player"
import "level"
import "utils"
import "bullethell"

local fsm = import "statemachine"
local tween = import "tween"
local music = music()

local gfx <const> = playdate.graphics

local flips <const> = {
	gfx.kImageUnflipped,
	gfx.kImageFlippedX,
	gfx.kImageFlippedY,
	gfx.kImageFlippedXY,
}

local font <const> = gfx.font.new('font/topaz_11')
local side <const> = gfx.image.new('images/transition.png')
local side_mask <const> = gfx.image.new('images/transition_mask.png')
local side_masks = {}
local asmodeus <const> = gfx.image.new('images/demons/asmodeus.png')
local white <const> = gfx.image.new('images/break.png')
local black <const> = gfx.image.new('images/black.png')
local logo <const> = gfx.image.new('images/logo.png')
local seal <const> = gfx.image.new('images/secret_seal.png')
local logo_glow <const> = gfx.image.new('images/logo_glow.png')
local player <const> = player()
local current_level = nil

local tweens = {}
local vars = {}

local fsm_game <const> = fsm.create({
	initial = 'title_screen',
	events = {
		{ name = 'start_game', from = 'title_screen', to = 'bullethell' }, -- to: deckbuilding
		{ name = 'choose_fate', from = 'deckbuilding', to = 'bullethell' },
		{ name = 'meet_the_enemy', from = 'bullethell', to = 'enemy_screen' },
		{ name = 'back_to_level', from = 'enemy_screen', to = 'bullethell' },
		{ name = 'continue_game', from = 'bullethell', to = 'deckbuilding' },
		{ name = 'defeat', from = 'bullethell', to = 'title_screen' }
	},
	callbacks = {
		onstart_game = function(self, event, from, to, msg) 
			vars.level_index = 1
			current_level = level()
			current_level:load(vars.level_index, 0)
		end,
	}
})

-- TITLE SCREEN

local function update_title_screen()
	if tweens.title_fade == nil then
		music:play_music("intro")
		vars.title_done = false
		vars.title_crank = 0
		vars.title_glow = 0
		vars.title_fade = { value = 0 }
		tweens.title_fade = tween.new(30, vars.title_fade, { value = 1 }, 'outCubic')
	else
		tweens.title_fade:update(0.1)
		if tweens.title_fadeout ~= nil then tweens.title_fadeout:update(0.1) end

		if not vars.title_done then
			local c, a = playdate.getCrankChange()
			if c < 0 then c = 0 end
			vars.title_crank = vars.title_crank + c
			if vars.title_crank >= 360 then
				vars.title_crank = 360
				vars.title_done = true
				music:play_start_game_sound()
				music:fadeout_music("fight")
				vars.title_fadeout = { value = 0 }
				tweens.title_fadeout = tween.new(5, vars.title_fadeout, { value = 1 }, 'outCubic')
			end
			if c == 0 and a == 0 and playdate.getCrankPosition() > 0 then
				vars.title_crank = vars.title_crank - 0.1
				if vars.title_crank < 0 then vars.title_crank = 0 end
			end
			vars.title_glow = vars.title_glow + 1
			if vars.title_glow > 380 then
				vars.title_glow = 0
			end
		end
	end
end

local function draw_title_screen()
	logo:drawFaded(0, 0, vars.title_fade.value, gfx.image.kDitherTypeBayer4x4)
	logo_glow:draw(vars.title_glow - 20, -1, gfx.kImageUnflipped, playdate.geometry.rect.new(vars.title_glow - 20, 0, 50, 100))
	logo_glow:draw(vars.title_glow, -1, gfx.kImageUnflipped, playdate.geometry.rect.new(vars.title_glow, 0, 20, 240))
	gfx.setImageDrawMode(playdate.graphics.kDrawModeInverted)
	if vars.title_crank > 0 then
		gfx.drawArc(200, 170, 30, 0, vars.title_crank or 0)
		local a = deg2rad(vars.title_crank - 90)
		local x, y = 30 * math.cos(a), 30 * math.sin(a)
		gfx.setColor(gfx.kColorBlack)
		gfx.fillCircleAtPoint(200 + x, 170 + y, 8)
		gfx.setColor(gfx.kColorWhite)
		gfx.fillCircleAtPoint(200 + x, 170 + y, 5)
		gfx.setColor(gfx.kColorWhite)
		gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)
		seal:drawFaded(200 - 30, 170 - 30, vars.title_crank / 360, gfx.image.kDitherTypeBayer2x2)
	end
	gfx.setColor(gfx.kColorBlack)
	gfx.fillRect(0, 160, 400, 12)
	gfx.setColor(gfx.kColorWhite)
	gfx.setImageDrawMode(playdate.graphics.kDrawModeInverted)
	font:drawTextAligned("CRANK: Begin Ritual", 200, 160, kTextAlignment.center)
	gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)
	if vars.title_done then
		black:drawFaded(0, 0, vars.title_fadeout.value, gfx.image.kDitherTypeBayer2x2)
		if vars.title_fadeout.value == 1 then
			fsm_game:start_game()
		end
	elseif vars.title_crank == 0 then
		playdate.ui.crankIndicator:draw()
	end
end

-- DECKBUILDING

local function update_deckbuilding()
end

local function draw_deckbuilding()
end

-- BULLETHELL

local function update_bullethell()
	if current_level ~= nil then
		local scenario = current_level.scenario
		if scenario ~= nil then
			local config = scenario.data.config
			if player.summon_progress >= config.req then
				if player.phase == 1 then
					player.phase = 2
					fsm_game:meet_the_enemy()
				elseif player.phase == 2 then
					print("WINNER!")
				end
			end
		end
	end

	local orbx, orby, orbr = player:get_orb_center_and_radius()
	if player.phase == 2 then orbr = nil end
	local old_score = player.score
	local scored = current_level:update(orbx, orby, orbr, music)
	if scored > 0 then
		music:play_collect_sound(1 + math.min(1, player.score / player.limit) * 0.5)
	end
	player:update(scored)
	local new_score = player.score
	if old_score < player.limit and new_score >= player.limit then
		music:play_full_sound()
	end

	if player.summoned then
		player.summoned = false
		music:play_summon_sound()
	end

	if player.defeat then
		music:play_laugh_sound()
		playdate.wait(500)
		fsm_game:defeat()
	end
end

local function draw_bullethell()
	current_level:draw()
	player:draw_shade()
	current_level:draw_scenario(player.x)
	player:draw()

	if not player:is_invulnerable() then 
		local x, y = player:get_amulet_top_left()
		if current_level:get_scenario() ~= nil then
			if current_level:get_scenario():is_touching_rect(x, y, 1, 1) then
				player:start_invulnerability(100)
				if player.score > 0 then
					vars.breaking = true
					vars.breaking_time = -1
					vars.break_direction = math.random(1, #flips)
				end
				player:lose_points()
				music:play_break_sound()
			end
		end
	end

	player:draw_notifications()
end

-- ENEMY SCREEN

local function update_enemy_screen()
	if vars.enemy_screen == nil then
		vars.enemy_screen = gfx.image.new(400, 240)
		gfx.lockFocus(vars.enemy_screen)
		draw_bullethell()
		gfx.unlockFocus()
		music:play_laugh_sound()
		music:fadeout_music("boss")
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(0, 0, 400, 240)

		for i = 0, 3 do
			local back = gfx.image.new(400, 240)
			gfx.lockFocus(back)
			side_mask:draw(0, 0, playdate.graphics.kImageUnflipped,
				playdate.geometry.rect.new(400 * i, 0, 400, 240))
			gfx.unlockFocus()
			table.insert(side_masks, back)
		end

		vars.enemy_reveal_time = 0
		player.score = 0
		current_level:start_scenario("test2")
	else
		vars.enemy_reveal_time = vars.enemy_reveal_time + 1
		if vars.enemy_reveal_time >= 100 then
			fsm_game:back_to_level()
		end
	end
end

local function draw_enemy_screen()
	if vars.enemy_screen ~= nil then
		vars.enemy_screen:vcrPauseFilterImage():drawFaded(0, 0, 0.8, gfx.image.kDitherTypeBayer2x2)
		local t2 = math.floor(vars.enemy_reveal_time / 10)
		local k = math.floor(vars.enemy_reveal_time / 10)
		if k >= 3 then k = 3 end
		back = gfx.image.new(400, 240)
		gfx.lockFocus(back)
		asmodeus:draw(-t2, -t2)
		gfx.unlockFocus()
		back:setMaskImage(side_masks[k + 1])
		back:draw(0, 0, playdate.graphics.kImageUnflipped)
		font:drawText("Asmodeus", 180, 10)
		gfx.setImageDrawMode(playdate.graphics.kDrawModeInverted)
		font:drawText("Asmodeus", 182, 12)
		gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)
	else
		gfx.setColor(gfx.kColorWhite)
		gfx.fillRect(0, 0, 400, 240)
	end
end

--

local update_fns <const> = {
	title_screen = update_title_screen,
	deckbuilding = update_deckbuilding,
	bullethell = update_bullethell,
	enemy_screen = update_enemy_screen
}

local draw_fns <const> = {
	title_screen = draw_title_screen,
	deckbuilding = draw_deckbuilding,
	bullethell = draw_bullethell,
	enemy_screen = draw_enemy_screen
}

local function loadGame()
	playdate.display.setRefreshRate(50)
	math.randomseed(playdate.getSecondsSinceEpoch())
	gfx.setFont(font)
end

local t = 0
local t2 = 0
--local k = -1
--local liftK = false

local function updateGame()
	t = t + 1
	if t % 5 == 0 then t2 = t2 + 1 end

	if vars.breaking then
		if t % 2 == 0 then vars.breaking_time = vars.breaking_time + 1 end
		if vars.breaking_time >= 5 then
			vars.breaking = false
		end
	else
		update_fns[fsm_game.current]()
	end
end

local function drawGame()
	gfx.clear(gfx.kColorBlack)
	print(fsm_game.current)
	draw_fns[fsm_game.current]()

	if vars.breaking then
		white:draw(0, 0, flips[vars.break_direction], playdate.geometry.rect.new(math.max(0, vars.breaking_time) * 400, 0, 400, 240))
	end
end

loadGame()

function playdate.update()
	updateGame()
	drawGame()
	playdate.drawFPS(0, 0)
end
