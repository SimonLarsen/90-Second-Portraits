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
	return math.random() - math.random()
end
