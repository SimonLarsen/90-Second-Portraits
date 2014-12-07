local Canvas = require("Canvas")
local GameBackground = require("GameBackground")
local Palette = require("Palette")

local GameScene = class("GameScene", Scene)

function GameScene:initialize()
	Scene.initialize(self)

	self:addEntity(Canvas(20, 28, 120, 160))
	self:addEntity(GameBackground())
	self:addEntity(Palette(166, 178))
end

return GameScene
