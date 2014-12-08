local Background = class("Background", Entity)

Background.static.NUM_BACKGROUNDS = 5

function Background:initialize(id)
	Entity.initialize(self, WIDTH-152, -184, 30)

	self.id = id
	self.state = 1

	self.image = Resources.static:getImage("background"..self.id..".png")
end

function Background:update(dt)
	if self.state == 1 then
		self.y = self.y + dt*170
		if self.y >= 2 then
			self.y = 2
			self.state = 2
		end
	elseif self.state == 3 then
		self.y = self.y - dt*170
		if self.y <= -400 and self.nextid then
			self.y = -184
			self.state = 1

			self.id = self.nextid
			if self.id > Background.static.NUM_BACKGROUNDS then
				self.id = 1
			end
			self.image = Resources.static:getImage("background"..self.id..".png")
		end
	end
end

function Background:draw()
	love.graphics.draw(self.image, self.quads[self.id], self.x, self.y)
end

function Background:swap(nextid)
	self.state = 3
	self.nextid = nextid
end

return Background
