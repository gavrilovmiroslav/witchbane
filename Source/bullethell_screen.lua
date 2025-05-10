import "CoreLibs/ui"
local gfx <const> = cauldron.graphics
local g <const> = playdate.graphics
local fsm <const> = cauldron.fsm
local twn <const> = cauldron.tween
local mus <const> = cauldron.music
local sfx <const> = cauldron.sfx

local rad = math.rad
local game = fsm.get("game")

game:add_on_enter_hook("sanctuary", function()
    
    -- calculate which demons to offer next based on current score
end)

game:add_on_update_hook("sanctuary", function()
    -- can enter infoscreens
    -- can enter dialogues
    -- move to bullethell
end)

game:add_on_draw_hook("sanctuary", function()

end)