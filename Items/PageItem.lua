
local DEFAULT_HEIGHT = 0.03

local SCROLL_TIME = 150

local function NewPageItem(scrollMenu)
	local self = setmetatable(BaseItem(scrollMenu), PageItem)

	self.colors = {
		background	= self.parent.colors.background or Colors.DarkGrey:Alpha(180),
		hBackground	= self.parent.colors.hBackground or Colors.LightGrey:Alpha(180),
		arrow		= self.parent.colors.text or Colors.White,
		hArrow		= self.parent.colors.hText or Colors.White
	}

	-- segment background
	self:Remove(self.background)

	self.background = SpriteUV(BACKGROUND.TXD, BACKGROUND.NAME, vector2(0, 0), vector2(self.parent.width * 0.4, self.height), 0.0, self.colors.background)
	self.background.uv2 = vector2(0.4, 1.0)
	self:Add(self.background)

	self.background2 = SpriteUV(BACKGROUND.TXD, BACKGROUND.NAME, vector2(self.parent.width * 0.4, 0), vector2(self.parent.width * 0.2, self.height), 0.0, self.colors.background)
	self.background2.uv1 = vector2(0.4, 0.0)
	self.background2.uv2 = vector2(0.6, 1.0)
	self:Add(self.background2)

	self.background3 = SpriteUV(BACKGROUND.TXD, BACKGROUND.NAME, vector2(self.parent.width * 0.6, 0), vector2(self.parent.width * 0.4, self.height), 0.0, self.colors.background)
	self.background3.uv1 = vector2(0.6, 0.0)
	self.background3.uv2 = vector2(1.0, 1.0)
	self:Add(self.background3)

	-- page number
	self.text = Text(1, self.colors.text, vector2(self.parent.width * 0.5, 0.0), 0.4, TextAlignment.Center)
	self.text.maxWidth = self.parent.width * 0.2
	self:Add(self.text)

	self.hoveredLeft	= false
	self.hoveredRight	= false

	local scale = vector2(self.parent.width, DEFAULT_HEIGHT)

	local direction = _direction
	self.sprite		= SpriteUV("commonmenu", "arrowleft",  vector2(self.parent.width * 0.15, 0.0), vector2(0.015, 0.015 * GetAspectRatio(false)))
	self.sprite2	= SpriteUV("commonmenu", "arrowright", vector2(self.parent.width * 0.75, 0.0), vector2(0.015, 0.015 * GetAspectRatio(false)))
	self:Add(self.sprite)
	self:Add(self.sprite2)

	self.OnActivate     = function() end
	self.OnRelease      = function() end
	self.OnStartHover   = function() end
	self.OnEndHover     = function() end



	function self:InLeftBounds(point)
		local pos = self:AbsolutePosition()
		return point.x >= pos.x 
			and point.y >= pos.y 
			and point.x < pos.x + self.parent.width * self.parent.scale.x * 0.5
			and point.y < pos.y + self.height * self.parent.scale.y
	end

	-- process the Item
	function self:Process(cursorPosition)
		if (not self.enabled) then
			return
		end

		local hovered = self:InBounds(cursorPosition)
		if (hovered ~= self.hovered) then
			self.hovered = hovered

			if (self.hovered) then
				Citizen.CreateThread(function()
					self.OnStartHover()
				end)
			else
				Citizen.CreateThread(function()
					self.OnEndHover()
				end)

				self.background.color = self.colors.background
				self.background3.color = self.colors.background

				self.sprite.color = self.colors.arrow
				self.sprite2.color = self.colors.arrow
			end
		end

		if (self.hovered) then
			local hoveredLeft = self:InLeftBounds(cursorPosition)
			self.hoveredLeft = hoveredLeft
			self.background.color = hoveredLeft and self.colors.hBackground or self.colors.background
			self.background3.color = not hoveredLeft and self.colors.hBackground or self.colors.background

			self.sprite.color = hoveredLeft and self.colors.hArrow or self.colors.arrow
			self.sprite2.color = not hoveredLeft and self.colors.hArrow or self.colors.arrow
		end
	end

	function self:Activated()
		if (not self.enabled) then
			return
		end

		if (self.hoveredLeft) then
			self.parent:SwitchPage("left")
		else
			self.parent:SwitchPage("right")
		end

		Citizen.CreateThread(function()
			self.OnActivate()
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

PageItem = {}
PageItem.__index = PageItem
setmetatable(PageItem, {
	__call = function(cls, ...)
		return NewPageItem(...)
	end
})

PageItem.__tostring = function(obj)
	return string.format("PageItem()")
end

PageItem.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
