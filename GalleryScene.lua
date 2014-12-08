local GalleryScene = class("GalleryScene", Scene)

function GalleryScene:initialize()
	Scene.initialize(self)

	self.scroll = 0
	self.day = Preferences.static:get("days")
	self.background = Resources.static:getImage("background.png")

	self.paintings = {}
	for i=1,5 do
		self.paintings[i] = love.graphics.newImage(string.format("painting_%d_%d.png", self.day, i))
	end
end

function GalleryScene:update(dt)
	local mx, my = Mouse.static:getPosition()

	if mx >= WIDTH/2-16 and mx <= WIDTH/2+16
	and my >= HEIGHT-32 and my <= HEIGHT then
		if Mouse.static:isDown("l") then
			self.scroll = self.scroll + dt*100
		end
	end
end

function GalleryScene:gui()
	love.graphics.draw(self.background, 0, 0)

	love.graphics.setColor(0, 0, 0, 225)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.push()
	love.graphics.translate(0, -self.scroll)

	for i=1,5 do
		love.graphics.draw(self.paintings[i], 20, i*200)
	end

	love.graphics.pop()

	love.graphics.rectangle("fill", WIDTH/2-16, HEIGHT-32, 32, 32)
end

return GalleryScene
