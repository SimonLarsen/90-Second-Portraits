local Resources = class("Resources")

Resources.static._images = {}

function Resources.static:getImage(path)
	path = "data/images/" .. path
	if self._images[path] == nil then
		self._images[path] = love.graphics.newImage(path)
	end
	return self._images[path]
end

Resources.static._sounds = {}

function Resources.static:getSound(path)
	path = "data/sounds/" .. path
	if self._sounds[path] == nil then
		self._sounds[path] = love.audio.newSource(path, "static")
	end
	return self._sounds[path]
end

function Resources.static:playMusic(path)
	path = "data/music/" .. path
	local music = love.audio.newSource(path, "stream")
	music:setLooping(true)
	music:setVolume(0.6)
	love.audio.play(music)
end

return Resources
