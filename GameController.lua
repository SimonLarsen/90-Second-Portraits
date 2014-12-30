local ImageTools = require("ImageTools")
local GalleryScene = require("GalleryScene")
local ScorePopup = require("ScorePopup")

local GameController = class("GameController", Entity)

GameController.static.TIME = 90
GameController.static.ROUNDS = 5

function GameController:initialize(customer_order, background_order)
	Entity.initialize(self, 0, 0, 1)
	
	self.day = Preferences.static:get("days", 0) + 1
	self.scores = {}
	self.round = 1

	self.customer_order = customer_order
	self.background_order = background_order

	self.time = GameController.static.TIME

	self.next_button = Resources.static:getImage("next.png")
	self.quads_next = love.graphics.newQuad(0, 0, 55, 16, 55, 32)
	self.quads_next_hover = love.graphics.newQuad(0, 16, 55, 16, 55, 32)

	self.timer = Resources.static:getImage("timer.png")
	self.timer_bar = Resources.static:getImage("timer_bar.png")
	self.quad_timer = love.graphics.newQuad(0, 0, 151, 12, 151, 12)

	self.canvas = nil
	self.customer = nil
	self.background = nil
	self.nextEnabled = false
	Timer.add(2, function() self.nextEnabled = true end)
end

function GameController:update(dt)
	if self.canvas == nil then self.canvas = self.scene:findOfType("Canvas") end
	if self.customer == nil then self.customer = self.scene:findOfType("Customer") end
	if self.background == nil then self.background = self.scene:findOfType("Background") end

	if self.customer:getState() == 2 then
		self.time = self.time - dt
		if self.time <= 0 then
			self:next()
		end
	end
	local barwidth = self.time / GameController.static.TIME * 151
	self.quad_timer:setViewport(0, 0, barwidth, 12)

	local mx, my = Mouse.static:getPosition()
	if self.nextEnabled and mx >= WIDTH-59 and my >= HEIGHT-20 then
		if Mouse.static:wasPressed("l") then
			self:next()
		end
	end

	if Keyboard.static:wasPressed("escape") then
		gamestate.switch(require("TitleScene")())
		Sound.play("pageturn.wav")
	end
end

function GameController:next()
	local customer = self.canvas:getImageData()
	local portrait = self:getCustomerImage()
	
	-- Write canvas to image
	customer:encode(string.format("painting_%d_%d.png", self.day, self.round), "png")

	local bucketscore = ImageTools.compareBuckets(customer, portrait, 10)
	
	self.scores[self.round] = { score = bucketscore, time = self.time }
	self.scene:addEntity(ScorePopup(self.round, self.scores[self.round]))

	self.time = GameController.static.TIME
	self.round = self.round + 1
	self.nextEnabled = false
	Timer.add(4, function() self.nextEnabled = true end)

	if self.round <= GameController.static.ROUNDS then
		self.canvas:swap()
		self.customer:swap(self.customer_order[self.round])
		self.background:swap(self.background_order[self.round])
	else
		self.canvas:swap()
		self.customer:swap()
		self.background:swap()

		Timer.add(4.0, function()
			self:saveDay()
			gamestate.switch(GalleryScene())
		end)
	end
end

function GameController:saveDay()
	Preferences.static:set("days", self.day)

	Preferences.static:set(string.format("day_%d_customer_order", self.day), self.customer_order)
	Preferences.static:set(string.format("day_%d_background_order", self.day), self.background_order)

	Preferences.static:set(string.format("day_%d_scores", self.day), self.scores)
end

function GameController:calculateScore(customer, portrait)
	local comp = ImageTools.compare(customer, portrait, 10)

	return comp
end

function GameController:gui()
	if self:isActive() == false then return end

	local mx, my = Mouse.static:getPosition()

	if self.nextEnabled then
		if mx >= WIDTH-59 and my >= HEIGHT-20 then
			love.graphics.draw(self.next_button, self.quads_next_hover, WIDTH-59, HEIGHT-20)
		else
			love.graphics.draw(self.next_button, self.quads_next, WIDTH-59, HEIGHT-20)
		end
	end

	love.graphics.draw(self.timer_bar, self.quad_timer, 7, 9)
	if self.time < 15 and (self.time % 0.5) < 0.25 then
		love.graphics.setBlendMode("additive")
		love.graphics.draw(self.timer_bar, self.quad_timer, 7, 9)
		love.graphics.setBlendMode("alpha")
	end
	love.graphics.draw(self.timer, 5, 7)
end

function GameController:getCustomerImage()
	local canvas = love.graphics.newCanvas(120, 160)
	canvas:clear(241, 232, 199)

	local w, h = self.customer.image:getDimensions()

	local quad_background = love.graphics.newQuad(12, 10, 120, 160, 152, 184)
	local quad_customer = love.graphics.newQuad(w/2-60, h-230, 120, 160, w, h)

	local oldCanvas = love.graphics.getCanvas()

	love.graphics.setCanvas(canvas)

	love.graphics.draw(self.background.image, quad_background, 0, 0)
	love.graphics.draw(self.customer.image, quad_customer, 0, 0)

	love.graphics.setCanvas(oldCanvas)

	return canvas:getImageData()
end

return GameController
