
local function NewObject2D(_position, _scale)
	local self = setmetatable({}, Object2D)

	self.parent     = nil
	self.children   = {}

	self.position   = _position or vector2(0.0, 0.0)
	self.scale      = _scale or vector2(1.0, 1.0)



	-- get/set the parent of the Object2D
	function self:Parent(newParent)
		if (not newParent) then
			return self.parent
		end

		if (self.parent) then
			for i, child in ipairs(self.parent.children) do
				if (child == self) then
					table.remove(self.parent.children, i)
					break
				end
			end
		end

		self.parent = newParent

		table.insert(self.parent.children, self)

		self:Position(self:Position())
		self:Scale(self:Scale())
	end

	-- get/set the position of the Object2D
	function self:Position(newPosition)
		if (not newPosition) then
			return self.position
		end

		self.position = newPosition
	end

	-- get/set the scale of the Object2D
	function self:Scale(newScale)
		if (not newScale) then
			return self.scale
		end

		self.scale = newScale
	end

	-- get the absolute screen position of the Object2D
	function self:AbsolutePosition()
		if (self.parent) then
			return self.parent:AbsolutePosition() + self.position * self.parent:AbsoluteScale()
		else
			return self.position
		end
	end

	-- get the absolute screen scale of the Object2D
	function self:AbsoluteScale()
		if (self.parent) then
			return self.parent:AbsoluteScale() * self.scale
		else
			return self.scale
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

		for k, v in pairs(self) do
			self[k] = nil
		end
	end



	return self
end

Object2D = {}
Object2D.__index = Object2D
setmetatable(Object2D, {
	__call = function(cls, ...)
		return NewObject2D(...)
	end
})

Object2D.__tostring = function(object2D)
	return string.format("Object2D(%s, %s)", object2D.position, object2D.scale)
end

Object2D.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
