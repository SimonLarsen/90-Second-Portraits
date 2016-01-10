local Mouse = class("Mouse")

Mouse.static.down = {}
Mouse.static.pressed = {}
Mouse.static.released = {}

function Mouse.static:wasPressed(button)
	return Mouse.static.pressed[button]
end

function Mouse.static:wasReleased(button)
	return Mouse.static.released[button]
end

function Mouse.static:isDown(button)
	return Mouse.static.down[button]
end

function Mouse.static:getPosition()
	local mx, my = love.mouse.getPosition()
	return mx/SCALE - OFFSET_X, my/SCALE
end

function Mouse.static:mousepressed(x, y, button)
	Mouse.static.down[button] = true
	Mouse.static.pressed[button] = true
end

function Mouse.static:mousereleased(x, y, button)
	Mouse.static.down[button] = false
	Mouse.static.released[button] = true
end

function Mouse.static:wheelmoved(x, y)
	if y > 0 then
		Mouse.static.pressed["wu"] = true
	elseif y < 0 then
		Mouse.static.pressed["wd"] = true
	end
end

function Mouse.static:clear()
	for i,v in pairs(Mouse.static.pressed) do
		Mouse.static.pressed[i] = false
	end
	for i,v in pairs(Mouse.static.released) do
		Mouse.static.released[i] = false
	end
end

return Mouse
