local Canvas = require("Canvas")

local GameScene = class("GameScene", Scene)

function GameScene:initialize()
	Scene.initialize(self)

	self:addEntity(Canvas(20, 30, 120, 160))
end

return GameScene
