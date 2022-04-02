
local function NewCheckboxItem(menu, title, value)
	local self = setmetatable(Item(menu, title), CheckboxItem)

	-- add all necessary colors
	self.colors = {
		background  = self.parent.colors.background,
		hBackground = self.parent.colors.hBackground,
		text        = self.parent.colors.text,
		hText       = self.parent.colors.hText,
		rightText   = self.parent.colors.text,
		hRightText  = self.parent.colors.hText
	}

	local checked = value

	self:RightSprite("commonmenu", checked and "shop_box_tick" or "shop_box_blank")

	self.OnValueChanged = function(value) end



	function self:Activated()
		if (not self.enabled) then
			return
		end

		checked = not checked

		self:RightSprite("commonmenu", checked and "shop_box_tick" or "shop_box_blank")

		Citizen.CreateThread(function()
			self.OnActivate()

			self.OnValueChanged(checked)
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

CheckboxItem = {}
CheckboxItem.__index = CheckboxItem
setmetatable(CheckboxItem, {
	__call = function(cls, ...)
		return NewCheckboxItem(...)
	end
})

CheckboxItem.__tostring = function(obj)
	return string.format("CheckboxItem()")
end

CheckboxItem.__gc = function(obj)
	if (obj.Destroy) then
		obj:Destroy()
	end
end
