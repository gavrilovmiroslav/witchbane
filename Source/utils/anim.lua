local anim = {}
local loaded_anims = {}

function anim:new(gfx, name, path, cols, speed, rep)
    local o = {}
    cols = cols or 1
    if cols == 0 then cols = 1 end
    speed = speed or 4
    rep = rep or true
    setmetatable(o, self)

    self.name = name

    if loaded_anims[name] == nil then
        gfx.load_image("anim-" .. name, path .. "//" .. name .. ".png")
        loaded_anims[name] = true
    end

    self.time = 0
    self.frame = 1
    self.cols = cols
    self.width, self.height = gfx.get_image("anim-" .. name):getSize()
    self.width = self.width / cols
    self.done = false
    self.callback = nil
    self.pivot = { 0.5, 0.5 }
    return o
end

function anim:update()
    self.time = self.time + 1
    if self.time > self.speed then
        self.frame = self.frame + 1
        if self.frame > self.cols then
            if self.callback ~= nil then
                self.callback()
            end

            if self.rep then
                self.frame = 1
            else
                self.done = true
            end
        end
    end
end

return anim