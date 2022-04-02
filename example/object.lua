
local ECM = exports["ContextMenu"]

ECM:Register(function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
	if (not DoesEntityExist(hitEntity) or not IsEntityAnObject(hitEntity)) then
        return
    end

    local object = hitEntity

    local itemDelete = ECM:AddItem(0, "Delete object")
    ECM:OnActivate(itemDelete, function()
        if (DoesEntityExist(object)) then
            SetEntityAsMissionEntity(object)
            DeleteEntity(object)
        end
    end)
end)
