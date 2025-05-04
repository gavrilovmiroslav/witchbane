import "utils/playout"
import "CoreLibs/object"
local lume <const> = import "utils/lume"
local tween <const> = import "utils/tween"
local panels = import "panels/Panels"
local fsm = import "utils/fsm"

local M = {}

local gfx = playdate.graphics

M.fps = true
M.loaded = {}
M.loaded.images = {}
M.loaded.fonts = {}
M.loaded.ui = {}
M.loaded.fsms = {}
M.loaded.cutscenes = {}
M.loaded.save = {}

-- SAVE

M.save = { name = nil, data = nil }

M.save.init = function(name, clear)
    M.save.name = name
    if clear then
        playdate.datastore.delete(name)
    end
end

M.save.commit = function(o)
    M.save.data = lume.merge(M.save.data or {}, o)
    playdate.datastore.write(o, M.save.name, false)
end

M.save.load = function(default)
    local savedata = playdate.datastore.read(M.save.name)
    if savedata == nil then
        savedata = default
        M.save.commit(savedata)
        return false, savedata
    end
    return true, savedata
end

-- COLORS 

M.colors = {}

M.colors.black = gfx.kColorBlack
M.colors.white = gfx.kColorWhite
M.colors.clear = gfx.kColorClear
M.colors.xor = gfx.kColorXOR

-- FSM

M.fsm = {}

M.fsm.new = function(name)
    M.loaded.fsms[name] = fsm:new()
    return M.loaded.fsms[name]
end

M.fsm.get = function(name)
    return M.loaded.fsms[name]
end

-- CUTSCENES

M.cutscene = {}
M.cutscene.state = nil
Panels.Settings.defaultFrame = { gap = 0, margin = 2 }

M.cutscene.load = function(name, path)
    local data = json.decodeFile(path .. ".json")
    if M.loaded.cutscenes[name] ~= nil then
        print("Warning: cutscene " .. name .. " already exists, overwriting!")
    end

    data.backgroundColor = Panels.Color.BLACK
    data.axis = Panels.ScrollAxis.VERTICAL
    data.scrollType = Panels.ScrollType.AUTO
    data.direction = Panels.ScrollDirection.UP_TO_DOWN
    
    M.loaded.cutscenes[name] = { data }
end

M.cutscene.play = function(name, fn)
    M.cutscene.stop()

    if M.loaded.cutscenes[name] ~= nil then
        M.cutscene.state = name
        Panels.startCutscene(M.loaded.cutscenes[name], function()
            M.cutscene.state = nil
            if fn ~= nil then
                fn()
            end
        end)
    else
        print("Warning: cutscene " .. name .. " doesn't exist!")
    end
end

M.cutscene.stop = function()
    if M.cutscene.state ~= nil then
        Panels.haltCutscene()
        M.cutscene.state = nil
    end
end

M.cutscene.is_playing = function()
    return M.cutscene.state ~= nil
end

-- GRAPHICS 

M.graphics = {}

M.graphics.clear_black = function()
    gfx.setColor(gfx.kColorBlack)
    gfx.fillRect(0, 0, 400, 240)
end

M.graphics.clear_white = function()
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 240)
end

M.graphics.copy_white = function()
    gfx.setColor(gfx.kColorWhite)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

M.graphics.copy_black = function()
    gfx.setColor(gfx.kColorBlack)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)
end

M.graphics.invert_white = function()
    gfx.setColor(gfx.kColorWhite)
    gfx.setImageDrawMode(gfx.kDrawModeInverted)
end

M.graphics.invert_black = function()
    gfx.setColor(gfx.kColorBlack)
    gfx.setImageDrawMode(gfx.kDrawModeInverted)
end

M.graphics.white = function()
    gfx.setColor(gfx.kColorWhite)
end

M.graphics.black = function()
    gfx.setColor(gfx.kColorBlack)
end

M.graphics.load_font = function(name, path)
    M.loaded.fonts[name] = gfx.font.new(path)
end

M.graphics.set_font = function(name)
    M.graphics._current_font = name
    gfx.setFont(M.loaded.fonts[name])
end

M.graphics.get_font = function(name)
    return M.loaded.fonts[name]
end

M.graphics.font = function(name)
    return M.loaded.fonts[name]
end

M.graphics.draw_fps = playdate.drawFPS

M.graphics.draw_text = function(x, y, text, colorChange)
    local oldColor = gfx.getColor()
    if colorChange ~= nil then
        gfx.setColor(colorChange)
    end

    gfx.drawText(text, x, y)
    gfx.setColor(oldColor)
end

M.graphics.draw_text_centered = function(x, y, text, colorChange)
    local oldColor = gfx.getColor()
    if colorChange ~= nil then
        gfx.setColor(colorChange)
    end

    gfx.drawTextAligned(text, x, y, kTextAlignment.center)
    gfx.setColor(oldColor)
