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
	for i,v in ipairs(TitleController.static.BUTTONS) do
		self.offsets[i] = 0
	end
end

function TitleController:update(dt)
	local mx, my = Mouse.static:getPosition()

	for i,v in ipairs(TitleController.static.BUTTONS) do
		self.offsets[i] = math.max(0, self.offsets[i] - 40*dt)

		if mx >= 32 and mx <= 140
		and my >= 20+i*28 and my <= 47+i*28 then
			self.offsets[i] = math.min(10, self.offsets[i] + 80*dt)

			if Mouse.static:wasPressed("l") then
				if i == 1 then
					gamestate.switch(require("GameScene")())
					Sound.play("pageturn.wav")
				elseif i == 2 then
					gamestate.switch(require("GalleryScene")())
					Sound.play("pageturn.wav")
				elseif i == 3 then
					gamestate.switch(require("TutorialScene")())
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
end

function TitleController:gui()
	love.graphics.draw(self.background, 0, 0)

	love.graphics.setFont(self.text_font)

	for i,v in ipairs(TitleController.static.BUTTONS) do
		love.graphics.setColor(0, 0, 0)
		love.graphics.print(v, 32+self.offsets[i], 22+i*28)
		love.graphics.setColor(255, 255, 255)
		love.graphics.print(v, 32+self.offsets[i], 20+i*28)
	end

	local mx, my = Mouse.static:getPosition()
	love.graphics.draw(self.cursor, mx, my)
end

return TitleController
