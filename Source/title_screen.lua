import "CoreLibs/ui"
local gfx <const> = cauldron.graphics
local g <const> = playdate.graphics
local fsm <const> = cauldron.fsm
local twn <const> = cauldron.tween
local sfx <const> = cauldron.sfx

local rad = math.rad
local game = fsm.get("game")

local title_done = false
local title_crank = 0
local title_glow = 0

gfx.load_image("title_black", 'images/black.png')
gfx.load_image("title_logo", 'images/logo.png')
gfx.load_image("title_seal", 'images/secret_seal.png')
gfx.load_image("title_glow", 'images/logo_glow.png')

game:add_on_enter_hook("menu", function()
    title_done = false
    title_crank = 0
    title_glow = 0
    twn.new("title_fade", 30, { 0, 1 }, 'outCubic')
end)

game:add_on_update_hook("menu", function()
    twn.update()
    if not title_done then
        local c, a = playdate.getCrankChange()
        if c < 0 then c = 0 end
        title_crank = title_crank + c
        if title_crank >= 360 then
            title_crank = 360
            title_done = true
            sfx.play("start")
            twn.new("title_fadeout", 5, { 0, 1 }, 'outCubic', function()
                game:follow("menu->run start")
            end)
        end
        if c == 0 and a == 0 and playdate.getCrankPosition() > 0 then
            title_crank = title_crank - 0.1
            if title_crank < 0 then title_crank = 0 end
        end
        title_glow = title_glow + 1
        if title_glow > 380 then
            title_glow = 0
        end
    end
end)

game:add_on_draw_hook("menu", function()
    gfx.clear_black()
    gfx.copy_white()
    gfx.draw_faded(0, 0, "title_logo", twn.get("title_fade"))
    gfx.draw_image(title_glow - 20, -1, "title_glow", playdate.geometry.rect.new(title_glow - 20, 0, 50, 100))
    gfx.draw_image(title_glow, -1, "title_glow", playdate.geometry.rect.new(title_glow, 0, 20, 240))

    gfx.invert_white()

    if title_crank > 0 then
        gfx.draw_arc(200, 170, 30, 0, title_crank or 0)
        local a = rad(title_crank - 90)
        local x, y = 30 * math.cos(a), 30 * math.sin(a)
        gfx.black()
        gfx.draw_circle(200 + x, 170 + y, 8, true)
        gfx.white()
        gfx.draw_circle(200 + x, 170 + y, 5, true)
        gfx.copy_white()
        gfx.draw_faded(170, 140, "seal", title_crank / 360, g.image.kDitherTypeBayer2x2)
    end

    gfx.copy_black()
    gfx.draw_rect(0, 160, 400, 12, true)
    gfx.invert_white()
    gfx.draw_text_centered(200, 160, "CIRCLE: Begin Ritual")
    gfx.copy_white()

    if title_done then
        gfx.draw_faded(0, 0, "title_black", twn.get("title_fadeout") or 1, g.image.kDitherTypeBayer2x2)
    elseif title_crank == 0 then
        playdate.ui.crankIndicator:draw()
    end
end)