end

M.graphics.load_image = function(name, path)
    M.loaded.images[name] = gfx.image.new(path)
    return M.loaded.images[name]
end

M.graphics.get_image = function(name)
    return M.loaded.images[name]
end

M.graphics.unload_image = function(name)
    M.loaded.images[name] = nil
end

M.graphics.draw_faded = function(x, y, name, fade, dither)
    if M.loaded.images[name] ~= nil then
        M.loaded.images[name]:drawFaded(x, y, fade or 0.5, dither or gfx.image.kDitherTypeBayer4x4)
    else
        print("Missing image", name)
    end
end

M.graphics.draw_image = function(x, y, name, rect)
    if M.loaded.images[name] ~= nil then
        M.loaded.images[name]:draw(x, y, gfx.kImageUnflipped, rect)
    end
end

M.graphics.draw_arc = function(x, y, a, b, i)
    gfx.drawArc(x, y, a, b, i)
end

M.graphics.draw_circle = function(x, y, r, filled)
    if filled then
        gfx.fillCircleAtPoint(x, y, r)
    else
        gfx.drawCircleAtPoint(x, y, r)
    end
end

M.graphics.draw_rect = function(x, y, w, h, filled)
    if filled then
        gfx.fillRect(x, y, w, h)
    else
        gfx.drawRect(x, y, w, h)
    end
end

-- UI

M.ui = playout

M.ui.make = function(ui)
    return playout.tree.new(ui, { useCache = false }):compute()
end

-- SIMULATOR

M.debug = function(message) end

M.simulator = {}
M.simulator.fetch = function(url)
    playdate.simulator.getURL(url)
end

function playdate.serialMessageReceived(message)
    M.debug(message)
end

-- TWEEN

M.tween = {}
M.tween.vars = {}
M.tween.limits = {}
M.tween.tweens = {}
M.tween.callbacks = {}

M.tween.new = function(name, length, range, kind, callback)
    M.tween.vars[name] = { value = range[1] }
    M.tween.limits[name] = range[2]
    M.tween.tweens[name] = tween.new(length, M.tween.vars[name], { value = range[2] }, kind or 'outCubic')
    M.tween.callbacks[name] = callback
    return M.tween.tweens[name]
end

M.tween.update = function(dt)
    for n, t in pairs(M.tween.tweens) do
        t:update(dt or 0.1)
        if M.tween.vars[n].value >= M.tween.limits[n] then
            if M.tween.callbacks[n] ~= nil then
                M.tween.callbacks[n]()
                M.tween.vars[n] = nil
                M.tween.limits[n] = nil
                M.tween.tweens[n] = nil
                M.tween.callbacks[n] = nil
            end
        end
    end
end

M.tween.get = function(name)
    local t = M.tween.vars[name]
    if t == nil then return nil end
    return t.value
end

-- AUDIO

local sound <const> = playdate.sound

M.sfx = {}
M.sfx.tracks = {}

M.sfx.prepare = function(sounds)
    for _, s in ipairs(sounds) do
        M.sfx.tracks[s.name] = sound.sampleplayer.new(s.path)
        if s.volume ~= nil then
            M.sfx.tracks[s.name]:setVolume(s.volume, s.volume)
        end
    end
end

M.sfx.play = function(name, rate)
    if rate ~= nil then
        M.sfx.tracks[name]:setRate(rate)
    end
    M.sfx.tracks[name]:play()
end

M.music = {}
M.music.current = nil
M.music.tracks = {}

M.music.prepare = function(songs)
    for _, s in ipairs(songs) do
        M.music.tracks[s.name] = sound.fileplayer.new(s.path)
        if s.rate ~= nil then
            M.music.tracks[s.name]:setRate(s.rate)
        end
    end
end

M.music.play = function(next, from_volume)
    M.music.current = M.music.tracks[next]
    if M.music.current ~= nil then
        M.music.current:setVolume(from_volume or 0)
        M.music.current:play(0)
        M.music.current:setVolume(1, 1, 1.0)
    else
        print("Couldn't find song", next)
    end
end

M.music.fade_to = function(next)
    if M.music.current ~= nil then
        M.music.current:setVolume(0, 0, 1.0, function(p, e)
            M.music.current:stop()
            M.music.current:setVolume(1)
            if next ~= nil then
                M.music.play(next, 0)
            end
        end)
    end
end

-- GENERAL

M.load = function() end
M.draw = function() end
M.update = function() end

function playdate.update()
    if M.cutscene.state ~= nil then
        Panels.update()
    else
        M.update()
        M.draw()
    end
    if M.fps then
        playdate.drawFPS(0, 0)
    end
end

M.init = function()
    M.load()
end

return M