
local DEFAULT_HEIGHT = 0.03

local function NewBaseItem(menu)
	local self = setmetatable(Container(), BaseItem)

	-- if the item is enabled and shows in the Menu
	self.enabled = true

	-- the parent Menu of the Item
	self.parent = menu

	-- the colors of the Item
	self.colors = {
		background = self.parent and self.parent.colors.background or Colors.DarkGrey
	}

	-- the height of the Item
	self.height = DEFAULT_HEIGHT

	-- the background sprite of the Item
	self.background = Sprite(BACKGROUND.TXD, BACKGROUND.NAME, vector2(0, 0), vector2(self.parent.width, self.height), 0.0, self.colors.background)
	self:Add(self.background)

	self.isOverlapped = false



	-- get/set if the Item is enabled
	function self:Enabled(newEnabled)
		if (newEnabled == nil) then
			return self.enabled
		end

		self.enabled = newEnabled
	end

	-- process the Item
	function self:Process()
		return
	end

	function self:Draw()
		if (self.isOverlapped) then
			return
		end

		for i, obj in ipairs(self.objectList) do
			obj:Draw()
		end
	end

	-- get/set the height of the Item
	function self:Height(newHeight)
		if (not newHeight) then
			return self.height
		end

		self.height = newHeight

		self.background:Size(vector2(self.parent.width, self.height))
	end

	-- checks, if a screen relative point is inside the item bounds
	function self:InBounds(point)
		local pos = self:AbsolutePosition()
		return point.x >= pos.x 
			and point.y >= pos.y 
			and point.x < pos.x + self.parent.width * self.parent.scale.x
			and point.y < pos.y + self.height * self.parent.scale.y
	end

	-- checks, if the item is currently overlapped by another menu
	function self:IsOverlapped()
		for i, menu in ipairs(self.parent.pool.menus) do
			if (menu:Visible() and menu.order > self.parent.order) then
				local pos = self.position + vector2(self.parent.width, self.height) * 0.5
				for j, item in ipairs(menu.objectList) do
					if (item.InBounds ~= nil and item:InBounds(pos)) then
						self.isOverlapped = true

						return true
					end
				end
			end
		end

		self.isOverlapped = false

		return false
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

BaseItem = {}
BaseItem.__index = BaseItem
setmetatable(BaseItem, {
	__call = function(cls, ...)
		return NewBaseItem(...)
	end
})

BaseItem.__tostring = function(obj)
	return string.format("BaseItem()")
end

BaseItem.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
