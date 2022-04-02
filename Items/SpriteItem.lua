
local DEFAULT_HEIGHT = 0.03

local function NewSpriteItem(menu, textureDict, textureName)
	local self = setmetatable(BaseItem(menu), SpriteItem)

	self.colors = {
		background  = self.parent.colors.background,
		text        = self.parent.colors.text,
		rightText   = self.parent.colors.text
	}

	self.hovered = false

	local x, y = GetActiveScreenResolution()
	local texRes = GetTextureResolution(textureDict, textureName)

	local scale = vector2(self.parent.width, DEFAULT_HEIGHT)

	self.sprite = Sprite(textureDict, textureName, nil, scale)
	self:Add(self.sprite)

	self.highlight = Rect(vector2(0, 0), vector2(self.parent.width, self.height), Colors.White:Alpha(50))

	self.OnActivate     = function() end
	self.OnRelease      = function() end
	self.OnStartHover   = function() end
	self.OnEndHover     = function() end



	-- process the Item
	function self:Process(cursorPosition)
		if (not self.enabled) then
			return
		end

		local hovered = self:InBounds(cursorPosition)
		if (hovered ~= self.hovered) then
			self.hovered = hovered

			if (self.hovered) then
				self:Add(self.highlight)

				Citizen.CreateThread(function()
					self.OnStartHover()
				end)
			else
				self:Remove(self.highlight)

				Citizen.CreateThread(function()
					self.OnEndHover()
				end)
			end
		end
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

SpriteItem = {}
SpriteItem.__index = SpriteItem
setmetatable(SpriteItem, {
	__call = function(cls, ...)
		return NewSpriteItem(...)
	end
})

SpriteItem.__tostring = function(obj)
	return string.format("SpriteItem()")
end

SpriteItem.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
