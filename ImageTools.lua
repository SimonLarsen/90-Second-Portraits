local ImageTools = {}

function ImageTools.histogram(data, steps)
	local hist = {}
	local w, h = data:getDimensions()
	hist.steps = steps
	hist.width = w
	hist.height = h

	for r=0, steps-1 do
		hist[r] = {}
		for g=0, steps-1 do
			hist[r][g] = {}
			for b = 0, steps-1 do
				hist[r][g][b] = 0
			end
		end
	end

	for iy = 0, h-1 do
		for ix = 0, w-1 do
			local r, g, b = data:getPixel(ix, iy)
			local ir = math.floor(r / 256 * steps)
			local ig = math.floor(g / 256 * steps)
			local ib = math.floor(b / 256 * steps)
			hist[ir][ig][ib] = hist[ir][ig][ib] + 1
		end
	end

	local total = w * h
	for r=0, steps-1 do
		for g=0, steps-1 do
			for b = 0, steps-1 do
				hist[r][g][b] = hist[r][g][b] / total
			end
		end
	end

	return hist
end

-- Compares two histogram
-- Returns similarty from 0 to 1
-- where 1 is completely similar
function ImageTools.compare(hist1, hist2)
	assert(hist1.steps == hist2.steps)
	assert(hist1.width == hist2.width)
	assert(hist1.height == hist2.height)

	local steps = hist1.steps

	local dist = 0
	for r=0, steps-1 do
		for g=0, steps-1 do
			for b = 0, steps-1 do
				dist = dist + math.abs(hist1[r][g][b] - hist2[r][g][b])
			end
		end
	end

	return 1 - dist/2
end

return ImageTools
