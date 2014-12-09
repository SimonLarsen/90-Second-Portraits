local Canvas = class("Canvas", Entity)

Canvas.static.BRUSH = {
	{ size = 3, spacing = 2 },
	{ size = 8, spacing = 3 },
	{ size = 0, spacing = 0 }
}

function Canvas:initialize()
	Entity.initialize(self)

	self.tool = 2
	self.brush_dir = 1
	self.color = { 224, 24, 24, 255 }
	self.width = 120
	self.height =  160

	self.canvas = love.graphics.newCanvas(self.width, self.height)
	self.canvas_bg = Resources.static:getImage("canvas.png")
	self:reset()

	self.splatter = Resources.static:getImage("splatter.png")
	self.brush_small = Animation(Resources.static:getImage("brush_small.png"), 30, 40)
	self.brush_small_tips = Animation(Resources.static:getImage("brush_small_tips.png"), 30, 40)
	self.brush_big = Animation(Resources.static:getImage("brush_big.png"), 40, 50)
	self.brush_big_tips = Animation(Resources.static:getImage("brush_big_tips.png"), 40, 50)
	self.bucket = Resources.static:getImage("bucket.png")
	self.bucket_aim = Resources.static:getImage("bucket_aim.png")
	self.bucket_cursor = Resources.static:getImage("bucket_cursor.png")
	self.bucket_contents = Resources.static:getImage("bucket_contents.png")
end

function Canvas:reset()
	self.x, self.y = 20, -165
	self.yspeed = 150
	self.hits = 0
	self.rotation = 0
	self.state = 1

	self.canvas:clear(241, 232, 199)
end

function Canvas:update(dt)
	local mx, my = Mouse.static:getPosition()

	if self.state == 1 then
		self.yspeed = self.yspeed + 200*dt
		self.y = self.y + self.yspeed * dt
		if self.y >= 28 then
			if self.hits >= 1 then
				self.hits = 0
				self.y = 28
				self.yspeed = 0
				self.rotation = 0
				self.state = 2
			else
				self.hits = self.hits + 1
				self.y = 28
				self.yspeed = self.yspeed * -0.2
			end
		end
	end

	if self.state == 1 or self.state == 2 then
		mx = mx - self.x
		my = my - self.y

		-- Check mouse controls
		local spacing = Canvas.static.BRUSH[self.tool].spacing

		local oldCanvas = love.graphics.getCanvas()

		love.graphics.setCanvas(self.canvas)
		love.graphics.setColor(self.color)

		if Mouse.static:wasPressed("l") then
			if self.tool == 1 or self.tool == 2 then
				self.lastx = mx
				self.lasty = my
				self.brush_dir = 2
				if self.lastx >= 0 and self.lastx < self.width
				and self.lasty >= 0 and self.lasty < self.height then
					Sound.play("brush.wav")
				end
			elseif self.tool == 3 then
				self.lastx = mx
				self.lasty = my
				self.brush_dir = 2
			end
		end

		if Mouse.static:wasReleased("l") and self.tool == 3 and self.lastx then
			if self.lastx >= 0 and self.lastx < self.width
			and self.lasty >= 0 and self.lasty < self.height then
				local radius = math.abs(my - self.lasty)
				local scale = 4*radius / 415
				local rotation = love.math.random() * 2 * math.pi
				love.graphics.draw(self.splatter, self.lastx, self.lasty, rotation, scale, scale, 202, 152)
				Sound.play("splat_big.wav")
			end
		end

		if Mouse.static:isDown("l") then
			if self.tool == 1 or self.tool == 2 and self.lastx then
				local size = Canvas.static.BRUSH[self.tool].size
				love.graphics.setLineWidth(size)
				love.graphics.line(self.lastx, self.lasty, mx, my)
				love.graphics.circle("fill", self.lastx, self.lasty, size/2, 32)
				love.graphics.circle("fill", mx, my, size/2, 32)

				self.lastx, self.lasty = mx, my
			end
		else
			self.brush_dir = 1
		end

		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setCanvas(oldCanvas)
	end

	if self.state == 3 then
		self.x = self.x + dt*400
		self.y = self.y - dt*200
		self.rotation = self.rotation + dt*4

		if self.x > WIDTH + 80 then
			self:reset()
		end
	end
end

function Canvas:draw()
	love.graphics.draw(self.canvas_bg, self.x+60, self.y+80, self.rotation, 1, 1, 60, 80)
	love.graphics.draw(self.canvas, self.x+60, self.y+80, self.rotation, 1, 1, 60, 80)
end

function Canvas:gui()
	if self:isActive() == false then return end

	local mx, my = Mouse.static:getPosition()
	if self.tool == 1 then
		love.graphics.draw(self.brush_small._image, self.brush_small._quads[self.brush_dir], mx, my, 0, 1, 1, 9, 2)
		love.graphics.setColor(self.color)
		love.graphics.draw(self.brush_small_tips._image, self.brush_small_tips._quads[self.brush_dir], mx, my, 0, 1, 1, 9, 2)

	elseif self.tool == 2 then
		love.graphics.draw(self.brush_big._image, self.brush_big._quads[self.brush_dir], mx, my, 0, 1, 1, 14, 3)
		love.graphics.setColor(self.color)
		love.graphics.draw(self.brush_big_tips._image, self.brush_big_tips._quads[self.brush_dir], mx, my, 0, 1, 1, 14, 3)

	elseif self.tool == 3 then
		if self.brush_dir == 1 then
			love.graphics.draw(self.bucket_cursor, mx, my, 0, 1, 1, 8, 8)
			love.graphics.draw(self.bucket, mx, my, 0, 1, 1, 17, -17)
			love.graphics.setColor(self.color)
			love.graphics.draw(self.bucket_contents, mx, my, 0, 1, 1, 17, -17)
		else
			love.graphics.draw(self.bucket_cursor, self.x+self.lastx, self.y+self.lasty, 0, 1, 1, 8, 8)
			love.graphics.draw(self.bucket_aim, mx, my, 0, 1, 1, 17, -17)
		end
	end

	love.graphics.setColor(255, 255, 255)
end

function Canvas:swap()
	self.state = 3
	Sound.play("woosh.wav")
end

function Canvas:setColor(c)
	self.color = c
end

function Canvas:setTool(t)
	self.tool = t
end

function Canvas:getImageData()
	return self.canvas:getImageData()
end

return Canvas
