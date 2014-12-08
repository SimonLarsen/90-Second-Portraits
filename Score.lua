local Score = {}

Score.letters = {C, B, A, S}

function Score.getGrade(score)
	if score < 0.15 then
		return "F"
	elseif score < 0.3 then
		return "C"
	elseif score < 0.5 then
		return "B"
	elseif score < 0.75 then
		return "A" 
	else
		return "S"
	end
end

function Score.getTimeGrade(time)
	if time < 60 then
		return "S"
	elseif time < 80 then
		return "A"
	elseif time < 100 then
		return "B"
	elseif time < 120 then
		return "C"
	else
		return "-"
	end
end

function Score.getPayment(score, time)
	local multiplier = 1 + math.cap(120 - time, 0, 0.5)
	local base = score * 10
	return math.round(base * multiplier)
end

return Score
