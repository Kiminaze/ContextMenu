
local DEFAULT_HEIGHT = 0.03
local DEFAULT_TEXT_POSITION = vector2(0.002, 0.0035)

local function NewTextItem(menu, title)
	local self = setmetatable(BaseItem(menu), TextItem)

	self.colors = {
		background  = self.parent and self.parent.colors.background or Colors.DarkGrey,
		text        = self.parent and self.parent.colors.text or Colors.White,
		rightText   = self.parent and self.parent.colors.text or Colors.White
	}

	self.text = Text(title, self.colors.text, DEFAULT_TEXT_POSITION)
	self.text.font = TEXT.FONT
	self.text.maxWidth = self.parent.width
	self:Add(self.text)

	self.rightText = nil

	self.leftSprite     = nil
	self.rightSprite    = nil



	local function RecalculatePosition()
		self.text.maxWidth = self.parent.width - (self.leftSprite and 0.015 or 0) - (self.rightSprite and 0.015 or 0)
		if (self.leftSprite) then
			self.text:Position(DEFAULT_TEXT_POSITION + vector2(0.015, 0))
		end
		if (self.rightText) then
			self.rightText.maxWidth = self.parent.width - (self.leftSprite and 0.015 or 0) - (self.rightSprite and 0.0125 or 0)
			self.rightText:Position(vector2(self.parent.width - 0.004 - 0.0125, DEFAULT_TEXT_POSITION.y))
		end
	end

	function self:LeftSprite(textureDict, textureName)
		self:Remove(self.leftSprite)

		if (textureDict and textureName) then
			self.leftSprite = Sprite(textureDict, textureName, vector2(0.0008, 0.0015), vector2(0.015, 0.015 * GetAspectRatio(false)))
			self:Add(self.leftSprite)
		else
			self.leftSprite = nil
		end

		RecalculatePosition()
	end

	function self:RightSprite(textureDict, textureName)
		self:Remove(self.rightSprite)

		if (textureDict and textureName) then
			self.rightSprite = Sprite(textureDict, textureName, vector2(0.135, 0.0015), vector2(0.015, 0.015 * GetAspectRatio(false)))
			self:Add(self.rightSprite)
		else
			self.rightSprite = nil
		end

		RecalculatePosition()
	end

	function self:RightText(title)
		self:Remove(self.rightText)

		self.rightText = Text(title, self.colors.rightText, vector2(self.parent.width - 0.004, DEFAULT_TEXT_POSITION.y), nil, TextAlignment.Right)
		self.rightText.maxWidth = self.parent.width - (self.leftSprite and 0.015 or 0) - (self.rightSprite and 0.0125 or 0)
		if (self.rightSprite) then
			self.rightText:Position(vector2(self.parent.width - 0.004 - 0.0125, DEFAULT_TEXT_POSITION.y))
		end
		self:Add(self.rightText)
	end

	function self:Destroy()
		LogDebug("Destroyed " .. tostring(self))

		self.parent = nil

		for k, v in pairs(self.children) do
			if (self.children[k].Destroy) then
				self.children[k]:Destroy()
			end

			self.children[k] = nil
		end

		for k, v in pairs(self.objectList) do
			if (self.objectList[k].Destroy) then
				self.objectList[k]:Destroy()
			end

			self.objectList[k] = nil
		end

		for k, v in pairs(self) do
			self[k] = nil
		end
	end



	return self
end

TextItem = {}
TextItem.__index = TextItem
setmetatable(TextItem, {
	__call = function(cls, ...)
		return NewTextItem(...)
	end
})

TextItem.__tostring = function(obj)
	return string.format("TextItem()")
end

TextItem.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
