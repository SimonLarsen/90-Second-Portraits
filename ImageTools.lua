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
function ImageTools.compareHistograms(hist1, hist2)
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

function ImageTools.downscale(data, size)
	local w, h = data:getDimensions()

	local xbuckets = w / size
	local ybuckets = h / size
	local count = size*size

	local buckets = {}
	for ix=0, xbuckets-1 do
		buckets[ix] = {}
		for iy=0, ybuckets-1 do
			local mb = {0, 0, 0}

			for x=ix*size, (ix+1)*size-1 do
				for y=iy*size, (iy+1)*size-1 do
					local r, g, b = data:getPixel(x, y)
					mb[1] = mb[1] + r
					mb[2] = mb[2] + g
					mb[3] = mb[3] + b
				end
			end

			mb[1] = mb[1] / count
			mb[2] = mb[2] / count
			mb[3] = mb[3] / count
			buckets[ix][iy] = mb
		end
	end

	return buckets
end

function ImageTools.compareBuckets(data1, data2, size)
	assert(data1:getWidth() == data2:getWidth())
	assert(data1:getHeight() == data2:getHeight())

	local small1 = ImageTools.downscale(data1, size)
	local small2 = ImageTools.downscale(data2, size)

	local xbuckets = data1:getWidth() / size
	local ybuckets = data1:getHeight() / size

	local dist = 0
	for ix=0, xbuckets-1 do
		for iy=0, ybuckets-1 do
			local rdist = small1[ix][iy][1] - small2[ix][iy][1]
			local gdist = small1[ix][iy][2] - small2[ix][iy][2]
			local bdist = small1[ix][iy][3] - small2[ix][iy][3]

			dist = dist + math.rgbdistance(small1[ix][iy][1], small1[ix][iy][2], small1[ix][iy][3], small2[ix][iy][1], small2[ix][iy][2], small2[ix][iy][3])
		end
	end

	return 1 - math.min(50000, dist)/50000
end

return ImageTools
