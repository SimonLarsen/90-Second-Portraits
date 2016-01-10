local Toolbox = class("Toolbox", Entity)

function Toolbox:initialize(x, y)
	Entity.initialize(self, x, y, 5)

	self.image_back = Resources.static:getImage("toolbox_back.png")
	self.image_front = Resources.static:getImage("toolbox_front.png")

	self.image_tools = Resources.static:getImage("icons.png")
	self.quads_tools = {}
	for i=1, 3 do
		self.quads_tools[i] = love.graphics.newQuad((i-1)*40, 0, 40, 40, 120, 40)
	end

	self.hover = 0
	self.tool = 2
	self.canvas = nil
end

function Toolbox:update(dt)
	if self.canvas == nil then
		self.canvas = self.scene:findOfType("Canvas")
		self.canvas:setTool(self.tool)
	end

	local mx, my = Mouse.static:getPosition()

	self.hover = 0
	if mx >= self.x and mx <= self.x+120
	and my >= self.y-20 and my <= self.y+18 then
		self.hover = math.floor((mx - self.x) / 40) + 1
		if Mouse.static:wasPressed(1) then
			self.tool = self.hover
			self.canvas:setTool(self.tool)
		end
	end
end

function Toolbox:gui()
	love.graphics.draw(self.image_back, self.x, self.y)

	for i=1, 3 do
		if self.hover == i or self.tool == i then
			love.graphics.draw(self.image_tools, self.quads_tools[i], self.x+(i-1)*40, self.y-30)
		else
			love.graphics.draw(self.image_tools, self.quads_tools[i], self.x+(i-1)*40, self.y-20)
		end
	end

	love.graphics.draw(self.image_front, self.x, self.y)
end

return Toolbox
