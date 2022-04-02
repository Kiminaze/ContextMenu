
local DEFAULT_HEIGHT = 0.02

local SCROLL_TIME = 150
local MAX_SCROLL_TIME = 50

local function NewScrollItem(scrollMenu, _direction)
	assert(_direction == "up" or _direction == "down", "Parameter \"direction\" must be a either \"up\" or \"down\"!")
	local self = setmetatable(BaseItem(scrollMenu), ScrollItem)

	self.colors = {
		background	= self.parent.colors.background or Colors.DarkGrey:Alpha(180),
		hBackground	= self.parent.colors.hBackground or Colors.LightGrey:Alpha(180),
		arrow		= self.parent.colors.text or Colors.White,
		hArrow		= self.parent.colors.hText or Colors.White
	}

	self.hovered = false

	self.height = DEFAULT_HEIGHT
	self.background:Size(vector2(self.parent.width, self.height))

	local direction = _direction

	self.sprite = SpriteUV("commonmenu", "shop_arrows_upanddown", vector2(0.06, 0.0), vector2(0.03, 0.015 * GetAspectRatio(false)))
	if (direction == "up") then
		self.sprite:Position(vector2(0.06, -0.0075))
		self.sprite.uv2 = vector2(1.0, 0.5)
	else
		self.sprite.uv1 = vector2(0.0, 0.5)
	end
	self:Add(self.sprite)

	self.OnActivate     = function() end
	self.OnRelease      = function() end
	self.OnStartHover   = function() end
	self.OnEndHover     = function() end



	local function Coroutine_StartedHoveringForScroll()
		local scrollTime = SCROLL_TIME
		Citizen.CreateThread(function()
			local startTime = GetGameTimer()
			while (true) do
				if (not self.hovered or not self.parent or not self.parent:Visible()) then
					return
				end

				if (GetGameTimer() - scrollTime > startTime) then
					self.parent:Scroll(direction)

					startTime = GetGameTimer()
					
					if (scrollTime > MAX_SCROLL_TIME) then
						scrollTime = scrollTime - ((SCROLL_TIME - MAX_SCROLL_TIME) * 0.1)
					end
				end

				Citizen.Wait(0)
			end
		end)
	end



	-- process the Item
	function self:Process(cursorPosition)
		if (not self.enabled) then
			return
		end

		local hovered = self:InBounds(cursorPosition)
		if (hovered ~= self.hovered) then
			self.hovered = hovered

			self.sprite.color = self.hovered and self.colors.hArrow or self.colors.arrow
			self.background.color = self.hovered and self.colors.hBackground or self.colors.background

			if (self.hovered) then
				Coroutine_StartedHoveringForScroll()
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

ScrollItem = {}
ScrollItem.__index = ScrollItem
setmetatable(ScrollItem, {
	__call = function(cls, ...)
		return NewScrollItem(...)
	end
})

ScrollItem.__tostring = function(obj)
	return string.format("ScrollItem()")
end

ScrollItem.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
