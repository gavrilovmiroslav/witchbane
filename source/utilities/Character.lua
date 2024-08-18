
CharacterSheet = {}
class("CharacterSheet").extends()

function CharacterSheet.new()
    local self = setmetatable({}, CharacterSheet)

    self.Ready = false
    self.Portrait = 1
	self.Cards = {}
	self.Discard = {}
	self.Skip = {}

	self.Campaign = nil
	self.Actions = 7
	self.PlayedActions = 0

	self.Day = 0
	self.Week = 0

	self.Tags = {}

	self.Resources = {
		artifacts = 0,
		affluence = 3,
		herbs = 3,
		familiars = 0,
		coven = 1,
		suspicion = 0,
	}

    return self
end

Character = {}
class("Character").extends()

All = -1

function Character.new(sheet)
    local self = setmetatable({}, Character)

    self.Data = sheet

	self.iconframe = Graphics.image.new("assets/images/icon-frame")
	self.icons = Graphics.imagetable.new("assets/images/icons")
	self.smallicons = Graphics.imagetable.new("assets/images/smallicons")

	self.portraitIds = {
		12, -- FLEDGLING HEDGE WITCH (371, 902)
		3,  -- TRAVELING DIVINER (705, 294)
		14, -- SENSITIVE SOUL (979, 489)
		17, -- COVEN LEADER (1660, 415)
		35, -- HERETICAL WARLOCK (700, 1322)
	}

    self.descriptions = {
		"A young sprout, spliting\ntruths from tea leaves.",
		"Walks the earth ever\nknowing what to hope for.",
		"Never in company, but \nnever alone. Well attuned.",
		"A hieromant chief, driven\nby spite and ambition.",
		"Lore mage of eld, searching\nfor what was promised."
	}

    return self
end

function Character:draw(description, bonuses)
	self:drawPortrait(description)
	self:drawInventory(bonuses)
end

function Character:drawPortrait(description)
	local w, h = playdate.display.getSize()
	Portraits:drawImage(self.portraitIds[self.Data.Portrait], 0, h - 80, playdate.graphics.kImageFlippedX)
    if description then
	    Graphics.drawInvertedText(self.descriptions[self.Data.Portrait], 85, h - 70)
	end
end

function Character:drawInventory(bonuses)
	local w, h = playdate.display.getSize()
	local stats = table.copy(self.Data.Resources)

    if bonuses ~= nil then
    	bonuses[self.Data.Portrait](stats)
    end

	for i = 1, 6 do
		Graphics.setColor(Graphics.kColorBlack)
		Graphics.fillRect(54 + i * 25, h - 38 - 4, 26, 38)

		self.iconframe:draw(54 + i * 25, h - 38 - 4)
		Graphics.drawInvertedTextAligned(tostring(stats[Utilities.getStat(i)]), 54 + i * 25 + 13, h - 34 - 4, kTextAlignment.center)
		self.icons:drawImage(i, 54 + i * 25 + 5, h - 27 + 7 - 4)
	end
end
