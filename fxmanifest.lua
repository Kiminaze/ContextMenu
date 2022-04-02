fx_version 'cerulean'
games { 'gta5' }

author 'Philipp Decker'
description 'Lets you create context menus.'
version '2.0'

client_scripts {
	'Utils/screenToWorld.lua',
	'Utils/TextAlignment.lua',
	'Utils/TextFont.lua',
	'Utils/Log.lua',
	'Utils/Color.lua',

	'DefaultValues.lua',

	'Graphics2D/Object2D.lua',
	'Graphics2D/Rect.lua',
	'Graphics2D/Text.lua',
	'Graphics2D/Sprite.lua',
	'Graphics2D/SpriteUV.lua',
	'Graphics2D/Container.lua',
	'Graphics2D/Border.lua',

	'Items/BaseItem.lua',
	'Items/SeparatorItem.lua',
	'Items/ScrollItem.lua',
	'Items/PageItem.lua',
	'Items/TextItem.lua',
	'Items/Item.lua',
	'Items/SpriteItem.lua',
	'Items/SubmenuItem.lua',
	'Items/CheckboxItem.lua',

	'Menu/Menu.lua',
	'Menu/ScrollMenu.lua',
	'Menu/PageMenu.lua',
	'Menu/MenuPool.lua',

	'Menu/ExportMenu.lua'
}

-- example
client_scripts {
	'example/*.lua'
}



-- TODO
--   - fix performance

-- AFTER RELEASE
--   change colors
--   more items
--    - list
--    - slider
--   text font position adjustments
--   SpriteItem scaling
--   wiki

--Citizen.CreateThread(function()
--    local txd = CreateRuntimeTxd("testDict")
--    local dui = CreateDui("https://dunb17ur4ymx4.cloudfront.net/wysiwyg/924122/13278270afe4a542a675a9e642adf8cef460ee10.png", 500, 300)
--    local duiHandle = GetDuiHandle(dui)
--    local runtimeTexture = CreateRuntimeTextureFromDuiHandle(txd, "textureName", duiHandle)
--
--    local sprite = Sprite("testDict", "textureName", vector2(0.1, 0.1))
--
--    local rect = Rect(vector2(0.25, 0.25), vector2(0.5, 0.5), Colors.Red:Alpha(100))
--    local rect2 = Rect(vector2(0.25, 0.25), vector2(0.5, 0.5), Colors.Green:Alpha(100))
--    rect2:Parent(rect)
--
--    while (true) do
--        Citizen.Wait(0)
--
--        if (IsControlPressed(0, 38)) then
--            local pos = rect:Position()
--            rect:Position(vector2(pos.x + 0.01, pos.y))
--        end
--
--        rect:Draw()
--        rect2:Draw()
--
--        sprite:Draw()
--    end
--end)
