Adventuring = {}
class("Adventuring").extends(GenericScene)
local scene = Adventuring

function scene:init()
	scene.super.init(self)

	self.background = Graphics.image.new("assets/images/background1")
	self.sequence = nil
	self.bonusSequence = nil
	self.bonusSequenceLoop = nil
	self.bonusTexts = {}

	self.done = false
	self.choiceMade = false
	self.topicName = nil
	self.topic = nil
	self.disabledOptions = {}

	self.menuX = 15

	self.menuYFrom = 0
	self.menuY = 15
	self.menuYTo = 240

	self.frame = 1
	self.newWeek = false

	self.deck = nil
	self.portraitSequence = nil
	self.deckSequence = nil
	self.drawDeck = true
	self.cardAnims = {}

	self.inputHandler["AButtonDown"] = function()
		if self.menu ~= nil then
			self.menu:click()
		end
	end
end

function scene:whish(_time)
	playdate.timer.performAfterDelay(_time, function()
		Sounds:play("move2")
	end)
end

function scene:whoosh(_time)
	playdate.timer.performAfterDelay(_time, function()
		Sounds:play("move")
	end)
end

function scene:whosh(_time)
	playdate.timer.performAfterDelay(_time, function()
		Sounds:play("move3")
	end)
end

function scene:destroyCard(_offset)
	if _offset == nil then
		_offset = { x = math.random(-120, 120), y = math.random(-10, 10) }
	end

	playdate.timer.performAfterDelay(math.random(0, 100), function() 
		table.insert(self.cardAnims, CardDestroy.new(3, _offset))
		playdate.timer.performAfterDelay(200, function()
			Sounds:play("oneoff")
		end)
	end)
end

function scene:popCard(_name, _offset)
	if _offset == nil then
		_offset = { x = math.random(-120, 120), y = math.random(-10, 10) }
	end

	playdate.timer.performAfterDelay(math.random(0, 100), function() 
		Sounds:play("create")
		table.insert(self.cardAnims, CardAppear.new({ name = Titles[_name], image = CardBacks[_name] }, 2, _offset))
		self:whoosh(1700)
	end)
end

function scene:selectUp()
	if self.menu ~= nil and not self.done then
	    self.menu:selectPrevious()
    	Sounds:play("menu-move")
	end
end

function scene:selectDown()
	self.frame = self.frame + 1
	if self.frame > 7 then self.frame = 1 end
	if self.menu ~= nil and not self.done then
		self.menu:selectNext()
	    Sounds:play("menu-move")
	end
end

function scene:start()
	scene.super.start(self)
end

function scene:drawBackground()
	scene.super.drawBackground(self)

	self.background:draw(0, 0)
end

