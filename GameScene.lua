local Canvas = require("Canvas")
local Palette = require("Palette")
local Sprite = require("Sprite")
local Toolbox = require("Toolbox")
local Customer = require("Customer")

local GameScene = class("GameScene", Scene)

function GameScene:initialize()
	Scene.initialize(self)

	self:addEntity(Canvas(20, 28, 120, 160))
	self:addEntity(Palette(166, 182))
	self:addEntity(Toolbox(27, 222))

	self:addEntity(Sprite(16, 24, 20, Resources.static:getImage("easel.png"), 0, 0))
	self:addEntity(Sprite(WIDTH/2, HEIGHT/2, 100, Resources.static:getImage("background.png")))
	self:addEntity(Sprite(240, 90, 0, Resources.static:getImage("customer_frame.png")))

	self:addEntity(Customer(1))
end

return GameScene
