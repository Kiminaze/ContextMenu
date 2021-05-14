SubmenuItem = {}
SubmenuItem.__index = SubmenuItem

setmetatable(SubmenuItem, {
    __index = Item,
    __call = function(cls, ...)
        local self = setmetatable({}, cls)
        self:Init(...)
        return self
    end
})

function SubmenuItem:Init(menu, text, submenu, textColor, disabledTextColor, bgColor, bgHoveredColor, alpha)
    Item.Init(self, menu, text, textColor, disabledTextColor, bgColor, bgHoveredColor, alpha)    
    
    self.submenu = submenu

    self.colors.sprite = Colors.White
    self.colors.disabledSprite = Colors.LightGrey
    
    self.closeMenuOnClick = false

    self.rightSprite = Sprite("commonmenu", "arrowright", nil, vector2(0.015, 0.015 * GetAspectRatio(false)))
end

function SubmenuItem:Process(cursorPosition)
    Item.Process(self, cursorPosition)
end

function SubmenuItem:Clicked()
    if (not self.enabled) then
        return
    end
    
    Citizen.CreateThread(function()
        self.OnClick()
    end)
    
    OpenSubmenu(self)
end

function SubmenuItem:OnStartedHovering()
    Citizen.CreateThread(function()
        self.OnStartHover()
    end)
    
    Coroutine_StartedHoveringForSubmenu(self)
end

function SubmenuItem:OnStoppedHovering()
    Citizen.CreateThread(function()
        self.OnStopHover()
    end)
    
    Coroutine_StoppedHoveringForSubmenu(self)
end

function SubmenuItem:CloseSubmenu()
    CloseSubmenu(self)
end



function OpenSubmenu(item)
    for i = 1, #item.parent.items, 1 do
        if (item.parent.items[i] ~= item and item.parent.items[i].submenu and item.parent.items[i].submenu:Visible()) then
            item.parent.items[i]:CloseSubmenu()
        end
    end

    item.submenu:SetPosition(item.position + vector2(item.parent.width, 0.0))
    item.submenu:Visible(true)
end
function CloseSubmenu(item)
    for i = 1, #item.submenu.items, 1 do
        if (item.submenu.items[i].submenu and item.submenu.items[i].submenu:Visible()) then
            item.submenu.items[i]:CloseSubmenu()
        end
    end

    item.submenu:Visible(false)
end

function Coroutine_StartedHoveringForSubmenu(item)
    Citizen.CreateThread(function()
        local startTime = GetGameTimer()
        while (true) do
            if (not item.hovered or item.submenu:Visible() or not item.parent:Visible()) then
                return
            end

            if (GetGameTimer() - item.parent.hoverTimeout >= startTime) then
                OpenSubmenu(item)

                return
            end
            
            Citizen.Wait(0)
        end
    end)
end
function Coroutine_StoppedHoveringForSubmenu(item)
    Citizen.CreateThread(function()
        local startTime = GetGameTimer()
        while (true) do
            if (item.hovered or not item.submenu:Visible() or item.submenu:InBounds(GetCursorScreenPosition())) then
                return
            end

            if (GetGameTimer() - item.parent.hoverTimeout >= startTime) then
                CloseSubmenu(item)
                
                return
            end
            
            Citizen.Wait(0)
        end
    end)
end
