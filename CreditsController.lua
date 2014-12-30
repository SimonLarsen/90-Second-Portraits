local CreditsController = class("CreditsController", Entity)

CreditsController.static.TEXT =
[[Programming
Simon Larsen

Artwork
Lukas Hansen

Character design
Frederik Storm

Voice acting
Frederik and Simon

Music
"Monkeys Spinning Monkeys"
by Kevin MacLeod (incompetech.com)
Licensed under Creative Commons
By Attribution 3.0
creativecommons.org/licenses/by/3.0/



Thanks for playing!]]

function CreditsController:initialize()
	Entity.initialize(self)

	self.scroll = 0
	self.time = 0

	self.arrow = Resources.static:getImage("arrow.png")
	self.exit = Resources.static:getImage("exit.png")
	self.cursor = Resources.static:getImage("cursor.png")
	self.title_font = love.graphics.newFont("data/fonts/yb.ttf", 40)
	self.text_font = love.graphics.newFont("data/fonts/atari.ttf", 16)
end

function CreditsController:update(dt)
	self.time = self.time + dt
	local mx, my = Mouse.static:getPosition()

	if Keyboard.static:wasPressed("escape")
	or (Mouse.static:wasPressed("l") and mx >= WIDTH-32 and my <= 32) then
		gamestate.switch(require("TitleScene")())
		Sound.play("pageturn.wav")
	end

	-- Scroll buttons
	if Mouse.static:isDown("l") then
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
	self.scroll = math.cap(self.scroll, 0, 300)
end

function CreditsController:gui()
	local mx, my = Mouse.static:getPosition()
	local offset = math.cos(self.time*10)*2

	love.graphics.setColor(53, 30, 24)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.push()
	love.graphics.translate(0, -self.scroll)

	love.graphics.setFont(self.title_font)
	love.graphics.printf("Credits", 0, 10, WIDTH, "center")

	love.graphics.setFont(self.text_font)
	love.graphics.printf(CreditsController.static.TEXT, 0, 65, WIDTH, "center")

	love.graphics.pop()

	if self.scroll > 0 then
		love.graphics.draw(self.arrow, WIDTH/2, 16-offset, 3*math.pi/2, 1, 1, 16, 16)
	end
	if self.scroll < 300 then
		love.graphics.draw(self.arrow, WIDTH/2, HEIGHT-16+offset, math.pi/2, 1, 1, 16, 16)
	end

	love.graphics.draw(self.exit, WIDTH-32, 0)

	self:drawCursor(self.cursor)
end

return CreditsController
