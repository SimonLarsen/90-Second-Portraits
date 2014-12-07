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
	self:reset()

	self.mix_circle = Resources.static:getImage("mix_circle.png")
	self.submit_button = Resources.static:getImage("submit.png")
	self.reset_button = Resources.static:getImage("reset.png")
	self.tubes = Resources.static:getImage("tubes.png")
	self.quads_tubes = {}
	for i=1, 8 do
		self.quads_tubes[i] = love.graphics.newQuad((i-1)*40, 0, 40, 60, 320, 60)
	end
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

	if totals[1] > 0 then
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
		local x = (i % 4) * 40
		local y = math.floor((i-1) / 4) * 64

		if mx >= 99 and mx <= 131
		and my >= 199 and my <= 231 then
			if Mouse.static:wasPressed("l") then
				self:reset()
			end
		end

		if mx >= x and mx <= x+40
		and my >= y and my <= y+64 then
			if Mouse.static:wasPressed("l") then
				self.counts[i] = self.counts[i] + 1
				self:updateColor()

				for i=1, 10 do
					local angle = love.math.random() * 2 * math.pi
					local offset = math.random(4, 25)
					local x = math.cos(angle) * offset
					local y = math.sin(angle) * offset
					local r = math.random() * 10
					local splat = { x=x, y=y, r=r }
					table.insert(self.splats, splat)
				end

				while #self.splats > 50 do
					table.remove(self.splats, 1)
				end
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

	love.graphics.setColor(255, 255, 255, 255)
	for i=1, #ColorMixer.static.COLORS do
		local x = (i % 4) * 40
		local y = math.floor((i-1) / 4) * 64
		love.graphics.draw(self.tubes, self.quads_tubes[i], x, y)
	end

	love.graphics.draw(self.mix_circle, 80, 180, 0, 1, 1, 45, 45)

	if self.total > 0 then
		love.graphics.setColor(self.mycolor)
		for i,v in ipairs(self.splats) do
			love.graphics.circle("fill", 80+v.x, 180+v.y, v.r, 32)
		end
	end

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.draw(self.reset_button, 115, 215, 0, 1, 1, 16, 16)
	love.graphics.draw(self.submit_button, 201, 202)
end

function ColorMixer:reset()
	self.mycolor = { 0, 0, 0 }
	self.counts = {}
	for i=1,#ColorMixer.static.COLORS do
		self.counts[i] = 0
	end
	self.total = 0
	self.splats = {}
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
