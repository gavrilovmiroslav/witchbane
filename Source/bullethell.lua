import "CoreLibs/graphics"
import "CoreLibs/object"
import "utils"

local playdate <const> = playdate
local gfx <const> = playdate.graphics
local pool = import "pool"

local small_smoke <const> = gfx.image.new("images/smoke_40.png")
local big_smoke <const> = gfx.image.new("images/smoke_48.png")

local small_shade <const> = gfx.image.new("images/small_shade.png")
local big_shade <const> = gfx.image.new("images/big_shade.png")

bullethell = { data = {} }
class("bullethell").extends()

function bullethell:init()
    self.time = 0
    self.bullet_pool = pool.create(function() return { lt = 0, x = 0, px = 0, y = 0, angle = 0, model = nil, fq = 0 } end, 1000)
    self.bullets = {}
    self.free = {}
    self.free_idx = {}
    self.collision_map = gfx.image.new(400, 240, gfx.kColorBlack);
    
    self.small_smoke = { { -100, -100, -1 }, { -100, -100, -1 }, { -100, -100, -1 }, { -100, -100, -1 }, { -100, -100, -1 } }
    self.small_smoke_free = { 1, 2, 3, 4, 5 }
    
    self.big_smoke = { { -100, -100, -1 }, { -100, -100, -1 }, { -100, -100, -1 }, { -100, -100, -1 }, { -100, -100, -1 } }
    self.big_smoke_free = { 1, 2, 3, 4, 5 }

    self.sprites = {
        goat = gfx.image.new("images/goat.png"),
        piglet = gfx.image.new("images/piglet.png"),
        boss = gfx.image.new("images/boss.png"),
        demon = gfx.image.new("images/demon.png"),
        skelly = gfx.image.new("images/skelly.png"),
        swine = gfx.image.new("images/swine.png")
    }
end

function bullethell:is_touching(x, y)
    return self.collision_map:sample(x, y) == gfx.kColorWhite
end

function bullethell:make_small_smoke(x, y)
    if #self.small_smoke_free > 0 then
        local idx = table.remove(self.small_smoke_free, 1)
        self.small_smoke[idx][1] = x - 44
        self.small_smoke[idx][2] = y - 50
        self.small_smoke[idx][3] = 0
    end
end

function bullethell:make_big_smoke(x, y)
    if #self.big_smoke_free > 0 then
        local idx = table.remove(self.big_smoke_free, 1)
        self.big_smoke[idx][1] = x - 46
        self.big_smoke[idx][2] = y - 52
        self.big_smoke[idx][3] = 0
    end
end

function bullethell:is_touching_rect(x, y, w, h)
    for i = 0, w do
        for j = 0, h do
            if self:is_touching(x + i, y + j) then
                return true
            end
        end
    end

    return false
end

function bullethell:is_touching_circle(x, y, r)
    local x1 = x - r
    local y1 = y - r
    local x2 = x + r
    local y2 = y + r
    for yi = y1, y2 do
        for xi = x1, x2 do
            local distX = xi - x + 0.5
            local distY = yi - y + 0.5
            local distance = math.sqrt(distX*distX + distY*distY);
            if distance <= r then
                if self:is_touching(xi, yi) then
                    return true
                end
            end
        end
    end

    return false
end

function bullethell:get_collision_map()
    return self.collision_map
end

function bullethell:load(file)
    local store = "/levels/" .. string.trim(file)
    local data = playdate.datastore.read(store)
    if data ~= nil then
        self.data = data
    else
        print("ERROR LOADING ERROR", file, store)
    end
end

function bullethell:destroy_bullet(i, o)
    self.free[i] = true
    o.px = -100
    o.y = -100
    table.insert(self.free_idx, i)
    self.bullet_pool:free(o)
end

function bullethell:create_new_bullet(b)
    local o = self.bullet_pool:obtain()
    o.model = b.model
    o.x = b.x or 0
    o.px = 20 + 40 * o.x
    o.y = b.y or 0

    local model = self.data.legend[o.model]
    if model ~= nil then
        o.angle = b.angle or (model.angle or 0)
        o.v = b.v or (model.v or 0)
    end

    if #self.free_idx > 0 then
        local idx = table.remove(self.free_idx, 1)
        self.bullets[idx] = o
        self.free[idx] = nil
    else
        table.insert(self.bullets, o)
    end

    return o
end

