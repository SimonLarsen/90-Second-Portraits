local Customer = class("Customer", Entity)

function Customer:initialize(id)
	Entity.initialize(self, WIDTH+90, 125, 20)

	self.image = Resources.static:getImage("customer"..id..".png")
end

function Customer:update(dt)
	self.x = math.max(240, self.x - dt * 100)
end

function Customer:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, 90, 115)
end

return Customer
