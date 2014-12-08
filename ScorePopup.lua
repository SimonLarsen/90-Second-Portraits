local Score = require("Score")

local ScorePopup = class("ScorePopup", Entity)

function ScorePopup:initialize(round, score)
	Entity.initialize(self, 0, 0, -10)

	self.time = 0

	self.round = round
	self.score = score
	self.title_font = love.graphics.newFont("data/fonts/yb.ttf", 24)
	self.text_font = love.graphics.newFont("data/fonts/atari.ttf", 16)

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

		love.graphics.setFont(self.text_font)
		love.graphics.print("Grade", WIDTH/2-60, HEIGHT/2-25)
		love.graphics.print("Time", WIDTH/2-60, HEIGHT/2+5)
		love.graphics.print("Payment", WIDTH/2-60, HEIGHT/2+35)

		love.graphics.printf(self.grade, WIDTH/2-60, HEIGHT/2-25, 120, "right")
		love.graphics.printf(self.timeGrade, WIDTH/2-60, HEIGHT/2+5, 120, "right")
		love.graphics.printf("$"..self.payment, WIDTH/2-60, HEIGHT/2+35, 120, "right")
	end
end

return ScorePopup
