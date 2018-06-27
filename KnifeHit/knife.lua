--[[

	Knife Hit - Knife Class

--]]

Knife = Core.class(Sprite)
ThrowKnife = Core.class(Knife)
HitKnife = Core.class(Knife)

HitKnifes = {}

--
function Knife:init()
	local bitmap = Bitmap.new(Texture.new("knife.png"))
	self:addChild(bitmap)
	
	print("call knife init")
end

function Knife:printType(klass)
	print(klass.type)
end
--
--
function HitKnife:init(x, y, targetRotation)
	print("call hitknife init")
	print("targetRotation::::::: ", targetRotation)
	
	--self:setAnchorPoint(0, 0)
	self:setAnchorPoint(0.5, 0.5)
	self:setScale(Scale, Scale, Scale)
	self:setX(x)
	self:setY(y)
	
	self.type = "hit"
	self.impactAngle = targetRotation % 360
	print("self.impactAngle: ", self.impactAngle)
	
	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
end
--
function HitKnife:removeFromParent()
	print("call hit knife remove self")
	local parent = self:getParent()
	if parent ~= nil then
		parent:removeChild(self)
	end
end
--
function HitKnife:onEnterFrame(event)
	 local rotation = self:getRotation() + 3
	 
	 local rad = math.rad(rotation + 90)
	 local targetX, targetY = target:getPosition();	 
	 local x = targetWidth / 2 * math.cos(rad) + targetX
	 local y = targetHeight / 2 * math.sin(rad)  + targetY
	self:setPosition(x, y)
	
	self:setRotation(rotation)
end
--
--
function ThrowKnife:init()
	self:setAnchorPoint(0, 0.5)
	self:setScale(Scale, Scale, Scale)
	self:setX(ScreenW / 2)
	self:setY(ScreenH / 5 * 4)
	
	self.type = "throw"
	self.throwSpeed = 5
	self.fallOut = false

	self:addEventListener(Event.ENTER_FRAME, self.onEnterFrame, self)
	print("call throw knife init", self.type)
end
--
function ThrowKnife:printType()
	self.super:printType(self)
end
--
function ThrowKnife:onMouseDown(event)
	-- throwing knife
	canThrow = false
	
	-- target position
	local x, y = target:getPosition()
	local toY = y + target:getWidth() / 2
	
	local tween = GTween.new(self, 0.2, {y = toY}, {ease = easing.linear, reflect = true, onComplete = function()  self:throwComplete() end}, {dispatchEvents = true})
end
--
function ThrowKnife:addHitKnife(x, y, targetRotation)
	print("thrownknife addHitKnife")

	local knifeIndex = #HitKnifes + 1
	local hitKnife = HitKnife.new(x, y - 100, targetRotation)
	HitKnifes[knifeIndex] = hitKnife
	print(#HitKnifes)

	stage:addChildAt(hitKnife, 2)
end
--
function ThrowKnife:checkHit(targetRotation)
	print("check throwknife hit ", targetRotation)
	for i = 1, #HitKnifes do
		local knife = HitKnifes[i]
		local diff = math.abs(targetRotation - knife.impactAngle)
		print("angleの差分::", diff)
		print("knife.impactAngle", knife.impactAngle)
		
		if diff < 10 then
			print(" OUT !!!")
			legalHit = false
			break
		end
	end
end
--
function ThrowKnife:throwComplete()
	print("throw complete ended")
	
	local targetRotation = target:getRotation() % 360
	self:checkHit(targetRotation)	
	print("legalHit: ", legalHit)

	if legalHit then
		-- 丸太に当たっていたら新しいknifeを生成して刺す
		local knifeX, knifeY = self:getPosition()
		self:addHitKnife(knifeX, knifeY, targetRotation)
		print("hitKnifes length: ", #HitKnifes)
		
		-- 投げたナイフは元の位置に戻す
		local x,y = self:getPosition();
		local toY = ScreenH / 5 * 4;
		
		-- 投げるナイフを元の位置に戻す
		GTween.new(self, 0.1, {y = toY}, {
			ease = easing.linear,
			reflect = true,
			onComplete = function()
				canThrow = true
				legalHit = true
			end
		})
	else
		-- ナイフに当たっていたらGAME OVER
		print("knife fallout")
		self.fallOut = true
		GTween.new(self, 0.7, {y = ScreenH + self:getHeight()}, {
			ease = easing.linear,
			reflect = true,
			onComplete = function()
				print("throw knife fall out tween end")
				
					-- remove hit knifes
					for i = 1, #HitKnifes do
						local knife = HitKnifes[i]
						knife:removeFromParent()
					end
				
				-- reset flag
				canThrow = true
				legalHit = true
				self.fallOut = false
				
				HitKnifes = {}
				
				-- reset throw knife
				self:setRotation(0)
				self:setY(ScreenH / 5 * 4)
			end
		})
	end
end
--
function ThrowKnife:onEnterFrame(event)
	if self.fallOut == true then
		self:setRotation(self:getRotation() + 6)
	end
end






