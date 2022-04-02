
local DEFAULT_HEIGHT = 0.012

local function NewSeparatorItem(menu)
	local self = setmetatable(BaseItem(menu), SeparatorItem)

	self.colors = {
		background  = self.parent.colors.background,
		line        = self.parent.colors.border
	}

	self:Height(DEFAULT_HEIGHT)

	self.thickness  = self.height / 12.0

	self.line = Rect(
		vector2(0.0025, (self.height / 2.0) - (self.thickness * GetAspectRatio(false) * 0.5)), 
		vector2(self.parent.width - 0.005, self.thickness * GetAspectRatio(false)), 
		self.colors.line
	)
	self:Add(self.line)

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

SeparatorItem = {}
SeparatorItem.__index = SeparatorItem
setmetatable(SeparatorItem, {
	__call = function(cls, ...)
		return NewSeparatorItem(...)
	end
})

SeparatorItem.__tostring = function(obj)
	return string.format("SeparatorItem()")
end

SeparatorItem.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