function bullethell:update(orbx, orby, orbr, music)
    for i, o in ipairs(self.small_smoke) do
        if o[3] >= 0 then
            o[3] = o[3] + 1
            if o[3] > 9 then
                o[3] = -1
                table.insert(self.small_smoke_free, i)
            end
        end
    end

    for i, o in ipairs(self.big_smoke) do
        if o[3] >= 0 then
            o[3] = o[3] + 1
            if o[3] > 11 then
                o[3] = -1
                table.insert(self.big_smoke_free, i)
            end
        end
    end

    local score = 0
    for i, o in ipairs(self.bullets) do
        if not self.free[i] then
            local model = self.data.legend[o.model]

            if model == nil then
                print("PROBLEM WITH MODEL FOR i=", i)
                print(o.model)
                printTable(self.data.legend)
            else
                o.v = o.v * (model.a or 1)
                local a = deg2rad(o.angle)
                local x, y = o.v * math.cos(a), o.v * math.sin(a)

                o.px = o.px + (x or 0)
                o.y = o.y + (y or 0)
                o.angle = o.angle + (model.rot or 0)

                if orbr ~= nil and dist_under(o.px, o.y, orbx, orby, orbr * 2) then
                    if model.sprite == nil then
                        self:destroy_bullet(i, o)
                        score = score + orbr
                    else
                        local up = 20
                        if model.size == "big" then up = 40 end
                        self:make_big_smoke(o.px + 10, o.y - 30)
                        music:play_scream_sound()
                        self:destroy_bullet(i, o)
                        score = score + up
                    end
                elseif o.px < -20 or o.px > 420 or o.y < -20 or o.y > 260 then
                    self:destroy_bullet(i, o)
                else
                    if model.emit ~= nil and model.freq ~= nil then
                        o.fq = o.fq + 1
                        if o.fq >= model.freq then
                            o.fq = 0
                            local n = #model.emit
                            for j = 1, n do
                                local part = model.emit[j]
                                local spawn = {
                                    model = part.model,
                                    angle = (part.angle or 0) + o.angle,
                                    x = o.x or 5,
                                    y = o.y or 10,
                                }
                                self:create_new_bullet(spawn)
                            end
                        end
                    end

                    if model.life ~= nil then
                        o.lt = o.lt + 1
                        if o.lt > model.life then
                            self:destroy_bullet(i, o)
                        end
                    end
                end
            end
        end
    end

    gfx.lockFocus(self.collision_map)
    gfx.clear(gfx.kColorClear)
    gfx.setColor(gfx.kColorWhite)

    local n = #self.bullets
    for i = 1, n do
        local o = self.bullets[i]
        local model = self.data.legend[o.model]
        if model.shape ~= nil then
            if model.shape == "circle" then
                gfx.fillCircleAtPoint(o.px, o.y, model.size)
            elseif model.shape == "arrow" then
                gfx.fillEllipseInRect(o.px - model.size / 2, o.y - model.size, model.size, 2 * model.size)
            end
        end
    end
    gfx.unlockFocus()

    self.time = self.time + 1
    local t = tostring(self.time)
    local p = self.data.progression[t]
    if p ~= nil then
        local l = #p
        for i = 1, l do
            self:create_new_bullet(p[i])
            local model = self.data.legend[p[i].model]
            if model.sprite ~= nil then
                local px = 20 + 40 * p[i].x
                if model.size == "big" then
                    self:make_big_smoke(px, p[i].y)
                else
                    self:make_small_smoke(px, p[i].y)
                end
            end
        end
    end

    return score
end

local gfx <const> = playdate.graphics

function bullethell:draw(plx)
    local n = #self.bullets
    gfx.setColor(gfx.kColorBlack)
    for i = 1, n do
        local o = self.bullets[i]
        local model = self.data.legend[o.model]

        if model.sprite ~= nil and self.sprites[model.sprite] ~= nil then
            if model.size == "big" then
                big_shade:drawCentered(o.px, o.y)
            else
                small_shade:drawCentered(o.px, o.y)
            end
        end

        if model.shape ~= nil then
            if model.shape == "circle" then
                gfx.fillCircleAtPoint(o.px, o.y, model.size + 3)
            elseif model.shape == "arrow" then
                gfx.fillEllipseInRect(o.px - model.size / 2 - 2, o.y - model.size - 2, model.size + 4, 2 * model.size + 4)
            end
        end
    end

    gfx.setImageDrawMode(gfx.kDrawModeBlackTransparent)
    self.collision_map:draw(0, 0, gfx.kImageUnflipped)
    gfx.setImageDrawMode(gfx.kDrawModeCopy)

    for i = 1, n do
        local o = self.bullets[i]
        local model = self.data.legend[o.model]
        if model.sprite ~= nil and self.sprites[model.sprite] ~= nil then
            local flip = gfx.kImageUnflipped
            if plx > o.px then flip = gfx.kImageFlippedX end
            self.sprites[model.sprite]:drawCentered(o.px, o.y, flip)
        end
    end
end

function bullethell:draw_vfx()
    for _, o in ipairs(self.small_smoke) do
        if o[3] >= 0 then
            small_smoke:draw(o[1], o[2], gfx.kImageUnflipped, playdate.geometry.rect.new((o[3] - 1) * 80, 0, 80, 80))
        end
    end

    for _, o in ipairs(self.big_smoke) do
        if o[3] >= 0 then
            big_smoke:draw(o[1], o[2], gfx.kImageUnflipped, playdate.geometry.rect.new((o[3] - 1) * 96, 0, 96, 96))
        end
    end
end
