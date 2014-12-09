local CreditsController = require("CreditsController")

local CreditsScene = class("CreditsScene", Scene)

function CreditsScene:initialize()
	Scene.initialize(self)

	self:addEntity(CreditsController())
end

return CreditsScene
