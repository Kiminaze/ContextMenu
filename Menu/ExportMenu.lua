
-- table for default menu open functions
local funcTable = {}

-- table for alternate functions
local altFuncTable = {}

local exportMenuPool
local exportMenu

local itemList = {}
local submenuList = {}



local function GetMenu(menuId)
	if (menuId == nil or menuId == 0) then
		return exportMenu
	end

	assert(menuId <= #submenuList, "Parameter \"menuId\" must be a valid menu id!")

	return submenuList[menuId]
end

local function AddItemToList(item)
	table.insert(itemList, item)
	return #itemList
end

local function AddSubmenuToList(submenu)
	table.insert(submenuList, submenu)
	return #submenuList
end

function InitExportMenu()
	exportMenuPool = MenuPool()

	exportMenuPool.OnInteract = function(screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
		-- reset menu
		exportMenuPool:Reset()

		-- empty out item and submenu list
		for k, v in pairs(itemList) do
			itemList[k] = nil
		end
		itemList = {}
		for k, v in pairs(submenuList) do
			submenuList[k] = nil
		end
		submenuList = {}

		-- add first layer menu
		exportMenu = exportMenuPool:AddMenu()

		-- execute registered functions and remove/ignore the ones causing errors
		local toDelete = {}
		for i, func in ipairs(funcTable) do
			local result, error = pcall(func, screenPosition, hitSomething, worldPosition, hitEntity, normalDirection)
			if (not result) then
				table.insert(toDelete, i)
				if (error) then
					LogError("The following error occured and the registered function was removed: \n" .. tostring(error))
				end
			end
		end
		for i = 1, #toDelete do
			table.remove(funcTable, toDelete[i])
		end

		-- display menu
		exportMenu:Position(screenPosition)
		exportMenu:Visible(true)
	end
end



local function Register(index, func)
	if (type(index) == "number" and func ~= nil) then
		table.insert(funcTable, index, func)
	else
		table.insert(funcTable, index)
	end

	if (exportMenuPool == nil) then
		InitExportMenu()
	end

	return #funcTable
end

Register(function() end)

local function RegisterAltFunction(key, func)
	if (exportMenuPool == nil) then
		exportMenuPool = MenuPool()
	end

	exportMenuPool:AddAlternateFunction(key, func)
end



local function AddSeparator(menuId)
	local item = GetMenu(menuId):AddSeparator()

	return AddItemToList(item)
end

local function AddTextItem(menuId, title)
	local item = GetMenu(menuId):AddTextItem(title)

	return AddItemToList(item)
end

local function AddItem(menuId, title, func)
	local item = GetMenu(menuId):AddItem(title)
	if (func) then
		item.OnActivate = func
	end

	return AddItemToList(item)
end

local function AddItems(itemList)
	local itemIds = {}

	for i, item in ipairs(itemList) do
		local id = AddItem(item[1], item[2], item[3])

		table.insert(itemIds, id)
	end

	Citizen.Wait(0)

	return itemIds
end

local function AddSpriteItem(menuId, textureDict, textureName)
	local item = GetMenu(menuId):AddSpriteItem(textureDict, textureName)

	return AddItemToList(item)
end

local function AddCheckboxItem(menuId, title, checked)
	local item = GetMenu(menuId):AddCheckboxItem(title, checked)

	return AddItemToList(item)
end

local function AddSubmenu(parentMenuId, title)
	local submenu, item = GetMenu(parentMenuId):AddSubmenu(title)

	return AddSubmenuToList(submenu), AddItemToList(item)
end

local function AddScrollSubmenu(parentMenuId, title, maxItems)
	local scrollSubmenu, item = GetMenu(parentMenuId):AddScrollSubmenu(title, maxItems)

	return AddSubmenuToList(scrollSubmenu), AddItemToList(item)
end

local function AddPageSubmenu(parentMenuId, title, maxItems)
	local pageSubmenu, item = GetMenu(parentMenuId):AddPageSubmenu(title, maxItems)

	return AddSubmenuToList(pageSubmenu), AddItemToList(item)
end



local function OnActivate(itemId, func)
	assert(itemId ~= nil and itemId >= 0 and itemId <= #itemList, "Parameter \"itemId\" must be a valid item id!")
	assert(func ~= nil, "Parameter \"func\" must be a valid function!")

	itemList[itemId].OnActivate = func
end

local function OnRelease(itemId, func)
	assert(itemId ~= nil and itemId >= 0 and itemId <= #itemList, "Parameter \"itemId\" must be a valid item id!")
	assert(func ~= nil, "Parameter \"func\" must be a valid function!")

	itemList[itemId].OnRelease = func
end

local function OnValueChanged(itemId, func)
	assert(itemId ~= nil and itemId >= 0 and itemId <= #itemList, "Parameter \"itemId\" must be a valid item id!")
	assert(func ~= nil, "Parameter \"func\" must be a valid function!")

	itemList[itemId].OnValueChanged = func
end

local function Enabled(itemId, enabled)
	assert(itemId ~= nil and itemId >= 0 and itemId <= #itemList, "Parameter \"itemId\" must be a valid item id!")

	return itemList[itemId]:Enabled(enabled)
end

local function CloseOnActivate(itemId, closeOnActivate)
	assert(itemId ~= nil and itemId >= 0 and itemId <= #itemList, "Parameter \"itemId\" must be a valid item id!")

	itemList[itemId].closeOnActivate = closeOnActivate
end

local function RightText(itemId, text)
	assert(itemId ~= nil and itemId >= 0 and itemId <= #itemList, "Parameter \"itemId\" must be a valid item id!")

	if (text) then
		itemList[itemId]:RightText(text)
	else
		return itemList[itemId].rightText and itemList[itemId].rightText.title
	end
end

local function LoadAsync(menuId, func)
	local menu = GetMenu(menuId)
	assert(tostring(menu):find("PageMenu") ~= nil, "Parameter \"menuId\" must be a valid PageMenu id!")

	menu.LoadAsync = func

	menu:LoadFirstPage()
end



exports("Register", Register)
exports("RegisterAltFunction", RegisterAltFunction)

-- menu related
exports("AddSeparator", AddSeparator)
exports("AddTextItem", AddTextItem)
exports("AddItem", AddItem)
exports("AddItems", AddItems)
exports("AddSpriteItem", AddSpriteItem)
exports("AddCheckboxItem", AddCheckboxItem)
exports("AddSubmenu", AddSubmenu)
exports("AddScrollSubmenu", AddScrollSubmenu)
exports("AddPageSubmenu", AddPageSubmenu)
exports("LoadAsync", LoadAsync)

-- item related
exports("OnActivate", OnActivate)
exports("OnRelease", OnRelease)
exports("OnValueChanged", OnValueChanged)
exports("Enabled", Enabled)
exports("CloseOnActivate", CloseOnActivate)
exports("RightText", RightText)
