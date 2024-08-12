Credits = {}
class("Credits").extends(GenericScene)
local scene = Credits

function scene:init()
	scene.super.init(self)

	local takes = {
		"[ DESIGN, CODE, DITHER ]",
		"Miroslav Gavrilov",
		"",
		"[ CHARACTER PORTRAITS ]",
		"Sleepless Seven",
		"",
		"[ RESOURCE ICONS ]",
		"RPG Pixel",
		"",
		"[ MUSIC ]",
		"David Feslyian"
	}

	self.printout = table.concat(takes, "\n")

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

function scene:update()
	scene.super.update(self)

	local w, h = playdate.display.getSize()
	Graphics.drawInvertedTextAligned("CREDITS", w / 2, 20, kTextAlignment.center)
	Graphics.drawInvertedTextAligned(self.printout, w / 2, 50, kTextAlignment.center)

	self.menu:draw(w / 2, h - 30)
end