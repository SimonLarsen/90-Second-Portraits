local Canvas = class("Canvas", Entity)

Canvas.static.BRUSH = {
	{ size = 4, spacing = 2 },
	{ size = 8, spacing = 3 },
	{ size = 0, spacing = 0 }
}

function Canvas:initialize(x, y, w, h)
	Entity.initialize(self)

	self.x, self.y = x, y
	self._width, self._height = w, h

	self._tool = 2
	self._color = { 224, 24, 24, 255 }

	self._canvas = love.graphics.newCanvas(self._width, self._height)
	self._canvas:clear(237, 217, 122, 255)

	self._cursor = Resources.static:getImage("brush_big.png")

	self._splats = {}
	self._splats[2] = Resources.static:getImage("splats_big.png")
	self._splat_quads = {}
	for brush = 1, 2 do
		local size = Canvas.static.BRUSH[brush].size
		for i=0,3 do
			self._splat_quads[brush] = love.graphics.newQuad(i*size, 0, size, size, size*4, size)
		end
	end
end

function Canvas:update(dt)
	local mx, my = Mouse.static:getPosition()
	mx = mx - self.x
	my = my - self.y
	local spacing = Canvas.static.BRUSH[self._tool].spacing
	local size = Canvas.static.BRUSH[self._tool].size

	love.graphics.setCanvas(self._canvas)
	love.graphics.setColor(self._color)

	if Mouse.static:wasPressed("l") then
		if self._tool == 1 or self._tool == 2 then
			local brush_index = love.math.random(0, 3)
			love.graphics.draw(self._splats[self._tool], self._splat_quads[self._tool], mx, my, 0, 1, 1, size/2, size/2)
			self._lastx = mx
			self._lasty = my
		elseif self._tool == 3 then
			self._lastx = mx
			self._lasty = my
		end
	end

	if Mouse.static:wasReleased("l") and self._tool == 3 then
		local radius = my - self._lasty
		for i=1,10 do
			local angle = love.math.random()*2*math.pi
			local offset = love.math.random()*radius
			local size = love.math.random() * radius/2
			local x = self._lastx + math.cos(angle) * offset
			local y = self._lasty + math.sin(angle) * offset
			love.graphics.circle("fill", x, y, size, 32)
		end
	end

	if Mouse.static:isDown("l") and (self._tool == 1 or self._tool == 2) then
		local xdist = math.cap(mx, 0, self._width) - self._lastx
		local ydist = math.cap(my, 0, self._height) - self._lasty
		local fsteps = math.sqrt(xdist^2 + ydist^2) / spacing
		local steps = math.floor(fsteps)
		if steps > 0 then
			local xinc = xdist / fsteps
			local yinc = ydist / fsteps
			for i=1, steps-1 do
				self._lastx = self._lastx + xinc
				self._lasty = self._lasty + yinc
				love.graphics.draw(self._splats[self._tool], self._splat_quads[self._tool], self._lastx, self._lasty, 0, 1, 1, size/2, size/2)
			end
		end
	end

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setCanvas()
end

function Canvas:draw()
	love.graphics.draw(self._canvas, self.x, self.y)
end

function Canvas:gui()
	local mx, my = Mouse.static:getPosition()
	love.graphics.draw(self._cursor, mx, my)
end

return Canvas
