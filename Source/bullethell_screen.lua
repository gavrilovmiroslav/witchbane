import "CoreLibs/ui"
local gfx <const> = cauldron.graphics
local g <const> = playdate.graphics
local fsm <const> = cauldron.fsm
local twn <const> = cauldron.tween
local mus <const> = cauldron.music
local sfx <const> = cauldron.sfx
local ecs <const> = cauldron.ecs

local rad = math.rad
local game = fsm.get("game")

local player = ecs:spawn()

game:add_on_enter_hook("bullethell", function()
    -- calculate which demons to offer next based on current score
end)

game:add_on_update_hook("bullethell", function()
    -- can enter infoscreens
    -- can enter dialogues
    -- move to bullethell
end)

game:add_on_draw_hook("bullethell", function()

end)