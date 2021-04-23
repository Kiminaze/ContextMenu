CheckboxItem = {}
CheckboxItem.__index = CheckboxItem

setmetatable(CheckboxItem, {
    __index = Item,
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        self:Init(...)
        return self
    end
})

function CheckboxItem:Init(menu, text, value, textColor, disabledTextColor, bgColor, bgHoveredColor, opacity)
    Item.Init(self, menu, text, textColor, disabledTextColor, bgColor, bgHoveredColor, opacity)    
    
    self.checked = value

    self.colors.sprite = self.colors.text
    self.colors.disabledSprite = self.colors.disabledText

    self.OnValueChanged = function(checked) end

    self.closeMenuOnClick = false
    
    if (self.checked) then
        self.sprite = Sprite("commonmenu", "shop_box_tick", nil, vector2(0.02, 0.02 * GetAspectRatio(false)))
    else
        self.sprite = Sprite("commonmenu", "shop_box_blank", nil, vector2(0.02, 0.02 * GetAspectRatio(false)))
    end
end

function CheckboxItem:Process(cursorPosition)
    Item.Process(self, cursorPosition)

    self.sprite:Draw(self.enabled and self.colors.sprite or self.colors.disabledSprite)
end

function CheckboxItem:Clicked()
    if (not self.enabled) then
        return
    end

    self.OnClick()

    self.checked = not self.checked
    
    self.OnValueChanged(self.checked)
    
    if (self.checked) then
        self.sprite.name = "shop_box_tick"
    else
        self.sprite.name = "shop_box_blank"
    end
end

function CheckboxItem:SetPosition(position)
    Item.SetPosition(self, position)
    self.sprite:SetPosition(position + vector2(0.131, -0.0029))
end

function CheckboxItem:InBounds(position)
    return Item.InBounds(self, position)
end
