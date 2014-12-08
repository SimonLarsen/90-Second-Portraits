local Customer = class("Customer", Entity)

function Customer:initialize(id)
	Entity.initialize(self, 0, 0, 20)

	self.id = id
	self:reset()
end

function Customer:reset()
	self.image = Resources.static:getImage("customer".. self.id ..".png")
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()
	self.state = 1

	self.x = WIDTH + self.width/2
end

function Customer:update(dt)
	if self.state == 1 then
		self.x = self.x - dt * 100
		self.y = 10 - math.abs(math.cos((240 - self.x) / 10)) * 10
		if self.x <= 240 then
			self.x = 240
			self.y = 0
			self.state = 2
		end

	elseif self.state == 3 then
		self.x = self.x + dt * 100
		self.y = 10 - math.abs(math.cos((240 - self.x) / 10)) * 10

		if self.x > WIDTH+146 and self.nextid then
			self.id = self.nextid
			self:reset()
		end
	end
end

function Customer:swap(nextid)
	self.state = 3
	self.nextid = nextid
end

function Customer:draw()
	love.graphics.draw(self.image, self.x, HEIGHT+self.y, 0, 1, 1, self.width/2, self.height)
end

function Customer:getState()
	return self.state
end

return Customer
