local ScorePopup = class("ScorePopup", Entity)

function ScorePopup:initialize(round, scores)
	Entity.initialize(self, 0, 0, -10)

	self.time = 0

	self.round = round
	self.scores = scores
	self.title_font = love.graphics.newFont("data/fonts/yb.ttf", 24)
end

function ScorePopup:update(dt)
	self.time = self.time + dt

	if self.time > 4
	or (Mouse.static:wasPressed("l") and self.time > 1) then
		self:kill()
	end
end

function ScorePopup:gui()
	if self.time > 0.9 then
		love.graphics.setColor(0, 0, 0, 250)

		love.graphics.rectangle("fill", WIDTH/2-100, HEIGHT/2-75, 200, 150)
		love.graphics.setColor(255, 255, 255, 255)

		love.graphics.setFont(self.title_font)
		love.graphics.printf("Customer "..self.round, WIDTH/2-100, HEIGHT/2-65, 200, "center")

		love.graphics.printf(self.scores[1], WIDTH/2-100, HEIGHT/2-35, 200, "center")
		love.graphics.printf(self.scores[2], WIDTH/2-100, HEIGHT/2-5, 200, "center")
	end
end

return ScorePopup
