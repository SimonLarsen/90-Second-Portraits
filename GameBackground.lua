local GameBackground = class("GameBackground", Entity)

function GameBackground:initialize()
	Entity.initialize(self, 0, 0, 100)

	self.image = Resources.static:getImage("background.png")
end

function GameBackground:draw()
	love.graphics.draw(self.image, 0, 0)
end

return GameBackground
