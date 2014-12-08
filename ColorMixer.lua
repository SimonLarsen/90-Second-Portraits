local ColorMixer = class("ColorMixer", Entity)

ColorMixer.static.COLORS = {
	{ 255, 255, 255 }, { 0, 0, 0 },
	{ 192,0,0 }, { 255,160,0 },
	{ 255,255,0 }, { 0,128,0 },
	{ 0,0,192 }, { 128,0,128 }
}

function ColorMixer:initialize(slot, color)
	Entity.initialize(self)

	self.slot = slot
	self:reset()

	local h, s, v = math.rgbtohsv(color[1], color[2], color[3], 255)
	local hasHue = false
	if s > 0 then hasHue = true end
	self:updateColor(color, hasHue)
	self:addSplats()

	self.mix_circle = Resources.static:getImage("mix_circle.png")
	self.submit_button = Resources.static:getImage("submit.png")
	self.reset_button = Resources.static:getImage("reset.png")
	self.tubes = Resources.static:getImage("tubes.png")
	self.quads_tubes = {}
	for i=1, 8 do
		self.quads_tubes[i] = love.graphics.newQuad((i-1)*40, 0, 40, 60, 320, 60)
	end
end

function ColorMixer:reset()
	self.mycolor = nil
	self.hasHue = false
	self.splats = {}
end

function ColorMixer:updateColor(color, hasHue)
	self.hasHue = self.hasHue or hasHue

	if self.mycolor == nil then
		self.mycolor = { color[1], color[2], color[3] }
		return
	end

	local oh, os, ov = math.rgbtohsv(self.mycolor[1], self.mycolor[2], self.mycolor[3], 255)
	local nh, ns, nv = math.rgbtohsv(color[1], color[2], color[3], 255)

	local h, s, v
	if self.hasHue and hasHue then
		h = math.huemid(oh, math.huemid(oh, nh))
	elseif self.hasHue then
		h = oh
	elseif hasHue then
		h = nh
	else
		h = 0
	end
	s = (2*os + ns) / 3
	v = (2*ov + nv) / 3

	local r, g, b = math.hsvtorgb(h, s, v, 255)
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
				if i <= 2 then
					self:updateColor(ColorMixer.static.COLORS[i], false)
				else
					self:updateColor(ColorMixer.static.COLORS[i], true)
				end
				self:addSplats()
			end
		end
	end
end

function ColorMixer:addSplats()
	for i=1, 10 do
		local angle = love.math.random() * 2 * math.pi
		local offset = love.math.random(4, 25)
		local x = math.cos(angle) * offset
		local y = math.sin(angle) * offset
		local r = love.math.random() * 10
		local splat = { x=x, y=y, r=r }
		table.insert(self.splats, splat)
	end

	while #self.splats > 50 do
		table.remove(self.splats, 1)
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

	love.graphics.setColor(0, 0, 0)
	if self.mycolor then
		for i,v in ipairs(self.splats) do
			love.graphics.circle("fill", 80+v.x, 180+v.y, v.r+1, 32)
		end
	end
	if self.mycolor then
		love.graphics.setColor(self.mycolor)
		for i,v in ipairs(self.splats) do
			love.graphics.circle("fill", 80+v.x, 180+v.y, v.r, 32)
		end
	end

	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.draw(self.reset_button, 115, 215, 0, 1, 1, 16, 16)
	love.graphics.draw(self.submit_button, 201, 202)
end

function ColorMixer:getSlot()
	return self.slot
end

function ColorMixer:getColor()
	return self.mycolor
end

return ColorMixer
