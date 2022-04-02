
local function NewText(_title, _color, _position, _size, _alignment)
	local self = setmetatable(Object2D(_position, vector2(1.0, 1.0)), Text)

	-- private
	local internalPosition  = vector2(0.0, 0.0)
	local internalSize      = 1.0

	local size = _size or 0.3

	-- public
	self.title = _title or "MISSING_TEXT"

	self.alignment  = _alignment or TextAlignment.Left
	self.maxWidth   = 0.0

	self.font = TextFont.Default

	self.color = _color or Colors.White

	self.shadowDistance = 0
	self.shadowColor    = Colors.Black



	-- get/set the position of the Text
	function self:Position(newPosition)
		if (not newPosition) then
			return self.position
		end

		self.position = newPosition

		internalPosition = self:AbsolutePosition()

		-- re-calc children position
		for i, child in ipairs(self.children) do
			child:Position(child:Position())
		end
	end

	-- get/set the scale of the Text
	function self:Scale(newScale)
		if (not newScale) then
			return self.scale
		end

		self.scale = newScale

		internalSize = self:AbsoluteScale() * size

		self:Position(self:Position())

		-- re-calc children scale
		for i, child in ipairs(self.children) do
			child:Scale(child:Scale())
		end
	end

	-- get/set the scale of the Text
	function self:Size(newSize)
		if (not newSize) then
			return size
		end

		size = newSize

		internalSize = self:AbsoluteScale() * size
	end

	-- get the total width of the Text
	function self:GetWidth()
		BeginTextCommandGetWidth("CELL_EMAIL_BCON")

		AddTextComponentSubstringPlayerName(self.title)

		SetTextScale(0.0, internalSize)

		SetTextJustification(self.alignment)
		if (self.maxWidth > 0.0) then
			if (self.alignment == TextAlignment.Left) then
				SetTextWrap(internalPosition.x, internalPosition.x + self.maxWidth)
			elseif (self.alignment == TextAlignment.Center) then
				SetTextWrap(internalPosition.x - self.maxWidth * 0.5, internalPosition.x + self.maxWidth * 0.5)
			elseif (self.alignment == TextAlignment.Right) then
				SetTextWrap(internalPosition.x - self.maxWidth, internalPosition.x)
			end
		end

		SetTextFont(self.font)

		return EndTextCommandGetWidth(true)
	end

	-- get the total height of the Text
	function self:GetHeight()
		return self:GetLineCount() * GetRenderedCharacterHeight(internalSize, self.font)

		-- also include line spacing
		--local lineCount = self:GetLineCount()
		--return lineCount * GetRenderedCharacterHeight(internalSize, self.font) + (lineCount - 1) * 0.006
	end

	-- get the height of a single line of the Text
	function self:GetSingleLineHeight()
		return GetRenderedCharacterHeight(internalSize, self.font)
	end

	-- get the line count of the Text
	function self:GetLineCount()
		BeginTextCommandLineCount("CELL_EMAIL_BCON")

		AddTextComponentSubstringPlayerName(self.title)

		SetTextScale(0.0, internalSize)

		SetTextJustification(self.alignment)
		if (self.maxWidth > 0.0) then
			if (self.alignment == TextAlignment.Left) then
				SetTextWrap(internalPosition.x, internalPosition.x + self.maxWidth)
			elseif (self.alignment == TextAlignment.Center) then
				SetTextWrap(internalPosition.x - self.maxWidth * 0.5, internalPosition.x + self.maxWidth * 0.5)
			elseif (self.alignment == TextAlignment.Right) then
				SetTextWrap(internalPosition.x - self.maxWidth, internalPosition.x)
			end
		end

		SetTextFont(self.font)

		return EndTextCommandLineCount(true)
	end

	-- draw the Text to the screen
	function self:Draw()
		SetTextScale(0.0, internalSize)
		SetTextColour(self.color.r, self.color.g, self.color.b, self.color.a)

		SetTextJustification(self.alignment)

		if (self.maxWidth > 0.0) then
			if (self.alignment == TextAlignment.Left) then
				SetTextWrap(internalPosition.x, internalPosition.x + self.maxWidth)
			elseif (self.alignment == TextAlignment.Center) then
				SetTextWrap(internalPosition.x - self.maxWidth * 0.5, internalPosition.x + self.maxWidth * 0.5)
			elseif (self.alignment == TextAlignment.Right) then
				SetTextWrap(internalPosition.x - self.maxWidth, internalPosition.x)
			end
		end

		SetTextFont(self.font)

		if (self.shadowDistance > 0) then
			SetTextDropshadow(self.shadowDistance, self.shadowColor.r, self.shadowColor.g, self.shadowColor.b, self.shadowColor.a)
		end

		BeginTextCommandDisplayText("CELL_EMAIL_BCON")
		AddTextComponentSubstringPlayerName(self.title)
		EndTextCommandDisplayText(internalPosition.x, internalPosition.y)
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



	-- re-calc position and scale once
	self:Position(_position)
	self:Scale(vector2(1.0, 1.0))

	return self
end

Text = {}
Text.__index = Text
setmetatable(Text, {
	__call = function(cls, ...)
		return NewText(...)
	end
})

Text.__tostring = function(text)
	return string.format("Text(\"%s\")", text.title)
end

Text.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
