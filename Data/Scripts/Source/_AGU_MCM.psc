Scriptname _AGU_MCM extends SKI_ConfigBase  

;####################################################################################################################################################
;Properties
;####################################################################################################################################################
GlobalVariable Property gvSettingHotkeysSlotEnabled Auto
GlobalVariable Property gvSettingHotkeysGroupEnabled Auto
GlobalVariable Property gvSettingHotkeysSlotAlternative Auto
GlobalVariable Property gvSettingShieldCloak Auto
GlobalVariable Property gvSettingShieldBackpack Auto
_AGU_System Property AGUSystem Auto

;####################################################################################################################################################
;Variables
;####################################################################################################################################################
;Options
Int[] iOptionHotkeys
Int iOptionHotkeysSlotEnabled
Int iOptionHotkeysGroupEnabled
Int[] iOptionSlotMaskLeft
Int[] iOptionSlotMaskRight
Int iOptionShieldCloak
Int iOptionShieldBackpack
Int iOptionHotkeysSlotAlternative

;Option state variables
Bool bHotkeysSlotEnabled
Bool bHotkeysGroupEnabled
Int[] iSlotMaskLeft
Int[] iSlotMaskRight
Int[] iSlotMaskIndexLeft
Int[] iSlotMaskIndexRight
Bool bShieldCloak = True
Bool bShieldBackpack = True
Bool bHotkeysSlotAlternative = False

;Constants and drop-down menu arrays
Int[] iSlotMasks
String[] sSlotMasksClearText
String[] sSlotLabel

