
-- short cut
local ECM = exports["ContextMenu"]

-- this function gets called when clicking on anything
ECM:Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
	if (not DoesEntityExist(hitEntity) or not IsEntityAVehicle(hitEntity)) then
		return
	end

	local vehicle = hitEntity

	local itemDelete = ECM:AddItem(0, "Delete vehicle")
	ECM:OnActivate(itemDelete, function()
		if (DoesEntityExist(vehicle)) then
			SetEntityAsMissionEntity(vehicle)
			DeleteEntity(vehicle)
		end
	end)

    if (GetNumberOfVehicleDoors(vehicle) > 0) then
        local submenuDoor, submenuDoorItem = ECM:AddSubmenu(0, "Open door")
        for i = 1, GetNumberOfVehicleDoors(vehicle), 1 do
            local itemDoor = ECM:AddItem(submenuDoor, "Door " .. i)
            ECM:OnActivate(itemDoor, function()
                local door = i - 1
	            if (GetVehicleDoorAngleRatio(vehicle, door) < 0.1) then
		            SetVehicleDoorOpen(vehicle, door, false, false)
	            else
		            SetVehicleDoorShut(vehicle, door, false)
	            end
            end)
        end
    end
end)
