Text = {}
Text.__index = Text

setmetatable(Text, {
    __call = function(cls, ...)
        return cls.CreateNew(...)
    end
})

function Text.CreateNew(text)
    local self = setmetatable({}, Text)

    self.text = text
    self.position = vector2(0, 0)
    self.scale = vector2(0.3, 0.3)

    return self
end

function Text:Draw(color)
    SetTextScale(self.scale.x, self.scale.y)
    SetTextColour(color.r, color.g, color.b, color.a)
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
