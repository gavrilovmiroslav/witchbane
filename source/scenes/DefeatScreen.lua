DefeatScreen = {}
class("DefeatScreen").extends(GenericScene)
local scene = DefeatScreen

function scene:init()
	scene.super.init(self)
	self.menu = Noble.Menu.new(false, Noble.Text.ALIGN_CENTER, false, Graphics.kColorWhite, 4, 4, 2, Font)
	self.menu:addItem("BACK", function() Noble.transition(MainMenuScene, nil, Noble.Transition.DipToBlack) end)
end

function scene:start()
	scene.super.start(self)

	self.menu:activate()
end

function scene:enter()
	scene.super.enter(self)
end

function scene:drawBackground()
	scene.super.drawBackground(self)
	local w, h = playdate.display.getSize()
	Graphics.setColor(Graphics.kColorBlack)
	Graphics.fillRect(0, 0, w, h)
end

function scene:drawCard(_name, _x, _y)
	local w, h = playdate.display.getSize()
	Graphics.setColor(Graphics.kColorBlack)
	Graphics.fillRoundRect(_x + w / 2 - 64 - 4, _y + h / 2 - 100 - 4, 128 + 8, 200 + 8, 4)
	CardImages:drawImage(CardBacks[_name], _x + w / 2 - 64, _y + h / 2 - 100)
	CardFrames:drawImage(1, _x + w / 2- 64, _y + h / 2 - 100)
	Graphics.drawInvertedTextAligned("DEFEAT", _x + w / 2, _y + h / 2 + 68, kTextAlignment.center)
end

function scene:update()
	scene.super.update(self)

	local w, h = playdate.display.getSize()
	self:drawCard(Defeat, 0, 0)
	self.menu:draw(w / 2, h - 30)
end