local Keyboard = class("Keyboard")

Keyboard.static.down = {}
Keyboard.static.pressed = {}
Keyboard.static.released = {}

function Keyboard.static:wasPressed(k)
	return Keyboard.static.pressed[k]
end

function Keyboard.static:wasReleased(k)
	return Keyboard.static.released[k]
end

function Keyboard.static:isDown(k)
	return Keyboard.static.down[k]
end

function Keyboard.static:keypressed(k)
	Keyboard.static.down[k] = true
	Keyboard.static.pressed[k] = true
end

function Keyboard.static:keyreleased(k)
	Keyboard.static.down[k] = false
	Keyboard.static.released[k] = true
end

function Keyboard.static:clear()
	for i,v in pairs(Keyboard.static.pressed) do
		Keyboard.static.pressed[i] = false
	end
	for i,v in pairs(Keyboard.static.released) do
		Keyboard.static.released[i] = false
	end
end

return Keyboard
