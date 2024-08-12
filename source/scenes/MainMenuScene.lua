
MainMenuScene = {}
class("MainMenuScene").extends(GenericScene)
local scene = MainMenuScene

function scene:doReset()
    Char.Data = CharacterSheet.new()
    Noble.transition(StartAdventure, nil, Noble.Transition.DipToBlack)
end

function scene:doContinue()
    Noble.transition(Adventuring, nil, Noble.Transition.DipToBlack)
end

function scene:doCredits()
    Noble.transition(Credits, nil, Noble.Transition.DipToBlack)
end

function scene:init()
    scene.super.init(self)
    
    Music:play("dark-castle")

	self.logo = Graphics.image.new("assets/images/logo")
    self.underlogo = Graphics.imagetable.new("assets/images/underlogo")

	self.sequence = nil	
    self.menu = Noble.Menu.new(false, Noble.Text.ALIGN_CENTER, false, Graphics.kColorWhite, 4, 6, 2, Font)
    
    local w, h = playdate.display.getSize()
    self.menuX = w / 2 - self.menu.width / 8
	self.menuYFrom = h / 2 + 40
	self.menuY = h / 2 + 50
	self.menuYTo = 240
    
    self.underlogoFrame = 1
    self.underlogoTime = 0
end

function scene:enter()
    scene.super.enter(self)
 
    Char.Data = Noble.GameData.get("Character") or CharacterSheet.new()

    if Char.Data.Ready then
        self.menu:addItem("Continue", scene.doContinue)
        self.menu:addItem("Reset", scene.doReset)
    else
        self.menu:addItem("Adventure", scene.doReset)
    end

    self.menu:addItem("Credits", scene.doCredits)
 
	self.sequence = Sequence.new():from(self.menuYFrom):to(self.menuY, 1.5, Ease.outBounce):start()
end

function scene:start()
    scene.super.start(self)
	self.menu:activate()
end

function scene:update()
	scene.super.update(self)

    self.underlogoTime = self.underlogoTime + 1
    if self.underlogoTime > 10 then 
        self.underlogoTime = 0
        self.underlogoFrame = self.underlogoFrame + 1
        if self.underlogoFrame == 5 then
            self.underlogoFrame = 1
        end
    end 

    local w, h = playdate.display.getSize()
    Graphics.setColor(Graphics.kColorBlack)
	Graphics.fillRect(0, 0, w, h)
    self.underlogo:drawImage(self.underlogoFrame, w / 2 - 129, 122)
    self.logo:draw(w / 2 - 129, 10)
    self.menu:draw(self.menuX + 5, self.sequence:get() + 8 or self.menuY + 8)
end

function scene:exit()
	scene.super.exit(self)
	self.sequence = Sequence.new():from(self.menuY):to(self.menuYTo, 0.5, Ease.inSine)
	self.sequence:start()
end