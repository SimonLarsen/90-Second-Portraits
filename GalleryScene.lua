local GalleryController = require("GalleryController")

local GalleryScene = class("GalleryScene", Scene)

function GalleryScene:initialize()
	Scene.initialize(self)

	self:addEntity(GalleryController())
end

return GalleryScene
