Config = {}

Config.isDebug = true

Config.anims = {
    { "Carry box",          "anim@heists@box_carry@",                                       "idle"                  },
    { "Load box",           "anim@heists@load_box",                                         "load_box_1"            },
    { "Carry coffee",       "amb@world_human_aa_coffee@base",                               "base"                  },
    { "Place box",          "anim@mp_fireworks",                                            "place_firework_3_box"  },
    { "Pickup drink",       "anim@amb@nightclub@mini@drinking@drinking_shots@ped_c@normal", "pickup"                },
    { "Pickup briefcase",   "missheist_agency2aig_13",                                      "pickup_briefcase"      },
    { "Pickup object",      "pickup_object",                                                "pickup_low"            },
    { "Pickup box",         "anim@heists@load_box",                                         "lift_box"              },
    { "Load box idle",      "anim@heists@load_box",                                         "idle"                  },
}

Config.weathers = {
    "Clear",
    "Extrasunny",
    "Clouds",
    "Overcast",
    "Rain",
    "Clearing",
    "Thunder",
    "Smog",
    "Foggy",
    "Xmas",
    "Snowlight",
    "Blizzard"
}

Config.times = {
    { "Morning", 8 },
    { "Afternoon", 12 },
    { "Evening", 18 },
    { "Night", 22 },
}

function Log(text)
    if (Config.isDebug) then
        print(text)
    end
end

function LogError(text)
    Log("^1" .. text)
end



-- create a new menu pool
local menuPool = MenuPool()

-- overwrite the menu open function
menuPool.OnOpenMenu = function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
    -- create your menu here!
    CreateMenu(screenPosition, worldPosition, hitEntity)
end

