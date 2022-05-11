
### Support

If you require any form of support after acquiring this resource, the right place to ask is our 
Discord Server: https://discord.gg/UyAu2jABzE

Make sure to react to the initial message with the tick and your language to get access to all 
the different channels.

Please do not contact anyone directly unless you have a really specific request that does not 
have a place in the server.


### What exactly is the “ContextMenu” and what can you do with it?

ContextMenu is a script that allows you to create your own menus for any kind of purpose. It does 
nothing by itself.
You hold a button and your cursor appears on the screen. You can then click on any object and 
open specific menus for specific objects. This is kind of like your default rightclick menu in 
every other application.
E.g. clicking on a player can have a completely different menu than clicking on a vehicle.
An example of what can be done with this script can be found in this video:
https://www.youtube.com/watch?v=5ZXmMr_QwH4

Checkout the Vehicle Interaction Script that is using this menu here:
https://forum.cfx.re/t/release-advanced-vehicle-interaction/2719099


### Features

- Create custom context based menus using LUA.
- Menu items include:
  - Item: Just has text and can be clicked.
  - SpriteItem: Background image and can be clicked.
  - TextItem: Just text and no functionality.
  - CheckboxItem: Has a text and a checkbox that can be checked.
  - SubmenuItem: Automatically created when creating a submenu to a menu.
  - Separator: Just a separator line to group items together.
- Use custom sprites on the right and left side of an item.
- Extensive customizability with more to come!
- Easily create custom ingame UI elements using the following elements:
  - Sprites (with UV coordinates)
  - Text (with all settings)
  - Rectangles
- All elements can be parented, positioned, scaled etc.
- Compatible with basically everything? Might collide with other targeting scripts.
- Let me know if you find any issues!


### Performance

- The script itself draws no performance at all.
- When you have created your own menu, the performance depends on the amount of items that are 
  currently displayed on the screen.


### FAQ

Is this still WIP and will it be expanded upon?

- Yes, this script is very much a work-in-progress project.
- A lot of things will be added and changed throughout this process.
- I'll try to keep updates as compatible as possible, but new versions might break backwards 
  compatibility here or there.
- If you have any suggestions on changes or find features missing, just let me know and I'll see 
  what is possible and can be done.


How can I create a custom menu?

- The documentation is currently WIP and can be accessed in the Github repository:
  https://github.com/Kiminaze/ContextMenu/wiki
- You can also take a look at the included example and try and figure it out for yourself. It is 
  not difficult!


### Known Issues

- No Controller support as of now.


### Patchnotes

### Update v2.0
- Completely reworked every single part of the code. Not compatible with prior versions!
- Basically now acts as a giant UI library for FiveM:
  All UI elements can now be parented to other UI elements to make positioning and scaling much easier.
- Better performance while menu is open.
- Menu background is now a Sprite that can be changed to better fit your own server aesthetics instead of just a grey background.
- Added Scroll- and PageMenu which both allow for an unlimited number of items without cluttering the screen.
- Added exports for creating the menu. Several scripts can add items / submenus to the default menu without overlapping each other.
- Added SpriteUV for controlling the UVs of a sprite directly.

### Update v2.0.1
- Fixed an error when using the "CloseOnActivate" setting from an item.

### Update v2.0.2
- Fixed an error when using the mouse wheel when not hovering a scroll menu.

### Update v2.1.0
- Added color to items when disabled.
- Left/Right sprites on items now take the same color as the items' text.
- Fixed a glitch where a SubmenuItem would open its submenu although it was overlapped with another menu.
