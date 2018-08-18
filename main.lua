require("mymath")
require("slam")
class = require("middleclass.middleclass")
gamestate = require("hump.gamestate")
Resources = require("Resources")
Preferences = require("Preferences")
Timer = require("hump.timer")
Mouse = require("Mouse")
Keyboard = require("Keyboard")
Scene = require("Scene")
Entity = require("Entity")
Sound = require("Sound")
Animation = require("Animation")

WIDTH = 320
HEIGHT = 240
OFFSET_X = 0
IS_MOBILE = false

local canvas

function love.load()
	local winwidth, winheight = love.window.getDesktopDimensions()
	if love.system.getOS() == "Android" then
		updateScale(winheight / HEIGHT)
		OFFSET_X = (winwidth - WIDTH*SCALE)/2 / SCALE
		IS_MOBILE = true
	else
		updateScale(math.floor(winheight / HEIGHT))
	end

	love.mouse.setVisible(false)
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setLineStyle("rough")

	Preferences.static:load()

	canvas = love.graphics.newCanvas(WIDTH, HEIGHT)

	gamestate.registerEvents()
	gamestate.switch(require("TitleScene")())
	
	Sound.music("monkeys.ogg")
end

function love.gui()
	gamestate.current():gui()
end

function love.mousepressed(x, y, button)
	Mouse.static:mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	Mouse.static:mousereleased(x, y, button)
end

function love.wheelmoved(x, y)
	Mouse.static:wheelmoved(x, y)
end

function love.keypressed(k)
	if k == "1" then updateScale(1)
	elseif k == "2" then updateScale(2)
	elseif k == "3" then updateScale(3)
	elseif k == "4" then updateScale(4)
	elseif k == "5" then updateScale(5)
	elseif k == "6" then updateScale(6)
	elseif k == "7" then updateScale(7)
	end

	Keyboard.static:keypressed(k)
end

function love.keyreleased(k)
	Keyboard.static:keyreleased(k)
end

function love.run()
	if love.math then
		love.math.setRandomSeed(os.time())
		love.math.random()
	end

	if love.event then
		love.event.pump()
	end

	if love.load then love.load(arg) end
	if love.timer then love.timer.step() end
	local dt = 0

	while true do
		if love.event then
			love.event.pump()
			for e,a,b,c,d in love.event.poll() do
				if e == "quit" then
					if not love.quit or not love.quit() then
						if love.audio then
							love.audio.stop()
						end
						return
					end
				end
				love.handlers[e](a,b,c,d)
			end
		end

		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end

		if love.update then love.update(dt) end

		Mouse.static:clear()
		Keyboard.static:clear()

		if love.window and love.graphics and love.window.isOpen() then
			love.graphics.clear()
			love.graphics.origin()
			love.graphics.push()

			love.graphics.setCanvas(canvas)

			if love.draw then love.draw() end
			if love.gui then love.gui() end

			love.graphics.pop()
			love.graphics.push()

			love.graphics.scale(SCALE, SCALE)

			love.graphics.setCanvas()
			love.graphics.draw(canvas, OFFSET_X, 0)
			
			love.graphics.pop()

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end

function updateScale(s)
	SCALE = s
	love.window.setMode(WIDTH*SCALE, HEIGHT*SCALE)
end
