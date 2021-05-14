TextItem = {}
TextItem.__index = TextItem

setmetatable(TextItem, {
    __index = Item,
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        self:Init(...)
        return self
    end
})

function TextItem:Init(menu, text, textColor, bgColor, alpha)
    Item.Init(self, menu, text, nil, textColor, nil, bgColor, alpha)  
    
    self.enabled = false
end
