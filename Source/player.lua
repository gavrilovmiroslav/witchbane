import "CoreLibs/graphics"
import "CoreLibs/object"
import "utils"

local gfx <const> = playdate.graphics

player = {}
class("player").extends()

local image_wave <const> = gfx.image.new('images/wave.png')
local image_player <const> = gfx.image.new('images/player.png')
local image_player_shadow <const> = gfx.image.new('images/player_shadow.png')
local image_player_distant_shadow <const> = gfx.image.new('images/player_distant_shadow.png')
local image_player_shade <const> = gfx.image.new('images/shade.png')
local image_player_flame <const> = gfx.image.new('images/flame.png')

local circMask <const> = gfx.image.new(16, 16)
gfx.lockFocus(circMask)
gfx.setColor(gfx.kColorWhite)
gfx.fillCircleAtPoint(8, 8, 8)
gfx.unlockFocus()

local circ <const> = gfx.image.new(16, 16)
gfx.lockFocus(circ)
gfx.setColor(gfx.kColorWhite)
gfx.drawCircleAtPoint(8, 8, 8)
gfx.unlockFocus()

function player:init()
    self.x = 200
	self.y = 120
	self.offset = { { 200, 120 }, { 200, 120 }, { 200, 120 } }
	self.sprites = { image_player_distant_shadow, image_player_shadow, image_player }
	self.pt = 0
	self.ps = -1
	self.invulnerable_time = 0
	self.orb = { 0, 0 }
	self.wave_time = 0
	self.score = 0
	self.limit = 100
	self.crank_val = 0
	self.summon_wave_origin = nil
	self.summon_wave_size = 0
	self.summon_progress = 0
	self.phase = 1
	self.defeat = false
end

function player:lose_points()
	if self.phase == 1 then
		if self.score <= 0 and self.summon_progress > 0 then
			self.summon_progress = self.summon_progress - 1
		end

		self.score = -20
		self.crank_val = 0
	elseif self.phase == 2 then
		if self.summon_progress > 0 then
			self.summon_progress = self.summon_progress - 1
		else
			self.defeat = true
		end
	end
end

function player:update(scored)
	self.wave_time = self.wave_time + 1
	self.score = self.score + scored

	if self.invulnerable_time > 0 then
		self.invulnerable_time = self.invulnerable_time - 1
	end

	self.pt = self.pt + 1
	local playdate = playdate

	local dx, dy = 0, 0
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		self.ps = -1
		dx = -1
	elseif playdate.buttonIsPressed(playdate.kButtonRight) then
		self.ps = 1
		dx = 1
	end

	if playdate.buttonIsPressed(playdate.kButtonUp) then
		dy = -1
	elseif playdate.buttonIsPressed(playdate.kButtonDown) then
		dy = 1
	end

	if self.pt % 6 == 0 then
		self.offset[1][1], self.offset[1][2] = self.offset[2][1], self.offset[2][2]
	end

	if self.pt % 3 == 0 then
		self.offset[2][1], self.offset[2][2] = self.offset[3][1], self.offset[3][2]
	end

	local nx, ny = norm(dx, dy)
	local speed = 1.2
	if self:is_invulnerable() then speed = 0.8 end
	nx = nx * speed
	ny = ny * speed
	self.x, self.y = self.x + nx, self.y + ny
	self.offset[3][1], self.offset[3][2] = self.x, self.y

	if self.score >= self.limit then
		local c, a = playdate.getCrankChange()
		self.crank_val = self.crank_val + c
		if math.abs(self.crank_val) >= 360 then
			self.summoned = true
			self.crank_val = 0
			self.score = 0
			self.summon_wave_origin = { self.x, self.y }
			self.summon_wave_size = 10
			self.summon_progress = self.summon_progress + 1
		end
	end
end

local playerRect = playdate.geometry.rect.new(0, 0, 26, 26)
local unflipped = playdate.graphics.kImageUnflipped
local flipped = playdate.graphics.kImageFlippedX

function player:draw_shade()
	local playdate = playdate
	local graphics = playdate.graphics

	image_player_shade:draw(self.offset[3][1] - 48, self.offset[3][2] - 48)
end

