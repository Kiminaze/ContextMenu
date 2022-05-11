
local HOVER_TIMEOUT = 250

local function MenuOverlapped(menu)
	for i, item in ipairs(menu.objectList) do
		if (item.submenu and item.submenu:Visible()) then
			for j, item2 in ipairs(item.submenu.objectList) do
				if (item2.submenu and item2.submenu:Visible()) then
					for k, item3 in ipairs(item2.submenu.objectList) do
						if (item3.hovered) then
							return true
						end
					end
				end
			end
		end
	end

	return false
end

local function NewSubmenuItem(menu, title, submenu)
	-- create the SubmenuItem
	local self = setmetatable(Item(menu, title), SubmenuItem)

	-- add all necessary colors
	self.colors = {
		background  = self.parent and self.parent.colors.background or Colors.DarkGrey:Alpha(180),
		hBackground = self.parent and self.parent.colors.hBackground or Colors.LightGrey:Alpha(180),
		dBackground = self.parent and self.parent.colors.dBackground or Colors.DarkGrey:Alpha(180),
		text        = self.parent and self.parent.colors.text or Colors.White,
		hText       = self.parent and self.parent.colors.hText or Colors.White,
		dText       = self.parent and self.parent.colors.dText or Colors.Grey,
		rightText   = self.parent and self.parent.colors.text or Colors.White,
		hRightText  = self.parent and self.parent.colors.hText or Colors.White,
		dRightText  = self.parent and self.parent.colors.dText or Colors.Grey
	}

	self.submenu = submenu
	submenu:Visible(false)

	self.rightText = nil

	self:RightSprite("commonmenu", "arrowright")

	self.closeOnActivate = false

	self.hovered = nil



	self.OnActivate     = function() end
	self.OnRelease      = function() end
	self.OnStartHover   = function() end
	self.OnEndHover     = function() end



	local function Coroutine_StartedHoveringForSubmenu()
		Citizen.CreateThread(function()
			local startTime = GetGameTimer()
			while (true) do
				if (not self.hovered or (self.submenu and self.submenu:Visible()) or (self.parent and not self.parent:Visible())) then
					return
				end

				if (GetGameTimer() - HOVER_TIMEOUT >= startTime) then
					if (self.OpenSubmenu) then
						self:OpenSubmenu()
					end

					return
				end

				Citizen.Wait(0)
			end
		end)
	end
	local function Coroutine_StoppedHoveringForSubmenu()
		Citizen.CreateThread(function()
			local startTime = GetGameTimer()
			while (true) do
				if (self.hovered or (self.submenu and not self.submenu:Visible()) or (self.submenu and self.submenu:InBounds(GetCursorScreenPosition()))) then
					return
				end

				if (GetGameTimer() - HOVER_TIMEOUT >= startTime) then
					if (self.CloseSubmenu) then
						self:CloseSubmenu()
					end

					return
				end

				Citizen.Wait(0)
			end
		end)
	end

	-- process the SubmenuItem
	function self:Process(cursorPosition)
		if (not self.enabled) then
			return
		end

		local hovered = self:InBounds(cursorPosition)
		if (hovered ~= self.hovered) then
			self.hovered = hovered

			self.text.color = self.hovered and self.colors.hText or self.colors.text
			self.background.color = self.hovered and self.colors.hBackground or self.colors.background

			if (not MenuOverlapped(self.parent)) then
				if (self.hovered) then
					Citizen.CreateThread(function()
						Coroutine_StartedHoveringForSubmenu(self)

						self.OnStartHover()
					end)
				else
					Citizen.CreateThread(function()
						Coroutine_StoppedHoveringForSubmenu(self)

						self.OnEndHover()
					end)
				end
			end
		end
	end

	function self:OpenSubmenu()
		for i = 1, #self.parent.objectList, 1 do
			if (self.parent.objectList[i] ~= self and self.parent.objectList[i].submenu and self.parent.objectList[i].submenu:Visible()) then
				self.parent.objectList[i]:CloseSubmenu()
			end
		end

		self.submenu:Position(self.position + vector2(self.parent.width, 0.0))
		self.submenu:Visible(true)
	end
	function self:CloseSubmenu()
		for i = 1, #self.submenu.objectList, 1 do
			if (self.submenu.objectList[i].submenu and self.submenu.objectList[i].submenu:Visible()) then
				self.submenu.objectList[i]:CloseSubmenu()
			end
		end

		self.submenu:Visible(false)
	end

	function self:Activated()
		if (not enabled) then
			return
		end

		Citizen.CreateThread(function()
			self:OpenSubmenu()
		end)

		Citizen.CreateThread(function()
			self.OnActivate()
		end)
	end

	function self:Destroy()
		LogDebug("Destroyed " .. tostring(self))

		self.parent = nil

		for k, v in pairs(self.children) do
			if (self.children[k].Destroy) then
				self.children[k]:Destroy()
			end

			self.children[k] = nil
		end

		for k, v in pairs(self.objectList) do
			if (self.objectList[k].Destroy) then
				self.objectList[k]:Destroy()
			end

			self.objectList[k] = nil
		end

		for k, v in pairs(self) do
			self[k] = nil
		end
	end



	return self
end

SubmenuItem = {}
SubmenuItem.__index = SubmenuItem
setmetatable(SubmenuItem, {
	__call = function(cls, ...)
		return NewSubmenuItem(...)
	end
})

SubmenuItem.__tostring = function(obj)
	return string.format("SubmenuItem()")
end

SubmenuItem.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
