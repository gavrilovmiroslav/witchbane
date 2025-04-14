
function dist_under(x1, y1, x2, y2, r)
	local x = x1 - x2
	local y = y1 - y2
	local xs = x * x
	local ys = y * y
	local l = math.sqrt(xs + ys)
	return l < r
end

function norm(x, y)
	local xs = x * x
	local ys = y * y
	local l = math.sqrt(xs + ys)
	if l == 0 then return 0, 0 end
	return x / l, y / l
end

function lerp(a, b, n)
	return a + (b - a) * n
end

function deg2rad(rad)
	return rad * math.pi / 180
end

function rad2deg(deg)
	return deg * 180 / math.pi
end

function string.starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start
end

function string.trim(String)
	return String:match"^%s*(.*)":match"(.-)%s*$"
end