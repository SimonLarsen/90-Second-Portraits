local TutorialController = require("TutorialController")

local TutorialScene = class("TutorialScene", Scene)

function TutorialScene:initialize(goToGame)
	Scene.initialize(self)

	self:addEntity(TutorialController(goToGame))
end

return TutorialScene
