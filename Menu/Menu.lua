Menu = {}
Menu.__index = Menu

setmetatable(Menu, {
    __call = function(cls, ...)
        return cls.CreateNew(...)
    end
})

function Menu.CreateNew(pool)
    local self = setmetatable({}, Menu)

    self.pool = pool

    self.visible = false

    self.parent = nil

    self.position = vector2(0, 0)
    self.lowerRight = vector2(0, 0)

    self.width = 0.15
    self.hoverTimeout = 250

    self.colors = {
        background = Colors.DarkGrey,
        backgroundHovered = Colors.LightGrey,
        text = Colors.White,
        textDisabled = Colors.Grey
    }
    self.alpha = 255

    self.border = Border(nil, nil, 0.001)

    self.items = {}

    self.separators = {}

    self.OnClosed = function() end

    return self
end

function Menu:AddItem(text)
    table.insert(self.items, Item(self, text, self.colors.text, self.colors.textDisabled, self.colors.background, self.colors.backgroundHovered, self.alpha))

    self:RecalculatePosition(self.position)

    return self.items[#self.items]
end

function Menu:AddTextItem(text)
    table.insert(self.items, TextItem(self, text, self.colors.text, self.colors.background, self.alpha))

    self:RecalculatePosition(self.position)

    return self.items[#self.items]
end

function Menu:AddCheckboxItem(text, value)
    table.insert(self.items, CheckboxItem(self, text, value, self.colors.text, self.colors.textDisabled, self.colors.background, self.colors.backgroundHovered, self.alpha))

    self:RecalculatePosition(self.position)

    return self.items[#self.items]
end

function Menu:AddSubmenu(text, submenu)
    table.insert(self.items, SubmenuItem(self, text, submenu, self.colors.text, self.colors.textDisabled, self.colors.background, self.colors.backgroundHovered, self.alpha))

    self.items[#self.items].submenu.parent = self

    self.items[#self.items].submenu.colors = self.colors
    self.items[#self.items].submenu.alpha = self.alpha

    self:RecalculatePosition(self.position)

    return self.items[#self.items]
end

function Menu:AddSeparator()
    table.insert(self.separators, Separator(self, #self.items, self.colors.border, self.colors.background, self.alpha))

    self:RecalculatePosition(self.position)
end

function Menu:Clicked(cursorPosition)
    for i = 1, #self.items, 1 do
        if (self.items[i]:InBounds(cursorPosition)) then
            self.items[i]:Clicked()

            return self.items[i]
        end
    end
end

function Menu:Released(cursorPosition)
    for i = 1, #self.items, 1 do
        if (self.items[i]:InBounds(cursorPosition)) then
            self.items[i]:Released()

            return self.items[i]
        end
    end
end

function Menu:Process(cursorPosition)
    for i = 1, #self.items, 1 do
        self.items[i]:Process(cursorPosition)

        for j = 1, #self.separators, 1 do
            if (self.separators[j].index == i) then
                self.separators[j]:Process()
                break
            end
        end
    end

    self.border:Draw()
end

function Menu:SetPosition(position)
    self:RecalculatePosition(position)
end

function Menu:Visible(visible)
    if (visible == nil) then
        return self.visible
    end

    if (visible == false) then
        Citizen.CreateThread(function()
            self.OnClosed()
        end)
    end

    self.visible = visible
end

function Menu:InBounds(position)
    return position.x >= self.position.x and position.x < self.lowerRight.x and position.y >= self.position.y and position.y < self.lowerRight.y
end

function Menu:IsOverlapped()
    for k, item in pairs(self.items) do
        if (item.submenu and item.submenu:Visible()) then
            for j, subItem in pairs(item.submenu.items) do
                if (subItem.submenu and subItem.submenu:Visible()) then
                    for i, sub2Item in pairs(subItem.submenu.items) do
                        if (self:InBounds(sub2Item.position + vector2(sub2Item.parent.width, sub2Item.height) * 0.5)) then
                            return true
                        end
                    end
                end
            end
        end
    end

    return false
end

function Menu:RecalculatePosition(position)
    local totalHeight = 0.012 * #self.separators
    for k, item in pairs(self.items) do
        totalHeight = totalHeight + item.height
    end

    self.position = position
    self.lowerRight = self.position + vector2(self.width, totalHeight)
    if (self.lowerRight.x > 1.0) then
        self.position = self.position - vector2(self.lowerRight.x - 1.0, 0.0)
        self.lowerRight = vector2(1.0, self.lowerRight.y)
        
        if (self.parent ~= nil) then
            self.position = vector2(self.position.x - (1.0 - self.parent.position.x), self.position.y)
            self.lowerRight = vector2(self.lowerRight.x - (1.0 - self.parent.position.x), self.lowerRight.y)
        end
    end
    if (self.lowerRight.y > 1.0) then
        self.position = self.position - vector2(0.0, self.lowerRight.y - 1.0)
        self.lowerRight = vector2(self.lowerRight.x, 1.0)
    end

    self.border:SetPositionAndSize(self.position, self.lowerRight - self.position)

    local currPos = self.position
    for i = 1, #self.items, 1 do
        self.items[i]:SetPosition(currPos)
        currPos = currPos + vector2(0.0, self.items[i].height)
        
        for j = 1, #self.separators, 1 do
            if (self.separators[j].index == i) then
                self.separators[j]:SetPosition(currPos)
                currPos = vector2(currPos.x, currPos.y + 0.012)
                break
            end
        end
    end
end
