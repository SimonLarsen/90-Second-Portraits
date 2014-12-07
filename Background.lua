local Background = class("Background", Entity)

Background.static.NUM_BACKGROUNDS = 5

function Background:initialize()
	Entity.initialize(self, WIDTH-152, -184, 30)

	self.id = 1
	self.state = 1

	self.image = Resources.static:getImage("backgrounds.png")
	self.quads = {}
	for i=1, Background.static.NUM_BACKGROUNDS do
		self.quads[i] = love.graphics.newQuad((i-1)*152, 0, 152, 184, 760, 184)
	end
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
		if self.y <= -400 then
			self.y = -184
			self.state = 1

			self.id = self.id + 1
			if self.id > Background.static.NUM_BACKGROUNDS then
				self.id = 1
			end
		end
	end
end

function Background:draw()
	love.graphics.draw(self.image, self.quads[self.id], self.x, self.y)
end

function Background:swap()
	self.state = 3
end

return Background
