local Mouse = class("Mouse")

Mouse.static._down = {}
Mouse.static._pressed = {}
Mouse.static._released = {}

function Mouse.static:wasPressed(button)
	return Mouse.static._pressed[button]
end

function Mouse.static:wasReleased(button)
	return Mouse.static._released[button]
end

function Mouse.static:isDown(button)
	return Mouse.static._down[button]
end

function Mouse.static:getPosition()
	local mx, my = love.mouse.getPosition()
	return mx/SCALE, my/SCALE
end

function Mouse.static:mousepressed(x, y, button)
	Mouse.static._down[button] = true
	Mouse.static._pressed[button] = true
end

function Mouse.static:mousereleased(x, y, button)
	Mouse.static._down[button] = false
	Mouse.static._released[button] = true
end

function Mouse.static:clear()
	for i,v in pairs(Mouse.static._pressed) do
		Mouse.static._pressed[i] = false
	end
	for i,v in pairs(Mouse.static._released) do
		Mouse.static._released[i] = false
	end
end

return Mouse
