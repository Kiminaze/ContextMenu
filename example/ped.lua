
local ECM = exports["ContextMenu"]

ECM:Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
	if (not DoesEntityExist(hitEntity) or not IsEntityAPed(hitEntity)) then
        return
    end

    local ped = hitEntity

    local itemDelete = ECM:AddItem(0, "Delete ped")
    ECM:OnActivate(itemDelete, function()
        if (DoesEntityExist(ped)) then
            SetEntityAsMissionEntity(ped)
            DeleteEntity(ped)
        end
    end)
end)
