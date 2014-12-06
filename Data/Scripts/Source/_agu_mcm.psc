Scriptname _AGU_MCM extends SKI_ConfigBase  

;###################################################################################################################################################
;Properties
;###################################################################################################################################################

;1.0.0
Actor Property kPlayer Auto
Light Property kTorch Auto
Message Property msgSetup Auto
Weapon Property kToken Auto
ObjectReference Property kSafeChest Auto
Quest Property _AGU_QUEST_Containers Auto
SKI_FavoritesManager SkyUI
Spell Property kTwoHandedSpell Auto
Spell Property kVoiceSpell Auto
Weapon Property kTwoHandedWeapon Auto

;1.1.0
_AGU_Addon1_Alias Property Addon1 Auto

;###################################################################################################################################################
;Local variables (Non-MCM)
;###################################################################################################################################################

;1.0.0
Float fOverrideSensitivity = 0.5
Bool Property bHideUnequippedWeapons Auto Hidden
Bool bSkyUIHijacked
Bool bWeaponDrawn
Int[] iHotkeyVanilla
Int[] iHotkeySkyUI
Int[] iHotkeyMenu
SoundCategory audioUI
String[] sHotkeyVanillaKeyName
String[] sHotkeyMenuKeyName
String[] sHotkeyMenuName

Form[] Property mainHand Auto Hidden
Form[] Property offHand Auto Hidden
Int[] mainHandID
Int[] offHandID
Int[] iTorch

;1.1.0
Bool bAddon1
Bool bAddon1_ExtraAfterHotkey

;###################################################################################################################################################
;MCM
;###################################################################################################################################################

Bool bMCM_AlternativeMechanism
Bool bMCM_AutomatedMechanism
Bool Property bMCM_ContainerMechanism = True Auto Hidden
Int iMCM_Group_Sheet

Bool[] bGroupHideUnequipped
Bool[] bGroupUnequipOffHand

String sInfoHotkeyNative = "Select the key that selects this slot.\nDefault: "
String sInfoHotkeyInventory = "Select the key that opens the inventory.\nDefault: I."
String sInfoHotkeyMagic = "Select the key that opens the magic menu.\nDefault: P."
String sInfoHotkeyTween = "Select the key that opens the character menu.\nDefault: Tab."
String sInfoHotkeyFavorites = "Select the key that opens the favorites menu.\nDefault: Q."
String sInfoUnmap = "Unmaps all of the hotkeys above this option."
String sInfoClearHideUnequippedGroups = "Clear all the settings above this option."
String sInfoHotkeyGroup = "Select the key that switches to this favorite group.\nDefault: "

String sInfoContainerMenu = "Automatically sheathe/unsheathe weapons and spells when opening containers or looting bodies. \nDefault: Enabled."
String sInfoResetModels = "Reset any stuck models. Exit MCM and unpause the game after selecting this option."
String sInfoInitSetup = "Start the mod/redo the initial setup. Exit MCM and unpause the game after selecting this option."
String sInfoGroupHideUnequipped  = "Toggle whether or not this group hides unequipped weapons. Can be used with SkyUI's 'Unequip Armor' setting in order to create clothing sets."
String sInfoGroupUnequipOffHand = "Toggle whether or not your off-hand weapon/spell is unequipped before switching to this group."

String sInfoUnequipOffHand = "Toggle unequipping of off-hand items when switching to this favorite group.\nDefault: Disabled."
String sInfoAlternativeMechanism = "Does not support werewolf or Vampire Lord characters. \nDefault: Disabled"
String sInfoAutomatedMechanism = "Supports werewolf and Vampire Lord characters. \nDefault: Disabled."
String sInfoHideUnequipped = "Toggle hiding of unequipped weapons when wearing the armor in this slot.\nDefault: None."

String sInfoOverrideSensitivity = "Set the time that a menu hotkey has to be held down to override automatic sheathing/unsheathing. Does not apply when 'Automated mechanism' is enabled.\nDefault: 0.5 seconds."
String sFormatOverrideSensitivity = "{2} seconds"

Event OnConfigOpen()

EndEvent

Event OnConfigClose()
	iMCM_Group_Sheet = 0
	If(bMCM_AutomatedMechanism && GetState() != "Automated")
		Utility.Wait(0.1)
		;Debug.Notification("Switching")
		GoToState("Automated")
		RegisterForMenus()
	ElseIf(!bMCM_AutomatedMechanism && GetState() == "Automated")
		Utility.Wait(0.1)
		;Debug.Notification("Switching back")
		GoToState("")
		UnregisterForMenus()
	EndIf
	If(bMCM_ContainerMechanism && !_AGU_QUEST_Containers.IsRunning())
		_AGU_QUEST_Containers.Start()
	ElseIf(!bMCM_ContainerMechanism && _AGU_QUEST_Containers.IsRunning())
		_AGU_QUEST_Containers.Stop()
	EndIf
EndEvent

Event OnPageReset(String Page)
	If(Page == "" || Page == "Settings")
		SetTitleText("Settings")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		AddHeaderOption("Native Hotkeys")
		AddKeyMapOptionST("stHotkeyNative1", "Hotkey 1", iHotkeyVanilla[0], OPTION_FLAG_WITH_UNMAP)
		AddKeyMapOptionST("stHotkeyNative2", "Hotkey 2", iHotkeyVanilla[1], OPTION_FLAG_WITH_UNMAP)
		AddKeyMapOptionST("stHotkeyNative3", "Hotkey 3", iHotkeyVanilla[2], OPTION_FLAG_WITH_UNMAP)
		AddKeyMapOptionST("stHotkeyNative4", "Hotkey 4", iHotkeyVanilla[3], OPTION_FLAG_WITH_UNMAP)
		AddKeyMapOptionST("stHotkeyNative5", "Hotkey 5", iHotkeyVanilla[4], OPTION_FLAG_WITH_UNMAP)
		AddKeyMapOptionST("stHotkeyNative6", "Hotkey 6", iHotkeyVanilla[5], OPTION_FLAG_WITH_UNMAP)
		AddKeyMapOptionST("stHotkeyNative7", "Hotkey 7", iHotkeyVanilla[6], OPTION_FLAG_WITH_UNMAP)
		AddKeyMapOptionST("stHotkeyNative8", "Hotkey 8", iHotkeyVanilla[7], OPTION_FLAG_WITH_UNMAP)
		AddKeyMapOptionST("stHotkeyTween", "Character Menu", iHotkeyMenu[3], OPTION_FLAG_WITH_UNMAP)
		AddKeyMapOptionST("stHotkeyFavorites", "Favorites", iHotkeyMenu[0], OPTION_FLAG_WITH_UNMAP)
		AddKeyMapOptionST("stHotkeyInventory", "Quick Inventory", iHotkeyMenu[1], OPTION_FLAG_WITH_UNMAP)
		AddKeyMapOptionST("stHotkeyMagic", "Quick Magic", iHotkeyMenu[2], OPTION_FLAG_WITH_UNMAP)
		AddTextOptionST("stUnmapNative", "Unmap all", "")
		AddEmptyOption()
		
		AddHeaderOption("Gamepad compatibility")
		If(bMCM_AlternativeMechanism)
			AddToggleOptionST("stAlternativeMechanism", "Alternative mechanism", bMCM_AlternativeMechanism, OPTION_FLAG_NONE)
			AddToggleOptionST("stAutomatedMechanism", "Automated mechanism", bMCM_AutomatedMechanism, OPTION_FLAG_DISABLED)
		ElseIf(bMCM_AutomatedMechanism)
			AddToggleOptionST("stAlternativeMechanism", "Alternative mechanism", bMCM_AlternativeMechanism, OPTION_FLAG_DISABLED)
			AddToggleOptionST("stAutomatedMechanism", "Automated mechanism", bMCM_AutomatedMechanism, OPTION_FLAG_NONE)
		Else
			AddToggleOptionST("stAlternativeMechanism", "Alternative mechanism", bMCM_AlternativeMechanism, OPTION_FLAG_NONE)
			AddToggleOptionST("stAutomatedMechanism", "Automated mechanism", bMCM_AutomatedMechanism, OPTION_FLAG_NONE)
		EndIf
		
		SetCursorPosition(1)
		AddHeaderOption("SkyUI Favorite Groups")
		If(iMCM_Group_Sheet == 0) ;Buttons
			AddTextOptionST("stHotkeyGroupSheet", "Switch to", "Hide unequipped weapons")
			AddKeyMapOptionST("stHotkeyGroup1", "Group 1", iHotkeySkyUI[0], OPTION_FLAG_WITH_UNMAP)
			AddKeyMapOptionST("stHotkeyGroup2", "Group 2", iHotkeySkyUI[1], OPTION_FLAG_WITH_UNMAP)
			AddKeyMapOptionST("stHotkeyGroup3", "Group 3", iHotkeySkyUI[2], OPTION_FLAG_WITH_UNMAP)
			AddKeyMapOptionST("stHotkeyGroup4", "Group 4", iHotkeySkyUI[3], OPTION_FLAG_WITH_UNMAP)
			AddKeyMapOptionST("stHotkeyGroup5", "Group 5", iHotkeySkyUI[4], OPTION_FLAG_WITH_UNMAP)
			AddKeyMapOptionST("stHotkeyGroup6", "Group 6", iHotkeySkyUI[5], OPTION_FLAG_WITH_UNMAP)
			AddKeyMapOptionST("stHotkeyGroup7", "Group 7", iHotkeySkyUI[6], OPTION_FLAG_WITH_UNMAP)
			AddKeyMapOptionST("stHotkeyGroup8", "Group 8", iHotkeySkyUI[7], OPTION_FLAG_WITH_UNMAP)
			AddTextOptionST("stUnmapGroup", "Unmap all", "")
		ElseIf(iMCM_Group_Sheet == 1) ;Hide unequipped weapons
			;AddTextOptionST("stHotkeyGroupSheet", "Switch to", "Unequip off-hand")
			AddTextOptionST("stHotkeyGroupSheet", "Switch to", "Hotkeys")
			AddToggleOptionST("stHideUnequippedGroup1", "Group 1", bGroupHideUnequipped[0])
			AddToggleOptionST("stHideUnequippedGroup2", "Group 2", bGroupHideUnequipped[1])
			AddToggleOptionST("stHideUnequippedGroup3", "Group 3", bGroupHideUnequipped[2])
			AddToggleOptionST("stHideUnequippedGroup4", "Group 4", bGroupHideUnequipped[3])
			AddToggleOptionST("stHideUnequippedGroup5", "Group 5", bGroupHideUnequipped[4])
			AddToggleOptionST("stHideUnequippedGroup6", "Group 6", bGroupHideUnequipped[5])
			AddToggleOptionST("stHideUnequippedGroup7", "Group 7", bGroupHideUnequipped[6])
			AddToggleOptionST("stHideUnequippedGroup8", "Group 8", bGroupHideUnequipped[7])
			AddTextOptionST("stClearHideUnequippedGroups", "Clear all", "")
		ElseIf(iMCM_Group_Sheet == 2) ;Unequip off-hand
			AddTextOptionST("stHotkeyGroupSheet", "Switch to", "Hotkeys")
			AddToggleOptionST("stUnequipOffHandGroup1", "Group 1", bGroupUnequipOffHand[0])
			AddToggleOptionST("stUnequipOffHandGroup2", "Group 2", bGroupUnequipOffHand[1])
			AddToggleOptionST("stUnequipOffHandGroup3", "Group 3", bGroupUnequipOffHand[2])
			AddToggleOptionST("stUnequipOffHandGroup4", "Group 4", bGroupUnequipOffHand[3])
			AddToggleOptionST("stUnequipOffHandGroup5", "Group 5", bGroupUnequipOffHand[4])
			AddToggleOptionST("stUnequipOffHandGroup6", "Group 6", bGroupUnequipOffHand[5])
			AddToggleOptionST("stUnequipOffHandGroup7", "Group 7", bGroupUnequipOffHand[6])
			AddToggleOptionST("stUnequipOffHandGroup8", "Group 8", bGroupUnequipOffHand[7])
		EndIf
		AddEmptyOption()
		
		AddHeaderOption("Miscellaneous")
		AddSliderOptionST("stOverrideSensitivity", "Override sensitivity", fOverrideSensitivity , sFormatOverrideSensitivity)
		AddToggleOptionST("stContainerMechanism", "Container menu", bMCM_ContainerMechanism)
		AddTextOptionST("stResetModels", "Reset stuck models", "")
		AddTextOptionST("stInitSetup", "Initial setup", "")
		If(bAddon1)
			AddTextOptionST("stAddon1Enabled", "Walking Armory", "Enabled", OPTION_FLAG_DISABLED)
			AddTextOptionST("stAddon1ClearSlots", "Clear models", "")
		Else
			AddTextOptionST("stAddon1Enabled", "Walking Armory", "Disabled", OPTION_FLAG_DISABLED)
		EndIf
		
	ElseIf(Page == "Help")
		AddTextOptionST("stHelpInitSetup", "Initial setup", "")
		AddTextOptionST("stHelpResetModels", "Reset stuck models", "")
		AddTextOptionST("stHelpHotkeys", "Hotkeys", "")
		AddTextOptionST("stHelpOverrideSensitivity", "Override sensitivity", "")
		AddTextOptionST("stHelpSkyUIHideUnequipped", "SkyUI - Hide unequipped weapons", "")
		AddTextOptionST("stHelpGamepadCompatibility", "Gamepad - Compatibility", "")
		AddTextOptionST("stHelpGamepadAlternative", "Gamepad - Alternative mechanism", "")
		AddTextOptionST("stHelpGamepadAutomated", "Gamepad - Automated mechanism", "")
		AddTextOptionST("stHelpContainer", "Container menu", "")
	ElseIf(Page == "Walking Armory")
		AddHeaderOption("Works")
	EndIf
