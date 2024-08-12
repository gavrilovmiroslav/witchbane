
GenericScene = {}
class("GenericScene").extends(NobleScene)
local scene = GenericScene

function scene:selectUp()
	if self.menu ~= nil then
	    self.menu:selectPrevious()
    	Sounds:play("menu-move")
	end
end

function scene:selectDown()
	if self.menu ~= nil then
		self.menu:selectNext()
	    Sounds:play("menu-move")
	end
end

function scene:init()
    scene.super.init(self)

	local crankTick = { 0 }

	self.inputHandler = {
        upButtonDown = function()
			self:selectUp()
		end,
		downButtonDown = function()
			self:selectDown()
		end,
		cranked = function(change, acceleratedChange)
			crankTick[1] = crankTick[1] + change
			if (crankTick[1] > 30) then
				crankTick[1] = 0
				self:selectDown()
			elseif (crankTick[1] < -30) then
				crankTick[1] = 0
				self:selectUp()
			end
		end,
		AButtonDown = function()
			if self.menu ~= nil then
				self.menu:click()
			end
            Sounds:play("menu-select")
		end
    }
end

function scene:update()
	scene.super.update(self)
    Music:update()
end
