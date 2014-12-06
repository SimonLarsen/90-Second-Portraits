local Animation = class("Animation")

function Animation:initialize(image, fw, fh, delay, loop, ox, oy)
	self._image = image

	local imgw = image:getWidth()
	local imgh = image:getHeight()

	local xframes = math.floor(imgw / fw)
	local yframes = math.floor(imgh / fh)

	self._quads = {}
	for iy = 0, yframes-1 do
		for ix = 0, xframes-1 do
			local q = love.graphics.newQuad(ix*fw, iy*fh, fw, fh, imgw, imgh)
			table.insert(self._quads, q)
		end
	end

	self._frames = xframes * yframes
	self._delay = delay
	self._speed = 1
	if loop ~= nil then
		self._loop = loop
	else
		self._loop = true
	end
	self._ox = ox or (fw/2)
	self._oy = oy or (fh/2)
	self:reset()
end

function Animation:update(dt, entity)
	self._time = self._time + dt * self._speed
	if self._time >= self._delay then
		self._time = self._time - self._delay
		self._frame = self._frame + 1
		if self._frame > self._frames then
			if self._loop then
				self._frame = 1
			else
				self._frame = self._frames
			end
			self._finished = true
		end
	end
end

function Animation:reset()
	self._frame = 1
	self._time = 0
	self._finished = false
end

function Animation:draw(x, y, r, sx, sy)
	love.graphics.draw(self._image, self._quads[self._frame], math.round(x), math.round(y), r, sx, sy, self._ox, self._oy)
end

function Animation:setSpeed(speed)
	self._speed = speed
end

function Animation:setOrigin(ox, oy)
	self._ox = ox
	self._oy = oy
end

function Animation:setLoop(loop)
	self._loop = loop
end

function Animation:isFinished()
	return self._finished
end

return Animation
