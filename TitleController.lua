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

	self.menu_font = love.graphics.newFont("data/fonts/neuton.ttf", 20)
end

function TitleController:update(dt)
	local mx, my = Mouse.static:getPosition()

	if Mouse.static:wasPressed("l")
	and mx >= 32 and mx <= 140 then
		for i,v in ipairs(TitleController.static.BUTTONS) do
			if my >= 20+i*28 and my <= 47+i*28 then
				if v == "Start working" then
					gamestate.switch(require("GameScene")())
					Sound.play("pageturn.wav")
				elseif v == "Art gallery" then
					gamestate.switch(require("GalleryScene")())
					Sound.play("pageturn.wav")
				elseif v == "Tutorial" then
					gamestate.switch(require("TutorialScene")())
					Sound.play("pageturn.wav")
				elseif v == "Credits" then
					gamestate.switch(require("CreditsScene")())
					Sound.play("pageturn.wav")
				elseif v == "Quit" then
					love.event.quit()
					Sound.play("pageturn.wav")
				end
			end
		end
	end
end

function TitleController:gui()
	love.graphics.draw(self.background, 0, 0)

	love.graphics.setFont(self.menu_font)
	love.graphics.setColor(0, 0, 0)
	for i,v in ipairs(TitleController.static.BUTTONS) do
		love.graphics.print(v, 32, 22+i*28)
	end
	love.graphics.setColor(255, 255, 255)
	for i,v in ipairs(TitleController.static.BUTTONS) do
		love.graphics.print(v, 32, 20+i*28)
	end

	local mx, my = Mouse.static:getPosition()
	love.graphics.draw(self.cursor, mx, my)
end

return TitleController
