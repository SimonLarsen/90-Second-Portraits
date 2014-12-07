local GameController = class("GameController", Entity)

function GameController:initialize()
	Entity.initialize(self, 0, 0, 1)
	
	self.next_button = Resources.static:getImage("next.png")
	self.quads_next = love.graphics.newQuad(0, 0, 55, 16, 55, 32)
	self.quads_next_hover = love.graphics.newQuad(0, 16, 55, 16, 55, 32)

	self.canvas = nil
	self.customer = nil
	self.background = nil
end

function GameController:update(dt)
	if self.canvas == nil then self.canvas = self.scene:findOfType("Canvas") end
	if self.customer == nil then self.customer = self.scene:findOfType("Customer") end
	if self.background == nil then self.background = self.scene:findOfType("Background") end

	local mx, my = Mouse.static:getPosition()
	if mx >= WIDTH-59 and my >= HEIGHT-20 then
		if Mouse.static:wasPressed("l") then
			self.canvas:swap()
			self.customer:swap()
			self.background:swap()
		end
	end
end

function GameController:gui()
	if self:isActive() == false then return end

	local mx, my = Mouse.static:getPosition()

	if mx >= WIDTH-59 and my >= HEIGHT-20 then
		love.graphics.draw(self.next_button, self.quads_next_hover, WIDTH-59, HEIGHT-20)
	else
		love.graphics.draw(self.next_button, self.quads_next, WIDTH-59, HEIGHT-20)
	end
end

return GameController