EndEvent

Int Function CheckForConflict(Int newKeyCode, String conflictControl, String conflictName, Int currentKeyCode)
	Bool bContinue = True
	If(conflictControl != "")
		String msg
		If(conflictName != "")
			msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
		Else
			msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
		EndIf

		bContinue = ShowMessage(msg, True, "$Yes", "$No")
	EndIf

	If(bContinue)
		UnregisterForKey(currentKeyCode)
		RegisterForKey(newKeyCode)
		Return newKeyCode
	Else
		Return currentKeyCode
	EndIf
EndFunction

;/
Function HotkeyChange(Int KeyCode, Int newKeyCode, String conflictControl, string conflictName)
	UnregisterForKey(KeyCode)
	KeyCode = CheckForConflict(newKeyCode, conflictControl, conflictName)
	SetKeyMapOptionValueST(KeyCode)
	RegisterForKey(KeyCode)
EndFunction
/;

Function HotkeyDefault(Int aiHotkey, Int aiDefault = -1)
	UnregisterForKey(aiHotkey)
	aiHotkey = aiDefault
	SetKeyMapOptionValueST(aiHotkey)
	If(aiHotkey != -1)
		RegisterForKey(aiHotkey)
	EndIf
EndFunction

;/
String function GetCustomControl(int keyCode)
	If (keyCode == iHotkeyVanilla[0])
		Return "Hotkey 1"
	ElseIf (keyCode == iHotkeyVanilla[1])
		Return "Hotkey 2"
	ElseIf (keyCode == iHotkeyVanilla[2])
		Return "Hotkey 3"
	ElseIf (keyCode == iHotkeyVanilla[3])
		Return "Hotkey 4"
	ElseIf (keyCode == iHotkeyVanilla[4])
		Return "Hotkey 5"
	ElseIf (keyCode == iHotkeyVanilla[5])
		Return "Hotkey 6"
	ElseIf (keyCode == iHotkeyVanilla[6])
		Return "Hotkey 7"
	ElseIf (keyCode == iHotkeyVanilla[7])
		Return "Hotkey 8"
	ElseIf (keyCode == iHotkeyMenu[0])
		Return "Favorites"
	ElseIf (keyCode == iHotkeyMenu[1])
		Return "Quick Inventory"
	ElseIf (keyCode == iHotkeyMenu[2])
		Return "Quick Magic"
	ElseIf (keyCode == iHotkeyMenu[3])
		Return "Character Menu"
	ElseIf (keyCode == iHotkeySkyUI[0])
		Return "Group 1"
	ElseIf (keyCode == iHotkeySkyUI[1])
		Return "Group 2"
	ElseIf (keyCode == iHotkeySkyUI[2])
		Return "Group 3"
	ElseIf (keyCode == iHotkeySkyUI[3])
		Return "Group 4"
	ElseIf (keyCode == iHotkeySkyUI[4])
		Return "Group 5"
	ElseIf (keyCode == iHotkeySkyUI[5])
		Return "Group 6"
	ElseIf (keyCode == iHotkeySkyUI[6])
		Return "Group 7"
	ElseIf (keyCode == iHotkeySkyUI[7])
		Return "Group 8"
	Else
		Return ""
	EndIf
EndFunction
/;

