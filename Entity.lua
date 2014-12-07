local Entity = class("Entity")

function Entity:initialize(x, y, z)
	self.x = x or 0
	self.y = y or 0
	self.z = z or 0

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

return Entity
