local Score = require("Score")

local ScorePopup = class("ScorePopup", Entity)

function ScorePopup:initialize(round, score)
	Entity.initialize(self, 0, 0, -10)

	self.time = 0

	self.round = round
	self.score = score
	self.title_font = love.graphics.newFont("data/fonts/yb.ttf", 24)
	self.text_font = love.graphics.newFont("data/fonts/atari.ttf", 16)
	self.background = Resources.static:getImage("popup.png")
	self.grades = Resources.static:getImage("grades.png")

	self.quad_grades = {}
	for i=1,6 do
		self.quad_grades[i] = love.graphics.newQuad((i-1)*6, 0, 6, 16, 36, 16)
	end

	self.grade = Score.getGrade(self.score.score)
	self.timeGrade = Score.getTimeGrade(self.score.time)
	self.payment = Score.getPayment(self.score.score, self.score.time)

	self.soundPlayed = false
end

function ScorePopup:update(dt)
	self.time = self.time + dt

	if self.time > 1 and self.soundPlayed == false and self.payment > 0 then
		Sound.play("kaching.wav")
		self.soundPlayed = true
	end

	if self.time > 4
	or (Mouse.static:wasPressed(1) and self.time > 1) then
		self:kill()
	end
end

function ScorePopup:gui()
	if self.time > 0.9 then
		love.graphics.draw(self.background, WIDTH/2-100, HEIGHT/2-75)

		love.graphics.setFont(self.title_font)
		love.graphics.printf("Customer "..self.round, WIDTH/2-100, HEIGHT/2-55, 200, "center")

		love.graphics.setFont(self.text_font)
		love.graphics.print("Grade", WIDTH/2-60, HEIGHT/2-20)
		love.graphics.print("Time", WIDTH/2-60, HEIGHT/2+10)
		love.graphics.print("Payment", WIDTH/2-60, HEIGHT/2+40)

		love.graphics.draw(self.grades, self.quad_grades[self.grade], WIDTH/2+54, HEIGHT/2-19)
		love.graphics.draw(self.grades, self.quad_grades[self.timeGrade], WIDTH/2+54, HEIGHT/2+11)
		love.graphics.printf("$"..self.payment, WIDTH/2-60, HEIGHT/2+40, 120, "right")
	end
end

return ScorePopup
