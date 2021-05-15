MenuPool = {}
MenuPool.__index = MenuPool

setmetatable(MenuPool, {
    __call = function(cls, ...)
        return cls.CreateNew(...)
    end
})

function MenuPool.CreateNew(holdKey, clickKey, altFunctionKey, activateItemKey)
    local self = setmetatable({}, MenuPool)

    self.menus = {}

    self.keys = {
        keyboard = {
            holdForCursor   = holdKey or 19,
            openMenu        = clickKey or 25,
            altFunction     = altFunctionKey or 24,
            activateItem    = activateItemKey or 24
        },
        --controller = {
        --    holdForCursor   = holdKey or 19,
        --    openMenu        = openMenuKey or 25,
        --    altClick        = altClickKey or 24,
        --    activateItem    = activateItemKey or 24
        --}
    }

    self.settings = {
        screenEdgeScroll = true
    }

    self.resolution = vector2(0, 0)

    self.OnOpenMenu     = nil
    self.OnAltFunction  = nil
    self.OnMouseOver    = nil
    
    Citizen.CreateThread(function()
        while (true) do
            Citizen.Wait(0)

            self:Process()
        end
    end)

    return self
end

function MenuPool:AddMenu()
    table.insert(self.menus, Menu(self))

    return self.menus[#self.menus]
end

function MenuPool:AddSubmenu(parentMenu, title)
    table.insert(self.menus, Menu(self))

    local item = parentMenu:AddSubmenu(title, self.menus[#self.menus])

    return self.menus[#self.menus], item
end

function MenuPool:Reset()
    self.menus = {}

    collectgarbage()
end

function MenuPool:Process()
    if (IsControlJustPressed(0, self.keys.keyboard.holdForCursor)) then
        SetCursorLocation(0.5, 0.5)

        local resX, resY = GetActiveScreenResolution()
        self.resolution = vector2(resX, resY)
    end

    if (IsControlPressed(0, self.keys.keyboard.holdForCursor)) then
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
        DisableControlAction(0, self.keys.keyboard.activateItem, true)
        DisableControlAction(0, self.keys.keyboard.openMenu, true)
        DisableControlAction(0, 68, true)
        DisableControlAction(0, 69, true)
        DisableControlAction(0, 70, true)
        DisableControlAction(0, 91, true)
        DisableControlAction(0, 92, true)
        DisableControlAction(0, 330, true)
        DisableControlAction(0, 331, true)
        DisableControlAction(0, 347, true)
        DisableControlAction(0, 257, true)
        
        local screenPosition = nil
        local hitSomething, worldPosition, normalDirection, hitEntityHandle = nil

        if (self.OnMouseOver) then
            screenPosition = GetCursorScreenPosition()
            hitSomething, worldPosition, normalDirection, hitEntityHandle = ScreenToWorld(screenPosition, 1000.0)

            self.OnMouseOver(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection)
        end

        if (self.OnOpenMenu and IsDisabledControlJustPressed(0, self.keys.keyboard.openMenu)) then
            if (screenPosition == nil) then
                screenPosition = GetCursorScreenPosition()
                hitSomething, worldPosition, normalDirection, hitEntityHandle = ScreenToWorld(screenPosition, 1000.0)
            end

            Citizen.CreateThread(function()
                self.OnOpenMenu(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection)
            end)
        end
        
        if (self.OnAltFunction and IsDisabledControlJustPressed(0, self.keys.keyboard.altFunction)) then
            if (screenPosition == nil) then
                screenPosition = GetCursorScreenPosition()
                hitSomething, worldPosition, normalDirection, hitEntityHandle = ScreenToWorld(screenPosition, 1000.0)
            end

            Citizen.CreateThread(function()
                self.OnAltFunction(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection)
            end)
        end
        
        if (IsDisabledControlJustPressed(0, self.keys.keyboard.activateItem)) then
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
        elseif (IsDisabledControlJustReleased(0, self.keys.keyboard.activateItem)) then
            for i = #self.menus, 1, -1 do
                if (self.menus[i]:Visible() and self.menus[i]:InBounds(cursorPos)) then
                    local item = self.menus[i]:Released(cursorPos)
                    break
                end
            end
        end

        if (self.settings.screenEdgeScroll) then
            if (screenPosition == nil) then
                screenPosition = GetCursorScreenPosition()
            end

            SetMouseCursorSprite(1)

            local frameTime = GetFrameTime()

            if (screenPosition.x > (self.resolution.x - 10.0) / self.resolution.x) then
                SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() - 25.0 * frameTime)
                SetMouseCursorSprite(7)
            elseif (screenPosition.x < 10.0 / self.resolution.x) then
                SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() + 25.0 * frameTime)
                SetMouseCursorSprite(6)
            end

            if (screenPosition.y > (self.resolution.y - 10.0) / self.resolution.y) then
                SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() - 25.0 * frameTime, 1.0)
                SetMouseCursorSprite(9)
            elseif (screenPosition.y < 10.0 / self.resolution.y) then
                SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + 25.0 * frameTime, 1.0)
                SetMouseCursorSprite(8)
            end
        end
    elseif (IsControlJustReleased(0, self.keys.keyboard.holdForCursor)) then
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

    collectgarbage()
end
