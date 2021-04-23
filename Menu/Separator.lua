Separator = {}
Separator.__index = Separator

setmetatable(Separator, {
    __call = function(cls, ...)
        return cls.CreateNew(...)
    end
})

function Separator.CreateNew(menu, index, lineColor, bgColor, opacity)
    local self = setmetatable({}, Separator)

    self.parent = menu
    self.index = index
    
    self.position = vector2(0, 0)

    self.background = Rect(vector2(0, 0), vector2(self.parent.width, 0.012))
    self.line = Rect(vector2(0, 0), vector2(self.parent.width - 0.004, 0.001 * GetAspectRatio(false)))
    self.opacity = opacity

    self.colors = {
        line = lineColor or Colors.Grey,
        background = bgColor or Colors.DarkGrey
    }

    return self
end

function Separator:Process()
    self.background:Draw(Color(self.colors.background.r, self.colors.background.g, self.colors.background.b, self.opacity))
    self.line:Draw(self.colors.line)
end

function Separator:SetPosition(position)
    self.position = position
    self.background.position = self.position
    self.line.position = self.position + vector2(0.0025, 0.0045)
end
