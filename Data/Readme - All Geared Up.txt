All Geared Up
Version: 2.1.1
Author: MrJack

Table of contents
- Description
- Requirements
- Compatibility
- How to install
- How to uninstall
- Known issues
- Credits
- How to contact the author
- Changelog


--Description--
All Geared Up displays unequipped favorited weapons and shields on the player character, and can also display weapons equipped in the left hand. Bows and crossbows are not currently supported due to technical issues.

Models of unequipped weapons on the right-hand side have to be removed before equipping said weapons due to technical reasons. If one doesn't do that, then one may end up with an invisible weapon in the player character's hand(s). You can either always enter the Favorites menu when switching weapons or use the custom hotkeys provided by the mod in order to remove the model(s) before equipping a weapon in the right hand. Also applies to two-handed melee weapons.

The All Geared Up mod configuration menu allows you to set which items you want to show up on the player character and which biped slots those items should use. The default slots are set up to be compatible with most cloak (slots 40 and 46) and backpack (slot 47) mods, but you may have to adjust the slots depending on the mods you are using. Shields can be set to accomodate (move further away from the player character) for cloaks and/or backpacks in order to minimize clipping. You can also enable/disable hotkeys and rebind those hotkeys. Quick slots 1-8 also have an alternative method that can be used in case the regular mode has issues.

The custom hotkeys for Quick slot 1-8 require modification of controlmap.txt, which can be done manually, with the optional download, or software like Skyrim Key Helper (part of Interface Hard Coded Key Tweaks, which is available on Skyrim Nexus). Quick slot 1-8 are by default bound to two sets of buttons (1-8 and Numpad 1-8). Unbind the keys you want to use (the custom hotkeys can be bound to those) and leave the other set of keys bound or rebind to another set of keys you will not be using. The custom Quick slot hotkeys are disabled by default and need to be enabled via MCM or the console before they can be used.

The custom SkyUI group 1-8 hotkeys do not need any modifications to the controlmap.txt file. Enabling these custom hotkeys will detect and hijack the keys you've set in SkyUI's mod configuration menu, and the hotkeys for the groups should then be rebound via AGU's menu. Disabling will reset the hotkeys and the hotkeys for the groups should then be rebound via SkyUI's menu again. The custom SkyUI group hotkeys are disabled by default and need to be enabled via MCM or the console before they can be used.

At the moment (version 2.1.1) the recommended way of (un)equipping weapons and shields is to use the inventory menu, the favorites menu, or the custom SkyUI group hotkeys. See the "Known issues" section for more information.

Certain items can also be displayed on the player character as long as the player has the item:
- Gold is represented by a coin purse that grows and shrinks (within certain limits, which can be adjusted) according to the amount of gold in the player's possession.
- Torch in a strap. Equipping a torch will remove the torch and leave the strap in place.
- Potions that restore health, magicka, or stamina are represented by three potions, each of them represents one of the three categories.
- Scrolls show up as a single scroll.
- A satchel for alchemical ingredients.
- Lute and/or flute for those playing as bard characters.
- Certain quest items like the package of the fragments of Wuuthrad, Elder Scrolls, etc.

All of the items can be enabled/disabled at will. The placement of some of these items can also be adjusted.


--Requirements--
Skyrim (>= 1.9.32.0.8)
SKSE (>= 1.7.0 alpha)

