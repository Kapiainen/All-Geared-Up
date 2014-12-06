All Geared Up
Version: 1.0.0
Author: MrJack

--Description--
All Geared Up is a mod that aims to fix the issues caused by using the bDisableGearedUp=0 INI tweak.
The issues and implemented fixes are:
- Switching weapons while they are drawn causes weapon models to get stuck in the player's hands.

This issue is addressed by replacing Skyrim's quick slot (1-8), quick inventory, quick magic, character menu,
favorites menu and SkyUI's favorite group hotkeys with custom hotkeys that include additional logic.
The new hotkeys force the player to sheathe weapons/spells, if it is deemed necessary based on what
the player is switching from and to, before actually performing the action of the old hotkeys. If the player
was forced to sheathe their weapons/spells, then they are automatically drawn once the switch has occurred.

Sheathing/drawing is also automated for the container menu, which is opened when activating a container, a corpse
or ash pile.

- Crossbows stick in the hands of NPCs when they switch to a melee weapon.

This is fixed by removing the crossbow from and returning the crossbow to the NPC when they switch weapons.

- Weapons stick on the player model in their usual place or at the player's feet when transforming into the
werewolf or Vampire Lord form.

Fixed by temporarily disabling the INI tweak. The tweak is enabled again once the player transforms back to
their original form.

A feature called "Hide unequipped weapons" has been added and can be enabled for each SkyUI favorite group.
This feature can be used to hide weapons when switching to a favorite group, which has been designated as an outfit
for walking around in cities and/or villages, without having to unfavorite all the other weapons. This feature
only works when the favorite group contains armor/clothing.


--Requirements--
Skyrim (>= 1.9.32.0.8)
SKSE (>= 1.6.16)

--Optional, but highly recommended--
SkyUI (>= 4.1)


--Compatibility--
The only know possible compatibility issue concerns users with a lot of hotkeys and running out of
keys that can be assigned.

Gamepads have limited compatibility due to Skyrim's hotkey functionality. See "How to install, 4." and "Known issues" for more information.


--How to install--
1. Extract all files to "\Skyrim\Data".
2. Activate All Geared Up.esp.
3. Start the mod:
	- Go to All Geared Up in MCM, click on "Initial setup", exit MCM, unpause the game and follow the instructions that show up.
	- Or if you do not have SkyUI, then type "setstage _agu_quest_mcmc 1" in the console, close the console and follow the instructions that show up.
4. Remap hotkeys the way you want them via the All Geared Up menu in MCM. Do not remap any of the hotkeys found in the All Geared Up's configuration menu
via their original menus (Skyrim's settings menu and SkyUI's configuration menu). If you have for example the Character Menu hotkey set to the same button
in both this mod's configuration menu and Skyrim's settings menu, then you will cause issues like menus closing when you try to open them. All Favorite Group
hotkeys should show up as unassigned in SkyUI's configuration menu.

By default the hotkeys are set to be the same as Skyrim's default hotkeys (1-8, I, P, Q, Tab).

The controlmap.txt that is included with this mod does the following:
- Moves the native hotkeys solely to the numpad.
	Hotkey 1		Numpad 1
	Hotkey 2		Numpad 2
	Hotkey 3		Numpad 3
	Hotkey 4		Numpad 4
	Hotkey 5		Numpad 5
	Hotkey 6		Numpad 6
	Hotkey 7		Numpad 7
	Hotkey 8		Numpad 8
	Character Menu		Numpad 9
	Favorites		Numpad 0
	Quick Inventory		Numpad -
	Quick Magic		Numpad +
- Enables remapping of Hotkey 1-8 in the game.
- Unmaps the D-Pad Down on XBOX 360 controllers so that it act as an additional hotkey.

If you are using a gamepad, then you should enable one of the options found in the "Gamepad compatibility" section found in this mod's configuration menu.
The options are "Alternative mechanism" and "Automated mechanism", both of which have their own target audience. The options enable different solutions to
the same problem: how to automatically sheathe/unsheathe weapons and spells when opening certain menus or switching weapons/spells. The two options have
some technical limitations and thus compromises have to be made. It may be possible to provide a single option that does not require any compromises, but
that is not possible at the moment.

"Alternative mechanism" is best suited for those who play characters that will not be transforming into a werewolf or Vampire Lord.
+ Sheathing of weapons/spells occurs before opening a menu.
- Opens the usual Character Menu, when the player character has transformed into a werewolf or Vampire Lord.
You need to set the menu hotkeys via this mod's configuration menu.

"Automated mechanism" works with player characters that will transform into werewolves or Vampire Lords.
+ Can open up the correct Skill/Perk tree menu when the player character has transformed into a werewolf or Vampire Lord.
- Menus open for a split second before closing so that weapons/spells can be sheathed. The menu will open up again automatically once the weapons/spells
have been sheathed.
You need to set the menu hotkeys via Skyrim's settings menu.

Those who use gamepads should use SkyUI's favorite groups instead of Skyrim's 1-8 hotkeys.

--How to uninstall--
Uninstalling this mod in the middle of a playthrough is not officially supported. Once the files have been removed, then you should either start a new game
or revert to a save that has not seen this mod.

Remove the following files:
\Skyrim\Data\All Geared Up.esp
\Skyrim\Data\All Geared Up.bsa
\Skyrim\Data\All Geared Up.ini


--Troubleshooting--
Q: A weapon model has become stuck in my characters hand. How do I fix it?
A: Either unequip the weapon(s) or use the "Reset stuck models" option in this mod's configuration menu.

Q: The mod doesn't seem to work anymore (unequipped, favorite weapons don't disappear when opening menus). Can this be fixed?
A: The problem might be caused by:
- the All Geared Up Token becoming unfavorited. Redo the initial setup via MCM or console (see How to install, 3.).
- "Hide unequipped weapons" has been enabled on a group and you haven't switched to a group containing armor/clothing with this setting disabled.
  Check the MCM if this setting has been enabled and if so, then either disable it and switch to that group or add armor/clothing to another group with this
  setting disabled and switch to that one.

--Known issues--
Animations from the previous weapon may carry over for a while when switching between weapons while using the 3rd person camera.
This resolves itself once the player character plays an animation (for example performs an attack or blocks) 

Some patterns of equipping weapons that cause models to stick in hands might not be properly unstuck by the Reset stuck models feature.
One of the weapons will remain invisible until you unequip and equip the weapon.

Using "Reset stuck models" when a user enchanted weapon is involved might cause an unenchanted weapon to be equipped instead, if you
have more than one copy of the weapon in your inventory.

Sheathing a weapon when switching weapons or opening a menu may cause hostile guards to mistake the action for a yield.

Use of Skyrim's favorites hotkeys is not supported on gamepads. Use SkyUI's favorite groups instead.

If the 'Container menu' option is enabled, then activating an ash pile might bring up the container menu for the wrong actor due to the way the FindClosestActorFromRef
function works. It hasn't happened to me even when I have tried my best to make that happen, but it is possible. There's also a failsafe so that if the found actor
isn't dead, then the ash pile will be activated instead. This will bring up the container menu for the correct actor, but automatic sheathing will no occur.

--Credits--
charon711 for the mod name, feedback and help with testing.
Chesko for two of his Papyrus resources; 2D Array Framework and General-Purpose Array Functions.
Thanks to everybody who helped with testing the release candidates and/or provided feedback to fix or improve the mod.

--How to contact me--
PM MrJack on the official Bethesda forums or mrpwn on Nexus.