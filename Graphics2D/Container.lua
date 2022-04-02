
local function NewContainer(_position)
	local self = setmetatable(Object2D(_position, nil), Container)

	-- list containing all Graphics2D elements to draw
	self.objectList = {}



	-- get/set the position of the Rect
	function self:Position(newPosition)
		if (not newPosition) then
			return self.position
		end

		self.position = newPosition

		-- re-calc children position
		for i, obj in ipairs(self.objectList) do
			obj:Position(obj:Position())
		end
	end

	-- get/set the scale of the Rect
	function self:Scale(newScale)
		if (not newScale) then
			return self.scale
		end

		self.scale = newScale

		-- re-calc children scale
		for i, obj in ipairs(self.objectList) do
			obj:Scale(obj:Scale())
		end
	end

	function self:Draw()
		for i, obj in ipairs(self.objectList) do
			obj:Draw()
		end
	end

	-- add new Graphics2D objects to the Container
	function self:Add(obj)
		obj:Parent(self)

		table.insert(self.objectList, obj)

		return self.objectList[#self.objectList]
	end

	-- remove a Graphics2D object from the Container
	function self:Remove(object)
		for i, obj in ipairs(self.objectList) do
			if (obj == object) then
				table.remove(self.objectList, i)
				return
			end
		end
	end

	-- remove all objects from the Container
	function self:Clear()
		self.objectList = {}
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

Container = {}
Container.__index = Container
setmetatable(Container, {
	__call = function(cls, ...)
		return NewContainer(...)
	end
})

Container.__tostring = function(container)
	return "Container()"
end

Container.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