;####################################################################################################################################################
;Events
;####################################################################################################################################################
Event OnInit()
	Parent.OnInit()
	ModName = "All Geared Up"
	Pages = new String[2]
	Pages[0] = "Hotkeys"
	Pages[1] = "Slots"
	iOptionHotkeys = New Int[16]
	iOptionSlotMaskLeft = New Int[9]
	iOptionSlotMaskRight = New Int[9]

	sSlotLabel = New String[9]
	sSlotLabel[0] = "Sword"
	sSlotLabel[1] = "Dagger"
	sSlotLabel[2] = "War Axe"
	sSlotLabel[3] = "Mace"
	sSlotLabel[4] = "Two-handed melee"
	sSlotLabel[5] = "Bow"
	sSlotLabel[6] = "Staff"
	sSlotLabel[7] = "Crossbow"
	sSlotLabel[8] = "Shield"

	iSlotMasks = New Int[16]
	iSlotMasks[0] = 0x00000000 ;-1
	iSlotMasks[1] = 0x00004000 ;44 - Supported by Frostfall.
	iSlotMasks[2] = 0x00008000 ;45 - Ignored by Frostfall. Sword (Left).
	iSlotMasks[3] = 0x00010000 ;46 - Supported by Frostfall. Cloaks use this and biped slot 40. 
	iSlotMasks[4] = 0x00020000 ;47 - Ignored by Frostfall. Backpack.
	iSlotMasks[5] = 0x00040000 ;48 - Ignored by Frostfall. Sword (Right).
	iSlotMasks[6] = 0x00080000 ;49 - Ignored by Frostfall. Dagger (Left).
	iSlotMasks[7] = 0x00400000 ;52 - Ignored by Frostfall. Dagger (Right).
	iSlotMasks[8] = 0x00800000 ;53 - Ignored by Frostfall. War Axe (Left).
	iSlotMasks[9] = 0x01000000 ;54 - Ignored by Frostfall. War Axe (Right).
	iSlotMasks[10] = 0x02000000 ;55 - Ignored by Frostfall. Mace (Left).
	iSlotMasks[11] = 0x04000000 ;56 - Ignored by Frostfall. Mace (Right).
	iSlotMasks[12] = 0x08000000 ;57 - Ignored by Frostfall. Staff (Left).
	iSlotMasks[13] = 0x10000000 ;58 - Ignored by Frostfall. Staff (Right).
	iSlotMasks[14] = 0x20000000 ;59 - Ignored by Frostfall. Two-handed melee.
	iSlotMasks[15] = 0x40000000 ;60 - Ignored by Frostfall. Shield.

	iSlotMaskLeft = New Int[9]
	iSlotMaskLeft[0] = iSlotMasks[2] ;Sword
	iSlotMaskLeft[1] = iSlotMasks[6] ;Dagger
	iSlotMaskLeft[2] = iSlotMasks[8] ;War Axe
	iSlotMaskLeft[3] = iSlotMasks[10] ;Mace
	;iSlotMaskLeft[4] = iSlotMasks[]
	;iSlotMaskLeft[5] = iSlotMasks[]
	iSlotMaskLeft[6] = iSlotMasks[12] ;Staff
	;iSlotMaskLeft[7] = iSlotMasks[]
	iSlotMaskLeft[8] = iSlotMasks[15] ;Shield

	iSlotMaskRight = New Int[9]
	iSlotMaskRight[0] = iSlotMasks[5] ;Sword
	iSlotMaskRight[1] = iSlotMasks[7] ;Dagger
	iSlotMaskRight[2] = iSlotMasks[9] ;War Axe
	iSlotMaskRight[3] = iSlotMasks[11] ;Mace
	iSlotMaskRight[4] = iSlotMasks[14] ;Two-handed
	;iSlotMaskRight[5] = iSlotMasks[]
	iSlotMaskRight[6] = iSlotMasks[13] ;Staff
	;iSlotMaskRight[7] = iSlotMasks[]
	;iSlotMaskRight[8] = iSlotMasks[]

	sSlotMasksClearText = New String[16]
	sSlotMasksClearText[0] = "Disabled"
	sSlotMasksClearText[1] = "44"
	sSlotMasksClearText[2] = "45"
	sSlotMasksClearText[3] = "46"
	sSlotMasksClearText[4] = "47"
	sSlotMasksClearText[5] = "48"
	sSlotMasksClearText[6] = "49"
	sSlotMasksClearText[7] = "52"
	sSlotMasksClearText[8] = "53"
	sSlotMasksClearText[9] = "54"
	sSlotMasksClearText[10] = "55"
	sSlotMasksClearText[11] = "56"
	sSlotMasksClearText[12] = "57"
	sSlotMasksClearText[13] = "58"
	sSlotMasksClearText[14] = "59"
	sSlotMasksClearText[15] = "60"

	iSlotMaskIndexLeft = New Int[9]
	iSlotMaskIndexLeft[0] = 2
	iSlotMaskIndexLeft[1] = 6
	iSlotMaskIndexLeft[2] = 8
	iSlotMaskIndexLeft[3] = 10
	iSlotMaskIndexLeft[4] = -2
	iSlotMaskIndexLeft[5] = -2
	iSlotMaskIndexLeft[6] = 12
	iSlotMaskIndexLeft[7] = -2
	iSlotMaskIndexLeft[8] = 15

	iSlotMaskIndexRight = New Int[9]
	iSlotMaskIndexRight[0] = 5
	iSlotMaskIndexRight[1] = 7
	iSlotMaskIndexRight[2] = 9
	iSlotMaskIndexRight[3] = 11
	iSlotMaskIndexRight[4] = 14
	iSlotMaskIndexRight[5] = -2
	iSlotMaskIndexRight[6] = 13
	iSlotMaskIndexRight[7] = -2
	iSlotMaskIndexRight[8] = -2
EndEvent

