local ImageTools = require("ImageTools")

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
			self:next()
		end
	end
end

function GameController:next()
	local customer = self.canvas:getImageData()
	local portrait = self:getCustomerImage()

	local hist1 = ImageTools.histogram(customer, 16)
	local hist2 = ImageTools.histogram(portrait, 16)

	local histscore = ImageTools.compareHistograms(hist1, hist2)
	local bucketscore = ImageTools.compareBuckets(customer, portrait, 10)
	
	local score = histscore*0.25 + bucketscore*0.75

	self.canvas:swap()
	self.customer:swap()
	self.background:swap()
end

function GameController:calculateScore(customer, portrait)
	local comp = ImageTools.compare(customer, portrait, 10)

	return comp
end

function GameController:getCustomerImage()
	local canvas = love.graphics.newCanvas(120, 160)
	canvas:clear(241, 232, 199)

	local oldCanvas = love.graphics.getCanvas()

	love.graphics.setCanvas(canvas)
	love.graphics.push()
	love.graphics.translate(-180, -10)

	self.background:draw()
	self.customer:draw()

	love.graphics.pop()

	love.graphics.setCanvas(oldCanvas)

	return canvas:getImageData()
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
