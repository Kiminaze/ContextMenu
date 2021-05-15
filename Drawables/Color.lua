Color = {}
Color.__index = Color

setmetatable(Color, {
    __call = function(cls, ...)
        return cls.CreateNew(...)
    end
})

function Color.CreateNew(r, g, b, a)
    local self = setmetatable({}, Color)

    self.r = r and math.floor(r) or 0
    self.g = g and math.floor(g) or 0
    self.b = b and math.floor(b) or 0
    self.a = a and math.floor(a) or 255

    return self
end

function Color:Alpha(alpha)
    return Color(self.r, self.g, self.b, alpha)
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

    -- missing color
    MISSING_COLOR   = Color(255, 0, 255)
}, {
    __index = function(table, key)
        return table.MISSING_COLOR
    end
})