function player:draw()
	local playdate = playdate
	local graphics = playdate.graphics

	if self.invulnerable_time % 2 == 0 then
		local index = math.max(0, math.min(2, math.floor((self.pt / 10) % 3)))
		playerRect.x = index * 26
		local flip = unflipped
		if self.ps > 0 then flip = flipped end

		for i = 1, 3 do
			self.sprites[i]:draw(self.offset[i][1], self.offset[i][2], flip, playerRect)
		end
	end

	graphics.setColor(graphics.kColorWhite)
	if self.phase == 1 then
		local angle = playdate.getCrankPosition()

		graphics.setLineWidth(1 + 5 * (self.crank_val / 360))
		graphics.setColor(graphics.kColorWhite)
		graphics.drawCircleAtPoint(self.x + 13, self.y + 13, 26)
		graphics.setLineWidth(6)

		local a = deg2rad(angle - 90)
		local x, y = 26 * math.cos(a), 26 * math.sin(a)
		local xl, yl = 26 * math.cos(a - 0.5), 26 * math.sin(a - 0.5)
		local xr, yr = 26 * math.cos(a + 0.5), 26 * math.sin(a + 0.5)

		graphics.setLineWidth(1)
		graphics.setColor(graphics.kColorBlack)
		graphics.fillCircleAtPoint(self.x + 13 + x, self.y + 13 + y, 9)
		graphics.fillCircleAtPoint(self.x + 13 + xl, self.y + 13 + yl, 5)
		graphics.fillCircleAtPoint(self.x + 13 + xr, self.y + 13 + yr, 5)
		graphics.setColor(graphics.kColorWhite)
		graphics.drawCircleAtPoint(self.x + 13 + x, self.y + 13 + y, 8)

		local wave = gfx.image.new(16, 16)
		gfx.lockFocus(wave)
		gfx.clear(gfx.kColorBlack)
		local dy = 16 - self.score / self.limit * 16
		if dy < -6 then dy = -6 end
		gfx.setImageDrawMode(gfx.kDrawModeCopy)
		image_wave:draw(0, dy, gfx.kImageUnflipped, playdate.geometry.rect.new(0, self.wave_time % 8 * 2, 16, 2))
		gfx.fillRect(0, dy + 1, 16, 100)
		gfx.unlockFocus()
		wave:setMaskImage(circMask)
		wave:draw(self.x + 13 + x - 8, self.y + 13 + y - 8)
		circ:draw(self.x + 13 + x - 8, self.y + 13 + y - 8)

		self.orb[1] = self.x + 13 + x
		self.orb[2] = self.y + 13 + y

		if self.summon_wave_origin ~= nil then
			self.summon_wave_size = self.summon_wave_size * 1.25
			gfx.drawCircleAtPoint(self.summon_wave_origin[1], self.summon_wave_origin[2], self.summon_wave_size)
			if self.summon_wave_size > 200 then
				self.summon_wave_origin = nil
				self.summon_wave_size = 0
			end
		end
	end

	graphics.setImageDrawMode(graphics.kDrawModeCopy)
	if self.summon_progress > 0 then
		local angle = 360 / self.summon_progress
		for i = 1, self.summon_progress do
			local a = deg2rad(i * angle - 90)
			local x, y = 27 * math.cos(a), 27 * math.sin(a)
			local idx = math.floor((i + self.wave_time) / 3) % 3
			image_player_flame:draw(self.x + x + 6, self.y + y + 6, graphics.kImageUnflipped,
				playdate.geometry.rect.new(idx * 16, 0, 16, 16))
		end
	end
end

-- /3 + 1/3
-- 0 1 2 3 4 5 6 7 8 9 10 11
-- 0 1/3 2/3 1
-- 0 0 0  
-- 0 0 0 1 1 1 2 2 2 0 0  0

function player:draw_notifications()
	if self.score >= self.limit then
		gfx.setColor(gfx.kColorBlack)
		gfx.drawCircleAtPoint(self.orb[1], self.orb[2], 6 + self.wave_time % 3)
		gfx.fillRect(110, 220, 180, 20)
		gfx.setColor(gfx.kColorWhite)
		gfx.drawCircleAtPoint(self.orb[1], self.orb[2], 12 + self.wave_time % 3)
		gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)
		gfx.drawTextAligned("CRANK: Summoning Circle", 200, 225, kTextAlignment.center)
		gfx.setImageDrawMode(playdate.graphics.kDrawModeCopy)
	end
end

function player:get_amulet_top_left()
	return self.x + 11, self.y + 17
end

function player:get_orb_center_and_radius()
	return self.orb[1], self.orb[2], 8
end

function player:start_invulnerability(t)
	self.invulnerable_time = t or 20
end

function player:is_invulnerable()
	return self.invulnerable_time > 0
end