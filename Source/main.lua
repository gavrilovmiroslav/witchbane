local cauldron <const> = import "cauldron"

local gfx <const> = cauldron.graphics
local fsm <const> = cauldron.fsm
local cut <const> = cauldron.cutscene

function cauldron.load()
	gfx.load_font("small", "font//topaz_11")
	gfx.load_font("big", "font//Mini Sans 2X")
	gfx.load_image("boss", "images//boss.png")

	local game = fsm.new("game")
	game:add_state("a")
	game:add_state("b")
	game:add_link("a", "b", "foo", function(x) print("FOO" .. tostring(x)) end)
	game:add_link("b", "a", "bar", function(x) print("BAR" .. tostring(x)) end)
end

function cauldron.debug(message)
	fsm.get("game"):follow(message)
end

function cauldron.update()

end

function cauldron.draw()
	gfx.clear()
	gfx.set_font("big")
	gfx.draw_text(10, 10, "Hello world")
	gfx.draw_image(100, 100, "boss")
end

cauldron.init()