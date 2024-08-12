StartAdventure = {}
class("StartAdventure").extends(GenericScene)
local scene = StartAdventure

function scene:setValues()
	self.background = Graphics.image.new("assets/images/background1")

	self.menu = nil
	self.sequence = nil

	self.menuX = 15

	self.menuYFrom = 15
	self.menuY = 15
	self.menuYTo = 240

	self.campaigns = {
		"HedgeWitch",
		"HedgeWitch",
		"HedgeWitch",
		"HedgeWitch",
		"HedgeWitch",
	}

	self.decks = {
		{},
		{},
		{},
		{},
		{},
	}

	self.bonuses = {
		function(stats) 
			stats.herbs = stats.herbs + 2
			stats.familiars = stats.familiars + 1
		end,

		function(stats) 
			stats.herbs = stats.herbs + 1
			stats.artifacts = stats.artifacts + 1
		end,

		function(stats) 
			stats.affluence = stats.affluence - 1
			stats.familiars = stats.familiars + 4
			stats.suspicion = stats.suspicion + 2
		end,

		function(stats) 
			stats.artifacts = stats.artifacts + 1
			stats.coven = stats.coven + 1
			stats.affluence = stats.affluence + 1
			stats.suspicion = stats.suspicion + 3
		end,

		function(stats) 
			stats.artifacts = stats.artifacts + 2
			stats.suspicion = stats.suspicion + 3
		end,
	}
end

function scene:init()
	scene.super.init(self)

	self:setValues()

	self.menu = Noble.Menu.new(false, Noble.Text.ALIGN_LEFT, false, Graphics.kColorWhite, 4, 4, 2, Font)

	self:setupMenu(self.menu)
end

function scene:enter()
	scene.super.enter(self)
	self.sequence = Sequence.new():from(self.menuYFrom):to(self.menuY, 1.5, Ease.outBounce):start()
end

function scene:start()
	scene.super.start(self)

	self.menu:activate()
end

function scene:exit()
	scene.super.exit(self)
	self.sequence = Sequence.new():from(self.menuY):to(self.menuYTo, 0.5, Ease.inSine)
	self.sequence:start();
end

function scene:setupMenu(__menu)
	-- +2 herbs, +1 familiar
	__menu:addItem("fledgling hedge-witch.", function() self:pickCharacter(1) end)
	-- +1 herbs, +1 artifacts
	__menu:addItem("traveling diviner.", function() self:pickCharacter(2) end)
	-- +4 familiars, +2 suspicion
	__menu:addItem("sensitive soul.", function() self:pickCharacter(3) end)
	-- +1 artifacts, +1 coven, +1 gold, +3 suspicion
	__menu:addItem("brave coven leader.", function() self:pickCharacter(4) end)
	-- +2 artifacts, +3 suspicion
	__menu:addItem("heretical warlock.", function() self:pickCharacter(5) end)
end

function scene:drawBackground()
	scene.super.drawBackground(self)

	self.background:draw(0, 0)
end

function scene:update()
	scene.super.update(self)

	Graphics.setColor(Graphics.kColorBlack)
	Graphics.setDitherPattern(0.2, Graphics.image.kDitherTypeScreen)
	Graphics.fillRoundRect(self.menuX, self.sequence:get() or self.menuY, 285, 300, 15)	
	Graphics.setColor(Graphics.kColorWhite)
	Graphics.setDitherPattern(1.0, Graphics.image.kDitherTypeScreen)
	
	Graphics.drawInvertedText("You are a...", 35, 30)
	self.menu:draw(self.menuX + 35, self.sequence:get() + 38 or self.menuY + 8)

	Char.Data.Portrait = self.menu.currentItemNumber
	Char:draw(true, self.bonuses)
end

function scene:pickCharacter(index)
	local bonuses = self.bonuses
	self.bonuses = nil
	bonuses[Char.Data.Portrait](Char.Data.Resources)

	Char.Data.Campaign = self.campaigns[Char.Data.Portrait]
	
	Char.Data.Ready = true
	Noble.GameData.set("Character", Char.Data)
	Noble.GameData.save()
	Noble.transition(Adventuring, nil, Noble.Transition.DipToBlack)
	Music:fadeout()
end
