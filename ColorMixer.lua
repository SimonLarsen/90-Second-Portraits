local ColorMixer = class("ColorMixer", Entity)

ColorMixer.static.COLORS = {
	{ 255, 255, 255 }, { 0, 0, 0 },
	{ 192,0,0 }, { 255,160,0 },
	{ 255,255,0 }, { 0,128,0 },
	{ 0,0,192 }, { 128,0,128 }
}

function ColorMixer:initialize(slot)
	Entity.initialize(self)

	self.slot = slot
	self.mycolor = { 0, 0, 0 }
	self.counts = {}
	for i=1,#ColorMixer.static.COLORS do
		self.counts[i] = 0
	end
	self.total = 0
end

function ColorMixer:updateColor()
	local mix = {0, 0, 0}
	local totals = {0, 0, 0}
	self.total = 0
	for i,v in ipairs(ColorMixer.static.COLORS) do
		local h, s, v = math.rgbtohsv(v[1], v[2], v[3], 255)
		if i >= 3 then
			mix[1] = mix[1] + h * self.counts[i]
			totals[1] = totals[1] + self.counts[i]
		end

		mix[2] = mix[2] + s * self.counts[i]
		mix[3] = mix[3] + v * self.counts[i]

		totals[2] = totals[2] + self.counts[i]
		totals[3] = totals[3] + self.counts[i]

		self.total = self.total + self.counts[i]
	end

	if totals[1] == 0 then
		mix[1] = 0
	else
		mix[1] = mix[1] / totals[1]
	end
	mix[2] = mix[2] / totals[2]
	mix[3] = mix[3] / totals[3]

	local r, g, b = math.hsvtorgb(mix[1], mix[2], mix[3], 255)
	self.mycolor = { r, g, b }
end

function ColorMixer:update(dt)
	local mx, my = Mouse.static:getPosition()

	for i=1, #ColorMixer.static.COLORS do
		local x = (i % 4 + 1) * 32 - 16
		local y = math.floor((i-1) / 4) * 64

		if mx >= x and mx <= x+32
		and my >= y and my <= y+64 then
			if Mouse.static:wasPressed("l") then
				self.counts[i] = self.counts[i] + 1
				self:updateColor()
			end
		end
	end
end

function ColorMixer:gui()
	love.graphics.setColor(0, 0, 0, 200)
	love.graphics.rectangle("fill", 0, 0, 180, HEIGHT)
	love.graphics.rectangle("fill", 300, 0, 180, HEIGHT)
	love.graphics.rectangle("fill", 180, 0, 120, 10)
	love.graphics.rectangle("fill", 180, 170, 120, HEIGHT-170)

	for i,v in ipairs(ColorMixer.static.COLORS) do
		love.graphics.setColor(v)
		local x = (i % 4 + 1) * 32 - 16
		local y = math.floor((i-1) / 4) * 64
		love.graphics.rectangle("fill", x, y, 32, 64)
	end

	if self.total > 0 then
		love.graphics.setColor(self.mycolor)
		love.graphics.rectangle("fill", WIDTH/4-32, HEIGHT-96, 64, 64)
	end

	love.graphics.setColor(255, 255, 255, 255)
end

function ColorMixer:getSlot()
	return self.slot
end

function ColorMixer:getTotal()
	return self.total
end

function ColorMixer:getColor()
	return self.mycolor
end

return ColorMixer
