local Canvas = class("Canvas", Entity)

function Canvas:initialize(x, y, w, h)
	Entity.initialize(self)

	self.x, self.y = x, y
	self._width, self._height = w, h

	self._canvas = love.graphics.newCanvas(self._width, self._height)
	self._canvas:clear(237, 217, 122, 255)

	self.cursor = Resources.static:getImage("brush_big.png")
end

function Canvas:draw()
	love.graphics.draw(self._canvas, self.x, self.y)
end

function Canvas:gui()
	local mx, my = Mouse.static:getPosition()
	love.graphics.draw(self.cursor, mx, my)
end

return Canvas