function scene:enter()
	scene.super.enter(self)
	self.sequence = Sequence.new():from(self.menuYFrom):to(self.menuY, 1, Ease.outBounce):start()
	
	local count = #Char.Data.Cards
	if count == 0 then
		-- new week!
		self.newWeek = true
		Char.Data.PlayedActions = 0
		Char.Data.Week = Char.Data.Week + 1
		table.shuffle(Char.Data.Discard)

		local remember = {}
		for _, card in pairs(Char.Data.Discard) do
			if Char.Data.Skip[card] ~= nil then
				Char.Data.Skip[card] = Char.Data.Skip[card] - 1
				if Char.Data.Skip[card] < 0 then
					Char.Data.Skip[card] = nil
					table.insert(Char.Data.Cards, card)
				else
					table.insert(remember, card)
				end
			else
				table.insert(Char.Data.Cards, card)
			end
		end

		Char.Data.Discard = {}
		table.move(remember, 1, #remember, 1, Char.Data.Discard)

		local weeklyOptions = Campaigns[Char.Data.Campaign]
		local weekly = weeklyOptions(Char.Data.Week, Char.Data)
		print("Week " .. tostring(Char.Data.Week) .. ": " .. weekly.name)

		for k, n in pairs(weekly.content) do
			if type(n) == "function" then
				n = math.floor(n())
			end
			local count = n
			if n == All then count = #Packs[k] end
			if n > #Packs[k] then n = #Packs[k] end
			table.shuffle(Packs[k])

			for i = 1, n do
				table.insert(Char.Data.Cards, Packs[k][i])
			end
		end

		self.menu = Noble.Menu.new(false, Noble.Text.ALIGN_LEFT, false, Graphics.kColorBlack, 4, 4, 4, Font)
		
		self.menu:addItem(weekly.name, function()
			for _, card in pairs(Char.Data.Cards) do
				print("-----------")
				print(weekly.name)
				print(Cards)
				print(card)
				local deck = Cards[card].deck
				self:popCard(deck)
				print("-----------")
			end

			playdate.timer.performAfterDelay(2500, function()
				Noble.transition(Adventuring, nil, Noble.Transition.DipToWhite)
			end)
		end)
		Music:play("Weekend")
		Sounds:play("new-day")
		self.menu:activate()
	else
		local w, h = playdate.display.getSize()

		self.newWeek = false
		Char.Data.Day = Char.Data.Day + 1
		local topic = table.remove(Char.Data.Cards, 1)

		self.topicName = topic
		self.topic = Cards[topic]
	
		playdate.timer.performAfterDelay(1000, function()
			self.deckSequence = Sequence.new():from(128):to(-40, 2, Ease.outBack):callback(function() self.menu:activate() end):start()
			self:whish(700)
			if self.topic.portrait ~= nil then 
				self.portraitSequence = Sequence.new():from(100):to(-130, 2, Ease.outBack):start()
			end	
		end)

		self.deck = self.topic.deck
		Music:play(self.deck:gsub("%d+", ""))

		if self.topic.oneoff == nil then
			table.insert(Char.Data.Discard, topic)
		end

		self.menu = Noble.Menu.new(false, Noble.Text.ALIGN_LEFT, false, Graphics.kColorWhite, 4, 4, 2, Font)
		local disabledCount = 0
		for i, o in pairs(self.topic.options) do
			self.menu:addItem(o.name, function() self:provideRewards() end)
			if not self:canDo(o) then
				self.disabledOptions[o.name] = true
				disabledCount = disabledCount + 1
			end
		end

		if disabledCount == #self.topic.options then
			Defeat = self.deck
			playdate.timer.performAfterDelay(5000, function()
				Noble.transition(DefeatScreen, nil, Noble.Transition.DipToBlack)
			end)
		end
	end
end

function scene:canDo(_option)
	local effect = _option.effect
	if next(effect) ~= nil then
		for k, n in pairs(effect) do
			if type(n) == "function" then
				n = math.floor(n(Char.Data.Resources[k]))
			end

			if n < 0 and Char.Data.Resources[k] + n < 0 then return false end
		end
	end

	return true
end

function scene:provideRewards()
	if self.choiceMade then return end

	if not self:canDo(self.topic.options[self.menu.currentItemNumber]) then
		Sounds:play("menu-cancel")
		return
	end

	Sounds:play("menu-select")

	self.choiceMade = true

	if not self.done then
		self.bonusTexts = {}
		local option = self.topic.options[self.menu.currentItemNumber]
		local effect = option.effect
		if next(effect) ~= nil then
			for k, n in pairs(effect) do
				if type(n) == "function" then
					n = math.floor(n(Char.Data.Resources[k]))
				end

				Char.Data.Resources[k] = Char.Data.Resources[k] + n
				table.insert(self.bonusTexts, { index = Utilities.getIndexForStat(k), value = n })
			end
		end

		local inserts = option.insert
		if inserts ~= nil and next(inserts) ~= nil then 
			for k, n in pairs(inserts) do
				if type(n) == "function" then
					n = math.floor(n())
				end
				local count = n
				if n == All then count = #Packs[k] end
				if n > #Packs[k] then n = #Packs[k] end
				table.shuffle(Packs[k])

				for i = 1, n do
					table.insert(Char.Data.Discard, Packs[k][i])
					self:popCard(k, { x = 50, y = 10 })
				end
			end
		end

		if option.skip ~= nil then
			Char.Data.Skip[self.topicName] = option.skip
		end

		if option.tags ~= nil then
			if option.tags["Victory"] ~= nil then
				Victory = self.deck
				Noble.transition(VictoryScreen, nil, Noble.Transition.DipToWhite)
				return
			end
		end

		Char.Data.PlayedActions = Char.Data.PlayedActions + 1
		print(tostring(Char.Data.PlayedActions) .. " out of " .. tostring(Char.Data.Actions))
		if Char.Data.PlayedActions > Char.Data.Actions then
			for _, card in pairs(Char.Data.Cards) do
				table.insert(Char.Data.Discard, card)
			end

			Char.Data.Cards = {}
		end

		local w, h = playdate.display.getSize()
		self.bonusSequence = Sequence.new():from(h - 40):to(h - 55, 1, Ease.outBounce):start()

		if #self.bonusTexts > 0 then
			playdate.timer.performAfterDelay(250, function() 
				self.bonusSequenceLoopX = Sequence.new():from(400):to(330, 2, Ease.inOutCubic):callback(function()
					self.bonusSequenceLoopX = Sequence.new():from(330):to(360, 2, Ease.inBack):mirror():start()
				end):start()
			end)
		else 
			self.bonusSequenceLoopX = Sequence.new():from(400):to(330, 1, Ease.inOutCubic):callback(function()
				self.bonusSequenceLoopX = Sequence.new():from(330):to(360, 2, Ease.inBack):mirror():start()
			end):start()
		end

		playdate.timer.performAfterDelay(500, function()
			if self.topic.oneoff then
				playdate.timer.performAfterDelay(600, function()
					self.drawDeck = false
				end)
				self:destroyCard({ x = 165, y = 0 })
			else
				self.deckSequence = Sequence.new():from(-40):to(128, 1, Ease.inBack):start()
				self:whosh(400)
				if self.topic.portrait ~= nil then
					self.portraitSequence = Sequence.new():from(-130):to(100, 1, Ease.inBack):start()
				end
			end
		end)

		playdate.timer.performAfterDelay(2000, function()
			self.done = true
		end)
	end
end

function scene:drawCard(_name, _x, _y)
	local w, h = playdate.display.getSize()
	Graphics.setColor(Graphics.kColorBlack)
	Graphics.fillRoundRect(_x + w - 64 - 4, _y + h / 2 - 100 - 4, 128 + 8, 200 + 8, 4)
	CardImages:drawImage(CardBacks[_name], _x + w - 64, _y + h / 2 - 100)
	CardFrames:drawImage(1, _x + w - 64, _y + h / 2 - 100)
	Graphics.drawInvertedTextAligned(Titles[_name], _x + w, _y + h / 2 + 68, kTextAlignment.center)
end

function scene:updateAnims()
	for i, card in pairs(self.cardAnims) do
		card:update()
		if card.done then self.cardAnims[i] = nil end
	end
end

function scene:update()
	scene.super.update(self)

	self:updateAnims()

	local w, h = playdate.display.getSize()

	if self.newWeek then 
		Graphics.setColor(Graphics.kColorWhite)
		Graphics.setDitherPattern(0.2, Graphics.image.kDitherTypeScreen)
		Graphics.fillRoundRect(self.menuX, self.sequence:get() or self.menuY, 285, 300, 15)	
		Graphics.setDitherPattern(1.0, Graphics.image.kDitherTypeScreen)
		Font:drawText("Start of week " .. tostring(Char.Data.Week) .. "!", 35, 30)
		self.menu:draw(self.menuX + 35, self.sequence:get() + 38 or self.menuY + 8)
	else
		Graphics.setColor(Graphics.kColorBlack)
		Graphics.setDitherPattern(0.2, Graphics.image.kDitherTypeScreen)
		Graphics.fillRoundRect(self.menuX, self.sequence:get() or self.menuY, 285, 300, 15)	
		Graphics.setDitherPattern(1.0, Graphics.image.kDitherTypeScreen)
		Graphics.drawInvertedText(self.topic.name, 35, 30)
		
		local i = 0

		local effect = self.topic.options[self.menu.currentItemNumber].effect
		local inserts = self.topic.options[self.menu.currentItemNumber].insert

		if self.menu:isActive() and not self.choiceMade then
			if next(effect) == nil then
				if inserts == nil or next(inserts) == nil then
					Graphics.drawInvertedText("No effect", 85, h - 120)
					i = i + 10
				end
			else
				for k, n in pairs(effect) do
					if type(n) == "function" then
						n = math.floor(n(Char.Data.Resources[k]))
					end

					n = math.floor(n)
					local sign = n > 0 and "+" or ""
					local num = sign .. tostring(n)
					local numWidth = Font:getTextWidth(num)
					Graphics.drawInvertedText(num, 85, h - 120 + i)
					Char.smallicons:drawImage(Utilities.getIndexForStat(k), 85 + numWidth + 5, h - 120 + i)
					Graphics.drawInvertedText(" " .. k, 85 + numWidth + 13, h - 120 + i)

					if n < 0 and Char.Data.Resources[k] + n < 0 then
						Graphics.setColor(Graphics.kColorBlack)
						Graphics.setDitherPattern(0.5, Graphics.image.kDitherTypeBayer2x2)
						Graphics.fillRoundRect(85, h - 120 + i, Font:getTextWidth(k) + numWidth + 36, 16, 1)
					end

					i = i + 10
				end
			end

			if inserts ~= nil and next(inserts) ~= nil then
				for k, n in pairs(inserts) do
					if type(n) == "function" then
						n = math.floor(n())
					end
					local count = n
					if n == All then count = "all" end
					print(k)
					print(count)
					print(Titles[k])
					Graphics.drawInvertedText("+" .. count .. " from " .. Titles[k], 85, h - 120 + i)
					i = i + 10
				end
			end
		end

		self.menu:draw(self.menuX + 5, self.sequence:get() + 38 or self.menuY + 8)
		for i, option in pairs(self.topic.options) do
			if self.disabledOptions[option.name] ~= nil then
				local text = option.name
				local width = Font:getTextWidth(text)
				Graphics.setColor(Graphics.kColorBlack)
				Graphics.setDitherPattern(0.5, Graphics.image.kDitherTypeBayer2x2)
				Graphics.fillRoundRect(self.menuX + 5, (i - 1) * 16 + self.sequence:get() + 38 or self.menuY + 8, width + 16, 16, 0)
			end
		end
	end

	if self.bonusSequence ~= nil then
		for _, bonus in pairs(self.bonusTexts) do
			local text = ""
			if bonus.value < 0 then
				text = tostring(bonus.value)
			elseif bonus.value > 0 then
				text = "+" .. tostring(bonus.value)
			else 
				text = ""
			end
			Graphics.drawInvertedTextAligned(text, 12 + 54 + bonus.index * 25, self.bonusSequence:get(), kTextAlignment.center)
		end

		Graphics.setColor(Graphics.kColorBlack)
		Graphics.setDitherPattern(0.5, Graphics.image.kDitherTypeBayer2x2)
	end

	if self.deck ~= nil and self.deckSequence ~= nil and self.drawDeck then
		self:drawCard(self.deck, self.deckSequence:get(), 0)
	end

	if self.topic ~= nil then
		if self.topic.portrait ~= nil and self.portraitSequence ~=nil then
			Portraits:drawImage(self.topic.portrait, w + self.portraitSequence:get(), 5)
		end
	end

	Char:draw(false, nil)

	for _, card in pairs(self.cardAnims) do
		card:draw()
	end

	if self.done and #self.cardAnims == 0 then
		Noble.transition(Adventuring, nil, Noble.Transition.SlideOffUp)
	end
end