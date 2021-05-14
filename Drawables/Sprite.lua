Sprite = {}
Sprite.__index = Sprite

setmetatable(Sprite, {
    __call = function(cls, ...)
        return cls.CreateNew(...)
    end
})

function Sprite.CreateNew(dict, name, position, size, heading, color)
    local self = setmetatable({}, Sprite)

    self.dict = dict
    self.name = name

    self.position = position or vector2(0, 0)
    self.size = size or vector2(1, 1)
    self.heading = heading or 0.0

    self.color = color or Colors.White

    return self
end

function Sprite:Draw()
	if not HasStreamedTextureDictLoaded(self.dict) then
		RequestStreamedTextureDict(self.dict, true)
	end

    local pos = self.position + self.size * 0.5
    DrawSprite(self.dict, self.name, pos.x, pos.y, self.size.x, self.size.y, self.heading, self.color.r, self.color.g, self.color.b, self.color.a)
end

function Sprite:SetPosition(position)
    self.position = position
end
