local TitleController = class("TitleController", Entity)

TitleController.static.BUTTONS = {
	"Start working",
	"Art gallery",
	"Tutorial",
	"Credits",
	"Quit"
}

function TitleController:initialize()
	Entity.initialize(self)	

	self.background = Resources.static:getImage("title_background.png")
	self.cursor = Resources.static:getImage("cursor.png")

	self.text_font = love.graphics.newFont("data/fonts/atari.ttf", 16)

	self.offsets = {}
	self.active = {}
	for i,v in ipairs(TitleController.static.BUTTONS) do
		self.offsets[i] = 0
		self.active[i] = true
	end

	self.days = Preferences.static:get("days", 0)
	if self.days == 0 then
		self.active[2] = false
	end
end

function TitleController:update(dt)
	local mx, my = Mouse.static:getPosition()

	for i,v in ipairs(TitleController.static.BUTTONS) do
		self.offsets[i] = math.max(0, self.offsets[i] - 40*dt)

		if mx >= 32 and mx <= 140
		and my >= 20+i*28 and my <= 47+i*28 and self.active[i] then
			self.offsets[i] = math.min(10, self.offsets[i] + 80*dt)

			if Mouse.static:wasPressed(1) then
				if i == 1 then
					local tutorialCompleted = Preferences.static:get("tutorialCompleted")
					if tutorialCompleted then
						gamestate.switch(require("GameScene")())
					else
						gamestate.switch(require("TutorialScene")(true))
					end
					Sound.play("pageturn.wav")
				elseif i == 2 then
					gamestate.switch(require("GalleryScene")())
					Sound.play("pageturn.wav")
				elseif i == 3 then
					gamestate.switch(require("TutorialScene")(false))
					Sound.play("pageturn.wav")
				elseif i == 4 then
					gamestate.switch(require("CreditsScene")())
					Sound.play("pageturn.wav")
				elseif i == 5 then
					love.event.quit()
					Sound.play("pageturn.wav")
				end
			end
		end
	end

	if Keyboard.static:wasPressed("escape") then
		love.event.quit()
	end
end

function TitleController:gui()
	love.graphics.draw(self.background, 0, 0)

	love.graphics.setFont(self.text_font)

	for i,v in ipairs(TitleController.static.BUTTONS) do
		love.graphics.setColor(0, 0, 0)
		love.graphics.print(v, 32+self.offsets[i], 22+i*28)

		if self.active[i] then
			love.graphics.setColor(255, 255, 255)
			love.graphics.print(v, 32+self.offsets[i], 20+i*28)
		else
			love.graphics.setColor(128, 128, 128)
			love.graphics.print(v, 32+self.offsets[i], 20+i*28)
			love.graphics.setColor(255, 255, 255)
		end
	end

	self:drawCursor(self.cursor)
end

return TitleController
