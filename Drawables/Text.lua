Text = {}
Text.__index = Text

setmetatable(Text, {
    __call = function(cls, ...)
        return cls.CreateNew(...)
    end
})

function Text.CreateNew(title, color)
    local self = setmetatable({}, Text)

    self.title = title
    self.color = color or Colors.White
    self.position = vector2(0, 0)
    self.scale = vector2(0.3, 0.3)

    return self
end

function Text:Draw()
    SetTextScale(self.scale.x, self.scale.y)
    SetTextColour(self.color.r, self.color.g, self.color.b, self.color.a)
    BeginTextCommandDisplayText("CELL_EMAIL_BCON")
    AddTextComponentSubstringPlayerName(self.title)
    EndTextCommandDisplayText(self.position.x, self.position.y)
end

function Text:GetWidth()
    BeginTextCommandWidth("CELL_EMAIL_BCON")
    AddTextComponentSubstringPlayerName(self.title)
    SetTextScale(self.scale.x, self.scale.y)
    return EndTextCommandGetWidth(true)
end
