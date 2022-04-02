
local on = false

Citizen.CreateThread(function()
	while (true) do
		Citizen.Wait(0)

		if (IsControlJustPressed(0, 51)) then
			collectgarbage()
		end

		if (IsControlJustPressed(0, 27)) then
			on = not on

			if (on) then
				TestMe()
			end
		end
	end
end)



function TestMe()
	Citizen.CreateThread(function()
		local speedText = Text()
		local background = Rect(nil, nil, Colors.Black:Alpha(180))

		local container = Container()
		container:Add(speedText)
		container:Add(background)

		while (true) do
			Citizen.Wait(0)

			local playerPed = PlayerPedId()

			if (IsPedInAnyVehicle(playerPed)) then
				local vehicle = GetVehiclePedIsIn(playerPed)
				local speed = math.floor(GetEntitySpeedVector(vehicle, true).y * 36.0) / 10.0

				speedText.title = tostring(speed) .. "km/h"

				background:Size(vector2(speedText:GetWidth(), speedText:GetHeight() + 0.008))

				local pos = GetEntityCoords(vehicle)
				local _, x, y = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
				container:Position(vector2(x, y))
				container:Draw()

				if (IsControlJustPressed(0, 27)) then
					container:Destroy()
					break
				end
			else
				Citizen.Wait(1000)
			end
		end
	end)
end
