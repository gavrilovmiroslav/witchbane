
Soundbank = {}
class("Soundbank").extends()
local bank = Soundbank

function Soundbank.new(init)
    local self = setmetatable({}, Soundbank)
    self.sounds = {}
    for k, v in pairs(init) do
        self.sounds[v] = playdate.sound.sampleplayer.new("assets/sfx/" .. v)
        print(self.sounds[v])
    end
    return self
end

function Soundbank:play(name)
    self.sounds[name]:play()
end
