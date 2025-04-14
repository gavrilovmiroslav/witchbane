import "CoreLibs/object"
local sound <const> = playdate.sound

music = {}
class("music").extends()

function music:init()
    self.volume = 1
    self.fade = 0
    self.music = nil
    
    self.intro_music = sound.fileplayer.new("music/intro.mp3")
    self.intro_music:setRate(0.7)
    self.fight_music = sound.fileplayer.new("music/phase1.mp3")
    self.boss_music = sound.fileplayer.new("music/phase2.mp3")

    self.start_tone = sound.sampleplayer.new("sfx/ack.wav")
    self.laugh_tone = sound.sampleplayer.new("sfx/evil_laugh.wav")
    self.collect_tone = sound.sampleplayer.new("sfx/blop.wav")
    self.break_tone = sound.sampleplayer.new("sfx/orb_break.wav")
    self.full_tone = sound.sampleplayer.new("sfx/orb_full.wav")
    self.full_tone:setVolume(0.5, 0.5)
    self.summon_tone = sound.sampleplayer.new("sfx/summon.wav")
    self.summon_tone:setVolume(0.5, 0.5)
    self.scream_tone = sound.sampleplayer.new("sfx/crush.wav")
    self.scream_tone:setVolume(0.4, 0.4)
    self.scream_count = 0
    self.scream_tone:setFinishCallback(function(e, h)
        self.scream_count = self.scream_count - 1
    end)
end

function music:play_music(next, from_volume)
    from_volume = from_volume or 0
    self.music = self[next .. "_music"]
    self.music:setVolume(from_volume)
    self.music:play(0)
    self.music:setVolume(1, 1, 1.0)
end

function music:play_start_game_sound()
    self.start_tone:play()
end

function music:play_scream_sound()
    self.scream_count = self.scream_count + 1
    self.scream_tone:setRate(1 + self.scream_count * 0.1)
    self.scream_tone:play()
end

function music:play_laugh_sound()
    printTable(self)
    self.laugh_tone:play()
end

function music:play_collect_sound(h)
    local v = math.min(0.6, 0.3 + h * 0.1)
    self.collect_tone:setRate(v)
    self.collect_tone:play(1, h or 1)
end

function music:play_break_sound()
    self.break_tone:play()
end

function music:play_full_sound()
    self.full_tone:play()
end

function music:play_summon_sound()
    self.summon_tone:play()
end

function music:fadeout_music(next)
    if self.music ~= nil then
        self.music:setVolume(0, 0, 1.0, function(p, e)
            self.music:stop()
            self.music:setVolume(1)
            if next ~= nil then
                self:play_music(next, 0)
            end
        end)
    end
end