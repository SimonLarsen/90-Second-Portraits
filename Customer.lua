local Customer = class("Customer", Entity)

function Customer:initialize(id)
	Entity.initialize(self, 0, 0, 20)

	self.image = Resources.static:getImage("customer"..id..".png")
	self.width = self.image:getWidth()
	self.height = self.image:getHeight()
	self.state = 0

	self.x = WIDTH + self.width/2
end

function Customer:update(dt)
	if self.state == 0 then
		self.x = self.x - dt * 100
		if self.x <= 240 then
			self.x = 240
			self.state = 1
		end
	end
end

function Customer:draw()
	love.graphics.draw(self.image, self.x, HEIGHT+self.y, 0, 1, 1, self.width/2, self.height)
end

return Customer
