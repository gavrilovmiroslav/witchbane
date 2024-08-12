
CardAppear = {}
class("CardAppear").extends()

function CardAppear.new(_card, _length, _offset)
    local self = setmetatable({}, CardAppear)

    self.card = _card
    self.time = 0
    self.frame = 0
    self.length = _length
    self.anim = nil
    self.offset = _offset
    self.done = false
    return self
end

function CardAppear:update()
    if self.done then return end
    
    if self.frame < 7 then
        self.time = self.time + 1
        if self.time > self.length then
            self.time = 0
            self.frame = self.frame + 1
        end
    elseif self.frame == 7 then        
        self.frame = 8;
    elseif self.frame < 11 then
        self.time = self.time + 1
        if self.time > self.length then
            self.time = 0
            self.frame = self.frame + 1
        end
    elseif self.frame == 11 then
        local w, h = playdate.display.getSize()
        self.anim = Sequence:new():from(h / 2):to(h + 129, 1.5, Ease.inBack):callback(function () self.done = true end):start()
        self.frame = 12
    end
end

function CardAppear:draw()
    if self.done then return end

    local w, h = playdate.display.getSize()
    Graphics.setColor(Graphics.kColorBlack)
    local x = w / 2
    local y = h / 2
    if self.anim ~= nil then y = self.anim:get() end

    x = x + self.offset.x
    y = y + self.offset.y

    if self.frame >= 5 then
        Graphics.fillRoundRect(x - 64 - 4, y - 100 - 4, 128 + 8, 200 + 8, 4)
        CardImages:drawImage(self.card.image, x - 64, y - 100)
        CardFrames:drawImage(1, x - 64, y - 100)
        Graphics.drawInvertedTextAligned(self.card.name, x, y + 68, kTextAlignment.center)
    end

    if self.frame < 8 then
        CardEffects:drawImage(self.frame, w / 2 + self.offset.x - 81, h / 2 + self.offset.y - 121)
    end
end