local TutorialController = class("TutorialController", Entity)

TutorialController.static.NUM_SLIDES = 8

function TutorialController:initialize(goToGame)
	Entity.initialize(self)

	self.goToGame = goToGame
	self.time = 0
	self.slide = 1
	self.image = Resources.static:getImage("slide1.png")
	self.arrow = Resources.static:getImage("arrow.png")
	self.cursor = Resources.static:getImage("cursor.png")
	self.exit = Resources.static:getImage("exit.png")
end

function TutorialController:previous()
	self.slide = self.slide - 1
	self.image = Resources.static:getImage("slide".. self.slide .. ".png")
end

function TutorialController:next()
	if self.slide == TutorialController.static.NUM_SLIDES then
		Preferences.static:set("tutorialCompleted", 1)
		if self.goToGame then
			gamestate.switch(require("GameScene")())
		else
			gamestate.switch(require("TitleScene")())
		end
	else
		self.slide = self.slide + 1
		self.image = Resources.static:getImage("slide".. self.slide .. ".png")
	end
end

function TutorialController:update(dt)
	self.time = self.time + dt
	local mx, my = Mouse.static:getPosition()

	if Mouse.static:wasPressed("l") then
		if my >= HEIGHT-32 then
			if mx <= 32 and self.slide > 1 then
				self:previous()
				Sound.play("pageturn.wav")
			end
			if mx >= WIDTH-32 then
				self:next()
				Sound.play("pageturn.wav")
			end
		end
	end

	if Keyboard.static:wasPressed("escape") then
		gamestate.switch(require("TitleScene")())
		Sound.play("pageturn.wav")
	end
end

function TutorialController:gui()
	local mx, my = Mouse.static:getPosition()
	love.graphics.draw(self.image, 0, 0)

	local offset = math.cos(self.time*10)*2

	if self.slide > 1 then
		love.graphics.draw(self.arrow, 16+offset, HEIGHT-16, math.pi, 1, 1, 16, 16)
	end

	if self.slide < TutorialController.static.NUM_SLIDES then
		love.graphics.draw(self.arrow, WIDTH-16-offset, HEIGHT-16, 0, 1, 1, 16, 16)
	else
		love.graphics.draw(self.exit, WIDTH-16-offset, HEIGHT-16, 0, 1, 1, 16, 16)
	end

	self:drawCursor(self.cursor)
end

return TutorialController
