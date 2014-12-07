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
