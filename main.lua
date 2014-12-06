class = require("middleclass.middleclass")
gamestate = require("hump.gamestate")
Resources = require("Resources")
Mouse = require("Mouse")
Scene = require("Scene")
Entity = require("Entity")

WIDTH = 320
HEIGHT = 240
SCALE = 3

function love.load()
	love.window.setMode(WIDTH*SCALE, HEIGHT*SCALE)
	love.graphics.setBackgroundColor(255, 255, 255)
	love.graphics.setDefaultFilter("nearest", "nearest")

	gamestate.registerEvents()
	gamestate.switch(require("GameScene")())
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

function love.run()
	if love.math then
		love.math.setRandomSeed(os.time())
	end

	if love.event then
		love.event.pump()
	end

	if love.load then love.load(arg) end

	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end

	local dt = 0

	-- Main loop time.
	while true do
		-- Process events.
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

		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
			dt = love.timer.getDelta()
		end

		-- Call update and draw
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled

		Mouse.static:clear()

		if love.window and love.graphics and love.window.isCreated() then
			love.graphics.clear()
			love.graphics.origin()

			love.graphics.push()
			love.graphics.scale(SCALE, SCALE)

			if love.draw then love.draw() end

			if love.gui then love.gui() end

			love.graphics.pop()

			love.graphics.present()
		end

		if love.timer then love.timer.sleep(0.001) end
	end
end
