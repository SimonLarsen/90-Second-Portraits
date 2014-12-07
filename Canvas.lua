local Canvas = class("Canvas", Entity)

Canvas.static.BRUSH = {
	{ size = 4, spacing = 2 },
	{ size = 8, spacing = 3 },
	{ size = 0, spacing = 0 }
}

function Canvas:initialize(x, y, w, h)
	Entity.initialize(self)

	self.x, self.y = x, y
	self.width, self.height = w, h

	self.tool = 2
	self.color = { 224, 24, 24, 255 }

	self.canvas = love.graphics.newCanvas(self.width, self.height)
	self.canvas:clear(241, 232, 199)

	self.cursor = Resources.static:getImage("brush_big.png")
end

function Canvas:update(dt)
	local mx, my = Mouse.static:getPosition()
	mx = mx - self.x
	my = my - self.y

	if love.keyboard.isDown("1") then
		self.tool = 1
	end
	if love.keyboard.isDown("2") then
		self.tool = 2
	end
	if love.keyboard.isDown("3") then
		self.tool = 3
	end

	-- Check mouse controls
	local spacing = Canvas.static.BRUSH[self.tool].spacing

	love.graphics.setCanvas(self.canvas)
	love.graphics.setColor(self.color)

	if Mouse.static:wasPressed("l") then
		if self.tool == 1 or self.tool == 2 then
			self.lastx = mx
			self.lasty = my
		elseif self.tool == 3 then
			self.lastx = mx
			self.lasty = my
		end
	end

	if Mouse.static:wasReleased("l") and self.tool == 3 then
		local radius = my - self.lasty
		for i=1,10 do
			local angle = love.math.random()*2*math.pi
			local offset = love.math.random()*radius
			local size = love.math.random() * radius/2
			local x = self.lastx + math.cos(angle) * offset
			local y = self.lasty + math.sin(angle) * offset
			love.graphics.circle("fill", x, y, size, 32)
		end
	end

	if Mouse.static:isDown("l") and (self.tool == 1 or self.tool == 2) then
		local size = Canvas.static.BRUSH[self.tool].size
		love.graphics.setLineWidth(size)
		love.graphics.line(self.lastx, self.lasty, mx, my)
		love.graphics.circle("fill", self.lastx, self.lasty, size/2, 32)
		love.graphics.circle("fill", mx, my, size/2, 32)

		self.lastx, self.lasty = mx, my
	end

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setCanvas()
end

function Canvas:draw()
	love.graphics.draw(self.canvas, self.x, self.y)
end

function Canvas:gui()
	local mx, my = Mouse.static:getPosition()
	love.graphics.draw(self.cursor, mx, my)
end

function Canvas:setColor(c)
	self.color = c
end

function Canvas:setTool(t)
	self.tool = t
end

return Canvas
