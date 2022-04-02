
local function NewRect(_position, _size, _color)
	local self = setmetatable(Object2D(_position, vector2(1.0, 1.0)), Rect)

	-- private
	local internalPosition  = vector2(0.0, 0.0)
	local internalScale     = vector2(1.0, 1.0)

	local size = _size or vector2(1.0, 1.0)

	-- public
	self.color = _color or Colors.White



	-- get/set the position of the Rect
	function self:Position(newPosition)
		if (not newPosition) then
			return self.position
		end

		self.position = newPosition

		internalPosition = self:AbsolutePosition() + (self:AbsoluteScale() * size * 0.5)

		-- re-calc children position
		for i, child in ipairs(self.children) do
			child:Position(child:Position())
		end
	end

	-- get/set the scale of the Rect
	function self:Scale(newScale)
		if (not newScale) then
			return self.scale
		end

		self.scale = newScale

		internalScale = self:AbsoluteScale() * size
		internalPosition = self:AbsolutePosition() + (self:AbsoluteScale() * size * 0.5)

		-- re-calc children scale
		for i, child in ipairs(self.children) do
			child:Scale(child:Scale())
		end
	end

	-- get/set the scale of the Rect
	function self:Size(newSize)
		if (not newSize) then
			return size
		end

		size = newSize

		internalScale = self:AbsoluteScale() * size
		internalPosition = self:AbsolutePosition() + (self:AbsoluteScale() * size * 0.5)
	end
	
	-- get/set the color of the Rect
	function self:Color(newColor)
		if (not newColor) then
			return self.color
		end

		self.color = newColor
	end

	-- draws the Rect to the screen
	function self:Draw()
		DrawRect(internalPosition.x, internalPosition.y, internalScale.x, internalScale.y, self.color.r, self.color.g, self.color.b, self.color.a)
	end

	function self:Destroy()
		LogDebug("Destroyed " .. tostring(self))

		self.parent = nil

		for k, v in pairs(self.children) do
			if (self.children[k].ClearReferences) then
				self.children[k]:ClearReferences()
			end

			self.children[k] = nil
		end

		for k, v in pairs(self) do
			self[k] = nil
		end
	end



	-- re-calc position and scale once
	self:Position(_position)
	self:Scale(vector2(1.0, 1.0))

	return self
end

Rect = {}
Rect.__index = Rect
setmetatable(Rect, {
	__call = function(cls, ...)
		return NewRect(...)
	end
})

Rect.__tostring = function(rect)
	return string.format("Rect(%s, %s, %s)", rect:Position(), rect:Size(), rect.color)
end

Rect.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
