local Score = require("Score")

local GalleryController = class("GalleryController", Entity)

GalleryController.static.MAX_SCROLL = 850

function GalleryController:initialize()
	Entity.initialize(self)

	self.scroll = 0
	self.time = 0
	self.days = Preferences.static:get("days")
	self.day = self.days

	self.canvas = Resources.static:getImage("canvas.png")
	self.arrow = Resources.static:getImage("arrow.png")
	self.exit = Resources.static:getImage("exit.png")
	self.quad_background = love.graphics.newQuad(12, 10, 120, 160, 152, 184)
	self.cursor = Resources.static:getImage("cursor.png")
	self.divider = Resources.static:getImage("fancydivider.png")

	self.text_font = love.graphics.newFont("data/fonts/atari.ttf", 16)
	self.title_font = love.graphics.newFont("data/fonts/yb.ttf", 40)

	self:loadDay()
end

function GalleryController:loadDay()
	self.customer_order = Preferences.static:get(string.format("day_%d_customer_order", self.day))
	self.background_order = Preferences.static:get(string.format("day_%d_background_order", self.day))
	self.scores = Preferences.static:get(string.format("day_%d_scores", self.day))

	self.money = 0
	for i=1,5 do
		self.money = self.money + Score.getPayment(self.scores[i].score, self.scores[i].time)
	end

	self.paintings = {}
	for i=1,5 do
		self.paintings[i] = love.graphics.newImage(string.format("painting_%d_%d.png", self.day, i))
	end

	self.customers = {}
	self.quads_customers = {}
	self.backgrounds = {}

	for i=1,5 do
		self.customers[i] = Resources.static:getImage("customer"..self.customer_order[i]..".png")
		local w = self.customers[i]:getWidth()
		local h = self.customers[i]:getHeight()
		self.quads_customers[i] = love.graphics.newQuad(w/2-60, h-230, 120, 160, w, h)

		self.backgrounds[i] = Resources.static:getImage("background"..self.background_order[i]..".png")
	end
end

function GalleryController:update(dt)
	self.time = self.time + dt

	local mx, my = Mouse.static:getPosition()

	if Mouse.static:wasPressed(1) then
		if my >= HEIGHT/2-16 and my <= HEIGHT/2+16 then
			if mx <= 32 and self.day > 1 then
				self.day = self.day - 1
				self.scroll = 0
				self:loadDay()
				Sound.play("pageturn.wav")
			end
			if mx >= WIDTH-32 and self.day < self.days then
				self.day = self.day + 1
				self.scroll = 0
				self:loadDay()
				Sound.play("pageturn.wav")
			end
		end

		if mx >= WIDTH-32 and my <= 32 then
			gamestate.switch(require("TitleScene")())
			Sound.play("pageturn.wav")
		end
	end

	-- Scroll buttons
	if Mouse.static:isDown(1) then
		if mx >= WIDTH/2-16 and mx <= WIDTH/2+16 then
			if my >= HEIGHT-32 and my <= HEIGHT then
				self.scroll = self.scroll + dt*200
			elseif my <= 32 then
				self.scroll = self.scroll - dt*200
			end
		end
	end

	if Mouse.static:wasPressed("wu") then
		self.scroll = self.scroll - 15
	end
	if Mouse.static:wasPressed("wd") then
		self.scroll = self.scroll + 15
	end
	self.scroll = math.cap(self.scroll, 0, GalleryController.static.MAX_SCROLL)

	if Keyboard.static:wasPressed("escape") then
		gamestate.switch(require("TitleScene")())
		Sound.play("pageturn.wav")
	end
end

function GalleryController:gui()
	local mx, my = Mouse.static:getPosition()

	local offset = math.cos(self.time*10)*2

	love.graphics.setColor(53, 30, 24)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.push()
	love.graphics.translate(0, -self.scroll)

	love.graphics.setFont(self.title_font)
	love.graphics.printf("Day "..self.day, 0, 10, WIDTH, "center")

	love.graphics.setFont(self.text_font)
	love.graphics.printf("Total earnings:  $"..self.money, 0, 65, WIDTH, "center")

	for i=1,5 do
		love.graphics.draw(self.canvas, 30, 100+(i-1)*200)
		love.graphics.draw(self.paintings[i], 30, 100+(i-1)*200)

		love.graphics.draw(self.canvas, 170, 100+(i-1)*200)
		love.graphics.draw(self.backgrounds[i], self.quad_background, 170, 100+(i-1)*200)
		love.graphics.draw(self.customers[i], self.quads_customers[i], 170, 100+(i-1)*200)

		if i < 5 then
			love.graphics.draw(self.divider, WIDTH/2-80, 72+i*200)
		end
	end

	love.graphics.pop()

	if self.scroll > 0 then
		love.graphics.draw(self.arrow, WIDTH/2, 16-offset, 3*math.pi/2, 1, 1, 16, 16)
	end
	if self.scroll < GalleryController.static.MAX_SCROLL then
		love.graphics.draw(self.arrow, WIDTH/2, HEIGHT-16+offset, math.pi/2, 1, 1, 16, 16)
	end

	if self.day > 1 then
		love.graphics.draw(self.arrow, 16+offset, HEIGHT/2, math.pi, 1, 1, 16, 16)
	end
	if self.day < self.days then
		love.graphics.draw(self.arrow, WIDTH-16-offset, HEIGHT/2, 0, 1, 1, 16, 16)
	end

	love.graphics.draw(self.exit, WIDTH-32, 0)

	self:drawCursor(self.cursor)
end


return GalleryController
