local Entity = class("Entity")

function Entity:initialize(x, y, z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0

	self.active = true
	self.alive = true
end
function Entity:update(dt)
	
end

function Entity:draw()
	
end

function Entity:drawCursor(image, ox, oy, quad)
	if IS_MOBILE == true then return end

	local mx, my = Mouse.static:getPosition()
	love.graphics.draw(image, math.floor(mx), math.floor(my), 0, 1, 1, ox or 0, oy or 0)
end

function Entity:gui()
	
end

function Entity:kill()
	self.alive = false
end

function Entity:isAlive()
	return self.alive
end

function Entity:setActive(a)
	self.active = a
end

function Entity:isActive()
	return self.active
end

return Entity
