local ColorMixer = require("ColorMixer")

local Palette = class("Palette", Entity)

Palette.static.PAINT_POS = { {7, 7}, {34, -4}, {67, -9}, {101, -1} }

function Palette:initialize(x, y)
	Entity.initialize(self, x, y, 2)

	self.colors = {
		{1, 1, 1},
		{48/255, 213/255, 48/255},
		{63/255, 127/255, 193/255},
		{224/255, 54/255, 54/255}
	}

	self.selection = 1
	self.state = 1

	self.image_base = Resources.static:getImage("palette.png")
	self.image_mix = Resources.static:getImage("mix_button.png")
	self.paint = Animation(Resources.static:getImage("paint.png"), 24, 21)
	self.paint_highlights = Animation(Resources.static:getImage("paint_highlights.png"), 26, 21)

	self.canvas = nil
	self.toolbox = nil
	self.controller = nil
end

function Palette:update(dt)
	local mx, my = Mouse.static:getPosition()

	if self.canvas == nil then
		self.canvas = self.scene:findOfType("Canvas")
		self.canvas:setColor(self.colors[self.selection])
	end
	if self.toolbox == nil then self.toolbox = self.scene:findOfType("Toolbox") end
	if self.controller == nil then self.controller = self.scene:findOfType("GameController") end

	if Mouse.static:wasPressed(1) then
		-- Colors
		for i=1,4 do
			local x = self.x + Palette.static.PAINT_POS[i][1]
			local y = self.y + Palette.static.PAINT_POS[i][2]

			if mx >= x and mx <= x + 24
			and my >= y and my <= y + 21 then
				if self.state == 1 then
					self.selection = i
					self.canvas:setColor(self.colors[i])
				elseif self.state == 2 then
					self.canvas:setActive(false)
					self.toolbox:setActive(false)
					self.colormixer = self.scene:addEntity(ColorMixer(i, self.colors[i]))
					self.selection = i
					self.state = 3
				end
			end
		end

		-- Mix button
		if mx >= self.x+35 and mx <= self.x+76
		and my >= self.y+20 and my <= self.y+41 then
			if self.state == 1 then
				self.state = 2
			elseif self.state == 2 then
				self.state = 1
			elseif self.state == 3 then
				self.state = 1
				self.canvas:setActive(true)
				self.toolbox:setActive(true)

				local color = self.colormixer:getColor()
				if color then
					local slot = self.colormixer:getSlot()
					self.colors[slot] = color
					self.canvas:setColor(self.colors[slot])
				end
				self.colormixer:kill()
				self.colormixer = nil
			end
		end
	end
end

function Palette:gui()
	love.graphics.draw(self.image_base, self.x, self.y)
	love.graphics.draw(self.image_mix, self.x+35, self.y+20)

	if self.state == 2 then
		love.graphics.setColor(0, 0, 0, 0.784)
		love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	end

	for i=1, 4 do
		local x = self.x + Palette.static.PAINT_POS[i][1]
		local y = self.y + Palette.static.PAINT_POS[i][2]

		love.graphics.setColor(1, 1, 1)
		if i == self.selection then
			love.graphics.setColor(1, 1, 1)
			love.graphics.draw(self.paint_highlights._image, self.paint_highlights._quads[i], x-1, y)
		end

		love.graphics.setColor(self.colors[i])
		love.graphics.draw(self.paint._image, self.paint._quads[i], x, y)
	end

	love.graphics.setColor(1, 1, 1)
end

return Palette
