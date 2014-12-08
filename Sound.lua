local Sound = {}

local music

function Sound.play(name, pitch)
	local source = Resources.static:getSound(name)
	if pitch then source:setPitch(pitch) end
	love.audio.play(source)
end

function Sound.music(name)
	if music ~= nil then
		music:stop()
	end
	music = love.audio.newSource("data/music/" .. name)
	music:setVolume(0.5)
	music:setLooping(true)
	love.audio.play(music)
end

return Sound
