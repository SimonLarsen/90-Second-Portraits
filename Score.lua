local Score = {}

Score.letters = {C, B, A, S}

function Score.getGrade(score)
	if score < 0.15 then
		return 5
	elseif score < 0.3 then
		return 4
	elseif score < 0.5 then
		return 3
	elseif score < 0.75 then
		return 2
	else
		return 1
	end
end

function Score.getTimeGrade(time)
	if time > 40 then
		return 1
	elseif time > 30 then
		return 2
	elseif time > 15 then
		return 3
	elseif time > 5 then
		return 4
	else
		return 6
	end
end

function Score.getPayment(score, time)
	local multiplier = 1 + math.cap((90 - time) / 100, 0, 0.5)
	local base = score * 10
	return math.round(base * multiplier)
end

return Score
