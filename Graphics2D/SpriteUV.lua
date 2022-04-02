
local function NewSpriteUV(_dict, _name, _position, _size, _angle, _color)
	local self = setmetatable(Object2D(_position, vector2(1.0, 1.0)), Sprite)

	-- private
	local dict = _dict
	local name = _name

	local internalPosition  = vector2(0, 0)
	local internalScale     = vector2(1, 1)

	local size = _size or vector2(1.0, 1.0)

	-- public
	self.angle  = _angle or 0.0
	self.color  = _color or Colors.White

	self.uv1 = vector2(0.0, 0.0)
	self.uv2 = vector2(1.0, 1.0)



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

	-- draw the Sprite to the screen
	function self:Draw()
		DrawSpriteUv(
			dict, name, 
			internalPosition.x, internalPosition.y, 
			internalScale.x, internalScale.y, 
			self.uv1.x, self.uv1.y, self.uv2.x, self.uv2.y, 
			self.angle, 
			self.color.r, self.color.g, self.color.b, self.color.a
		)
	end

	-- get the texture dictionary of the SpriteUV
	function self:Dict()
		return dict
	end

	-- get the name of the SpriteUV
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

SpriteUV = {}
SpriteUV.__index = SpriteUV
setmetatable(SpriteUV, {
	__call = function(cls, ...)
		return NewSpriteUV(...)
	end
})

SpriteUV.__tostring = function(sprite)
	return string.format("SpriteUV(\"%s\", \"%s\")", sprite:Dict(), sprite:Name())
end

SpriteUV.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
