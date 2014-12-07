local Palette = class("Palette", Entity)

Palette.static.PAINT_POS = { {7, 7}, {34, -4}, {67, -9}, {101, -1} }

function Palette:initialize(x, y)
	Entity.initialize(self, x, y, 1)

	self.colors = {
		{255, 255, 255},
		{48, 213, 48},
		{63, 127, 193},
		{224, 54, 54}
	}

	self.image = Resources.static:getImage("palette.png")
	self.paint = Animation(Resources.static:getImage("paint.png"), 24, 21)
	self.canvas = nil
end

function Palette:update(dt)
	local mx, my = Mouse.static:getPosition()

	if self.canvas == nil then
		self.canvas = self.scene:findOfType("Canvas")
	end

	if Mouse.static:wasPressed("l") then
		for i=1,4 do
			local x = self.x + Palette.static.PAINT_POS[i][1]
			local y = self.y + Palette.static.PAINT_POS[i][2]

			if mx >= x and mx <= x + 24
			and my >= y and my <= y + 21 then
				self.canvas:setColor(self.colors[i])
			end
		end
	end
end

function Palette:gui()
	love.graphics.draw(self.image, self.x, self.y)

	for i=1, 4 do
		love.graphics.setColor(self.colors[i])
		local x = self.x + Palette.static.PAINT_POS[i][1]
		local y = self.y + Palette.static.PAINT_POS[i][2]
		love.graphics.draw(self.paint._image, self.paint._quads[i], x, y)
	end
	love.graphics.setColor(255, 255, 255)
end

return Palette
