function math.sign(x)
	if x < 0 then return -1
	elseif x > 0 then return 1
	else return 0 end
end

function math.round(x)
	return math.floor(x+0.5)
end

function math.cap(x, min, max)
	return math.min(max, math.max(min, x))
end

function math.gauss()
	return love.math.random() - love.math.random()
end

function math.rgbtohsv(r, g, b, a)
  r, g, b, a = r / 255, g / 255, b / 255, a / 255
  local max, min = math.max(r, g, b), math.min(r, g, b)
  local h, s, v
  v = max

  local d = max - min
  if max == 0 then s = 0 else s = d / max end

  if max == min then h = 0
  else
    if max == r then
    h = (g - b) / d
    if g < b then h = h + 6 end
    elseif max == g then h = (b - r) / d + 2
    elseif max == b then h = (r - g) / d + 4
    end
    h = h / 6
  end

  return h, s, v, a
end

function math.hsvtorgb(h, s, v, a)
  local r, g, b

  local i = math.floor(h * 6);
  local f = h * 6 - i;
  local p = v * (1 - s);
  local q = v * (1 - f * s);
  local t = v * (1 - (1 - f) * s);

  i = i % 6

  if i == 0 then r, g, b = v, t, p
  elseif i == 1 then r, g, b = q, v, p
  elseif i == 2 then r, g, b = p, v, t
  elseif i == 3 then r, g, b = p, q, v
  elseif i == 4 then r, g, b = t, p, v
  elseif i == 5 then r, g, b = v, p, q
  end

  return r * 255, g * 255, b * 255, a * 255
end

function math.huemid(a, b)
	local lower = math.min(a, b)
	local higher = math.max(a, b)

	if higher - lower > 0.5 then
		return (higher + (1 + lower - higher) / 2) % 1
	else
		return (higher + lower) / 2
	end
end

function math.seq(from, to)
	local t = {}
	for i=from, to do
		table.insert(t, i)
	end
	return t
end

function math.subset(t, n)
	local s = {}
	for i=1, n do
		local index = love.math.random(1, #t)
		table.insert(s, t[index])
		table.remove(t, index)
	end
	return s
end