Event OnPageReset(String asPage)
	SetCursorFillMode(TOP_TO_BOTTOM)
	Int i = 0
	If(asPage == "Hotkeys")
		;Update variables
		bHotkeysSlotEnabled = gvSettingHotkeysSlotEnabled.GetValueInt() as Bool
		bHotkeysGroupEnabled = gvSettingHotkeysGroupEnabled.GetValueInt() as Bool
		bHotkeysSlotAlternative = gvSettingHotkeysSlotAlternative.GetValueInt() as Bool

		;Draw the menu
		SetCursorPosition(0)
		iOptionHotkeysSlotEnabled = AddToggleOption("Quick slot hotkeys", bHotkeysSlotEnabled)
		i = 0
		While(i < 8)
			String sLabel = "Quick slot " + (i + 1)
			iOptionHotkeys[i] = AddKeyMapOption(sLabel, AGUSystem.iHotkeySlot[i], OPTION_FLAG_WITH_UNMAP)
			i += 1
		EndWhile
		iOptionHotkeysSlotAlternative = AddToggleOption("Alternative mode", bHotkeysSlotAlternative)

		SetCursorPosition(1)
		iOptionHotkeysGroupEnabled = AddToggleOption("SkyUI group hotkeys", bHotkeysGroupEnabled)
		i = 8
		While(i < 16)
			String sLabel = "SkyUI group " + (i - 7)
			iOptionHotkeys[i] = AddKeyMapOption(sLabel, AGUSystem.iHotkeySlot[i], OPTION_FLAG_WITH_UNMAP)
			i += 1
		EndWhile
	ElseIf(asPage == "Slots")
		;Update variables
		bShieldCloak = gvSettingShieldCloak.GetValueInt() as Bool
		bShieldBackpack = gvSettingShieldBackpack.GetValueInt() as Bool

		;Draw the menu
		SetCursorPosition(0)
		AddHeaderOption("Left hand")
		i = 0
		While(i < 9)
			Int iIndex = iSlotMaskIndexLeft[i]
			If(iIndex != -2)
				iOptionSlotMaskLeft[i] = AddMenuOption(sSlotLabel[i], sSlotMasksClearText[iIndex])
			Else
				iOptionSlotMaskLeft[i] = AddMenuOption(sSlotLabel[i], "Not supported", OPTION_FLAG_DISABLED)
			EndIf
			i += 1
		EndWhile
		AddHeaderOption("Shields")
		iOptionShieldCloak = AddToggleOption("Accomodate cloaks", bShieldCloak)
		iOptionShieldBackpack = AddToggleOption("Accomodate backpacks", bShieldBackpack)

		SetCursorPosition(1)
		AddHeaderOption("Right hand")
		i = 0
		While(i < 9)
			Int iIndex = iSlotMaskIndexRight[i]
			If(iIndex != -2)
				iOptionSlotMaskRight[i] = AddMenuOption(sSlotLabel[i], sSlotMasksClearText[iIndex])
			Else
				iOptionSlotMaskRight[i] = AddMenuOption(sSlotLabel[i], "Not supported", OPTION_FLAG_DISABLED)
			EndIf
			i += 1
		EndWhile
	EndIf
EndEvent

Event OnOptionKeyMapChange(Int aiOption, Int aiKeyCode, string a_conflictControl, string a_conflictName)
	If(iOptionHotkeys.Find(aiOption) >= 0)
		Int iIndex = iOptionHotkeys.Find(aiOption)
		Bool bContinue = True
		If(a_conflictControl != "")
			String sMSG
			If(a_conflictName != "")
				sMSG = "This key is already mapped to:\n'" + a_conflictControl + "'\n(" + a_conflictName + ")\n\nAre you sure you want to continue?"
			Else
				sMSG = "This key is already mapped to:\n'" + a_conflictControl + "'\n\nAre you sure you want to continue?"
			EndIf
			bContinue = ShowMessage(sMSG, True, "$Yes", "$No")
		EndIf
		If(bContinue)
			AGUSystem.iHotkeySlot[iIndex] = aiKeyCode
			AGUSystem.UnregisterForAllKeys()
			AGUSystem.SetupHotkeys()
			SetKeyMapOptionValue(aiOption, aiKeyCode)
		EndIf
	Else
		
	EndIf
EndEvent

Event OnOptionMenuOpen(Int aiOption)
	If((iOptionSlotMaskLeft.Find(aiOption) >= 0) || (iOptionSlotMaskRight.Find(aiOption) >= 0))
		If(iOptionSlotMaskLeft.Find(aiOption) >= 0)
			SetMenuDialogStartIndex(iSlotMaskIndexLeft[iOptionSlotMaskLeft.Find(aiOption)])
		Else
			SetMenuDialogStartIndex(iSlotMaskIndexRight[iOptionSlotMaskRight.Find(aiOption)])
		EndIf
		SetMenuDialogDefaultIndex(1)
		SetMenuDialogOptions(sSlotMasksClearText)
	EndIf
EndEvent

