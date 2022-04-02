
local DEFAULT_MAX_ITEMS = 10

local function NewPageMenu(pool, _maxItems)
	local self = setmetatable(Menu(pool), PageMenu)

	-- private
	local visible = false

	local lowerRight = vector2(0, 0)

	local itemList = {}

	local maxItems = _maxItems or DEFAULT_MAX_ITEMS

	local currentIndex = 1

	local pageItem = PageItem(self)

	local border = Border()
	border:Color(self.colors.border)
	border:Parent(self)

	local function RecalculatePosition(_position)
		self.position = _position

		local totalHeight = 0.0
		local nonScaledHeight = 0.0
		for i, item in ipairs(self.objectList) do
			totalHeight = totalHeight + item:Height() * self.scale.y
			nonScaledHeight = nonScaledHeight + item:Height()
		end

		lowerRight = self:AbsolutePosition() + vector2(self.width * self.scale.x, totalHeight)
		if (lowerRight.x > 1.0) then
			if (self.parent ~= nil) then
				self.position = vector2(self.position.x - self.width - self.parent.width, self.position.y)
				lowerRight = vector2(lowerRight.x - self.width - self.parent.width, lowerRight.y)
			else
				self.position = self.position - vector2(lowerRight.x - 1.0, 0.0)
				lowerRight = vector2(1.0, lowerRight.y)
			end
		end
		if (lowerRight.y > 1.0) then
			self.position = self.position - vector2(0.0, lowerRight.y - 1.0)
			lowerRight = vector2(lowerRight.x, 1.0)
		end

		border:Size(lowerRight - self.position)
		border:Size(vector2(self.width, nonScaledHeight))

		local currPos = vector2(0, 0)
		for i, item in ipairs(self.objectList) do
			item:Position(currPos)
			currPos = currPos + vector2(0.0, item:Height())
		end
	end



	function self:SwitchPage(direction)
		if (direction == "right") then
			currentIndex = currentIndex + maxItems
		else
			currentIndex = currentIndex - maxItems
		end

		if (currentIndex < 1) then
			if (#itemList % maxItems == 0) then
				currentIndex = #itemList - maxItems + 1
			else
				currentIndex = #itemList - (#itemList % maxItems - 1)
			end
		end
		if (currentIndex > #itemList) then
			currentIndex = 1
		end

		self:Clear()
		pageItem.text.title = 1 + (math.floor(currentIndex / maxItems))
		self:Add(pageItem)

		for i = currentIndex, currentIndex + maxItems - 1, 1 do
			if (i <= #itemList) then
				self:Add(itemList[i])
			end
		end

		RecalculatePosition(self.position)
	end

	function self:AddAnyItem(item)
		table.insert(itemList, item)

		if (#itemList > maxItems) then
			self:Clear()

			self:Add(pageItem)
			for i = 1, maxItems, 1 do
				if (i <= #itemList) then
					self:Add(itemList[i])
				end
			end
		end

		if (#itemList <= maxItems) then
			self:Add(item)
		end

		RecalculatePosition(self.position)

		return item
	end

	-- processes and draws the menu
	function self:Process(cursorPosition)
	    if (not visible) then
	        return
	    end

	    for i, item in ipairs(self.objectList) do
	        if (item.Process) then
	            item:Process(cursorPosition)
	        end
	    end
	end

	function self:Draw()
		if (not visible) then
			return
		end

		for i, obj in ipairs(self.objectList) do
			obj:Draw()
		end

		border:Draw()
	end

	-- get/set the visibility of the Menu
	function self:Visible(visibility)
	    if (visibility == nil) then
	        return visible
	    end

	    --if (visibility == false) then
	    --    Citizen.CreateThread(function()
	    --        self.OnClosed()
	    --    end)
	    --end

	    visible = visibility
	end

	-- get/set the position of the Menu
	function self:Position(_position)
	    if (_position == nil) then
	        return self.position
	    end

	    RecalculatePosition(_position)
	end

	-- checks if the given position is inside the bounds of the Menu
	function self:InBounds(point)
	    local pos = self:AbsolutePosition()
	    return point.x >= pos.x 
	        and point.y >= pos.y 
	        and point.x < lowerRight.x 
	        and point.y < lowerRight.y
	end

	function self:IsOverlapped()
	    for i, item in ipairs(self.objectList) do
	        if (item.submenu and item.submenu:Visible()) then
	            for j, subItem in ipairs(item.submenu.objectList) do
	                if (subItem.submenu and subItem.submenu.objectList) then
	                    for k, sub2Item in ipairs(subItem.submenu.objectList) do
	                        if (self:InBounds(sub2Item.position + vector2(sub2Item.parent.width, sub2Item.height) * 0.5)) then
	                            return true
	                        end
	                    end
	                end
	            end
	        end
	    end

	    return false
	end

	function self:Destroy()
		LogDebug("Destroyed " .. tostring(self))

		self.parent = nil

		for k, v in pairs(itemList) do
			if (itemList[k].Destroy) then
				itemList[k]:Destroy()
			end

			itemList[k] = nil
		end

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



PageMenu = {}
PageMenu.__index = PageMenu
setmetatable(PageMenu, {
	__call = function(cls, ...)
		return NewPageMenu(...)
	end
})

PageMenu.__tostring = function(obj)
	return string.format("PageMenu()")
end

PageMenu.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
