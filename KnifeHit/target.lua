--[[

	Knife Hit - Target Class

--]]

Target = Core.class(Sprite)

function Target:init(texture)
	local bitmap = Bitmap.new(Texture.new("target.png"))
	bitmap:setAnchorPoint(0.5, 0.5)
	self:addChild(bitmap)

	self:setScale(Scale, Scale, Scale)
	self:setX(ScreenW / 2)
	self:setY(400 * Scale)

	self.width = self:getWidth()
	self.height = self:getHeight()
		
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)	
end

function Target:onEnterFrame(event)
	self:setRotation(self:getRotation() + 3)
end