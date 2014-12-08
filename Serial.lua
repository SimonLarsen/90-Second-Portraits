local Serial = {}

function Serial.pack(t)
	local ty = type(t)
	if ty == "table" then
		local s = "{"
		for i,v in pairs(t) do
			s = s .. string.format("[%s] = %s, ", Serial.pack(i), Serial.pack(v))
		end
		s = s .. "}"
		return s
	elseif ty == "number" then
		return tostring(t)
	elseif ty == "string" then
		return string.format("\"%s\"", t)
	elseif ty == "boolean" then
		return tostring(t)
	end
end

function Serial.unpack(str)
	local f = loadstring("return " .. str)
	return f()
end

return Serial