Event OnOptionMenuAccept(Int aiOption, Int aiIndex)
	If((iOptionSlotMaskLeft.Find(aiOption) >= 0) || (iOptionSlotMaskRight.Find(aiOption) >= 0))
		If(iOptionSlotMaskLeft.Find(aiOption) >= 0)
			Int iIndex = iOptionSlotMaskLeft.Find(aiOption)
			Int iOldSlotMask = iSlotMasks[iSlotMaskIndexLeft[iIndex]]
			Int iNewSlotMask = iSlotMasks[aiIndex]
			iSlotMaskIndexLeft[iIndex] = aiIndex
			If(iOldSlotMask != iNewSlotMask)
				If(iOldSlotMask == 0x00000000) ;Enabling
					AGUSystem.EnableSlot(iIndex, True)
				EndIf
				If(AGUSystem.kSlotVisualLeft[iIndex])
					If(iOldSlotMask != 0x00000000)
						AGUSystem.kSlotVisualLeft[iIndex].RemoveSlotFromMask(iOldSlotMask)
						AGUSystem.kSlotVisualLeft[iIndex].GetNthArmorAddon(0).RemoveSlotFromMask(iOldSlotMask)
					EndIf
					If(iNewSlotMask != 0x00000000)
						AGUSystem.kSlotVisualLeft[iIndex].AddSlotToMask(iNewSlotMask)
						AGUSystem.kSlotVisualLeft[iIndex].GetNthArmorAddon(0).AddSlotToMask(iNewSlotMask)
					EndIf
				EndIf
				If(iNewSlotMask == 0x00000000) ;Disabling
					AGUSystem.DisableSlot(iIndex, True)
				EndIf
			EndIf
		Else
			Int iIndex = iOptionSlotMaskRight.Find(aiOption)
			Int iOldSlotMask = iSlotMasks[iSlotMaskIndexRight[iIndex]]
			Int iNewSlotMask = iSlotMasks[aiIndex]
			iSlotMaskIndexRight[iIndex] = aiIndex
			If(iOldSlotMask != iNewSlotMask)
				If(iOldSlotMask == 0x00000000)
					AGUSystem.EnableSlot(iIndex, False)
				EndIf
				If(AGUSystem.kSlotVisualRight[iIndex])
					If(iOldSlotMask != 0x00000000)
						AGUSystem.kSlotVisualRight[iIndex].RemoveSlotFromMask(iOldSlotMask)
						AGUSystem.kSlotVisualRight[iIndex].GetNthArmorAddon(0).RemoveSlotFromMask(iOldSlotMask)
					EndIf
					If(iNewSlotMask != 0x00000000)
						AGUSystem.kSlotVisualRight[iIndex].AddSlotToMask(iNewSlotMask)
						AGUSystem.kSlotVisualRight[iIndex].GetNthArmorAddon(0).AddSlotToMask(iNewSlotMask)
					EndIf
				EndIf
				If(iNewSlotMask == 0x00000000)
					AGUSystem.DisableSlot(iIndex, False)
				EndIf
			EndIf
		EndIf
		SetMenuOptionValue(aiOption, sSlotMasksClearText[aiIndex])
	EndIf
EndEvent

Event OnOptionHighlight(Int aiOption)
	If(iOptionHotkeys.Find(aiOption) >= 0)
		Int iSlot = iOptionHotkeys.Find(aiOption)
		If(iSlot < 8)
			SetInfoText("Custom hotkey for quick slot " + (iSlot + 1) + ".\nDefault: " + (iSlot + 1) + ".")
		Else
			SetInfoText("Custom hotkey for SkyUI group " + (iSlot - 7) + ".\nDefault: None.")
		EndIf
	ElseIf(aiOption == iOptionHotkeysSlotEnabled)
		SetInfoText("Custom hotkeys are used to process equipping quick slots 1-8.\nDefault: Disabled.")
	ElseIf(aiOption == iOptionHotkeysGroupEnabled)
		SetInfoText("Custom hotkeys are used to process equipping SkyUI groups 1-8.\nDefault: Disabled.")
	ElseIf((iOptionSlotMaskLeft.Find(aiOption) >= 0) || (iOptionSlotMaskRight.Find(aiOption) >= 0))
		SetInfoText("The SlotMask used by the slot.")
	ElseIf(aiOption == iOptionShieldCloak)
		SetInfoText("Moves shields a bit further from the player, if a cloak is detected. Cloaks usually use slots 40 and 46.\nDefault: Enabled.")
	ElseIf(aiOption == iOptionShieldBackpack)
		SetInfoText("Moves shields a bit further from the player, if a backpack is detected. Backpacks usually use slot 47.\nDefault: Enabled.")
	ElseIf(aiOption == iOptionHotkeysSlotAlternative)
		SetInfoText("Equips and unequips items via script rather than by tapping the actual hotkey. \nDefault: Disabled.")
	EndIf
EndEvent

