import "CoreLibs/ui"
local gfx <const> = cauldron.graphics
local g <const> = playdate.graphics
local fsm <const> = cauldron.fsm
local twn <const> = cauldron.tween
local mus <const> = cauldron.music

local rad = math.rad
local game = fsm.get("game")

local vars = {}
local tweens = {}

gfx.load_image("title_black", 'images/black.png')
gfx.load_image("title_logo", 'images/logo.png')
gfx.load_image("title_seal", 'images/secret_seal.png')
gfx.load_image("title_glow", 'images/logo_glow.png')

game:add_on_enter_hook("menu", function()
    mus:play("intro")
    vars.title_done = false
    vars.title_crank = 0
    vars.title_glow = 0
    vars.title_fade = { value = 0 }
    tweens.title_fade = twn.new(30, vars.title_fade, { value = 1 }, 'outCubic')
end)

game:add_on_update_hook("menu", function()
    tweens.title_fade:update(0.1)
    if tweens.title_fadeout ~= nil then tweens.title_fadeout:update(0.1) end
    if not vars.title_done then
        local c, a = playdate.getCrankChange()
        if c < 0 then c = 0 end
        vars.title_crank = vars.title_crank + c
        if vars.title_crank >= 360 then
            vars.title_crank = 360
            vars.title_done = true
--            music:play_start_game_sound()
            mus:fade_to("fight")
            vars.title_fadeout = { value = 0 }
            tweens.title_fadeout = twn.new(5, vars.title_fadeout, { value = 1 }, 'outCubic')
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
    local black = gfx.get_image("title_black")
    local logo = gfx.get_image("title_logo")
    local seal = gfx.get_image("title_seal")
    local logo_glow = gfx.get_image("title_glow")
    local font = gfx.get_font("small")

    gfx.clearBlack()
    g.setColor(g.kColorWhite)
    g.setImageDrawMode(g.kDrawModeCopy)
    logo:drawFaded(0, 0, vars.title_fade.value, g.image.kDitherTypeBayer4x4)
    logo_glow:draw(vars.title_glow - 20, -1, g.kImageUnflipped, playdate.geometry.rect.new(vars.title_glow - 20, 0, 50, 100))
    logo_glow:draw(vars.title_glow, -1, g.kImageUnflipped, playdate.geometry.rect.new(vars.title_glow, 0, 20, 240))
    g.setImageDrawMode(g.kDrawModeInverted)

    if vars.title_crank > 0 then
        g.drawArc(200, 170, 30, 0, vars.title_crank or 0)
        local a = rad(vars.title_crank - 90)
        local x, y = 30 * math.cos(a), 30 * math.sin(a)
        g.setColor(g.kColorBlack)
        g.fillCircleAtPoint(200 + x, 170 + y, 8)
        g.setColor(g.kColorWhite)
        g.fillCircleAtPoint(200 + x, 170 + y, 5)
        g.setColor(g.kColorWhite)
        g.setImageDrawMode(playdate.graphics.kDrawModeCopy)
        seal:drawFaded(200 - 30, 170 - 30, vars.title_crank / 360, g.image.kDitherTypeBayer2x2)
    end
    g.setColor(g.kColorBlack)
    g.fillRect(0, 160, 400, 12)
    g.setColor(g.kColorWhite)
    g.setImageDrawMode(g.kDrawModeInverted)
    font:drawTextAligned("CRANK: Begin Ritual", 200, 160, kTextAlignment.center)
    g.setImageDrawMode(g.kDrawModeCopy)

    if vars.title_done then
        black:drawFaded(0, 0, vars.title_fadeout.value, g.image.kDitherTypeBayer2x2)
        if vars.title_fadeout.value == 1 then
            game:follow("menu->start")
        end
    elseif vars.title_crank == 0 then
        playdate.ui.crankIndicator:draw()
    end
end)