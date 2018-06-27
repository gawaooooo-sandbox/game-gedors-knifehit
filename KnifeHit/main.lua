--[[

	Knife Hit Main

--]]

-- global variables
ScreenW = application:getDeviceWidth()
ScreenH = application:getDeviceHeight()
Scale = 0.6
legalHit = true
canThrow = true

-- set window size
local fitW = 750 * Scale
local fitH = 1334 * Scale
application:setWindowSize(fitW, fitH)
-- set background color
application:setBackgroundColor(0x444444);

-- create target sprit
target = Target.new()
-- create throw knife sprites
throwKnife = ThrowKnife.new()

-- targetWidth, targetHeight
targetWidth = target:getWidth()
targetHeight = target:getHeight()

-- eventlistener
function onMouseDown(event)
	print("canThrow", canThrow)
	if canThrow then
		throwKnife:onMouseDown(event)
	end
end


-- add throw knife sprite to the stage
stage:addChild(throwKnife)

-- add target sprite to the stage
stage:addChild(target)

throwKnife:printType()

-- add mousedown event
stage:addEventListener(Event.MOUSE_DOWN, onMouseDown)
