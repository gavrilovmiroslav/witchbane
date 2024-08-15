
MusicPlayer = {}
class("MusicPlayer").extends()

function MusicPlayer.new()
    local self = setmetatable({}, MusicPlayer)
    self.tracks = { nil, nil }
    self.min = 0
    self.max = 1
    self.fadetime = 3
    self.fader = nil
    self.index = 0
    self.lastPlayed = nil
    return self
end

function MusicPlayer:setMaxVolume(m)
    self.max = m
end

function MusicPlayer:play(name)
    if self.lastPlayed == name then return end
    self.lastPlayed = name

    if self.index == 0 then
        self.index = 1
        self.tracks[1] = playdate.sound.fileplayer.new("assets/music/" .. name)
        self.tracks[1]:setVolume(self.max)
        self.tracks[1]:play(0)
    elseif self.index == 1 then 
        self.fader = Sequence.new():from(self.min):to(self.max, self.fadetime, Ease.inQuad):start()
        self.index = 2

        if self.tracks[2] ~= nil then
            self.tracks[2]:stop()
        end

        self.tracks[2] = playdate.sound.fileplayer.new("assets/music/" .. name)
        self.tracks[2]:setVolume(self.min)
        self.tracks[2]:play(0)
    elseif self.index == 2 then
        self.fader = Sequence.new():from(self.min):to(self.max, self.fadetime, Ease.inQuad):start()
        self.index = 1

        if self.tracks[1] ~= nil then
            self.tracks[1]:stop()
        end

        self.tracks[1] = playdate.sound.fileplayer.new("assets/music/" .. name)
        self.tracks[1]:setVolume(self.min)
        self.tracks[1]:play(0)
    end
end

function MusicPlayer:fadeout()
    self.fader = Sequence.new():from(self.min):to(self.max, self.fadetime, Ease.inQuad):start()
    local other = 3 - self.index
    self.index = other

    if self.tracks[other] ~= nil then
        self.tracks[other]:stop()
    end

end

function MusicPlayer:update()
    if self.fader ~= nil then 
        if self.tracks[self.index] ~= nil then
            self.tracks[self.index]:setVolume(self.fader:get())
        end 

        if self.tracks[3 - self.index] ~= nil then
            self.tracks[3 - self.index]:setVolume(self.max - self.fader:get())
        end
    end 
end