-Optional, but highly recommended-
SkyUI (>= 4.1) for configuring the mod and rebinding hotkeys.
XPMS (xp32's Maximum Skeleton) (>= 1.92) or another skeleton with the necessary nodes to support left-hand side weapons and/or weapons/shields on the player character's back.
Mesh packs using the standard set by Dual Sheath Redux. Necessary only for shields on back, staves, and left-hand side weapons.


--Compatibility--
The custom Quick slot 1-8 hotkeys are not compatible with gamepads due to the lack of available buttons. The custom SkyUI group 1-8 hotkeys can be used with gamepads.

The weapons and shield may be incompatible with some items added by mods, if the conflicting items use the same biped slot(s). The biped slots used by this mod can be set via MCM in order to reduce or eliminate incompatibility.


--How to install--
1. Extract all files to "\Skyrim\Data" or install with your favorite mod manager.
2. Activate All Geared Up.esp.

Once you've loaded Skyrim with the mod installed, then you can modify the settings either via MCM or the console. The settings available via the console can be found by typing in 

help "_agu_glob"

in the console. You can then set the values of those Global Variables:

set GLOBALVARIABLENAME to VALUE

where VALUE can be 0 (off/disabled) or 1 (on/enabled).

If you change a setting via the console, then you need to save and reload for the change to take effect. Using the MCM does not require you to save and reload.

If are going to use the custom Quick slot 1-8 hotkeys, then you need to modify controlmap.txt. Have the actual hotkeys for Quick slots 1-8 bound to keys you will not be using. The custom hotkeys will then inject the necessary scripting before tapping the actual hotkeys.


--How to uninstall--
Uninstalling this mod in the middle of a playthrough is not officially supported. Once the files have been removed, then you should either start a new game
or revert to a save that has not seen this mod.

Remove the following files:
\Skyrim\Data\All Geared Up.esp
\Skyrim\Data\All Geared Up.bsa


--Known issues--
Animations from the previous weapon may carry over for a while when switching between weapons while using the 3rd person camera. This resolves itself once the player character plays an animation (for example performs an attack or blocks).

Scabbards and sheaths may remain on the right-hand side of the player character at times. Manually equipping and unequipping the weapon should remove them, if it bothers you. This is most likely due to the way the game handles models.

The custom Quick slot hotkeys can sometimes fail to show the weapon that was unequipped in favor of another weapon. Opening a menu (for example the inventory or favorites menu) forces weapons, which should be visible on the player character, to show up. The problem has been intermittent during testing and no obvious pattern has emerged. The custom SkyUI hotkeys do not seem to exhibit this problem.


--Credits--
charon711 for the mod name, feedback and help with testing.
SKSE team for all their hard work, which has made this mod possible.
bla08 for figuring out a bug involving meshes.
Thanks to everybody who helped with testing the release candidates and/or provided feedback to fix or improve the mod.


--How to contact the author--
PM MrJack on the official Bethesda forums or mrpwn on Nexus.


--Changelog--
2.1.1:
	- Fixed a bug where changing the slotmask of item slots doesn't stick after loading a save game.
	- Fixed an issue where the correct lighting wasn't applied to certain meshes when they were in the shadows.
	- Corrected a page name in MCM ("Follower" is now "NPC")
	- Fixed a bug that caused coin purse stage limits in MCM to not correctly reflect the set value.

2.1.0:
	- Fixed bug that caused items to not show up when loading a game.
	- Fixed bug where items might not show up, if the armor forms, which are used to display weapons/shields, are removed from the player.
	- Added a new feature that displays certain non-weapon/shield items like a reactive coin purse, potions, scrolls, etc. on the player character. A reactive coin purse and torch can also be displayed on NPCs. The placement of certain items can be modified.
	- Merged the accomodate cloak and accomodate backpack options for shield.
	- Added a new option to hide shields when a backpack and/or cloak is detected.

2.0.0:
	- Complete overhaul of the mod.
	- The bDisableGearedUp=0 tweak has been abandoned in favor of an approach more akin to what Dual Sheath Redux does. This change also means that this mod no longer needs to fix the various bugs caused by the INI tweak.
	- The need for a SkyProc patcher has been replaced with a system that uses SKSE to modify ARMO forms, and their associated ARMA forms, at runtime instead of creating ARMO and ARMA forms in advance based on the load order. 

1.1.2:
	- Changed the behavior that determined if the weapons should be shown or hidden when the player switches races (transforms into a werewolf or Vampire Lord). Should fix the issue causing weapons to become hidden when the player becomes a regular vampire.

1.1.1:
	- Fixed a bug where weapons would get stuck in the player's hands because the automated sheathing/unsheathing mechanism didn't work when the player was on a mount. As a result the automated sheathing/unsheathing is replaced by disabling and enabling the INI tweak when the player is on a mount.

1.1.0:
	- Fixed the source of stack dumps in two scripts: "_agu_containers" and "_agu_npc_alias". 

	- Fixed a bug where switching from a two-handed weapon to a shield via the 1-8 hotkeys would result in the two-handed weapon getting stuck in the right hand. 

	- A new, optional and highly configurable feature. It combines and extends the underlying ideas of All Geared Up and Dual Sheath Redux. The following items can be shown on the player character at the same time: 
	- 2 daggers 
	- 2 maces 
	- 2 staffs 
	- 2 swords 
	- 2 war axes 
	- 1 battleaxe, greatsword or warhammer 
	- 1 bow 
	- 1 crossbow 
	- 1 shield 
	- 1 arrow quiver 
	- 1 bolt quiver 
	Equipped and favorited items are shown automatically. Unequipping a non-favorite item or unfavoriting an item that is not equipped will remove the item from the player character's model. The feature comes with a SkyProc patcher that generates everything that is needed for items in the load order, allows you to select which types of items you want to show up on the body and which biped slot they should use. The provided options should make it easy to make the new feature suit your tastes/needs and make the feature compatible with other mods that may use some of those biped slots for their own items (Frostfall, Wearable Lanterns, Bandolier - Bags and pouches, and many more). The feature is compatible with the meshes used by/made for Dual Sheath Redux and as such supports all the mods that have a mesh pack for Dual Sheath Redux. The feature is incompatible with the core of Dual Sheath Redux, but will not interfere with Dual Sheath Redux unless the feature is activated, which is done by generating a patch with the new patcher.

1.0.0:
	- Initial release