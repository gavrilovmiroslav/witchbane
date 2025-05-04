import "CoreLibs/ui"
local gfx <const> = cauldron.graphics
local g <const> = playdate.graphics
local fsm <const> = cauldron.fsm
local twn <const> = cauldron.tween
local mus <const> = cauldron.music
local sfx <const> = cauldron.sfx

local rad = math.rad
local game = fsm.get("game")

local vars = {}

gfx.load_image("title_black", 'images/black.png')
gfx.load_image("title_logo", 'images/logo.png')
gfx.load_image("title_seal", 'images/secret_seal.png')
gfx.load_image("title_glow", 'images/logo_glow.png')

game:add_on_enter_hook("menu", function()
    vars.title_done = false
    vars.title_crank = 0
    vars.title_glow = 0
    twn.new("title_fade", 30, { 0, 1 }, 'outCubic')
end)

game:add_on_update_hook("menu", function()
    twn.update()
    if not vars.title_done then
        local c, a = playdate.getCrankChange()
        if c < 0 then c = 0 end
        vars.title_crank = vars.title_crank + c
        if vars.title_crank >= 360 then
            vars.title_crank = 360
            vars.title_done = true
            sfx.play("start")
            mus.fade_to("fight")
            twn.new("title_fadeout", 5, { 0, 1 }, 'outCubic', function()
                game:follow("menu->start")
            end)
        end
        if c == 0 and a == 0 and playdate.getCrankPosition() > 0 then
            vars.title_crank = vars.title_crank - 0.1
            if vars.title_crank < 0 then vars.title_crank = 0 end
        end
        vars.title_glow = vars.title_glow + 1
        if vars.title_glow > 380 then
            vars.title_glow = 0
        end
    end
end)

game:add_on_draw_hook("menu", function()
    gfx.clear_black()
    gfx.copy_white()
    gfx.draw_faded(0, 0, "title_logo", twn.get("title_fade"))
    gfx.draw_image(vars.title_glow - 20, -1, "title_glow", playdate.geometry.rect.new(vars.title_glow - 20, 0, 50, 100))
    gfx.draw_image(vars.title_glow, -1, "title_glow", playdate.geometry.rect.new(vars.title_glow, 0, 20, 240))

    gfx.invert_white()

    if vars.title_crank > 0 then
        gfx.draw_arc(200, 170, 30, 0, vars.title_crank or 0)
        local a = rad(vars.title_crank - 90)
        local x, y = 30 * math.cos(a), 30 * math.sin(a)
        gfx.black()
        gfx.draw_circle(200 + x, 170 + y, 8, true)
        gfx.white()
        gfx.draw_circle(200 + x, 170 + y, 5, true)
        gfx.copy_white()
        gfx.draw_faded(170, 140, "seal", vars.title_crank / 360, g.image.kDitherTypeBayer2x2)
    end

    gfx.copy_black()
    gfx.draw_rect(0, 160, 400, 12, true)
    gfx.invert_white()
    gfx.draw_text_centered(200, 160, "CIRCLE: Begin Ritual")
    gfx.copy_white()

    if vars.title_done then
        gfx.draw_faded(0, 0, "title_black", twn.get("title_fadeout") or 1, g.image.kDitherTypeBayer2x2)
    elseif vars.title_crank == 0 then
        playdate.ui.crankIndicator:draw()
    end
end)