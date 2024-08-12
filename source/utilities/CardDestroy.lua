
CardDestroy = {}
class("CardDestroy").extends()

function CardDestroy.new(_length, _offset)
    local self = setmetatable({}, CardDestroy)

    self.time = 0
    self.frame = 0
    self.length = _length
    self.anim = nil
    self.offset = _offset
    self.done = false
    return self
end

function CardDestroy:update()
    if self.done then return end
    
    if self.frame < 7 then
        self.time = self.time + 1
        if self.time > self.length then
            self.time = 0
            self.frame = self.frame + 1
        end
    elseif self.frame == 7 then
        self.done = true
    end
end

function CardDestroy:draw()
    if self.done then return end

    local w, h = playdate.display.getSize()
    Graphics.setColor(Graphics.kColorBlack)
    local x = w / 2
    local y = h / 2
    if self.anim ~= nil then y = self.anim:get() end

    x = x + self.offset.x
    y = y + self.offset.y

    if self.frame < 8 then
        CardEffects:drawImage(14 + self.frame, w / 2 + self.offset.x - 81, h / 2 + self.offset.y - 121)
    end
end