Event OnOptionSelect(Int aiOption)
	If(aiOption == iOptionHotkeysSlotEnabled)
		bHotkeysSlotEnabled = !bHotkeysSlotEnabled
		gvSettingHotkeysSlotEnabled.SetValue(bHotkeysSlotEnabled as Int)
		AGUSystem.UnregisterForAllKeys()
		AGUSystem.SetupHotkeys()
	ElseIf(aiOption == iOptionHotkeysGroupEnabled)
		bHotkeysGroupEnabled = !bHotkeysGroupEnabled
		gvSettingHotkeysGroupEnabled.SetValue(bHotkeysGroupEnabled as Int)
		If(!bHotkeysGroupEnabled)
			AGUSystem.ResetGroupHotkeys()
		EndIf
		AGUSystem.UnregisterForAllKeys()
		AGUSystem.SetupHotkeys()		
	ElseIf(aiOption == iOptionShieldCloak)
		bShieldCloak = !bShieldCloak
		gvSettingShieldCloak.SetValue(bShieldCloak as Int)
		AGUSystem.SetBoolSetting("ShieldCloak", bShieldCloak)
	ElseIf(aiOption == iOptionShieldBackpack)
		bShieldBackpack = !bShieldBackpack
		gvSettingShieldBackpack.SetValue(bShieldBackpack as Int)
		AGUSystem.SetBoolSetting("ShieldBackpack", bShieldBackpack)
	ElseIf(aiOption == iOptionHotkeysSlotAlternative)
		bHotkeysSlotAlternative = !bHotkeysSlotAlternative
		gvSettingHotkeysSlotAlternative.SetValue(bHotkeysSlotAlternative as Int)
		AGUSystem.SetBoolSetting("HotkeySlotAlternative", bHotkeysSlotAlternative)
	EndIf
	ForcePageReset()
EndEvent

Event OnOptionDefault(Int aiOption)
	If(iOptionHotkeys.Find(aiOption) >= 0)
		Int iIndex = iOptionHotkeys.Find(aiOption)
		If(iIndex < 8)
			AGUSystem.iHotkeySlot[iIndex] = iIndex + 2
		Else
			AGUSystem.iHotkeySlot[iIndex] = -1
		EndIf
		AGUSystem.UnregisterForAllKeys()
		AGUSystem.SetupHotkeys()
	ElseIf(aiOption == iOptionHotkeysSlotEnabled)
		bHotkeysSlotEnabled = False
		gvSettingHotkeysSlotEnabled.SetValue(bHotkeysSlotEnabled as Int)
		AGUSystem.UnregisterForAllKeys()
		AGUSystem.SetupHotkeys()
	ElseIf(aiOption == iOptionHotkeysGroupEnabled)
		bHotkeysGroupEnabled = False
		gvSettingHotkeysGroupEnabled.SetValue(bHotkeysGroupEnabled as Int)
		If(!bHotkeysGroupEnabled)
			AGUSystem.ResetGroupHotkeys()
		EndIf
		AGUSystem.UnregisterForAllKeys()
		AGUSystem.SetupHotkeys()
	ElseIf(aiOption == iOptionShieldCloak)
		bShieldCloak = True
		gvSettingShieldCloak.SetValue(bShieldCloak as Int)
		AGUSystem.SetBoolSetting("ShieldCloak", bShieldCloak)
	ElseIf(aiOption == iOptionShieldBackpack)
		bShieldBackpack = True
		gvSettingShieldBackpack.SetValue(bShieldBackpack as Int)
		AGUSystem.SetBoolSetting("ShieldBackpack", bShieldBackpack)
	ElseIf(aiOption == iOptionHotkeysSlotAlternative)
		bHotkeysSlotAlternative = False
		gvSettingHotkeysSlotAlternative.SetValue(bHotkeysSlotAlternative as Int)
		AGUSystem.SetBoolSetting("HotkeySlotAlternative", bHotkeysSlotAlternative)
	EndIf
	ForcePageReset()
EndEvent

String Function GetCustomControl(Int aiKeyCode)
    If(AGUSystem.iHotkeySlot.Find(aiKeyCode) >= 0)
    	Int iIndex = AGUSystem.iHotkeySlot.Find(aiKeyCode)
		If(iIndex < 8)
			iIndex += 1
	        Return ("All Geared Up - Quick slot " + iIndex)
	    Else
	    	iIndex -= 7
	    	Return ("All Geared Up - SkyUI group " + iIndex)
	    EndIf
    Else
        Return ""
    EndIf
EndFunction