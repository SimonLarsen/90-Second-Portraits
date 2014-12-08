local GalleryScene = class("GalleryScene", Scene)

GalleryScene.static.MAX_SCROLL = 850

function GalleryScene:initialize()
	Scene.initialize(self)

	self.scroll = 0
	self.day = Preferences.static:get("days")
	self.canvas = Resources.static:getImage("canvas.png")
	self.quad_background = love.graphics.newQuad(12, 10, 120, 160, 152, 184)

	self:loadDay()
end

function GalleryScene:loadDay()
	self.customer_order = Preferences.static:get(string.format("day_%d_customer_order", self.day))
	self.background_order = Preferences.static:get(string.format("day_%d_background_order", self.day))

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

function GalleryScene:update(dt)
	local mx, my = Mouse.static:getPosition()

	if mx >= WIDTH/2-16 and mx <= WIDTH/2+16
	and my >= HEIGHT-32 and my <= HEIGHT then
		if Mouse.static:isDown("l") then
			self.scroll = math.min(GalleryScene.static.MAX_SCROLL, self.scroll + dt*200)
		end
	end

	if mx >= WIDTH/2-16 and mx <= WIDTH/2+16
	and my <= 32 then
		if Mouse.static:isDown("l") then
			self.scroll = math.max(0, self.scroll - dt*200)
		end
	end
end

function GalleryScene:gui()
	love.graphics.setColor(53, 30, 24)
	love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.push()
	love.graphics.translate(0, -self.scroll)

	for i=1,5 do
		love.graphics.draw(self.canvas, 20, i*180)
		love.graphics.draw(self.paintings[i], 20, i*180)

		love.graphics.draw(self.canvas, 180, i*180)
		love.graphics.draw(self.backgrounds[i], self.quad_background, 180, i*180)
		love.graphics.draw(self.customers[i], self.quads_customers[i], 180, i*180)
	end

	love.graphics.pop()

	if self.scroll > 0 then
		love.graphics.rectangle("fill", WIDTH/2-16, 0, 32, 32)
	end

	if self.scroll < GalleryScene.static.MAX_SCROLL then
		love.graphics.rectangle("fill", WIDTH/2-16, HEIGHT-32, 32, 32)
	end
end

return GalleryScene
