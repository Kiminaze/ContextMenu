
local function NewSprite(_dict, _name, _position, _size, _angle, _color)
	local self = setmetatable(Object2D(_position, vector2(1.0, 1.0)), Sprite)

	-- private
	local dict = _dict
	local name = _name

	local internalPosition  = vector2(0, 0)
	local internalScale     = vector2(1, 1)

	-- public
	local size = _size or vector2(1.0, 1.0)

	self.angle  = _angle or 0.0
	self.color  = _color or Colors.White



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

	-- get/set the size of the Rect
	function self:Size(newSize)
		if (not newSize) then
			return size
		end

		size = newSize

		internalScale = self:AbsoluteScale() * size
		internalPosition = self:AbsolutePosition() + (self:AbsoluteScale() * size * 0.5)

		-- re-calc children scale
		for i, child in ipairs(self.children) do
			child:Scale(child:Scale())
		end
	end

	-- draw the Sprite to the screen
	function self:Draw()
		DrawSprite(
			dict, name, 
			internalPosition.x, internalPosition.y, 
			internalScale.x, internalScale.y, 
			self.angle, 
			self.color.r, self.color.g, self.color.b, self.color.a
		)
	end

	-- get the texture dictionary of the Sprite
	function self:Dict()
		return dict
	end

	-- get the name of the Sprite
	function self:Name()
		return name
	end

	function self:Sprite(_dict, _name)
		dict = _dict
		name = _name

		-- request dictionary
		if (not HasStreamedTextureDictLoaded(dict)) then
			RequestStreamedTextureDict(dict, true)
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



	-- request dictionary
	if (not HasStreamedTextureDictLoaded(dict)) then
		RequestStreamedTextureDict(dict, true)
	end

	-- re-calc position and scale once
	self:Position(_position)
	self:Scale(vector2(1.0, 1.0))

	return self
end

Sprite = {}
Sprite.__index = Sprite
setmetatable(Sprite, {
	__call = function(cls, ...)
		return NewSprite(...)
	end
})

Sprite.__tostring = function(sprite)
	return string.format("Sprite(\"%s\", \"%s\")", sprite:Dict(), sprite:Name())
end

Sprite.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
