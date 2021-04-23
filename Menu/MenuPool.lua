MenuPool = {}
MenuPool.__index = MenuPool

setmetatable(MenuPool, {
    __call = function(cls, ...)
        return cls.CreateNew(...)
    end
})

function MenuPool.CreateNew(holdKey, openMenuKey, activateItemKey)
    local self = setmetatable({}, MenuPool)

    self.menus = {}

    self.keys = {
        hold = holdKey or 19,
        openMenu = openMenuKey or 25,
        activateItem = activateItemKey or 24
    }

    return self
end

function MenuPool:AddMenu()
    table.insert(self.menus, Menu(self))

    return self.menus[#self.menus]
end

function MenuPool:AddSubmenu(parentMenu, text)
    table.insert(self.menus, Menu(self))

    local item = parentMenu:AddSubmenu(text, self.menus[#self.menus])

    return self.menus[#self.menus], item
end

function MenuPool:Reset()
    self.menus = {}

    collectgarbage()
end

function MenuPool:Process(ClickFunction)
    if (IsControlPressed(0, self.keys.hold)) then
        SetMouseCursorActiveThisFrame()
        
        local cursorPos = GetCursorScreenPosition()
    
        local drawing = false
        for i = 1, #self.menus, 1 do
            if (self.menus[i]:Visible()) then
                self.menus[i]:Process(cursorPos)
                drawing = true
            end
        end

        DisableControlAction(0, 1, true)
        DisableControlAction(0, 2, true)
        DisableControlAction(0, self.keys.activateItem, true)
        DisableControlAction(0, self.keys.openMenu, true)
        DisableControlAction(0, 68, true)
        DisableControlAction(0, 69, true)
        DisableControlAction(0, 70, true)
        DisableControlAction(0, 91, true)
        DisableControlAction(0, 92, true)
        DisableControlAction(0, 330, true)
        DisableControlAction(0, 331, true)
        DisableControlAction(0, 347, true)
        DisableControlAction(0, 257, true)

        if (IsDisabledControlJustPressed(0, self.keys.openMenu)) then
            local screenPosition = GetCursorScreenPosition()
            local hitSomething, worldPos, normalDirection, hitEntity = ScreenToWorld(screenPosition, 1000.0)

            Citizen.CreateThread(function()
                ClickFunction(screenPosition, hitSomething, worldPos, hitEntity, normalDirection)
            end)
        end
        
        if (IsDisabledControlJustPressed(0, self.keys.activateItem)) then
            local clickedMenu = false

            for i = #self.menus, 1, -1 do
                if (self.menus[i]:Visible() and self.menus[i]:InBounds(cursorPos)) then
                    local item = self.menus[i]:Clicked(cursorPos)

                    clickedMenu = true
                    break
                end
            end

            if (not clickedMenu) then
                self:CloseAllMenus()
            end
        elseif (IsDisabledControlJustReleased(0, self.keys.activateItem)) then
            for i = #self.menus, 1, -1 do
                if (self.menus[i]:Visible() and self.menus[i]:InBounds(cursorPos)) then
                    local item = self.menus[i]:Released(cursorPos)
                    break
                end
            end
        end
    elseif (IsControlJustReleased(0, 19)) then
        self:CloseAllMenus()
    end
end

function MenuPool:IsAnyMenuOpen()
    for i = 1, #self.menus, 1 do
        if (self.menus[i]:Visible()) then
            return true
        end
    end

    return false
end

function MenuPool:CloseAllMenus()
    for i = 1, #self.menus, 1 do
        self.menus[i]:Visible(false)
    end
end
