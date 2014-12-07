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
	self.brush_dir = 1
	self.color = { 224, 24, 24, 255 }

	self.canvas = love.graphics.newCanvas(self.width, self.height)
	self.canvas:clear(241, 232, 199)

	self.brush_small = Animation(Resources.static:getImage("brush_small.png"), 30, 40)

	self.brush_big = Animation(Resources.static:getImage("brush_big.png"), 40, 50)
	self.brush_big_tips = Animation(Resources.static:getImage("brush_big_tips.png"), 40, 50)

	self.bucket = Resources.static:getImage("bucket.png")
	self.bucket_cursor = Resources.static:getImage("bucket_cursor.png")
	self.bucket_contents = Resources.static:getImage("bucket_contents.png")
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
			self.brush_dir = 2
		elseif self.tool == 3 then
			self.lastx = mx
			self.lasty = my
			self.brush_dir = 2
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

	if Mouse.static:isDown("l") then
		if self.tool == 1 or self.tool == 2 then
			local size = Canvas.static.BRUSH[self.tool].size
			love.graphics.setLineWidth(size)
			love.graphics.line(self.lastx, self.lasty, mx, my)
			love.graphics.circle("fill", self.lastx, self.lasty, size/2, 32)
			love.graphics.circle("fill", mx, my, size/2, 32)

			if mx > self.lastx then
				self.brush_dir = 2
			elseif mx < self.lastx then
				self.brush_dir = 3
			end
			self.lastx, self.lasty = mx, my
		end
	else
		self.brush_dir = 1
	end

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setCanvas()
end

function Canvas:draw()
	love.graphics.draw(self.canvas, self.x, self.y)
end

function Canvas:gui()
	local mx, my = Mouse.static:getPosition()
	if self.tool == 1 then
		love.graphics.draw(self.brush_small._image, self.brush_small._quads[self.brush_dir], mx, my, 0, 1, 1, 9, 2)
	elseif self.tool == 2 then
		love.graphics.draw(self.brush_big._image, self.brush_big._quads[self.brush_dir], mx, my, 0, 1, 1, 14, 3)
		love.graphics.setColor(self.color)
		love.graphics.draw(self.brush_big_tips._image, self.brush_big_tips._quads[self.brush_dir], mx, my, 0, 1, 1, 14, 3)
	elseif self.tool == 3 then
		love.graphics.draw(self.bucket_cursor, mx, my, 0, 1, 1, 8, 8)
		love.graphics.draw(self.bucket, mx, my, 0, 1, 1, 17, -17)
		love.graphics.setColor(self.color)
		love.graphics.draw(self.bucket_contents, mx, my, 0, 1, 1, 17, -17)
	end
	love.graphics.setColor(255, 255, 255)
end

function Canvas:setColor(c)
	self.color = c
end

function Canvas:setTool(t)
	self.tool = t
end

return Canvas
