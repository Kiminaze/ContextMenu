
local disabledControls = {
	1, 2, 16, 17, 24, 25, 68, 69, 70, 91, 92, 330, 331, 347, 257
}

local function NewMenuPool()
	local self = setmetatable({}, MenuPool)

	self.menus = {}

	self.keys = {
		keyboard = {
			holdForCursor   = holdKey or 19,
			interact        = interactKey or 25,
			activateItem    = activateItemKey or 24
		}
	}

	self.settings = {
		screenEdgeScroll = true,
		holdKeyWithMenuOpen = true
	}

	local resolution = vector2(0, 0)



	self.OnInteract     = nil
	self.OnMouseOver    = nil

	self.alternateFunctions = {}



	local function Process()
		if (IsPauseMenuActive()) then
			if (self:IsAnyMenuOpen()) then
				self:CloseAllMenus()
			end

			return
		end

		if (IsControlJustPressed(0, self.keys.keyboard.holdForCursor) or IsDisabledControlJustPressed(0, self.keys.keyboard.holdForCursor)) then
			if (self:IsAnyMenuOpen()) then
				self:CloseAllMenus()
			end

			SetCursorLocation(0.5, 0.5)

			local resX, resY = GetActiveScreenResolution()
			resolution = vector2(resX, resY)
		end

		--not self.settings.holdKeyWithMenuOpen and self:IsAnyMenuOpen()
		if (IsControlPressed(0, self.keys.keyboard.holdForCursor) or IsDisabledControlPressed(0, self.keys.keyboard.holdForCursor)) then
			SetMouseCursorActiveThisFrame()

			local cursorPosition = GetCursorScreenPosition()

			for i, menu in ipairs(self.menus) do
				if (menu:Visible()) then
					menu:Process(cursorPosition)
					menu:Draw()
				end
			end

			for i, control in ipairs(disabledControls) do
				DisableControlAction(0, control, true)
			end

			local screenPosition, hitSomething, worldPosition, normalDirection, hitEntityHandle

			if (self.OnMouseOver) then
				screenPosition = GetCursorScreenPosition()
				hitSomething, worldPosition, normalDirection, hitEntityHandle = ScreenToWorld(screenPosition, 10000.0)

				self.OnMouseOver(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection)
			end

			if (self.OnInteract and IsDisabledControlJustPressed(0, self.keys.keyboard.interact)) then
				if (screenPosition == nil) then
					screenPosition = GetCursorScreenPosition()
					hitSomething, worldPosition, normalDirection, hitEntityHandle = ScreenToWorld(screenPosition, 10000.0)
				end

				Citizen.CreateThread(function()
					self.OnInteract(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection)
				end)
			end

			for i, alt in ipairs(self.alternateFunctions) do
				if (IsControlJustPressed(0, alt.key) or IsDisabledControlJustPressed(0, alt.key)) then
					if (screenPosition == nil) then
						screenPosition = GetCursorScreenPosition()
						hitSomething, worldPosition, normalDirection, hitEntityHandle = ScreenToWorld(screenPosition, 10000.0)
					end

					Citizen.CreateThread(function()
						alt.Func(screenPosition, hitSomething, worldPosition, hitEntityHandle, normalDirection)
					end)
				end
			end

			if (IsDisabledControlJustPressed(0, self.keys.keyboard.activateItem)) then
				local activatedMenu = false

				for i = #self.menus, 1, -1 do
					if (self.menus[i]:Visible() and self.menus[i]:InBounds(cursorPosition)) then
						local item = self.menus[i]:Activated(cursorPosition)

						activatedMenu = true
						break
					end
				end

				if (not activatedMenu) then
					self:CloseAllMenus()
				end
			elseif (IsDisabledControlJustReleased(0, self.keys.keyboard.activateItem)) then
				for i = #self.menus, 1, -1 do
					if (self.menus[i]:Visible() and self.menus[i]:InBounds(cursorPosition)) then
						local item = self.menus[i]:Released(cursorPosition)
						break
					end
				end
			end

			if (IsDisabledControlJustPressed(0, 16)) then
				for i = #self.menus, 1, -1 do
					if (self.menus[i]:Visible() and self.menus[i].Scroll and self.menus[i]:InBounds(cursorPosition)) then
						self.menus[i]:Scroll("down")
						break
					end
				end
			elseif (IsDisabledControlJustPressed(0, 17)) then
				for i = #self.menus, 1, -1 do
					if (self.menus[i]:Visible() and self.menus[i].Scroll and self.menus[i]:InBounds(cursorPosition)) then
						self.menus[i]:Scroll("up")
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

				if (screenPosition.x > (resolution.x - 10.0) / resolution.x) then
					SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() - 60.0 * frameTime)
					SetMouseCursorSprite(7)
				elseif (screenPosition.x < 10.0 / resolution.x) then
					SetGameplayCamRelativeHeading(GetGameplayCamRelativeHeading() + 60.0 * frameTime)
					SetMouseCursorSprite(6)
				end

				-- causes camera problems
				--if (screenPosition.y > (resolution.y - 10.0) / resolution.y) then
				--    SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() - 25.0 * frameTime, 1.0)
				--    SetMouseCursorSprite(9)
				--elseif (screenPosition.y < 10.0 / resolution.y) then
				--    SetGameplayCamRelativePitch(GetGameplayCamRelativePitch() + 25.0 * frameTime, 1.0)
				--    SetMouseCursorSprite(8)
				--end
			end
		elseif (IsControlJustReleased(0, self.keys.keyboard.holdForCursor) or IsDisabledControlJustReleased(0, self.keys.keyboard.holdForCursor)) then
			self:Reset()
		end
	end

	function self:Reset()
		LogDebug("Resetting MenuPool")
		local currMemory = collectgarbage("count")

		for k, menu in pairs(self.menus) do
			if (self.menus[k].Destroy) then
				self.menus[k]:Destroy()
			end
			self.menus[k] = nil
		end
		self.menus = {}

		collectgarbage()

		LogDebug("Done. Deleted " .. (currMemory - collectgarbage("count")) .. " kb of memory.")
	end

	Citizen.CreateThread(function()
		while (true) do
			Citizen.Wait(0)
			Process()
		end
	end)



	return self
end

MenuPool = {}
MenuPool.__index = MenuPool
setmetatable(MenuPool, {
	__call = function(cls, ...)
		return NewMenuPool(...)
	end
})

function MenuPool:IsAnyMenuOpen()
	for i, menu in ipairs(self.menus) do
		if (menu:Visible()) then
			return true
		end
	end

	return false
end

function MenuPool:CloseAllMenus()
	for i, menu in ipairs(self.menus) do
		menu:Visible(false)
	end
end

function MenuPool:AddMenu()
	table.insert(self.menus, Menu(self))

	return self.menus[#self.menus]
end

function MenuPool:AddScrollMenu(maxItems)
	table.insert(self.menus, ScrollMenu(self, maxItems))

	return self.menus[#self.menus]
end

function MenuPool:AddPageMenu(maxItems)
	table.insert(self.menus, PageMenu(self, maxItems))

	return self.menus[#self.menus]
end

function MenuPool:AddAlternateFunction(_key, _Func)
	table.insert(self.alternateFunctions, {
		key = _key,
		Func = _Func
	})
end
