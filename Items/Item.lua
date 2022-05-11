
local function NewItem(menu, title)
	-- create the Item
	local self = setmetatable(TextItem(menu, title), Item)

	-- add all necessary colors
	self.colors = {
		background  = self.parent and self.parent.colors.background or Colors.DarkGrey:Alpha(180),
		hBackground = self.parent and self.parent.colors.hBackground or Colors.LightGrey:Alpha(180),
		dBackground = self.parent and self.parent.colors.dBackground or Colors.DarkGrey:Alpha(180),
		text        = self.parent and self.parent.colors.text or Colors.White,
		hText       = self.parent and self.parent.colors.hText or Colors.White,
		dText       = self.parent and self.parent.colors.dText or Colors.Grey,
		rightText   = self.parent and self.parent.colors.text or Colors.White,
		hRightText  = self.parent and self.parent.colors.hText or Colors.White,
		dRightText  = self.parent and self.parent.colors.dText or Colors.Grey
	}

	self.closeOnActivate = false

	self.hovered = false



	self.OnActivate     = function() end
	self.OnRelease      = function() end
	self.OnStartHover   = function() end
	self.OnEndHover     = function() end



	-- process the Item
	function self:Process(cursorPosition)
		if (not self.enabled) then
			return
		end

		if (self:IsOverlapped(cursorPosition)) then
			return
		end

		local hovered = self:InBounds(cursorPosition)
		if (hovered ~= self.hovered) then
			self.hovered = hovered

			self.text.color = self.hovered and self.colors.hText or self.colors.text
			self.background.color = self.hovered and self.colors.hBackground or self.colors.background
			if (self.rightText) then
				self.rightText.color = self.hovered and self.colors.hRightText or self.colors.rightText
			end
			if (self.leftSprite) then
				self.leftSprite.color = self.hovered and self.colors.hText or self.colors.text
			end
			if (self.rightSprite) then
				self.rightSprite.color = self.hovered and self.colors.hRightText or self.colors.rightText
			end

			if (self.hovered) then
				Citizen.CreateThread(function()
					self.OnStartHover()
				end)
			else
				Citizen.CreateThread(function()
					self.OnEndHover()
				end)
			end
		end
	end

	function self:Draw()
		if (self.isOverlapped) then
			return
		end

		for i, obj in ipairs(self.objectList) do
			obj:Draw()
		end
	end

	-- get/set if the Item is enabled
	function self:Enabled(newEnabled)
		if (newEnabled == nil) then
			return self.enabled
		end

		self.enabled = newEnabled

		self.text.color = self.enabled and self.colors.text or self.colors.dText
		self.background.color = self.enabled and self.colors.background or self.colors.dBackground
		if (self.rightText) then
			self.rightText.color = self.enabled and self.colors.rightText or self.colors.dRightText
		end
		if (self.leftSprite) then
			self.leftSprite.color = self.enabled and self.colors.text or self.colors.dText
		end
		if (self.rightSprite) then
			self.rightSprite.color = self.enabled and self.colors.rightText or self.colors.dRightText
		end
	end

	-- get/set the height of the Item
	--function self:Height(newHeight)
	--    if (not newHeight) then
	--        return self:Height()
	--    end
	--
	--    self:Height(newHeight)
	--end

	function self:Activated()
		if (not self.enabled) then
			return
		end

		Citizen.CreateThread(function()
			self.OnActivate()
		end)

		if (self.closeOnActivate) then
			self.parent.pool:CloseAllMenus()
		end
	end

	function self:Released()
		if (not self.enabled) then
			return
		end

		Citizen.CreateThread(function()
			self.OnRelease()
		end)
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

Item = {}
Item.__index = Item
setmetatable(Item, {
	__call = function(cls, ...)
		return NewItem(...)
	end
})

Item.__tostring = function(obj)
	return string.format("Item()")
end

Item.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
