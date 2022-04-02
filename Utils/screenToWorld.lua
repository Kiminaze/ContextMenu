--[[
	screenToWorld.lua by Discord User Kiminaze#9097

	The function ScreenToWorld(screenPosition, maxDistance) can be used to get world 
	coordinates from a screen position. You can e.g. access any entity that you can 
	currently see on your screen and interact with it.

	You are free to use this code snippet for any of your projects. But please either 
	keep this text with the function in your project or mention me in the credits if 
	you release something using this!

	It takes a screen position
		Top left corner: vector2(0.0, 0.0)
		Bottom right corner: vector2(1.0, 1.0)
		Accessing cursor position: vector2(GetControlNormal(0, 239), GetControlNormal(0, 240))
	and a maximum distance in meters

	Returns:
		hit             - bool (true if hit something, false if not)
		worldPosition   - vector3 (coordinates in worldspace) (zero vector if nothing was hit)
		normalDirection - vector3 (direction of the surface normal in worldspace) (zero vector if nothing was hit)
		entity          - entityHandle (nil if no entity was hit)

	Example:
		-- Hold alt to show mouse cursor, then rightclick something to get the point
		Citizen.CreateThread(function()
			while (true) do
				Citizen.Wait(0)

				if (IsControlPressed(0, 19)) then -- left alt
					SetMouseCursorActiveThisFrame()
					DisableControlAction(0, 24, true) -- left click
					DisableControlAction(0, 25, true) -- right click
					DisableControlAction(0, 1, true) -- mouse moving left right
					DisableControlAction(0, 2, true) -- mouse moving up down

					if (IsDisabledControlJustPressed(0, 25)) then -- right mouse
						local screenPosition = GetCursorScreenPosition()
						local hitSomething, worldPos, normalDir, hitEntity = ScreenToWorld(screenPosition, 1000.0)

						DoSomething(hitSomething, worldPos, normalDir, hitEntity)
					end
				elseif (IsControlJustReleased(0, 19)) then
					DoSomethingElse()
				end
			end
		end)
--]]

function GetCursorScreenPosition()
	if (not IsControlEnabled(0, 239)) then
		EnableControlAction(0, 239, true)
	end
	if (not IsControlEnabled(0, 240)) then
		EnableControlAction(0, 240, true)
	end

	return vector2(GetControlNormal(0, 239), GetControlNormal(0, 240))
end

function ScreenToWorld(screenPosition, maxDistance)
	local pos = GetGameplayCamCoord()
	local rot = GetGameplayCamRot(0)
	local fov = GetGameplayCamFov()
	local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, fov, 0, 2)
	local camRight, camForward, camUp, camPos = GetCamMatrix(cam)
	DestroyCam(cam, true)

	screenPosition = vector2(screenPosition.x - 0.5, screenPosition.y - 0.5) * 2.0

	local fovRadians = DegreesToRadians(fov)
	local to = camPos + camForward + (camRight * screenPosition.x * fovRadians * GetAspectRatio(false) * 0.534375) - (camUp * screenPosition.y * fovRadians * 0.534375)

	local direction = (to - camPos) * maxDistance
	local endPoint = camPos + direction

	local rayHandle = StartShapeTestRay(camPos.x, camPos.y, camPos.z, endPoint.x, endPoint.y, endPoint.z, -1, nil, 0)
	local _, hit, worldPosition, normalDirection, entity = GetShapeTestResult(rayHandle)

	if (hit == 1) then
		return true, worldPosition, normalDirection, entity
	else
		return false, vector3(0, 0, 0), vector3(0, 0, 0), nil
	end
end

function DegreesToRadians(degrees)
	return (degrees * 3.14) / 180.0
end
