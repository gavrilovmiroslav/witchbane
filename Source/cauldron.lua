import "utils/playout"
import "CoreLibs/object"

local panels = import "panels/Panels"
local fsm = import "utils/fsm"

local M = {}

local gfx = playdate.graphics

M.loaded = {}
M.loaded.images = {}
M.loaded.fonts = {}
M.loaded.ui = {}
M.loaded.fsms = {}
M.loaded.cutscenes = {}
M.loaded.save = {}

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
Panels.Settings.snapToPanels = true
Panels.Settings.defaultFrame = { gap = 10, margin = 2 }

M.cutscene.load = function(name, path)
    local data = json.decodeFile(path .. ".json")
    if M.loaded.cutscenes[name] ~= nil then
        print("Warning: cutscene " .. name .. " already exists, overwriting!")
    end

    data.axis = Panels.ScrollAxis.HORIZONTAL
    data.scrollType = Panels.ScrollType.AUTO
    data.direction = Panels.ScrollDirection.LEFT_TO_RIGHT
    
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

M.graphics.clear = function()
    gfx.setColor(gfx.kColorWhite)
    gfx.fillRect(0, 0, 400, 240)
end

M.graphics.load_font = function(name, path)
    M.loaded.fonts[name] = gfx.font.new(path)
end

M.graphics.set_font = function(name)
    M.graphics._current_font = name
    gfx.setFont(M.loaded.fonts[name])
end

M.graphics.get_font = function(name)
    return M.graphics._current_font
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

M.graphics.load_image = function(name, path)
    M.loaded.images[name] = gfx.image.new(path)
end

M.graphics.unload_image = function(name)
    M.loaded.images[name] = nil
end

M.graphics.draw_image = function(x, y, name)
    if M.loaded.images[name] ~= nil then
        M.loaded.images[name]:draw(x, y)
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
end

M.init = function()
    M.load()
end

return M