function CreateMenu(screenPosition, worldPosition, hitEntity)
    -- call this when you need to recreate a menu
    menuPool:Reset()

    -- create the main menu
    local contextMenu = menuPool:AddMenu()

    -- change the menus default opacity for all items
    --contextMenu.opacity = 150

    -- change the menus default text color (list of named colors can be found in Drawables/Color.lua)
    --contextMenu.colors.text = Colors.DarkRed

    -- check, if an entity was clicked
    if (hitEntity ~= nil and DoesEntityExist(hitEntity)) then
        if (PlayerPedId() == hitEntity) then
            -- player

            -- create a new submenu for animations
            local animMenu, animMenuItem = menuPool:AddSubmenu(contextMenu, "Animations")

            -- change color of a single menu item
            --animMenuItem.colors.text = Colors.Red

            -- loop through animations from config
            for i = 1, #Config.anims, 1 do
                local text = Config.anims[i][1]
                local animDict = Config.anims[i][2]
                local anim = Config.anims[i][3]

                -- create a new item with its name
                local animItem = animMenu:AddItem(text)
                -- add the OnClick function to the item
                animItem.OnClick = function()
	                local playerPed = PlayerPedId()
    
                    if (not HasAnimDictLoaded(animDict)) then
                        RequestAnimDict(animDict)
                        while (not HasAnimDictLoaded(animDict)) do
                            Citizen.Wait(0)
                        end
                    end
                    TaskPlayAnim(playerPed, animDict, anim, 8.0, 8.0, 5000, 49, 1.0, false, false, false)
                    RemoveAnimDict(animDict)
                end
            end
        elseif (IsEntityAVehicle(hitEntity)) then
            -- vehicle

            local vehicle = hitEntity

            local itemDelete = contextMenu:AddItem("Delete vehicle")
            itemDelete.OnClick = function()
                if (vehicle ~= nil and DoesEntityExist(vehicle)) then
                    SetEntityAsMissionEntity(vehicle)
                    DeleteEntity(vehicle)
                end
            end
            
            if (GetNumberOfVehicleDoors(vehicle) > 0) then
                local doorMenu = menuPool:AddSubmenu(contextMenu, "Open door")
                for i = 1, GetNumberOfVehicleDoors(vehicle), 1 do
                    local doorItem = doorMenu:AddItem("Door " .. i)
                    doorItem.OnClick = function()
                        local door = i - 1
	                    if (GetVehicleDoorAngleRatio(vehicle, door) < 0.1) then
		                    SetVehicleDoorOpen(vehicle, door, false, false)
	                    else
		                    SetVehicleDoorShut(vehicle, door, false)
	                    end
                    end
                end
            end

            if (IsThisModelABoat(GetEntityModel(vehicle))) then
                local anchorItem = contextMenu:AddItem("Anchor")
                anchorItem.OnClick = function()
                    SetBoatAnchor(vehicle, true)
                end
            end
        elseif (IsEntityAPed(hitEntity)) then
            -- ped

            local ped = hitEntity

            local itemDelete = contextMenu:AddItem("Delete ped")
            itemDelete.OnClick = function()
                if (ped ~= nil and DoesEntityExist(ped)) then
                    SetEntityAsMissionEntity(ped)
                    DeleteEntity(ped)
                end
            end
        elseif (IsEntityAnObject(hitEntity)) then
            -- object

            local object = hitEntity

            local itemDelete = contextMenu:AddItem("Delete object")
            itemDelete.OnClick = function()
                if (object ~= nil and DoesEntityExist(object)) then
                    SetEntityAsMissionEntity(object)
                    DeleteEntity(object)
                end
            end
        else
            -- terrain / walls / etc.
            local itemTeleport = contextMenu:AddItem("Teleport to point")
            itemTeleport.OnClick = function()
                local destination = worldPosition
                SetEntityCoords(PlayerPedId(), destination.x, destination.y, destination.z)
            end
            
            -- adding a separator line
            contextMenu:AddSeparator()
            
            -- creating a new submenu
            local testMenu1, testMenu1Item = menuPool:AddSubmenu(contextMenu, "testMenu1")
            -- disabling the button for the submenu
            testMenu1Item.enabled = false
            local testMenu2 = menuPool:AddSubmenu(contextMenu, "testMenu2")

            -- another separator line
            contextMenu:AddSeparator()

            -- several more submenus
            local testMenu3 = menuPool:AddSubmenu(testMenu1, "testMenu3")
            local testMenu4 = menuPool:AddSubmenu(testMenu3, "testMenu4")
            local itemTest1 = testMenu3:AddItem("Test1")
            local itemTest2 = testMenu2:AddItem("Test2")
            local itemTest3 = testMenu4:AddItem("Test3")
            
            -- another separator line
            contextMenu:AddSeparator()

            -- adding a checkbox item
            local itemCheckbox = contextMenu:AddCheckboxItem("Checkbox", true)
            -- changing sprite color
            itemCheckbox.colors.sprite = Colors.Green
            itemCheckbox.colors.disabledSprite = Colors.Red
            -- adding the OnValueChanged function
            itemCheckbox.OnValueChanged = function(value)
                -- disables the button when it is set to false
                if (value == false) then
                    itemCheckbox.enabled = false
                end
            end
        end
    else
        -- nothing clicked

        local weatherMenu = menuPool:AddSubmenu(contextMenu, "Change weather")
        for i = 1, #Config.weathers, 1 do
            local weatherItem = weatherMenu:AddItem(Config.weathers[i])
            weatherItem.OnClick = function()
                SetWeatherTypeOvertimePersist(Config.weathers[i], 5.0)
            end
        end

        local timeMenu = menuPool:AddSubmenu(contextMenu, "Change time")
        for i = 1, #Config.times, 1 do
            local timeItem = timeMenu:AddItem(Config.times[i][1])
            timeItem.OnClick = function()
                NetworkOverrideClockTime(Config.times[i][2], 0, 0)
            end
        end
    end
    
    -- sets the position of the menu on the screen
    contextMenu:SetPosition(screenPosition)
    -- set the visibility of the menu
    contextMenu:Visible(true)
end
