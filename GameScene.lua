local Canvas = require("Canvas")
local Palette = require("Palette")
local Sprite = require("Sprite")
local Toolbox = require("Toolbox")
local Customer = require("Customer")
local GameController = require("GameController")
local Background = require("Background")

local GameScene = class("GameScene", Scene)

function GameScene:initialize()
	Scene.initialize(self)

	local customer_order = { 1, 2, 3, 4, 5 }
	local background_order = { 5, 4, 3, 2, 1 }

	self:addEntity(GameController(customer_order, background_order))
	self:addEntity(Customer(customer_order[1]))
	self:addEntity(Canvas())
	self:addEntity(Background(background_order[1]))
	self:addEntity(Palette(166, 182))
	self:addEntity(Toolbox(27, 222))

	self:addEntity(Sprite(16, 24, 20, Resources.static:getImage("easel.png"), 0, 0))
	self:addEntity(Sprite(WIDTH/2, HEIGHT/2, 100, Resources.static:getImage("background.png")))
	self:addEntity(Sprite(240, 90, 0, Resources.static:getImage("customer_frame.png")))
end

return GameScene
