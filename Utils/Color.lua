
local function Clamp(value, min, max)
	return math.max(0, math.min(max, value))
end

local function NewColor(_r, _g, _b, _a)
	assert(
		(not _r or type(_r) == "number") and 
		(not _g or type(_g) == "number") and 
		(not _b or type(_b) == "number") and 
		(not _a or type(_a) == "number"), 
		"Attempted to create Color with incorrect values. Expected number(s)."
	)

	local self = setmetatable({}, Color)

	if (not _r) then
		self = Colors.MISSING_COLOR
	else
		self.r = _r and math.floor(Clamp(_r, 0, 255)) or 0
		self.g = _g and math.floor(Clamp(_g, 0, 255)) or 0
		self.b = _b and math.floor(Clamp(_b, 0, 255)) or 0
		self.a = _a and math.floor(Clamp(_a, 0, 255)) or 255
	end

	-- returns the same color with a different alpha value
	function self:Alpha(alpha)
		return Color(self.r, self.g, self.b, alpha)
	end

	return self
end

Color = {}
Color.__index = Color
setmetatable(Color, {
	__call = function(cls, ...)
		return NewColor(...)
	end
})

Color.__tostring = function(color)
	return string.format("Color(%i, %i, %i, %i)", color.r, color.g, color.b, color.a)
end



Colors = setmetatable({
	White           = Color(255, 255, 255),
	Black           = Color(0, 0, 0),

	Grey            = Color(60, 64, 67),
	LightGrey       = Color(75, 76, 79),
	DarkGrey        = Color(41, 42, 45),
	Gray            = Color(60, 64, 67),
	LightGray       = Color(75, 76, 79),
	DarkGray        = Color(41, 42, 45),

	-- RGB
	Red             = Color(255, 0, 0),
	Green           = Color(0, 255, 0),
	Blue            = Color(0, 0, 255),
	LightRed        = Color(255, 127, 127),
	LightGreen      = Color(127, 255, 127),
	LightBlue       = Color(127, 127, 255),
	DarkRed         = Color(127, 0, 0),
	DarkGreen       = Color(0, 127, 0),
	DarkBlue        = Color(0, 0, 127),

	-- CMY
	Cyan            = Color(0, 255, 255),
	Magenta         = Color(255, 0, 255),
	Yellow          = Color(255, 255, 0),
	LightCyan       = Color(127, 255, 255),
	LightMagenta    = Color(255, 127, 255),
	LightYellow     = Color(255, 255, 127),
	DarkCyan        = Color(0, 127, 127),
	DarkMagenta     = Color(127, 0, 127),
	DarkYellow      = Color(127, 127, 0),

	-- seethrough / invisible
	Invisible		= Color(0, 0, 0, 0),
	SeeThrough		= Color(0, 0, 0, 0),

	-- missing color
	MISSING_COLOR   = Color(255, 0, 255)
}, {
	__index = function(table, key)
		return table.MISSING_COLOR
	end
})
