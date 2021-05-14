Text = {}
Text.__index = Text

setmetatable(Text, {
    __call = function(cls, ...)
        return cls.CreateNew(...)
    end
})

function Text.CreateNew(text, color)
    local self = setmetatable({}, Text)

    self.text = text
    self.position = vector2(0, 0)
    self.scale = vector2(0.3, 0.3)
    self.color = color or Colors.White

    return self
end

function Text:Draw()
    SetTextScale(self.scale.x, self.scale.y)
    SetTextColour(self.color.r, self.color.g, self.color.b, self.color.a)
    BeginTextCommandDisplayText("CELL_EMAIL_BCON")
    AddTextComponentSubstringPlayerName(self.text)
    EndTextCommandDisplayText(self.position.x, self.position.y)
end

function Text:GetWidth()
	BeginTextCommandWidth("CELL_EMAIL_BCON")
	AddTextComponentSubstringPlayerName(self.text)
    SetTextScale(self.scale.x, self.scale.y)
	return EndTextCommandGetWidth(true)
end
