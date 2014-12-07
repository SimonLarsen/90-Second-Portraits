local Customer = class("Customer", Entity)

function Customer:initialize()
	Entity.initialize(self, 0, 0, 20)

	self.id = 1
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

		if self.x > WIDTH+146 then
			self.id = self.id + 1
			self:reset()
		end
	end
end

function Customer:swap()
	self.state = 3
end

function Customer:draw()
	love.graphics.draw(self.image, self.x, HEIGHT+self.y, 0, 1, 1, self.width/2, self.height)
end

return Customer
