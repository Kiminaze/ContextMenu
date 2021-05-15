
**Support**

If you require any form of support after acquiring this resource, the right place to ask is our 
Discord Server: https://discord.gg/UyAu2jABzE

Make sure to react to the initial message with the tick and your language to get access to all 
the different channels.

Please do not contact anyone directly unless you have a really specific request that does not 
have a place in the server.


**What exactly is the “ContextMenu” and what can you do with it?**

ContextMenu is a script that allows you to create your own menus for any kind of purpose. It does 
nothing by itself.
You hold a button and your cursor appears on the screen. You can then click on any object and 
open specific menus for specific objects. This is kind of like your default rightclick menu in 
every other application.
E.g. clicking on a player can have a completely different menu than clicking on a vehicle.
An example of what can be done with this script can be found in this video:
https://www.youtube.com/watch?v=corEK_GoZ1A

Checkout the Advanced Vehicle Interaction Script that is using this menu here:
https://forum.cfx.re/t/release-advanced-vehicle-interaction/2719099


**Features**

- Create custom menus using LUA.
- Menu items include:
  - Item: Just has text and can be clicked.
  - TextItem: Just text and no functionality.
  - CheckboxItem: Has a text and a checkbox that can be checked.
  - SubmenuItem: Automatically created when creating a submenu to a menu.
  - Separator: Just a separator line to group items together.
- Use custom sprites on the right side of an item.
- Fully customizable with width, height and colors (background, highlighted background, text, 
  highlighted text, sprite, menu border, separator lines).
- Includes the full source code.
- Compatible with basically everything? Let me know if you find any issues!


**Performance**

- The script itself draws no performance at all.
- When you have created your own menu, the performance depends on the amount of items that are 
  currently displayed on the screen.
- The Client side performance of the "Advanced Vehicle Interaction" menu is around 0.25ms when 
  the main menu is shown.


**FAQ**

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


**Known Issues**

- Resolutions wider than 21:9 will cause dislocation problems of the cursor and menu. This issue 
  is being worked on.
- Controller support is not working as of now.


**Patchnotes**

Update (v1.1):

- Breaking change: removed Process() function (example updated to reflect this change)
- Added more functions to the MenuPool:
  - OnOpenMenu: gets called, when the menu should open
  - OnAltFunction: gets called, when alt button is clicked
  - OnMouseOver: gets called while the button for the menu is held
- Added TextItem: No functionality, just text.
- Added camera rotation when touching the screen edge with the mouse (can be turned off).
- Renamed variable "opacity" to "alpha" in all instances.
- Renamed variable "text" from Text class to "title".
