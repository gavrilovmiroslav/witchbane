import "CoreLibs/graphics"
import "CoreLibs/object"

import "bullethell"
import "utils"

local playdate <const> = playdate
local gfx <const> = playdate.graphics

level = {}
class("level").extends()

local sigils <const> = gfx.image.new('images/sigils.png')
local sigil_mask <const> = gfx.image.new('images/sigil_mask.png')

current_level = {}

function level:start_scenario(name)
	self.scenario = bullethell()
	self.scenario:load(name)
	print("SCENARIO " .. name .. " LOADED!")
end

function level:stop_scenario()
	self.scenario = nil
	print("SCENARIO STOPPED!")
end

function level:get_scenario()
	return self.scenario
end

function level:init()
	self.level_time = 0
	self.scenario = nil
	current_level = self
end

function level:load(bx, by)
	self.level_time = 0
    local back_images = {}
    local index = by * 8 + bx

	if sigils ~= nil and sigil_mask ~= nil then
		for i = 0, 40, 4 do
			back = gfx.image.new(400, 400)
			gfx.lockFocus(back)
			sigils:draw(35, 35, playdate.graphics.kImageUnflipped, 
				playdate.geometry.rect.new(bx * 328, by * 328, 328, 328))
			back:drawBlurred(0, 0, i, math.ceil(i / 8), playdate.graphics.image.kDitherTypeBayer8x8)
			sigil_mask:drawFaded(35.5, 35.5, i / 10, playdate.graphics.image.kDitherTypeBayer8x8)
			gfx.unlockFocus()
			table.insert(back_images, back)
		end
	end

    self.back_images = back_images
	self:start_scenario("test")
end

playdate.serialMessageReceived = function(message)
	if string.starts(message, "load") then
		local content = string.sub(message, 5)
		current_level:start_scenario(content)
	elseif string.starts(message, "stop") then
		current_level:stop_scenario()
	end
end

function level:update(orbx, orby, orbr, music)
	self.level_time = self.level_time + 0.5
	if self.scenario ~= nil then
		return self.scenario:update(orbx, orby, orbr, music)
	end

	return 0
end

function level:draw()
	if self.back_images ~= nil then
		local index = math.min(math.ceil(self.level_time / 20), 10)
		self.back_images[index]:drawRotated(200, 120, self.level_time)
	end
end

function level:draw_scenario(plx)
	if self.scenario ~= nil then
		self.scenario:draw(plx)
		self.scenario:draw_vfx()
	end
end