State stHotkeyNative1
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 0
		;UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeyVanilla[iIndex])
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		;RegisterForKey(iHotkeyVanilla[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 0
		Int iDefault = 2
		UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		If(iHotkeyVanilla[iIndex] != -1)
			RegisterForKey(iHotkeyVanilla[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyNative +"1.")
	EndEvent
EndState

State stHotkeyNative2
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 1
		;UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeyVanilla[iIndex])
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		;RegisterForKey(iHotkeyVanilla[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 1
		Int iDefault = 3
		UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		If(iHotkeyVanilla[iIndex] != -1)
			RegisterForKey(iHotkeyVanilla[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyNative +"2.")
	EndEvent
EndState

State stHotkeyNative3
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 2
		;UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeyVanilla[iIndex])
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		;RegisterForKey(iHotkeyVanilla[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 2
		Int iDefault = 4
		UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		If(iHotkeyVanilla[iIndex] != -1)
			RegisterForKey(iHotkeyVanilla[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyNative +"3.")
	EndEvent
EndState

State stHotkeyNative4
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 3
		;UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeyVanilla[iIndex])
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		;RegisterForKey(iHotkeyVanilla[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 3
		Int iDefault = 5
		UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		If(iHotkeyVanilla[iIndex] != -1)
			RegisterForKey(iHotkeyVanilla[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyNative +"4.")
	EndEvent
EndState

State stHotkeyNative5
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 4
		;UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeyVanilla[iIndex])
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		;RegisterForKey(iHotkeyVanilla[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 4
		Int iDefault = 6
		UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		If(iHotkeyVanilla[iIndex] != -1)
			RegisterForKey(iHotkeyVanilla[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyNative +"5.")
	EndEvent
EndState

State stHotkeyNative6
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 5
		;UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeyVanilla[iIndex])
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		;RegisterForKey(iHotkeyVanilla[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 5
		Int iDefault = 7
		UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		If(iHotkeyVanilla[iIndex] != -1)
			RegisterForKey(iHotkeyVanilla[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyNative +"6.")
	EndEvent
EndState

State stHotkeyNative7
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 6
		;UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeyVanilla[iIndex])
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		;RegisterForKey(iHotkeyVanilla[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 6
		Int iDefault = 8
		UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		If(iHotkeyVanilla[iIndex] != -1)
			RegisterForKey(iHotkeyVanilla[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyNative +"7.")
	EndEvent
EndState

State stHotkeyNative8
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 7
		;UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeyVanilla[iIndex])
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		;RegisterForKey(iHotkeyVanilla[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 7
		Int iDefault = 9
		UnregisterForKey(iHotkeyVanilla[iIndex])
		iHotkeyVanilla[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeyVanilla[iIndex])
		If(iHotkeyVanilla[iIndex] != -1)
			RegisterForKey(iHotkeyVanilla[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyNative +"8.")
	EndEvent
EndState

State stHotkeyFavorites
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 0
		;UnregisterForKey(iHotkeyMenu[iIndex])
		iHotkeyMenu[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeyMenu[iIndex])
		SetKeyMapOptionValueST(iHotkeyMenu[iIndex])
		;RegisterForKey(iHotkeyMenu[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 0
		Int iDefault = 16
		UnregisterForKey(iHotkeyMenu[iIndex])
		iHotkeyMenu[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeyMenu[iIndex])
		If(iHotkeyMenu[iIndex] != -1)
			RegisterForKey(iHotkeyMenu[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyFavorites)
	EndEvent
EndState

State stHotkeyInventory
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 1
		;UnregisterForKey(iHotkeyMenu[iIndex])
		iHotkeyMenu[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeyMenu[iIndex])
		SetKeyMapOptionValueST(iHotkeyMenu[iIndex])
		;RegisterForKey(iHotkeyMenu[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 1
		Int iDefault = 23
		UnregisterForKey(iHotkeyMenu[iIndex])
		iHotkeyMenu[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeyMenu[iIndex])
		If(iHotkeyMenu[iIndex] != -1)
			RegisterForKey(iHotkeyMenu[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyInventory)
	EndEvent
EndState

State stHotkeyMagic
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 2
		;UnregisterForKey(iHotkeyMenu[iIndex])
		iHotkeyMenu[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeyMenu[iIndex])
		SetKeyMapOptionValueST(iHotkeyMenu[iIndex])
		;RegisterForKey(iHotkeyMenu[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 2
		Int iDefault = 25
		UnregisterForKey(iHotkeyMenu[iIndex])
		iHotkeyMenu[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeyMenu[iIndex])
		If(iHotkeyMenu[iIndex] != -1)
			RegisterForKey(iHotkeyMenu[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyMagic)
	EndEvent
EndState

Bool Function CheckConflict(Int newKeyCode, String conflictControl, String conflictName)
	Bool bContinue = True
	If(conflictControl != "")
		String msg
		If(conflictName != "")
			msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n(" + conflictName + ")\n\nAre you sure you want to continue?"
		Else
			msg = "This key is already mapped to:\n\"" + conflictControl + "\"\n\nAre you sure you want to continue?"
		EndIf

		bContinue = ShowMessage(msg, True, "$Yes", "$No")
	EndIf

	If(bContinue)
		Return True
	Else
		Return False
	EndIf
EndFunction

State stHotkeyTween
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 3
		;/
		If(CheckConflict(newKeyCode, conflictControl, conflictName))
			UnregisterForKey(iHotkeyMenu[3])
			iHotkeyMenu[3] = newKeyCode
			SetKeyMapOptionValueST(iHotkeyMenu[3])
			RegisterForKey(iHotkeyMenu[3])
		EndIf
		/;
		
		;UnregisterForKey(iHotkeyMenu[iIndex])
		iHotkeyMenu[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeyMenu[iIndex])
		SetKeyMapOptionValueST(iHotkeyMenu[iIndex])
		;RegisterForKey(iHotkeyMenu[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 3
		Int iDefault = 15
		UnregisterForKey(iHotkeyMenu[iIndex])
		iHotkeyMenu[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeyMenu[iIndex])
		If(iHotkeyMenu[iIndex] != -1)
			RegisterForKey(iHotkeyMenu[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyTween)
	EndEvent
EndState

State stResetModels
	Event OnSelectST()
		Utility.Wait(0.1)
		Utility.Wait(0.1)
		Utility.Wait(0.1)
		audioUI.Mute()
		Game.DisablePlayerControls()
		Bool bDrawn = kPlayer.IsWeaponDrawn()
		If(bDrawn)
			Sheathe()
		EndIf
		Form kLeftHand = kPlayer.GetEquippedObject(0)
		Form kRightHand = kPlayer.GetEquippedObject(1)
		DisableTweak()
		SkyUI.UnequipHand(0)
		SkyUI.UnequipHand(1)
		EnableTweak()
		If(kLeftHand as Spell)
			kPlayer.EquipSpell((kLeftHand as Spell), 0)
		Else
			kPlayer.EquipItemEx(kLeftHand, 2)
		EndIf
		If(kRightHand as Spell)
			kPlayer.EquipSpell((kRightHand as Spell), 1)
		Else
			kPlayer.EquipItemEx(kRightHand, 1)
		EndIf
		If(bDrawn)
			Draw()
		EndIf
		Game.EnablePlayerControls()
		audioUI.Unmute()
	EndEvent
	
	Event OnHighlightST()
		SetInfoText(sInfoResetModels)
	EndEvent
EndState

State stInitSetup
	Event OnSelectST()
		InitializeMod()
	EndEvent
	
	Event OnHighlightST()
		SetInfoText(sInfoInitSetup)
	EndEvent
EndState

State stHotkeyGroup1
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 0
		;UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeySkyUI[iIndex])
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		;RegisterForKey(iHotkeySkyUI[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 0
		Int iDefault = 59
		UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		If(iHotkeySkyUI[iIndex] != -1)
			RegisterForKey(iHotkeySkyUI[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyGroup +"F1.")
	EndEvent
EndState

State stHotkeyGroup2
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 1
		;UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeySkyUI[iIndex])
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		;RegisterForKey(iHotkeySkyUI[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 1
		Int iDefault = 60
		UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		If(iHotkeySkyUI[iIndex] != -1)
			RegisterForKey(iHotkeySkyUI[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyGroup +"F2.")
	EndEvent
EndState

State stHotkeyGroup3
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 2
		;UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeySkyUI[iIndex])
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		;RegisterForKey(iHotkeySkyUI[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 2
		Int iDefault = 61
		UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		If(iHotkeySkyUI[iIndex] != -1)
			RegisterForKey(iHotkeySkyUI[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyGroup +"F3.")
	EndEvent
EndState

State stHotkeyGroup4
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 3
		;UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeySkyUI[iIndex])
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		;RegisterForKey(iHotkeySkyUI[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 3
		Int iDefault = 62
		UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		If(iHotkeySkyUI[iIndex] != -1)
			RegisterForKey(iHotkeySkyUI[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyGroup +"F4.")
	EndEvent
EndState

State stHotkeyGroup5
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 4
		;UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeySkyUI[iIndex])
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		;RegisterForKey(iHotkeySkyUI[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 4
		Int iDefault = -1
		UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		If(iHotkeySkyUI[iIndex] != -1)
			RegisterForKey(iHotkeySkyUI[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyGroup +"None.")
	EndEvent
EndState

State stHotkeyGroup6
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 5
		;UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeySkyUI[iIndex])
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		;RegisterForKey(iHotkeySkyUI[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 5
		Int iDefault = -1
		UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		If(iHotkeySkyUI[iIndex] != -1)
			RegisterForKey(iHotkeySkyUI[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyGroup +"None.")
	EndEvent
EndState

State stHotkeyGroup7
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 6
		;UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeySkyUI[iIndex])
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		;RegisterForKey(iHotkeySkyUI[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 6
		Int iDefault = -1
		UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		If(iHotkeySkyUI[iIndex] != -1)
			RegisterForKey(iHotkeySkyUI[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyGroup +"None.")
	EndEvent
EndState

State stHotkeyGroup8
	Event OnKeyMapChangeST(Int newKeyCode, String conflictControl, String conflictName)
		Int iIndex = 7
		;UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = CheckForConflict(newKeyCode, conflictControl, conflictName, iHotkeySkyUI[iIndex])
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		;RegisterForKey(iHotkeySkyUI[iIndex])
	EndEvent

	Event OnDefaultST()
		Int iIndex = 7
		Int iDefault = -1
		UnregisterForKey(iHotkeySkyUI[iIndex])
		iHotkeySkyUI[iIndex] = iDefault
		SetKeyMapOptionValueST(iHotkeySkyUI[iIndex])
		If(iHotkeySkyUI[iIndex] != -1)
			RegisterForKey(iHotkeySkyUI[iIndex])
		EndIf
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoHotkeyGroup +"None.")
	EndEvent
EndState

State stHotkeyGroupSheet
	Event OnSelectST()
		If(iMCM_Group_Sheet < 1)
			iMCM_Group_Sheet += 1
		Else
			iMCM_Group_Sheet = 0
		EndIf
		ForcePageReset()
	EndEvent

	Event OnHighlightST()
		If(iMCM_Group_Sheet == 0)
			SetInfoText("")
		ElseIf(iMCM_Group_Sheet == 1)
			SetInfoText("")
		ElseIf(iMCM_Group_Sheet == 2)
			SetInfoText("")
		EndIf
	EndEvent
EndState

State stHideUnequippedGroup1
	Event OnSelectST()
		Int iIndex = 0
		bGroupHideUnequipped[iIndex] = !bGroupHideUnequipped[iIndex]
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent
	
	Event OnDefaultST()
		Int iIndex = 0
		bGroupHideUnequipped[iIndex] = False
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupHideUnequipped)
	EndEvent
EndState

State stHideUnequippedGroup2
	Event OnSelectST()
		Int iIndex = 1
		bGroupHideUnequipped[iIndex] = !bGroupHideUnequipped[iIndex]
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent
	
	Event OnDefaultST()
		Int iIndex = 1
		bGroupHideUnequipped[iIndex] = False
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupHideUnequipped)
	EndEvent
EndState

State stHideUnequippedGroup3
	Event OnSelectST()
		Int iIndex = 2
		bGroupHideUnequipped[iIndex] = !bGroupHideUnequipped[iIndex]
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent
	
	Event OnDefaultST()
		Int iIndex = 2
		bGroupHideUnequipped[iIndex] = False
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupHideUnequipped)
	EndEvent
EndState

State stHideUnequippedGroup4
	Event OnSelectST()
		Int iIndex = 3
		bGroupHideUnequipped[iIndex] = !bGroupHideUnequipped[iIndex]
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent
	
	Event OnDefaultST()
		Int iIndex = 3
		bGroupHideUnequipped[iIndex] = False
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupHideUnequipped)
	EndEvent
EndState

State stHideUnequippedGroup5
	Event OnSelectST()
		Int iIndex = 4
		bGroupHideUnequipped[iIndex] = !bGroupHideUnequipped[iIndex]
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent
	
	Event OnDefaultST()
		Int iIndex = 4
		bGroupHideUnequipped[iIndex] = False
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupHideUnequipped)
	EndEvent
EndState

State stHideUnequippedGroup6
	Event OnSelectST()
		Int iIndex = 5
		bGroupHideUnequipped[iIndex] = !bGroupHideUnequipped[iIndex]
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent
	
	Event OnDefaultST()
		Int iIndex = 5
		bGroupHideUnequipped[iIndex] = False
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupHideUnequipped)
	EndEvent
EndState

State stHideUnequippedGroup7
	Event OnSelectST()
		Int iIndex = 6
		bGroupHideUnequipped[iIndex] = !bGroupHideUnequipped[iIndex]
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent
	
	Event OnDefaultST()
		Int iIndex = 6
		bGroupHideUnequipped[iIndex] = False
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupHideUnequipped)
	EndEvent
EndState

State stHideUnequippedGroup8
	Event OnSelectST()
		Int iIndex = 7
		bGroupHideUnequipped[iIndex] = !bGroupHideUnequipped[iIndex]
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent
	
	Event OnDefaultST()
		Int iIndex = 7
		bGroupHideUnequipped[iIndex] = False
		SetToggleOptionValueST(bGroupHideUnequipped[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupHideUnequipped)
	EndEvent
EndState

State stUnequipOffHandGroup1
	Event OnSelectST()
		Int iIndex = 0
		bGroupUnequipOffHand[iIndex] = !bGroupUnequipOffHand[iIndex]
		SetToggleOptionValueST(bGroupUnequipOffHand[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupUnequipOffHand)
	EndEvent
EndState

State stUnequipOffHandGroup2
	Event OnSelectST()
		Int iIndex = 1
		bGroupUnequipOffHand[iIndex] = !bGroupUnequipOffHand[iIndex]
		SetToggleOptionValueST(bGroupUnequipOffHand[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupUnequipOffHand)
	EndEvent
EndState

State stUnequipOffHandGroup3
	Event OnSelectST()
		Int iIndex = 2
		bGroupUnequipOffHand[iIndex] = !bGroupUnequipOffHand[iIndex]
		SetToggleOptionValueST(bGroupUnequipOffHand[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupUnequipOffHand)
	EndEvent
EndState

State stUnequipOffHandGroup4
	Event OnSelectST()
		Int iIndex = 3
		bGroupUnequipOffHand[iIndex] = !bGroupUnequipOffHand[iIndex]
		SetToggleOptionValueST(bGroupUnequipOffHand[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupUnequipOffHand)
	EndEvent
EndState

State stUnequipOffHandGroup5
	Event OnSelectST()
		Int iIndex = 4
		bGroupUnequipOffHand[iIndex] = !bGroupUnequipOffHand[iIndex]
		SetToggleOptionValueST(bGroupUnequipOffHand[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupUnequipOffHand)
	EndEvent
EndState

State stUnequipOffHandGroup6
	Event OnSelectST()
		Int iIndex = 5
		bGroupUnequipOffHand[iIndex] = !bGroupUnequipOffHand[iIndex]
		SetToggleOptionValueST(bGroupUnequipOffHand[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupUnequipOffHand)
	EndEvent
EndState

State stUnequipOffHandGroup7
	Event OnSelectST()
		Int iIndex = 6
		bGroupUnequipOffHand[iIndex] = !bGroupUnequipOffHand[iIndex]
		SetToggleOptionValueST(bGroupUnequipOffHand[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupUnequipOffHand)
	EndEvent
EndState

State stUnequipOffHandGroup8
	Event OnSelectST()
		Int iIndex = 7
		bGroupUnequipOffHand[iIndex] = !bGroupUnequipOffHand[iIndex]
		SetToggleOptionValueST(bGroupUnequipOffHand[iIndex])
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoGroupUnequipOffHand)
	EndEvent
EndState

State stAlternativeMechanism
	Event OnSelectST()
		Int iIndex = 7
		bMCM_AlternativeMechanism = !bMCM_AlternativeMechanism
		If(bMCM_AlternativeMechanism)
			SetOptionFlagsST(OPTION_FLAG_DISABLED, False, "stAutomatedMechanism")
		Else
			SetOptionFlagsST(OPTION_FLAG_NONE, False, "stAutomatedMechanism")
		EndIf
		SetToggleOptionValueST(bMCM_AlternativeMechanism)
	EndEvent
	
	Event OnDefaultST()
		bMCM_AlternativeMechanism = False
		SetToggleOptionValueST(bMCM_AlternativeMechanism)
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoAlternativeMechanism)
	EndEvent
EndState

State stAutomatedMechanism
	Event OnSelectST()
		bMCM_AutomatedMechanism = !bMCM_AutomatedMechanism
		If(bMCM_AutomatedMechanism)
			SetOptionFlagsST(OPTION_FLAG_DISABLED, False, "stAlternativeMechanism")
		Else
			SetOptionFlagsST(OPTION_FLAG_NONE, False, "stAlternativeMechanism")
		EndIf
		SetToggleOptionValueST(bMCM_AutomatedMechanism)
	EndEvent
	
	Event OnDefaultST()
		bMCM_AutomatedMechanism = False
		SetToggleOptionValueST(bMCM_AutomatedMechanism)
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoAutomatedMechanism)
	EndEvent
EndState

State stContainerMechanism
	Event OnSelectST()
		bMCM_ContainerMechanism = !bMCM_ContainerMechanism
		SetToggleOptionValueST(bMCM_ContainerMechanism)
	EndEvent
	
	Event OnDefaultST()
		bMCM_ContainerMechanism = True
		SetToggleOptionValueST(bMCM_ContainerMechanism)
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoContainerMenu)
	EndEvent
EndState

State stUnmapNative
	Event OnSelectST()
		Int iIndex = 0
		While(iIndex < 8)
			UnregisterForKey(iHotkeyVanilla[iIndex])
			iHotkeyVanilla[iIndex] = -1
			iIndex += 1
		EndWhile
		iIndex = 0
		While(iIndex < 4)
			UnregisterForKey(iHotkeyMenu[iIndex])
			iHotkeyMenu[iIndex] = -1
			iIndex += 1
		EndWhile
		SetToggleOptionValueST(iHotkeyVanilla[0], True, "stHotkeyNative1")
		SetToggleOptionValueST(iHotkeyVanilla[1], True, "stHotkeyNative2")
		SetToggleOptionValueST(iHotkeyVanilla[2], True, "stHotkeyNative3")
		SetToggleOptionValueST(iHotkeyVanilla[3], True, "stHotkeyNative4")
		SetToggleOptionValueST(iHotkeyVanilla[4], True, "stHotkeyNative5")
		SetToggleOptionValueST(iHotkeyVanilla[5], True, "stHotkeyNative6")
		SetToggleOptionValueST(iHotkeyVanilla[6], True, "stHotkeyNative7")
		SetToggleOptionValueST(iHotkeyVanilla[7], True, "stHotkeyNative8")
		SetToggleOptionValueST(iHotkeyMenu[0], True, "stHotkeyFavorites")
		SetToggleOptionValueST(iHotkeyMenu[1], True, "stHotkeyInventory")
		SetToggleOptionValueST(iHotkeyMenu[2], True, "stHotkeyMagic")
		SetToggleOptionValueST(iHotkeyMenu[3], False, "stHotkeyTween")
		ForcePageReset()
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoUnmap)
	EndEvent
EndState

State stUnmapGroup
	Event OnSelectST()
		Int iIndex = 0
		While(iIndex < 8)
			UnregisterForKey(iHotkeySkyUI[iIndex])
			iHotkeySkyUI[iIndex] = -1
			iIndex += 1
		EndWhile
		SetToggleOptionValueST(iHotkeySkyUI[0], True, "stHotkeyGroup1")
		SetToggleOptionValueST(iHotkeySkyUI[1], True, "stHotkeyGroup2")
		SetToggleOptionValueST(iHotkeySkyUI[2], True, "stHotkeyGroup3")
		SetToggleOptionValueST(iHotkeySkyUI[3], True, "stHotkeyGroup4")
		SetToggleOptionValueST(iHotkeySkyUI[4], True, "stHotkeyGroup5")
		SetToggleOptionValueST(iHotkeySkyUI[5], True, "stHotkeyGroup6")
		SetToggleOptionValueST(iHotkeySkyUI[6], True, "stHotkeyGroup7")
		SetToggleOptionValueST(iHotkeySkyUI[7], False, "stHotkeyGroup8")
		ForcePageReset()
	EndEvent

	Event OnHighlightST()
		SetInfoText(sInfoUnmap)
	EndEvent
EndState

State stClearHideUnequippedGroups
	Event OnSelectST()
		Int iIndex = 0
		While(iIndex < 8)
			bGroupHideUnequipped[iIndex] = False
			iIndex += 1
		EndWhile
		SetToggleOptionValueST(bGroupHideUnequipped[0], True, "stHideUnequippedGroup1")
		SetToggleOptionValueST(bGroupHideUnequipped[1], True, "stHideUnequippedGroup2")
		SetToggleOptionValueST(bGroupHideUnequipped[2], True, "stHideUnequippedGroup3")
		SetToggleOptionValueST(bGroupHideUnequipped[3], True, "stHideUnequippedGroup4")
		SetToggleOptionValueST(bGroupHideUnequipped[4], True, "stHideUnequippedGroup5")
		SetToggleOptionValueST(bGroupHideUnequipped[5], True, "stHideUnequippedGroup6")
		SetToggleOptionValueST(bGroupHideUnequipped[6], True, "stHideUnequippedGroup7")
		SetToggleOptionValueST(bGroupHideUnequipped[7], False, "stHideUnequippedGroup8")
		ForcePageReset()
	EndEvent
	
	Event OnHighlightST()
		SetInfoText(sInfoClearHideUnequippedGroups)
	EndEvent
EndState

State stOverrideSensitivity
	Event OnSliderOpenST()
		SetSliderDialogStartValue(fOverrideSensitivity)
		SetSliderDialogDefaultValue(0.5)
		SetSliderDialogRange(0.0, 5.0)
		SetSliderDialogInterval(0.05)
	EndEvent
	
	Event OnSliderAcceptST(Float afValue)
		fOverrideSensitivity = afValue
		SetSliderOptionValueST(fOverrideSensitivity, sFormatOverrideSensitivity)
	EndEvent
	
	Event OnDefaultST()
		fOverrideSensitivity = 0.5
		SetSliderOptionValueST(fOverrideSensitivity, sFormatOverrideSensitivity)
	EndEvent
	
	Event OnHighlightST()
		SetInfoText(sInfoOverrideSensitivity)
	EndEvent
EndState
		
State stHelpInitSetup
	Event OnSelectST()
		ShowMessage("You need to favorite an item called 'All Geared Up Token' for this mod to work properly.\n\nGo to the 'Settings' page and click on the option called 'Initial setup'. Go back into the game and a message will pop up with further instructions.\n\nThe 'Initial Setup' option can also be used to redo the setup, if the token somehow stops being a favorited item.", False)
	EndEvent
EndState

State stHelpHotkeys
	Event OnSelectST()
		ShowMessage("Hotkeys, both Skyrim's and SkyUI's, should from now on be set in this mod's configuration menu. SkyUI's configuration menu should show the Favorite Group hotkeys as unassigned at all times and Skyrim's hotkeys should be moved to other keys, which has been done by the files included in this mod. D-Pad Down has also been unmapped so that it can be used as a custom hotkey (see Gamepad - Compatibility).", False)
	EndEvent
EndState

State stHelpSkyUIHideUnequipped
	Event OnSelectST()
		ShowMessage("Each Favorite Group has a setting called 'Hide unequipped weapons'. Any group, which contains armor/clothing and has this setting enabled, will disable the bDisableGearedUp tweak and hide all unequipped weapons. Switching to another group, which has armor/clothing and has this setting disabled, will enable the bDisableGearedUp tweak and show unequipped weapons once again.\n\nThis setting, in conjunction with SkyUI's 'Unequip Armor' option, can be used to create clothing sets for when you are in a city/village and in the wilderness.", False)
	EndEvent
EndState

State stHelpGamepadCompatibility
	Event OnSelectST()
		ShowMessage("Those who use gamepads need to use this mod in a slightly different way due to technical limitations.\n\nNative quick item hotkeys (D-Pad Left/Right by default) cannot be used. SkyUI's Favorite Groups can be used instead. D-Pad Down can now be used as an additional hotkey.\n\nYou should also enable either the 'Alternative mechanism' option or the 'Automated mechanism' option (see their Help articles for more information).", False)
	EndEvent
EndState
State stHelpGamepadAlternative
	Event OnSelectST()
		ShowMessage("The 'Alternative mechanism' option uses another method of opening menus that does not require two sets of hotkeys like the default mechanism does.\n\nThe upside to this option is that it works a lot like the default mechanism does when playing with a keyboard and mouse.\n\nThe downside is that the werewolf and Vampire Lord skill menus cannot be opened and as such this option is not suited for werewolf or Vampire Lord characters.\n\nMenu hotkeys are to be set via this mod's configuration menu.", False)
	EndEvent
EndState

State stHelpGamepadAutomated
	Event OnSelectST()
		ShowMessage("The 'Automated mechanism' option works by closing an opened menu, sheathing any weapon/spell that is drawn and then opening the menu again. Equipped weapons/spells will be drawn once the menu has closed.\n\nThe upside to this option is that the werewolf and Vampire Lord skill menus can be opened.\n\nThe downside is that menus will pop up for a split second before being closed so that the player's weapons/spells can be sheathed.\n\nMenu hotkeys are to be set via Skyrim's settings menu.", False)
	EndEvent
EndState

State stHelpOverrideSensitivity
	Event OnSelectST()
		ShowMessage("This option sets the amount of time that a menu hotkey has to be held down in order to override the automatic sheathing mechanism. Useful for when you just want to pop into a menu in the middle of combat with no intention of switching weapons/spells. To give a reference point: a quick tap of a key is usually registered as taking less than 0.1 seconds.", False)
	EndEvent
EndState

State stHelpContainer
	Event OnSelectST()
		ShowMessage("If this option is enabled, then activating any container or dead NPC should sheathe any drawn weapons/spells before the menu opens.", False)
	EndEvent
EndState

State stHelpResetModels
	Event OnSelectST()
		ShowMessage("If models get stuck in the player's hands, then this option should fix it. Click the option and then go back into the game. If a weapon remains invisible when equipped, then simply unequip and equip the weapon again.", False)
	EndEvent
EndState

;1.1.0
State stAddon1ClearSlots
	Event OnSelectST()
		Utility.Wait(0.1)
		Addon1.ClearAllSlots()
	EndEvent
EndState

;###################################################################################################################################################
;Events
;###################################################################################################################################################

Event OnInit()
	Parent.OnInit()
	audioUI = Game.GetFormFromFile(0x00064451, "Skyrim.esm") as SoundCategory
	bGroupHideUnequipped = New Bool[8]
	bGroupUnequipOffHand = New Bool[8]
	
	iHotkeyVanilla = New Int[8]
	iHotkeyVanilla[0] = 2
	iHotkeyVanilla[1] = 3
	iHotkeyVanilla[2] = 4
	iHotkeyVanilla[3] = 5
	iHotkeyVanilla[4] = 6
	iHotkeyVanilla[5] = 7
	iHotkeyVanilla[6] = 8
	iHotkeyVanilla[7] = 9
	sHotkeyVanillaKeyName = New String[8]
	sHotkeyVanillaKeyName[0] = "Hotkey1"
	sHotkeyVanillaKeyName[1] = "Hotkey2"
	sHotkeyVanillaKeyName[2] = "Hotkey3"
	sHotkeyVanillaKeyName[3] = "Hotkey4"
	sHotkeyVanillaKeyName[4] = "Hotkey5"
	sHotkeyVanillaKeyName[5] = "Hotkey6"
	sHotkeyVanillaKeyName[6] = "Hotkey7"
	sHotkeyVanillaKeyName[7] = "Hotkey8"
	
	iHotkeySkyUI = New Int[8]
	iHotkeySkyUI[0] = 59
	iHotkeySkyUI[1] = 60
	iHotkeySkyUI[2] = 61
	iHotkeySkyUI[3] = 62
	iHotkeySkyUI[4] = -1
	iHotkeySkyUI[5] = -1
	iHotkeySkyUI[6] = -1
	iHotkeySkyUI[7] = -1
	
	iHotkeyMenu = New Int[4]
	iHotkeyMenu[0] = 16 ;Favorites
	iHotkeyMenu[1] = 23 ;Inventory
	iHotkeyMenu[2] = 25 ;Magic
	iHotkeyMenu[3] = 15 ;Tween
	sHotkeyMenuKeyName = New String[4]
	sHotkeyMenuKeyName[0] = "Favorites"
	sHotkeyMenuKeyName[1] = "Quick Inventory"
	sHotkeyMenuKeyName[2] = "Quick Magic"
	sHotkeyMenuKeyName[3] = "Tween Menu"
	sHotkeyMenuName = New String[4]
	sHotkeyMenuName[0] = "FavoritesMenu"
	sHotkeyMenuName[1] = "InventoryMenu"
	sHotkeyMenuName[2] = "MagicMenu"
	sHotkeyMenuName[3] = "TweenMenu"
	
	RefreshRegistrations()
	
	mainHand  = New Form[8]
	offHand = New Form[8]
	mainHandID = New Int[8]
	offHandID = New Int[8]
	iTorch = New Int[8]
	
	Create_2D()
	
	;InitializeMod()
EndEvent

Event OnKeyUp(Int aiKey, Float fTime)
	GoToState("Inert")
	If(!UI.IsMenuOpen("Console") && !UI.IsTextInputEnabled())
		;Debug.Notification("OnKeyUp: " +fTime +" seconds.")
		Int iIndex
		If(iHotkeyVanilla.Find(aiKey) >= 0)
			iIndex = iHotkeyVanilla.Find(aiKey)
			If(IsInAMenu())
				If(UI.IsMenuOpen("FavoritesMenu"))
					Input.TapKey(Input.GetMappedKey(sHotkeyVanillaKeyName[iIndex])) ;Assigning items to hotkeys
				Else
					;Do nothing
				EndIf
			Else
				GoToState("Vanilla")
				ProcessInput(iIndex)
			EndIf
		ElseIf(iHotkeySkyUI.Find(aiKey) >= 0)
			iIndex = iHotkeySkyUI.Find(aiKey)
			If(IsInAMenu())
				;Do nothing
			Else
				GoToState("SkyUI")
				ProcessInput(iIndex)
			EndIf
		ElseIf(iHotkeyMenu.Find(aiKey) >= 0)
			iIndex = iHotkeyMenu.Find(aiKey)
			If(bMCM_AlternativeMechanism) ;Gamepad support enabled
				If(IsInAMenu()) ;Simply tap
					If(iIndex == 4)
						Input.TapKey(Input.GetMappedKey("Pause"))
					ElseIf(UI.IsMenuOpen(sHotkeyMenuName[iIndex]))
						Input.TapKey(Input.GetMappedKey("Pause"))
					Else
						UnregisterForMenus()
						Input.TapKey(Input.GetMappedKey("Pause"))
						While(IsInAMenu())
							Utility.WaitMenuMode(0.2)
						EndWhile
						RegisterForMenu(sHotkeyMenuName[iIndex])
						Utility.Wait(0.2)
						UI.InvokeString("HUD Menu", "_global.skse.OpenMenu", sHotkeyMenuName[iIndex])
					EndIf
				Else
					If(fTime >= fOverrideSensitivity)
						UI.InvokeString("HUD Menu", "_global.skse.OpenMenu", sHotkeyMenuName[iIndex])
					Else
						GoToState("MenuGamepad")
						ProcessInput(iIndex)
					EndIf
				EndIf
			Else
				If(IsInAMenu()) ;Simply tap
					Input.TapKey(Input.GetMappedKey(sHotkeyMenuKeyName[iIndex]))
				Else
					If(fTime >= fOverrideSensitivity)
						Input.TapKey(Input.GetMappedKey(sHotkeyMenuKeyName[iIndex]))
					Else
						GoToState("Menu")
						ProcessInput(iIndex)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	GoToState("")
EndEvent

Event OnGroupAdd(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	Int iIndex = a_numArg as Int
	Int iItemID = a_strArg as Int
	Form kItem = SkyUI.GetFormFromItemID(iIndex, iItemID)
	If(!(kItem as Weapon) && !(kItem as Spell))
		If(kItem == kTorch)
			iTorch[iIndex] = iItemID
			;Debug.Notification("Torch (" +iItemID +") added to group " +(iIndex + 1))
		EndIf
		If((kItem as Armor).IsShield())
			If(GetArrayFromID(iIndex).Find(iItemId) == -1)
				;Debug.Notification("Returned index = " +GetArrayFromID(iIndex).Find(iItemId))
				Int i = 0
				While(i < 16)
					If(IsEmpty_2D(iIndex, i))
						;Debug.Notification("Before: " +GetArrayFromID(iIndex)[i])
						Write_2D(iIndex, i, iItemID)
						;Debug.Notification("Added a shield (" +iItemID +") to group " +(iIndex + 1))
						;Debug.Notification("After: " +GetArrayFromID(iIndex)[i])
						i = 16
					Else
						i += 1
					EndIf
				EndWhile
			Else
				;Debug.Notification("Shield is already in array")
			EndIf
		EndIf
		return
	EndIf
	If(!(mainHand[iIndex]))
		mainHand[iIndex] = kItem
		mainHandID[iIndex] = iItemID
	ElseIf(!(offHand[iIndex]))
		offHand[iIndex] = kItem
		offHandID[iIndex] = iItemID
	EndIf
	;Debug.Notification("OnGroupAdd - Group index: " +iIndex +", Right: " +mainHand[iIndex].GetName() +", Left: " +offHand[iIndex].GetName())
EndEvent

Event OnGroupRemove(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	Int iIndex = a_numArg as Int
	Int iItemID = a_strArg as Int
	If(iItemID == mainHandID[iIndex])
		mainHand[iIndex] = None
		mainHandID[iIndex] = 0
		If(iItemID == offHandID[iIndex])
			offHand[iIndex] = None
			offHandID[iIndex] = 0
		Else
			If(kPlayer.GetItemCount(offHand[iIndex]) > 1)
				mainHand[iIndex] = offHand[iIndex]
				mainHandID[iIndex] = offHandID[iIndex]
			Else
				mainHand[iIndex] = offHand[iIndex]
				offHand[iIndex] = None
				mainHandID[iIndex] = offHandID[iIndex]
				offHandID[iIndex] = 0
			EndIf
		EndIf
	ElseIf(iItemID == offHandID[iIndex])
		offHand[iIndex] = None
		offHandID[iIndex] = 0
	ElseIf(iTorch[iIndex] == iItemID)
		iTorch[iIndex] = 0
		;Debug.Notification("Torch (" +iItemID +") removed from group " +(iIndex + 1))
	Else
		Int i = GetArrayFromID(iIndex).Find(iItemID)
		If(i != -1)
			;Debug.Notification("Before: " +GetArrayFromID(iIndex)[i])
			Clear_2D(iIndex, i)
			;Debug.Notification("Removed a shield (" +iItemID +") from group " +(iIndex + 1) +" at index " +i)
			;Debug.Notification("After: " +GetArrayFromID(iIndex)[i])
			ArraySort(GetArrayFromID(iIndex))
			;Debug.Notification("After sorting: " +GetArrayFromID(iIndex)[i])
		EndIF
	EndIf
	;Debug.Notification("OnGroupRemove - Group index: " +iIndex +", Right: " +mainHand[iIndex].GetName() +", Left: " +offHand[iIndex].GetName())
EndEvent

Event OnSaveEquipState(string a_eventName, string a_strArg, float a_numArg, Form a_sender)
	Int iIndex = a_numArg as Int
	Int iItemID = a_strArg as Int
	
	int mainHandItemId = UI.GetInt("FavoritesMenu", "_root.MenuHolder.Menu_mc.rightHandItemId")
	int offHandItemId = UI.GetInt("FavoritesMenu", "_root.MenuHolder.Menu_mc.leftHandItemId")
	;Debug.Notification("OnSaveEquipState - Group index: " +iIndex +", Right hand ID: " +mainHandItemId +", Left hand ID: " +offHandItemId)
	Form kmainHandItem = SkyUI.GetFormFromItemID(a_numArg as Int, mainHandItemId)
	Form koffHandItem = SkyUI.GetFormFromItemID(a_numArg as Int, offHandItemId)
	
	If(kmainHandItem)
		mainHand[iIndex] = kmainHandItem
		mainHandID[iIndex] = mainHandItemID
	Else
		mainHand[iIndex] = None
		mainHandID[iIndex] = 0
	EndIf
	If(koffHandItem)
		offHand[iIndex] = koffHandItem
		offHandID[iIndex] = offHandItemID
	Else
		offHand[iIndex] = None
		offHandID[iIndex] = 0
	EndIf
	;Debug.Notification("OnSaveEquipState - Group index: " +iIndex +", Right: " +mainHand[iIndex].GetName() +", Left: " +offHand[iIndex].GetName())
EndEvent

Event OnMenuClose(String asMenuName)
	GoToState("Inert")
	EnableTweak()
	If(bWeaponDrawn)
		Draw()
	EndIf
	UnregisterForMenus()
	GoToState("")
EndEvent

;###################################################################################################################################################
;Functions
;###################################################################################################################################################

Function Delay()
	While(kPlayer.GetAnimationVariableBool("bInJumpState"))
		;Debug.Notification("Jumping/falling")
		Utility.Wait(0.1)
	EndWhile
EndFunction

Function RefreshRegistrations()	
	;Unregister
	UnregisterForKey(iHotkeyVanilla[0])
	UnregisterForKey(iHotkeyVanilla[1])
	UnregisterForKey(iHotkeyVanilla[2])
	UnregisterForKey(iHotkeyVanilla[3])
	UnregisterForKey(iHotkeyVanilla[4])
	UnregisterForKey(iHotkeyVanilla[5])
	UnregisterForKey(iHotkeyVanilla[6])
	UnregisterForKey(iHotkeyVanilla[7])
	UnregisterForKey(iHotkeySkyUI[0])
	UnregisterForKey(iHotkeySkyUI[1])
	UnregisterForKey(iHotkeySkyUI[2])
	UnregisterForKey(iHotkeySkyUI[3])
	UnregisterForKey(iHotkeySkyUI[4])
	UnregisterForKey(iHotkeySkyUI[5])
	UnregisterForKey(iHotkeySkyUI[6])
	UnregisterForKey(iHotkeySkyUI[7])
	UnregisterForKey(iHotkeyMenu[0])
	UnregisterForKey(iHotkeyMenu[1])
	UnregisterForKey(iHotkeyMenu[2])
	UnregisterForKey(iHotkeyMenu[3])
	
	;Register
	RegisterForKey(iHotkeyVanilla[0])
	RegisterForKey(iHotkeyVanilla[1])
	RegisterForKey(iHotkeyVanilla[2])
	RegisterForKey(iHotkeyVanilla[3])
	RegisterForKey(iHotkeyVanilla[4])
	RegisterForKey(iHotkeyVanilla[5])
	RegisterForKey(iHotkeyVanilla[6])
	RegisterForKey(iHotkeyVanilla[7])
	RegisterForKey(iHotkeyMenu[0])
	RegisterForKey(iHotkeyMenu[1])
	RegisterForKey(iHotkeyMenu[2])
	RegisterForKey(iHotkeyMenu[3])
	
	UnregisterForModEvent("SKIFM_groupAdd")
	UnregisterForModEvent("SKIFM_groupRemove")
	UnregisterForModEvent("SKIFM_saveEquipState")
	If(Game.GetModByName("SkyUI.esp") < 255)
		;Debug.Notification("SkyUI detected")
		SkyUI = Game.GetFormFromFile(0x0000082A, "SkyUI.esp") as SKI_FavoritesManager
		If(!bSkyUIHijacked)
			iHotkeySkyUI = SkyUI.GetGroupHotkeys()
			bSkyUIHijacked = True
		EndIf
		SkyUI.SetGroupHotkey(0, -1)
		SkyUI.SetGroupHotkey(1, -1)
		SkyUI.SetGroupHotkey(2, -1)
		SkyUI.SetGroupHotkey(3, -1)
		SkyUI.SetGroupHotkey(4, -1)
		SkyUI.SetGroupHotkey(5, -1)
		SkyUI.SetGroupHotkey(6, -1)
		SkyUI.SetGroupHotkey(7, -1)
		RegisterForModEvent("SKIFM_groupAdd", "OnGroupAdd")
		RegisterForModEvent("SKIFM_groupRemove", "OnGroupRemove")
		RegisterForModEvent("SKIFM_saveEquipState", "OnSaveEquipState")
		RegisterForKey(iHotkeySkyUI[0])
		RegisterForKey(iHotkeySkyUI[1])
		RegisterForKey(iHotkeySkyUI[2])
		RegisterForKey(iHotkeySkyUI[3])
		RegisterForKey(iHotkeySkyUI[4])
		RegisterForKey(iHotkeySkyUI[5])
		RegisterForKey(iHotkeySkyUI[6])
		RegisterForKey(iHotkeySkyUI[7])
	Else
		;Debug.Notification("SkyUI is missing")
		SkyUI = None
	EndIf
	
	If(bHideUnequippedWeapons)
		DisableTweak()
	EndIf
	
	If(Game.GetModByName("All Geared Up - Walking Armory.esp") != 255)
		bAddon1 = True
	Else
		bAddon1 = False
	EndIf
EndFunction

Function InitializeMod()
	Utility.Wait(0.1)
	Utility.Wait(0.1)
	Utility.Wait(0.1)
	Utility.Wait(0.1)
	kPlayer.AddItem(kToken)
	msgSetup.Show()
	Utility.Wait(0.1)
	UI.InvokeString("HUD Menu", "_global.skse.OpenMenu", "InventoryMenu")
	Utility.Wait(0.1)
	While(!Game.IsObjectFavorited(kToken))
		UI.InvokeString("HUD Menu", "_global.skse.OpenMenu", "InventoryMenu")
		Utility.Wait(0.1)
	EndWhile
	kPlayer.RemoveItem(kToken, kPlayer.GetItemCount(kToken), False, kSafeChest)
EndFunction

Function DisableTweak()
	audioUI.Mute()
	Utility.SetINIBool("bDisableGearedUp:General", True)
	kSafeChest.RemoveItem(kToken, 1, True, kPlayer)
	kPlayer.RemoveItem(kToken, kPlayer.GetItemCount(kToken), True, kSafeChest)
	audioUI.Unmute()
EndFunction

Function EnableTweak()
	If(!bHideUnequippedWeapons)
		audioUI.Mute()
		Utility.SetINIBool("bDisableGearedUp:General", False)
		kSafeChest.RemoveItem(kToken, 1, True, kPlayer)
		kPlayer.RemoveItem(kToken, kPlayer.GetItemCount(kToken), True, kSafeChest)
		audioUI.Unmute()
	EndIf
EndFunction

Function RegisterForMenus()
	RegisterForMenu("FavoritesMenu")
	RegisterForMenu("InventoryMenu")
	RegisterForMenu("MagicMenu")
	RegisterForMenu("TweenMenu")
EndFunction

Function UnregisterForMenus()
	UnregisterForMenu("FavoritesMenu")
	UnregisterForMenu("InventoryMenu")
	UnregisterForMenu("MagicMenu")
	UnregisterForMenu("TweenMenu")
EndFunction

Bool Function IsInAMenu()
	If(Utility.IsInMenuMode())
		Return True
	ElseIf(UI.IsMenuOpen("CraftingMenu"))
		Return True
	ElseIf(UI.IsMenuOpen("Dialogue Menu"))
		Return True
	ElseIf(UI.IsMenuOpen("RaceSex Menu"))
		Return True
	ElseIf(UI.IsMenuOpen("Console"))
		Return True
	ElseIf(UI.IsMenuOpen("Console Native UI Menu"))
		Return True
	Else
		Return False
	EndIf
EndFunction

Bool Function IsWeaponOut() ;Check if a weapon/spell is drawn and then automatically sheathe the weapon/spell if so
	If(kPlayer.IsWeaponDrawn())
		Sheathe()
		Return True
	Else
		Return False
	EndIf
EndFunction

Function Sheathe()
	kPlayer.SheatheWeapon()
	While(kPlayer.GetAnimationVariableBool("IsUnequipping"))
		Utility.Wait(0.1)
	EndWhile
EndFunction

Function Draw()
	kPlayer.DrawWeapon()
	While(kPlayer.GetAnimationVariableBool("IsEquipping"))
		Utility.Wait(0.1)
	EndWhile
EndFunction

Function ProcessInput(Int aiKey)
EndFunction

;###################################################################################################################################################
;States
;###################################################################################################################################################

State Vanilla
	Event OnKeyDown(Int aiKey)
		;Debug.Notification("Processing - Vanilla")
	EndEvent
	
	Event OnKeyUp(Int aiKey, Float fTime)
	EndEvent

	Function ProcessInput(Int aiIndex)
		Delay()
		Form kHotkey = Game.GetHotkeyBoundObject(aiIndex)
		If((kHotkey as Weapon) || (kHotkey as Spell))
			bWeaponDrawn = kPlayer.IsWeaponDrawn()
			Bool bRanged = False
			Form kOffHand = kPlayer.GetEquippedObject(0)
			Form kMainHand = kPlayer.GetEquippedObject(1)
			If(kHotkey as Spell)
				If((kHotkey as Spell).GetEquipType() == kTwoHandedSpell.GetEquipType()) ;Two-handed
					If(kMainHand as Weapon)
						Sheathe()
					EndIf
				ElseIf((kHotkey as Spell).GetEquipType() == kVoiceSpell.GetEquipType())
					;Do nothing as the spell is equipped in the voice/shout slot
				Else ;One-handed
					If(kMainHand as Weapon)
						If((kMainHand as Weapon).GetEquipType() == kTwoHandedWeapon.GetEquipType())
							Sheathe()
						ElseIf(kOffHand == kHotkey)
							Sheathe()
						EndIf
					EndIf
				EndIf
			Else ;Weapon
				If((kHotkey as Weapon).GetEquipType() == kTwoHandedWeapon.GetEquipType()) ;Two-handed
					Sheathe()
					If((kHotkey as Weapon).IsBow())
						bRanged = True
						DisableTweak()
					EndIf
				Else ;One-handed
					If(kMainHand as Weapon)
						If(kMainHand != kHotkey)
							Sheathe()
						EndIf
					EndIf
					If(bAddon1)
						Addon1.BeforeVanillaHotkey(kHotkey, bWeaponDrawn)
					EndIf
				EndIf
			EndIf
			Input.TapKey(Input.GetMappedKey(sHotkeyVanillaKeyName[aiIndex]))
			If(bAddon1)
				Addon1.AfterVanillaHotkey(kHotkey, bWeaponDrawn)
			EndIf
			If(bRanged)
				EnableTweak()
			EndIf
			If(bWeaponDrawn)
				Draw()
			EndIf
		ElseIf((kHotkey as Armor).IsShield())
			If(kPlayer.GetEquippedWeapon().GetEquipType() == kTwoHandedWeapon.GetEquipType())
				Sheathe()
			EndIf
			Input.TapKey(Input.GetMappedKey(sHotkeyVanillaKeyName[aiIndex]))
		Else ;Armor/clothing/potion/shout/etc.
			Input.TapKey(Input.GetMappedKey(sHotkeyVanillaKeyName[aiIndex]))
		EndIf
	EndFunction
EndState

State SkyUI
	Event OnKeyDown(Int aiKey)
		;Debug.Notification("Processing - SkyUI")
	EndEvent
	
	Event OnKeyUp(Int aiKey, Float fTime)
	EndEvent

	Function ProcessInput(Int aiIndex)
		Delay()
		bWeaponDrawn = kPlayer.IsWeaponDrawn()
		Bool bRanged = False
		Form kOffHand = kPlayer.GetEquippedObject(0)
		Form kMainHand = kPlayer.GetEquippedObject(1)
		;Debug.Notification("Right hand: " +mainHand[aiIndex].GetName())
		;Debug.Notification("Left hand: " +offHand[aiIndex].GetName())
		
		If(mainHand[aiIndex] as Weapon)
			;Debug.Notification("Main hand weapon")
			If((mainHand[aiIndex] as Weapon).GetEquipType() == kTwoHandedWeapon.GetEquipType())
				Sheathe()
				If((mainHand[aiIndex] as Weapon).IsBow())
					bRanged = True
					DisableTweak()
				EndIf
			Else
				If((kMainHand as Weapon) && (kMainHand != mainHand[aiIndex]))
					Sheathe()
				EndIf
			EndIf
		ElseIf(mainHand[aiIndex] as Spell)
			;Debug.Notification("Main hand spell")
			If(kMainHand as Weapon)
				Sheathe()
			EndIf
		ElseIf(offHand[aiIndex] as Spell)
			;Debug.Notification("Off hand spell")
			If((kMainHand as Weapon).GetEquipType() == kTwoHandedWeapon.GetEquipType())
				Sheathe()
			EndIf
		Else
			;Debug.Notification("Something else")
			If(iTorch[aiIndex] != 0)
				;Debug.Notification("A torch")
				If((kMainHand as Weapon).GetEquipType() == kTwoHandedWeapon.GetEquipType())
					Sheathe()
				EndIf
			ElseIf(!IsEmpty_2D(aiIndex, 0))
				;Debug.Notification("Shield or something")
				If((kMainHand as Weapon).GetEquipType() == kTwoHandedWeapon.GetEquipType())
					Sheathe()
				EndIf
			EndIf
		EndIf
		If(bGroupUnequipOffHand[aiIndex])
			SkyUI.UnequipHand(0)
		EndIf
		;End of regular
		
		If(bAddon1)
			Addon1.BeforeSkyUIHotkey(kMainHand, kOffHand, bWeaponDrawn)
		EndIf
		
		;Hide unequipped weapons
		Form[] kBefore = new Form[14]
		kBefore[0] = kPlayer.GetWornForm(0x00000001) ;as Armor ;Head
		kBefore[1] = kPlayer.GetWornForm(0x00000002) ;as Armor ;Hair
		kBefore[2] = kPlayer.GetWornForm(0x00000004) ;as Armor ;Body
		kBefore[3] = None ;Player.GetWornForm(0x00000008) ;as Armor ;Hands
		kBefore[4] = kPlayer.GetWornForm(0x00000010) ;as Armor ;Forearms
		kBefore[5] = kPlayer.GetWornForm(0x00000020) ;as Armor ;Amulet
		kBefore[6] = kPlayer.GetWornForm(0x00000040) ;as Armor ;Ring
		kBefore[7] = kPlayer.GetWornForm(0x00000080) ;as Armor ;Feet
		kBefore[8] = kPlayer.GetWornForm(0x00000100) ;as Armor ;Calves
		kBefore[9] = None ;Player.GetWornForm(0x00000200) ;as Armor ;Shield
		kBefore[10] = kPlayer.GetWornForm(0x00000400) ;as Armor ;Tail
		kBefore[11] = kPlayer.GetWornForm(0x00000800) ;as Armor ;LongHair
		kBefore[12] = kPlayer.GetWornForm(0x00001000) ;as Armor ;Circlet
		kBefore[13] = kPlayer.GetWornForm(0x00002000) ;as Armor ;Ears
		
		SkyUI.GroupUse(aiIndex)
		
		;Hide unequipped weapons
		Form[] kAfter = new Form[14]
		kAfter[0] = kPlayer.GetWornForm(0x00000001) ;as Armor ;Head
		kAfter[1] = kPlayer.GetWornForm(0x00000002) ;as Armor ;Hair
		kAfter[2] = kPlayer.GetWornForm(0x00000004) ;as Armor ;Body
		kAfter[3] = None ;Player.GetWornForm(0x00000008) ;as Armor ;Hands
		kAfter[4] = kPlayer.GetWornForm(0x00000010) ;as Armor ;Forearms
		kAfter[5] = kPlayer.GetWornForm(0x00000020) ;as Armor ;Amulet
		kAfter[6] = kPlayer.GetWornForm(0x00000040) ;as Armor ;Ring
		kAfter[7] = kPlayer.GetWornForm(0x00000080) ;as Armor ;Feet
		kAfter[8] = kPlayer.GetWornForm(0x00000100) ;as Armor ;Calves
		kAfter[9] = None ;Player.GetWornForm(0x00000200) ;as Armor ;Shield
		kAfter[10] = kPlayer.GetWornForm(0x00000400) ;as Armor ;Tail
		kAfter[11] = kPlayer.GetWornForm(0x00000800) ;as Armor ;LongHair
		kAfter[12] = kPlayer.GetWornForm(0x00001000) ;as Armor ;Circlet
		kAfter[13] = kPlayer.GetWornForm(0x00002000) ;as Armor ;Ears
		
		Bool bChange = False
		Int i = 0
		While(i < 14)
			If(kAfter[i] != kBefore[i])
				bChange = True
				i = 14
				;Debug.Notification("Armor has changed")
			EndIf
			i += 1
		EndWhile
		
		If(bChange && bGroupHideUnequipped[aiIndex]) ;Hide all the favorited weapons
			;Debug.Notification("Hiding weapons")
			bHideUnequippedWeapons = True
			DisableTweak()
			bRanged = False
		ElseIf(bChange && !bGroupHideUnequipped[aiIndex]) ;Show all the favorited weapons
			;Debug.Notification("Showing weapons")
			bHideUnequippedWeapons = False
			EnableTweak()
		EndIf
		
		If(bAddon1)
			Addon1.AfterSkyUIHotkey(kMainHand, kOffHand, bWeaponDrawn)
		EndIf
		
		;Regular again
		If(bRanged)
			EnableTweak()
		EndIf
		If(bWeaponDrawn)
			Draw()
		EndIf
	EndFunction
EndState

State Menu
	Event OnKeyDown(Int aiKey)
		;Debug.Notification("Processing - Menu")
	EndEvent
	
	Event OnKeyUp(Int aiKey, Float fTime)
	EndEvent

	Function ProcessInput(Int aiIndex)
		Delay()
		bWeaponDrawn = IsWeaponOut()
		RegisterForMenu(sHotkeyMenuName[aiIndex])
		DisableTweak()
		Input.TapKey(Input.GetMappedKey(sHotkeyMenuKeyName[aiIndex]))
		If((aiIndex == 0) && (bWeaponDrawn)) ;Draw the weapon again in case nothing has been favorited and thus no menu will appear
			Utility.WaitMenuMode(0.5)
			If(!UI.IsMenuOpen(sHotkeyMenuName[aiIndex]))
				OnMenuClose(sHotkeyMenuName[aiIndex])
			EndIf
		EndIf
	EndFunction
EndState

State MenuGamepad
	Event OnKeyDown(Int aiKey)
		;Debug.Notification("Processing - Menu (Gamepad)")
	EndEvent
	
	Event OnKeyUp(Int aiKey, Float fTime)
	EndEvent
	
	Function ProcessInput(Int aiIndex)
		Delay()
		bWeaponDrawn = IsWeaponOut()
		RegisterForMenu(sHotkeyMenuName[aiIndex])
		DisableTweak()
		UI.InvokeString("HUD Menu", "_global.skse.OpenMenu", sHotkeyMenuName[aiIndex])
		If((aiIndex == 0) && (bWeaponDrawn)) ;Draw the weapon again in case nothing has been favorited and thus no menu will appear
			Utility.WaitMenuMode(0.5)
			If(!UI.IsMenuOpen(sHotkeyMenuName[aiIndex]))
				OnMenuClose(sHotkeyMenuName[aiIndex])
			EndIf
		EndIf
	EndFunction
EndState

State Inert
	Event OnKeyDown(Int aiKey)
	EndEvent
	
	Event OnKeyUp(Int aiKey, Float fTime)
	EndEvent
EndState

State Automated
	Event OnKeyDown(Int aiKey)
	EndEvent
	
	Event OnKeyUp(Int aiKey, Float fTime)
	EndEvent
	
	Event OnMenuOpen(String MenuName)
		GoToState("InertAutomated")
		;Debug.Notification("Automated - Opening - Start")
		bWeaponDrawn = kPlayer.IsWeaponDrawn()
		If(bWeaponDrawn)
			If(MenuName == "FavoritesMenu")
				Input.TapKey(Input.GetMappedKey("Pause"))
			Else
				Game.DisablePlayerControls()
				Game.EnablePlayerControls()
			EndIf
			While(IsInAMenu())
				Utility.WaitMenuMode(0.1)
			EndWhile
			Sheathe()
			Int iIndex = sHotkeyMenuName.Find(MenuName)
			DisableTweak()
			Input.TapKey(Input.GetMappedKey(sHotkeyMenuKeyName[iIndex]))
			GoToState("AutomatedDrawn")
		Else
			DisableTweak()
			GoToState("Automated")
		EndIf
		;Debug.Notification("Automated - Opening - End")
	EndEvent
	
	Event OnMenuClose(String asMenuName)
		GoToState("InertAutomated")
		;Debug.Notification("Automated - Closing - Start")
		EnableTweak()
		;Debug.Notification("Automated - Closing - End")
		GoToState("Automated")
	EndEvent
EndState

State AutomatedDrawn
	Event OnMenuClose(String asMenuName)
		GoToState("InertAutomated")
		EnableTweak()
		Draw()
		GoToState("Automated")
	EndEvent
EndState

State InertAutomated
	Event OnKeyDown(Int aiKey)
	EndEvent
	
	Event OnKeyUp(Int aiKey, Float fTime)
	EndEvent

	Event OnMenuOpen(String MenuName)
	EndEvent
	
	Event OnMenuClose(String MenuName)
	EndEvent
EndState

;###################################################################################################################################################
;2D array framework by Chesko
;###################################################################################################################################################

Int iXSize = 8
Int iYSize = 16

Int[] YNodes0
Int[] YNodes1
Int[] YNodes2
Int[] YNodes3
Int[] YNodes4
Int[] YNodes5
Int[] YNodes6
Int[] YNodes7

function Create_2D()
    ;-----------\
    ;Description \
    ;----------------------------------------------------------------
    ;Creates the 2D array.
    
    ;-------------\
    ;Return Values \
    ;----------------------------------------------------------------
    ;        None.
    
    YNodes0 = new Int[16]        ;Specify integer literal here, must match iYSize
    YNodes1 = new Int[16]
    YNodes2 = new Int[16]
    YNodes3 = new Int[16]
    YNodes4 = new Int[16]
    YNodes5 = new Int[16]
    YNodes6 = new Int[16]
    YNodes7 = new Int[16]
endFunction

Int[] function GetArrayFromID(int iID)
    ;-----------\
    ;Description \
    ;----------------------------------------------------------------
    ;Maps an ID to an array.
    ;These arrays MUST be listed manually by the user in the code
    ;below in order for the rest of the framework to function!
    
    ;-------------\
    ;Return Values \
    ;----------------------------------------------------------------
    ;        None.

    if iID == 0
        return YNodes0
    elseif iID == 1
        return YNodes1
    elseif iID == 2
        return YNodes2
    elseif iID == 3
        return YNodes3
    elseif iID == 4
        return YNodes4
    elseif iID == 5
        return YNodes5
    elseif iID == 6
        return YNodes6
    elseif iID == 7
        return YNodes7
    endif
endFunction

Int function Read_2D(int iX, int iY)
    ;-----------\
    ;Description \
    ;----------------------------------------------------------------
    ;Returns the value at the given indicies.
    
    ;-------------\
    ;Return Values \
    ;----------------------------------------------------------------
    ;        ObjectReference        =    The ObjectReference found.
    ;                                Returns None if not found.

    return GetArrayFromID(iX)[iY]
endFunction

function Write_2D(int iX, int iY, Int akObject)
    ;-----------\
    ;Description \
    ;----------------------------------------------------------------
    ;Writes akObject to the specified indicies.
    
    ;-------------\
    ;Return Values \
    ;----------------------------------------------------------------
    ;        None.

    GetArrayFromID(iX)[iY] = akObject
endFunction

function Clear_2D(int iX, int iY)
    ;-----------\
    ;Description \
    ;----------------------------------------------------------------
    ;Clears (sets to None) the indicies specified in the 2D array.
    
    ;-------------\
    ;Return Values \
    ;----------------------------------------------------------------
    ;        None.

    GetArrayFromID(iX)[iY] = 0
endFunction

bool function IsEmpty_2D(int iX, int iY)
    ;-----------\
    ;Description \
    ;----------------------------------------------------------------
    ;Checks whether or not the field at the given indicies is None.
    
    ;-------------\
    ;Return Values \
    ;----------------------------------------------------------------
    ;        true        =        The field at the indicies is None.
    ;        false        =        The field at the indicies is not None.

    if GetArrayFromID(iX)[iY] == 0
        return true
    else
        return false
    endif
endFunction

bool function ArraySort(Int[] myArray, Int i = 0)

	 ;-----------\
	 ;Description \  Author: Chesko
	 ;----------------------------------------------------------------
	 ;Removes blank elements by shifting all elements down.
	 ;Optionally starts sorting from element i.

	 ;-------------\
	 ;Return Values \
	 ;----------------------------------------------------------------
	 ;		   false		   =			   No sorting required
	 ;		   true			=			   Success

	 bool bFirstNoneFound = false
	 int iFirstNonePos = i
	 while i < myArray.Length
		  if myArray[i] == 0
			   if bFirstNoneFound == false
					bFirstNoneFound = true
					iFirstNonePos = i
					i += 1
			   else
					i += 1
			   endif
		  else
			   if bFirstNoneFound == true
			   ;check to see if it's a couple of blank entries in a row
					if !(myArray[i] == 0)
						 ;notification("Moving element " + i + " to index " + iFirstNonePos)
						 myArray[iFirstNonePos] = myArray[i]
						 myArray[i] = 0
			
						 ;Call this function recursively until it returns
						 ArraySort(myArray, iFirstNonePos + 1)
						 return true
					else
						 i += 1
					endif
			   else
					i += 1
			   endif
		  endif
	 endWhile

	 return false

endFunction
