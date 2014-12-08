local Score = require("Score")

local ScorePopup = class("ScorePopup", Entity)

function ScorePopup:initialize(round, score)
	Entity.initialize(self, 0, 0, -10)

	self.time = 0

	self.round = round
	self.score = score
	self.title_font = love.graphics.newFont("data/fonts/yb.ttf", 24)

	self.grade = Score.getGrade(self.score.score)
	self.timeGrade = Score.getTimeGrade(self.score.time)
	self.payment = Score.getPayment(self.score.score, self.score.time)
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

		love.graphics.printf("Grade: " .. self.grade, WIDTH/2-100, HEIGHT/2-44, 200, "center")
		love.graphics.printf("Time: " .. self.timeGrade, WIDTH/2-100, HEIGHT/2-25, 200, "center")
		love.graphics.printf("Payment: $" .. self.payment, WIDTH/2-100, HEIGHT/2-5, 200, "center")
	end
end

return ScorePopup
