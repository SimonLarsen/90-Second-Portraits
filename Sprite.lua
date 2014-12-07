local Sprite = class("Sprite", Entity)

function Sprite:initialize(x, y, z, image, ox, oy)
	Entity.initialize(self, x, y, z)

	self.image = image
	self.ox = ox or image:getWidth()/2
	self.oy = oy or image:getHeight()/2
end

function Sprite:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.ox, self.oy)
end

return Sprite
