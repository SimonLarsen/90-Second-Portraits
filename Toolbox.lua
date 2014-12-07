local Toolbox = class("Toolbox", Entity)

function Toolbox:initialize(x, y)
	Entity.initialize(self, x, y, 5)

	self.image_back = Resources.static:getImage("toolbox_back.png")
	self.image_front = Resources.static:getImage("toolbox_front.png")
end

function Toolbox:gui()
	love.graphics.draw(self.image_back, self.x, self.y)
	love.graphics.draw(self.image_front, self.x, self.y)
end

return Toolbox
