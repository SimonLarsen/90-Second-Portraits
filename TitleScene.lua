local TitleController = require("TitleController")

local TitleScene = class("TitleScene", Scene)

function TitleScene:initialize()
	Scene.initialize(self)

	self:addEntity(TitleController())
end

return TitleScene
