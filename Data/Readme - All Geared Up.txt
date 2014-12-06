All Geared Up
Version: 1.1.1
Author: MrJack

Table of contents
- Description
- Requirements
- Compatibility
- How to install
- How to install Walking Armory
- How to uninstall
- Troubleshooting
- Known issues
- Credits
- How to contact the author


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

"Walking Armory" is an optional feature that combines and expands the underlying ideas of All Geared Up and Dual Sheath Redux. Walking Armory
allows the following items to be shown on the player character at the same time:
- two daggers
- two maces
- two staffs
- two swords
- two war axes
- one battleaxe, greatsword or warhammer
- one bow
- one crossbow
- one shield
- one arrow quiver
- one bolt quiver

Only equipped and/or favorited items will show up on the player character. Items will disappear from the player character's model when either
unequipping a non-favorited item or unfavoriting an unequipped item.


--Requirements--
Skyrim (>= 1.9.32.0.8)
SKSE (>= 1.6.16)

-Optional, but highly recommended-
SkyUI (>= 4.1)

-Walking Armory-
Compatible meshes (for example those made for Dual Sheath Redux)
Compatible skeleton (xp32's Maximum Skeleton has been tested and is recommended)
Custom animations are recommended (for example Immersive Animations), particularly if using the "Sword on back" versions of DSR meshes and XPMS.

--Compatibility--
The only know possible compatibility issue concerns users with a lot of hotkeys and running out of
keys that can be assigned.

Gamepads have limited compatibility due to Skyrim's hotkey functionality. See "How to install, 4." and "Known issues" for more information.

The base version of All Geared Up is compatible with Dual Sheath Redux. However, the optional Walking Armory feature is not compatible with Dual Sheath Redux.

Requiem disables by default the ability to change armor during combat and this feature conflicts with the Walking Armory feature, so enable the ability to
change armor while in combat in MCM or Walking Armor won't function properly.

Some mods may contain items that use one or more of the biped slots, which can cause incompatibility with the Walking Armory feature. If you're lucky,
then you will just need to adjust which biped slots to use in the patcher. In some cases you will need to compromise by either not using some of the
items added by other mods or by disabling one or more item types in the patcher. You can find out which slots are used by various mods by consulting the
readme documents of those mods, checking the Armor Addon and Armor forms of items via TES5Edit or the Creation Kit, or asking the author of those mods.

Here's a list of the relevant biped slots, which are called BodyAddon* (replace * with a number) in TES5EDIT:
Biped slot	BodyAddon
44		3
45		4
46		5
47		6
48		7
49		8
52		9
53		10
54		11
55		12
56		13
57		14
58		15
59		16
60		17


--How to install--
1. Extract all files to "\Skyrim\Data".
2. Activate All Geared Up.esp.
3. Start the mod:
	- Go to All Geared Up in MCM, click on "Initial setup", exit MCM, unpause the game and follow the instructions that show up.
	- Or if you do not have SkyUI, then type "setstage _agu_quest_mcm 1" in the console, close the console and follow the instructions that show up.
4. Remap hotkeys the way you want them via the All Geared Up menu in MCM. Do not remap any of the hotkeys found in the All Geared Up's configuration menu
via their original menus (Skyrim's settings menu and SkyUI's configuration menu). Make sure that AGU's hotkeys are not bound to the same buttons as
Skyrim's hotkeys. If you have for example the Character Menu hotkey set to the same button in both this mod's configuration menu and Skyrim's settings
menu, then you will cause issues like menus closing when you try to open them. All Favorite Group hotkeys should show up as unassigned in SkyUI's
configuration menu.

By default the hotkeys are set to be the same as Skyrim's default hotkeys (1-8, I, P, Q, Tab).

The controlmap.txt that is included with this mod does the following as long as it isn't overridden by a loose file copy of the controlmap.txt:
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
- Unmaps the D-Pad Down on gamepads so that it act as an additional hotkey.

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


--How to install Walking Armory--
Download the latest "All Geared Up - Walking Armory Patcher" from the mod's Nexus site. Extract the contents to "\Skyrim\Data". You should now have a file called
"All Geared Up - Walking Armory.jar" in "\Skyrim\Data\SkyProc Patchers\All Geared Up - Walking Armory\". If this hasn't happened, then create such a folder and
place the file there manually.

You'll also need to install XP32's Maximum Skeleton (available on Nexus) and any relevant meshes from Dual Sheath Redux (available on Nexus).
The meshes for weapons and shields found in Skyrim and its DLCs can be found in the main file of Dual Sheath Redux. However, you should only install the meshes.
The Dual Sheath Redux.esp file should not be installed. The contents of Dual Sheath Redux's "Interface", "Scripts" and "SkyProc Patchers" folders should not be
installed either.

You may also want to install appropriate animations, if you've decided to use for example Dual Sheath Redux's "Swords on back" package.

You can run the "All Geared Up - Walking Armory.jar" patcher, once you've installed the XP32 Maximum Skeleton mod and any necessary meshes.

If you install more mods or remove mods that include weapons, shields or ammo (arrows, bolts, etc.), then you have to run the patcher again.
If you are about to remove a mod that has been included in the generated patch, then you should first:
- load up the save you intend to continue playing from
- open up AGU's configuration menu
- select the the "Clear models" option at the bottom
- exit the MCM and unpause the game
This should ensure that any variables in the scripts do not point at any items that might not exist anymore after you've generated a new patch.

The patcher has a settings panel where you can decide which biped slots to assign to each type of item for the sake of compatibility with other mods.
You can also stop an item type from showing up on the player by assigning "None" to the item type.

The setting called "Biped slot - Right sheath" is for the weapon model that is equipped on the right hand side of the player if he/she equips
a one-handed weapon in the left hand. If the player has more than one copy of the same weapon and no other weapons of the same type are equipped or favorited,
then a sheathed model of the weapon equipped in the left hand will be equipped on the right side of the player.

The patcher should be run after any other SkyProc generated patches have been generated as those patches may contain shields, weapons or ammo that needs to be processed by
the patcher.

Using the patcher with SUM: If you use SUM to manage multiple patchers AND(!) you set SUM to merge the patches, then you need have a dummy "All Geared Up - Walking Armory.esp" file loaded
in your load order or the feature will shut itself down or not activate. See the Known issues section for more information.


--How to uninstall--
Uninstalling this mod in the middle of a playthrough is not officially supported. Once the files have been removed, then you should either start a new game
or revert to a save that has not seen this mod.

Remove the following files:
\Skyrim\Data\All Geared Up.esp
\Skyrim\Data\All Geared Up.bsa
\Skyrim\Data\All Geared Up.ini

If you've installed the Walking Armory feature, then you will also need to remove the following files:
\Skyrim\Data\All Geared Up - Walking Armory.esp
\Skyrim\Data\SkyProc Patchers\All Geared Up - Walking Armory\All Geared Up - Walking Armory.jar


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

Equipping Bound weapons will cause weapons of the same type to be removed from the player character. For example equipping a Bound Sword will cause the model
of a sword, which was previously equipped in the same hand, to disappear.

Running SUM via Mod Organizer seems to cause the patcher (1.0) to freeze, if any of the patcher's settings are changed. Running SUM outside of Mod Organizer
does not seem to have any problems with changing settings in the patcher. The issue is being investigated and will, if possible, be fixed in an update.
Running the patcher itself with or without Mod Organizer works just fine.


--Credits--
charon711 for the mod name, feedback and help with testing.
Chesko for two of his Papyrus resources; 2D Array Framework and General-Purpose Array Functions.
Dienes (aka DienesToo) for helping me write the SkyProc patcher.
Leviathan1753, Plutoman101 and Dienes for their work on the SkyProc library.
Thanks to everybody who helped with testing the release candidates and/or provided feedback to fix or improve the mod.

--How to contact the author--
PM MrJack on the official Bethesda forums or mrpwn on Nexus.