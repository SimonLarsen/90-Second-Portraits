local Customer = class("Customer", Entity)

function Customer:initialize(id)
	Entity.initialize(self, WIDTH+90, 125, 20)

	self.image = Resources.static:getImage("customer"..id..".png")
	self.state = 0
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
	love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, 90, 115)
end

return Customer
