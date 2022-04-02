
local DEFAULT_THICKNESS = 0.001

local function NewBorder(_size, _thickness, _color)
	local self = setmetatable(Container(), Border)

	local size = _size or vector2(1.0, 1.0)

	local thickness = _thickness or DEFAULT_THICKNESS

	local color = _color or Colors.MISSING_COLOR

	local edges = { Rect(), Rect(), Rect(), Rect() }
	for i, edge in ipairs(edges) do
		self:Add(edge)
	end



	local function RecalculateBorder()
		-- pre-calc
		local aspectRatio = GetAspectRatio(false)
		local thick = vector2(thickness, thickness * aspectRatio)-- * self.scale
		local halfThick = thick * 0.5

		local topLeft = -halfThick
		local horizontalSize = vector2(size.x + thick.x, thick.y)
		local verticalSize = vector2(thick.x, size.y + thick.y)

		-- resize rects
		edges[1]:Position(topLeft)
		edges[1]:Size(horizontalSize)
		edges[2]:Position(topLeft)
		edges[2]:Size(verticalSize)
		edges[3]:Position(vector2(topLeft.x, size.y - halfThick.y))
		edges[3]:Size(horizontalSize)
		edges[4]:Position(vector2(size.x - halfThick.x, topLeft.y))
		edges[4]:Size(verticalSize)

		--self:Clear()
		--
		---- add rects
		--self:Add(Rect(topLeft, horizontalSize, color))
		--self:Add(Rect(topLeft, verticalSize, color))
		--self:Add(Rect(vector2(topLeft.x, size.y - halfThick.y), horizontalSize, color))
		--self:Add(Rect(vector2(size.x - halfThick.x, topLeft.y), verticalSize, color))
	end

	-- get/set the size of the Border
	function self:Size(newSize)
		if (not newSize) then
			return size
		end

		size = newSize

		RecalculateBorder()
	end

	-- get/set the color of the Border
	function self:Color(_color)
		if (_color == nil) then
			return color
		end

		color = _color

		for i, obj in ipairs(self.objectList) do
			obj.color = color
		end
	end

	function self:Destroy()
		LogDebug("Destroyed " .. tostring(self))

		self.parent = nil

		for k, v in pairs(edges) do
			if (edges[k].Destroy) then
				edges[k]:Destroy()
			end

			edges[k] = nil
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



	RecalculateBorder()

	return self
end

Border = {}
Border.__index = Border
setmetatable(Border, {
	__call = function(cls, ...)
		return NewBorder(...)
	end
})

Border.__tostring = function(border)
	return string.format("Border()")
end

Border.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
