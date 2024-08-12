-- Put your utilities and other helper functions here.
-- The "Utilities" table is already defined in "noble/Utilities.lua."
-- Try to avoid name collisions.

function Utilities.getIndexForStat(stat)
	if stat == "artifacts" then return 1
	elseif stat == "affluence" then return 2
	elseif stat == "herbs" then return 3
	elseif stat == "familiars" then return 4
	elseif stat == "coven" then return 5
	elseif stat == "suspicion" then return 6
	else return 0 end
end

function Utilities.getStat(index)
	local names = { 
		"artifacts",
		"affluence",
		"herbs",
		"familiars",
		"coven",
		"suspicion"
	}

	return names[index]
end

function playdate.graphics.drawInvertedText(...)
	local gfx = playdate.graphics

	local original_draw_mode = gfx.getImageDrawMode()

	gfx.setImageDrawMode( playdate.graphics.kDrawModeInverted )
	Font:drawText(...)
	gfx.setImageDrawMode( original_draw_mode )
end

function playdate.graphics.drawInvertedTextAligned(...)
	local gfx = playdate.graphics

	local original_draw_mode = gfx.getImageDrawMode()

	gfx.setImageDrawMode( playdate.graphics.kDrawModeInverted )
	Font:drawTextAligned(...)
	gfx.setImageDrawMode( original_draw_mode )
end

function table.copy(t)
	local u = { }
	for k, v in pairs(t) do u[k] = v end
	return setmetatable(u, getmetatable(t))
end

function table.find(f, l) -- find element v of l satisfying f(v)
	for i, v in ipairs(l) do
		if f(v) then
			return i
		end
	end
	return -1
end

function table.shuffle(t)
	if t == nil then return end
	if #t < 2 then return end

    for i = #t, 2, -1 do
        local j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end
