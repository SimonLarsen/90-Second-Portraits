local Scene = class("Scene")

function Scene:initialize()
	self.entities = {}
end

function Scene:update(dt)
	for i,v in ipairs(self.entities) do
		if v:isActive() then
			v:update(dt)
		end
	end

	for i=#self.entities, 1, -1 do
		if self.entities[i]:isAlive() == false then
			table.remove(self.entities, i)
		end
	end
end

function Scene:draw()
	for i,v in ipairs(self.entities) do
		v:draw()
	end
end

function Scene:gui()
	for i,v in ipairs(self.entities) do
		v:gui()
	end
end

function Scene:addEntity(e)
	table.insert(self.entities, e)
	table.sort(self.entities, function(a, b)
		return a.z > b.z
	end)
	e.scene = self
	return e
end

function Scene:find(name)
	for i,v in ipairs(self.entities) do
		if v.name == name then
			return v
		end
	end
	return nil
end

function Scene:findOfType(name)
	for i,v in ipairs(self.entities) do
		if v.class.name == name then
			return v
		end
	end
	return nil
end

function Scene:findAllOfType(name)
	local t = {}
	for i,v in ipairs(self.entities) do
		if v.class.name == name then
			table.insert(t, v)
		end
	end
	return t
end

return Scene
