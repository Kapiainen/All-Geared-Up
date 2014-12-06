Scriptname _AGU_MCM extends SKI_ConfigBase

{All Geared Up - The script that creates the MCM for the mod.}

;####################################################################################################################################################
;Properties
;####################################################################################################################################################
	GlobalVariable Property gvSettingHotkeysSlotEnabled Auto
	GlobalVariable Property gvSettingHotkeysGroupEnabled Auto
	GlobalVariable Property gvSettingHotkeysSlotAlternative Auto
	GlobalVariable Property gvSettingVisualizeTorch Auto
	GlobalVariable Property gvSettingVisualizeTorchPosition Auto
	GlobalVariable Property gvSettingVisualizeCoinPurse Auto
	GlobalVariable Property gvSettingVisualizeCoinPurseLimit1 Auto
	GlobalVariable Property gvSettingVisualizeCoinPurseLimit2 Auto
	GlobalVariable Property gvSettingVisualizeCoinPurseLimit3 Auto
	GlobalVariable Property gvSettingVisualizeCoinPurseLimit4 Auto
	GlobalVariable Property gvSettingVisualizeCoinPurseLimit5 Auto
	GlobalVariable Property gvSettingVisualizeCoinPurseLimit6 Auto
	GlobalVariable Property gvSettingVisualizeCoinPursePosition Auto
	GlobalVariable Property gvSettingVisualizeQuestItems Auto
	GlobalVariable Property gvSettingVisualizeQuestItemsAllowMultiple Auto
	GlobalVariable Property gvSettingVisualizePotions Auto
	GlobalVariable Property gvSettingVisualizePotionsPosition Auto
	GlobalVariable Property gvSettingVisualizeIngredients Auto
	GlobalVariable Property gvSettingVisualizeIngredientsPosition Auto
	GlobalVariable Property gvSettingVisualizeScrolls Auto
	GlobalVariable Property gvSettingVisualizeScrollsPosition Auto
	GlobalVariable Property gvSettingVisualizeTorchNPC Auto
	GlobalVariable Property gvSettingVisualizeTorchNPCPosition Auto
	GlobalVariable Property gvSettingVisualizeCoinPurseNPC Auto
	GlobalVariable Property gvSettingVisualizeCoinPurseNPCPosition Auto
	GlobalVariable Property gvSettingVisualizeFluteToggle Auto
	GlobalVariable Property gvSettingVisualizeLuteToggle Auto
	GlobalVariable Property gvSettingVisualizeQuestItemAzura Auto
	GlobalVariable Property gvSettingVisualizeQuestItemCWDocuments Auto
	GlobalVariable Property gvSettingVisualizeQuestItemElderScroll Auto
	GlobalVariable Property gvSettingVisualizeQuestItemHagravenHead Auto
	GlobalVariable Property gvSettingVisualizeQuestItemWuuthrad Auto
	GlobalVariable Property gvSettingVisualizeQuestItemWindcallerHorn Auto
	GlobalVariable Property gvSettingVisualizeQuestItemKlimmekSupplies Auto
	GlobalVariable Property gvSettingShieldAccomodate Auto
	GlobalVariable Property gvSettingShieldHide Auto
	GlobalVariable Property gvSettingVisualizeNPC Auto
	GlobalVariable Property gvSettingVisualizePlayer Auto

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
		Int iOptionShieldAccomodate
		Int iOptionShieldHide
		Int iOptionHotkeysSlotAlternative
		Int iOptionTorchToggle
		Int iOptionCoinPurseToggle
		Int iOptionQuestItemsToggle
		Int iOptionPotionsToggle
		Int iOptionIngredientSatchelToggle
		Int iOptionScrollsToggle
		Int iOptionCoinPursePosition
		Int iOptionTorchPosition
		Int iOptionIngredientSatchelPosition
		Int iOptionScrollPosition
		Int iOptionPotionsPosition
		Int iOptionFluteToggle
		Int iOptionLuteToggle
		Int iOptionScrollToggle
		Int iOptionCoinPurseLimit1
		Int iOptionCoinPurseLimit2
		Int iOptionCoinPurseLimit3
		Int iOptionCoinPurseLimit4
		Int iOptionCoinPurseLimit5
		Int iOptionCoinPurseLimit6
		Int iOptionQuestItemsAllowMultipleToggle
		Int iOptionQuestItemAzuraToggle
		Int iOptionQuestItemCWDocumentsToggle
		Int iOptionQuestItemElderScrollToggle
		Int iOptionQuestItemHagravenHeadToggle
		Int iOptionQuestItemWuuthradToggle
		Int iOptionQuestItemWindcallerHornToggle
		Int iOptionQuestItemKlimmekSuppliesToggle
		Int iOptionCoinPurseNPCToggle
		Int iOptionTorchNPCToggle
		Int iOptionCoinPurseNPCPosition
		Int iOptionTorchNPCPosition
		Int iOptionCoinPurseSettings
		Int iOptionQuestItemsSettings
		Int iOptionNPCVisualizationToggle
		Int iOptionPlayerVisualizationToggle

	;Option state variables
		Bool bHotkeysSlotEnabled
		Bool bHotkeysGroupEnabled
		Int[] iSlotMaskLeft
		Int[] iSlotMaskRight
		Int[] iSlotMaskIndexLeft
		Int[] iSlotMaskIndexRight
		Bool bShieldAccomodate
		Bool bShieldHide
		Bool bHotkeysSlotAlternative
		Bool bCoinPurseToggle
		Bool bTorchToggle
		Bool bQuestItemsToggle
		Bool bPotionsToggle
		Bool bScrollToggle
		Bool bFluteToggle
		Bool bLuteToggle
		Bool bIngredientSatchelToggle
		Bool bQuestItemsAllowMultipleToggle
		Bool bQuestItemsAzuraToggle
		Bool bQuestItemsCWDocumentsToggle
		Bool bQuestItemsElderScrollToggle
		Bool bQuestItemsHagravenHeadToggle
		Bool bQuestItemsWindcallerHornToggle
		Bool bQuestItemsKlimmekSuppliesToggle
		Bool bQuestItemsWuuthradToggle
		Bool bCoinPurseNPCToggle
		Bool bTorchNPCToggle
		Float fCoinPurseLimit1
		Float fCoinPurseLimit2
		Float fCoinPurseLimit3
		Float fCoinPurseLimit4
		Float fCoinPurseLimit5
		Float fCoinPurseLimit6
		Bool bNPCVisualizationToggle
		Bool bPlayerVisualization

		Int iIngredientSatchelPosition
		Int iScrollPosition
		Int iTorchPosition
		Int iPotionsPosition
		Int iTorchNPCPosition
		Int iCoinPurseNPCPosition
		Int iCoinPursePosition

	;Constants and drop-down menu arrays
		Int[] iSlotMasks
		String[] sSlotMasksClearText
		String[] sSlotLabel
		String[] sItemPosition
		String sFormatGold = "{0} gold"

		Int iSubMenuLevel1 = 0

;####################################################################################################################################################
;Events
;####################################################################################################################################################
	Event OnInit()
		Parent.OnInit()
		ModName = "All Geared Up"
		Pages = new String[3]
		Pages[0] = "Hotkeys"
		Pages[1] = "Player"
		Pages[2] = "NPC"
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

		sItemPosition = New String[5]
		sItemPosition[0] = "Front right"
		sItemPosition[1] = "Back right"
		sItemPosition[2] = "Back center"
		sItemPosition[3] = "Back left"
		sItemPosition[4] = "Front left"

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

	Event OnConfigOpen()
		Int i = 0
		While(i < iSlotMaskIndexLeft.Length)
			If(iSlotMaskIndexLeft[i] >= 0)
				If(AGUSystem.kSlotVisualLeft[i])
					Int iSlotMask = AGUSystem.kSlotVisualLeft[i].GetSlotMask()
					Int iIndex = iSlotMasks.Find(iSlotMask)
					If(iIndex < 1)
						iIndex = 0
					EndIf
					iSlotMaskIndexLeft[i] = iIndex
				Else
					iSlotMaskIndexLeft[i] = 0
				EndIf
			EndIf
			i += 1
		EndWhile
		i = 0
		While(i < iSlotMaskIndexRight.Length)
			If(iSlotMaskIndexRight[i] >= 0)
				If(AGUSystem.kSlotVisualRight[i])
					Int iSlotMask = AGUSystem.kSlotVisualRight[i].GetSlotMask()
					Int iIndex = iSlotMasks.Find(iSlotMask)
					If(iIndex < 1)
						iIndex = 0
					EndIf
					iSlotMaskIndexRight[i] = iIndex
				Else
					iSlotMaskIndexRight[i] = 0
				EndIf
			EndIf
			i += 1
		EndWhile

		iSubMenuLevel1 = 0
	EndEvent

	Event OnPageReset(String asPage)
		SetCursorFillMode(TOP_TO_BOTTOM)
		Int i = 0
		If(asPage == "")
			LoadCustomContent("AGU/Logo.dds", 120.0, -33.0)
			Return
		Else
			UnloadCustomContent()
		EndIf
		If(asPage == Pages[0])
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
		ElseIf(asPage == Pages[1])
			If(iSubMenuLevel1 == 0)
				;Update variables
				bCoinPurseToggle = gvSettingVisualizeCoinPurse.GetValueInt() as Bool
				bFluteToggle = gvSettingVisualizeFluteToggle.GetValueInt() as Bool
				bIngredientSatchelToggle = gvSettingVisualizeIngredients.GetValueInt() as Bool
				bLuteToggle = gvSettingVisualizeLuteToggle.GetValueInt() as Bool
				bScrollToggle = gvSettingVisualizeScrolls.GetValueInt() as Bool
				bTorchToggle = gvSettingVisualizeTorch.GetValueInt() as Bool
				bPotionsToggle = gvSettingVisualizePotions.GetValueInt() as Bool
				bQuestItemsToggle = gvSettingVisualizeQuestItems.GetValueInt() as Bool
				iIngredientSatchelPosition = gvSettingVisualizeIngredientsPosition.GetValueInt()
				iScrollPosition = gvSettingVisualizeScrollsPosition.GetValueInt()
				iTorchPosition = gvSettingVisualizeTorchPosition.GetValueInt()
				iPotionsPosition = gvSettingVisualizePotionsPosition.GetValueInt()
				iCoinPurseNPCPosition = gvSettingVisualizeCoinPurseNPCPosition.GetValueInt()
				iTorchNPCPosition = gvSettingVisualizeTorchNPCPosition.GetValueInt()
				bPlayerVisualization = gvSettingVisualizePlayer.GetValueInt() as Bool
				bShieldAccomodate = gvSettingShieldAccomodate.GetValueInt() as Bool
				bShieldHide = gvSettingShieldHide.GetValueInt() as Bool

				;Draw the menu
				SetCursorPosition(0)
				AddHeaderOption("Weapons and shields")
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
				iOptionShieldAccomodate = AddToggleOption("Accomodate backpacks and cloaks", bShieldAccomodate)
				iOptionShieldHide = AddToggleOption("Backpacks and cloaks hide shields", bShieldHide)

				SetCursorPosition(3)
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

				SetCursorPosition(30)
				AddHeaderOption("Miscellaneous items")
				iOptionCoinPurseToggle = AddToggleOption("Coin purse", bCoinPurseToggle)
				iOptionFluteToggle = AddToggleOption("Flute", bFluteToggle)
				iOptionIngredientSatchelToggle = AddToggleOption("Ingredient satchel", bIngredientSatchelToggle)
				iOptionLuteToggle = AddToggleOption("Lute", bLuteToggle)
				iOptionScrollToggle = AddToggleOption("Scroll", bScrollToggle)
				iOptionTorchToggle = AddToggleOption("Torch", bTorchToggle)
				iOptionPotionsToggle = AddToggleOption("Potions", bPotionsToggle)
				iOptionQuestItemsToggle = AddToggleOption("Quest items", bQuestItemsToggle)

				SetCursorPosition(31)
				iOptionPlayerVisualizationToggle = AddToggleOption("Enabled", bPlayerVisualization)
				iOptionCoinPurseSettings = AddTextOption("Settings", "")
				AddTextOption("Settings", "", OPTION_FLAG_DISABLED) ;Flute
				iOptionIngredientSatchelPosition = AddTextOption("Position", sItemPosition[iIngredientSatchelPosition])
				AddTextOption("Settings", "", OPTION_FLAG_DISABLED) ;Lute
				iOptionScrollPosition = AddTextOption("Position", sItemPosition[iScrollPosition])
				iOptionTorchPosition = AddTextOption("Position", sItemPosition[iTorchPosition])
				iOptionPotionsPosition = AddTextOption("Position", sItemPosition[iPotionsPosition])
				iOptionQuestItemsSettings = AddTextOption("Settings", "")
			Else
				SetCursorPosition(0)
				AddTextOptionST("stBackButton", "Back", "")
				SetCursorPosition(2)
				If(iSubMenuLevel1 == 1) ;Coin purse
					iCoinPursePosition = gvSettingVisualizeCoinPursePosition.GetValueInt()
					fCoinPurseLimit1 = gvSettingVisualizeCoinPurseLimit1.GetValue()
					fCoinPurseLimit2 = gvSettingVisualizeCoinPurseLimit2.GetValue()
					fCoinPurseLimit3 = gvSettingVisualizeCoinPurseLimit3.GetValue()
					fCoinPurseLimit4 = gvSettingVisualizeCoinPurseLimit4.GetValue()
					fCoinPurseLimit5 = gvSettingVisualizeCoinPurseLimit5.GetValue()
					fCoinPurseLimit6 = gvSettingVisualizeCoinPurseLimit6.GetValue()

					SetTitleText("Coin purse")
					iOptionCoinPursePosition = AddTextOption("Position", sItemPosition[iCoinPursePosition])
					iOptionCoinPurseLimit1 = AddSliderOption("Stage 1", fCoinPurseLimit1, sFormatGold)
					iOptionCoinPurseLimit2 = AddSliderOption("Stage 2", fCoinPurseLimit2, sFormatGold)
					iOptionCoinPurseLimit3 = AddSliderOption("Stage 3", fCoinPurseLimit3, sFormatGold)
					iOptionCoinPurseLimit4 = AddSliderOption("Stage 4", fCoinPurseLimit4, sFormatGold)
					iOptionCoinPurseLimit5 = AddSliderOption("Stage 5", fCoinPurseLimit5, sFormatGold)
					iOptionCoinPurseLimit6 = AddSliderOption("Stage 6", fCoinPurseLimit6, sFormatGold)
				ElseIf(iSubMenuLevel1 == 2) ;Quest items
					bQuestItemsAzuraToggle = gvSettingVisualizeQuestItemAzura.GetValueInt() as Bool
					bQuestItemsCWDocumentsToggle = gvSettingVisualizeQuestItemCWDocuments.GetValueInt() as Bool
					bQuestItemsElderScrollToggle = gvSettingVisualizeQuestItemElderScroll.GetValueInt() as Bool
					bQuestItemsHagravenHeadToggle = gvSettingVisualizeQuestItemHagravenHead.GetValueInt() as Bool
					bQuestItemsWuuthradToggle = gvSettingVisualizeQuestItemWuuthrad.GetValueInt() as Bool
					bQuestItemsWindcallerHornToggle = gvSettingVisualizeQuestItemWindcallerHorn.GetValueInt() as Bool
					bQuestItemsKlimmekSuppliesToggle = gvSettingVisualizeQuestItemKlimmekSupplies.GetValueInt() as Bool
					bQuestItemsAllowMultipleToggle = gvSettingVisualizeQuestItemsAllowMultiple.GetValueInt() as Bool

					SetTitleText("Quest items")
					iOptionQuestItemsAllowMultipleToggle = AddToggleOption("Allow multiple items", bQuestItemsAllowMultipleToggle)
					iOptionQuestItemAzuraToggle = AddToggleOption("Azura's Star (broken)", bQuestItemsAzuraToggle)
					iOptionQuestItemCWDocumentsToggle = AddToggleOption("Civil War documents", bQuestItemsCWDocumentsToggle)
					iOptionQuestItemElderScrollToggle = AddToggleOption("Elder Scroll", bQuestItemsElderScrollToggle)
					iOptionQuestItemWuuthradToggle = AddToggleOption("Fragments of Wuuthrad", bQuestItemsWuuthradToggle)
					iOptionQuestItemHagravenHeadToggle = AddToggleOption("Head of Glenmoril Witch", bQuestItemsHagravenHeadToggle)
					iOptionQuestItemWindcallerHornToggle = AddToggleOption("Horn of Jurgen Windcaller", bQuestItemsWindcallerHornToggle)
					iOptionQuestItemKlimmekSuppliesToggle = AddToggleOption("Klimmek's supplies", bQuestItemsKlimmekSuppliesToggle)
				EndIf
			EndIf
		ElseIf(asPage == Pages[2])
				;Update variables
				bCoinPurseNPCToggle = gvSettingVisualizeCoinPurseNPC.GetValueInt() as Bool
				bTorchNPCToggle = gvSettingVisualizeTorchNPC.GetValueInt() as Bool
				bNPCVisualizationToggle = gvSettingVisualizeNPC.GetvalueInt() as Bool

				;Draw the menu
				SetCursorPosition(0)
				AddHeaderOption("Miscellaneous items")
				iOptionCoinPurseNPCToggle = AddToggleOption("Coin purse", bCoinPurseNPCToggle)
				iOptionTorchNPCToggle = AddToggleOption("Torch", bTorchNPCToggle)

				SetCursorPosition(1)
				iOptionNPCVisualizationToggle = AddToggleOption("Enabled", bNPCVisualizationToggle)
				iOptionCoinPurseNPCPosition = AddTextOption("Position", sItemPosition[iCoinPurseNPCPosition])
				iOptionTorchNPCPosition = AddTextOption("Position", sItemPosition[iTorchNPCPosition])
		EndIf
		iSubMenuLevel1 = 0
	EndEvent

	State stBackButton
		Event OnSelectST()
			If(iSubMenuLevel1 != 0)
				iSubMenuLevel1 = 0
			EndIf
			ForcePageReset()
		EndEvent
	EndState

	Event OnOptionSliderOpen(Int aiOption)
		If(aiOption == iOptionCoinPurseLimit1)
			SetSliderDialogStartValue(fCoinPurseLimit1)
			SetSliderDialogDefaultValue(1.0)
			SetSliderDialogRange(0.0, 10000.0)
			SetSliderDialogInterval(1.0)
		ElseIf(aiOption == iOptionCoinPurseLimit2)
			SetSliderDialogStartValue(fCoinPurseLimit2)
			SetSliderDialogDefaultValue(50.0)
			SetSliderDialogRange(0.0, 10000.0)
			SetSliderDialogInterval(1.0)
		ElseIf(aiOption == iOptionCoinPurseLimit3)
			SetSliderDialogStartValue(fCoinPurseLimit3)
			SetSliderDialogDefaultValue(100.0)
			SetSliderDialogRange(0.0, 10000.0)
			SetSliderDialogInterval(1.0)
		ElseIf(aiOption == iOptionCoinPurseLimit4)
			SetSliderDialogStartValue(fCoinPurseLimit4)
			SetSliderDialogDefaultValue(150.0)
			SetSliderDialogRange(0.0, 10000.0)
			SetSliderDialogInterval(1.0)
		ElseIf(aiOption == iOptionCoinPurseLimit5)
			SetSliderDialogStartValue(fCoinPurseLimit5)
			SetSliderDialogDefaultValue(200.0)
			SetSliderDialogRange(0.0, 10000.0)
			SetSliderDialogInterval(1.0)
		ElseIf(aiOption == iOptionCoinPurseLimit6)
			SetSliderDialogStartValue(fCoinPurseLimit6)
			SetSliderDialogDefaultValue(250.0)
			SetSliderDialogRange(0.0, 10000.0)
			SetSliderDialogInterval(1.0)
		EndIf
	EndEvent

	Event OnOptionSliderAccept(Int aiOption, Float afValue)
		If(aiOption == iOptionCoinPurseLimit1)
			fCoinPurseLimit1 = afValue
			gvSettingVisualizeCoinPurseLimit1.SetValue(fCoinPurseLimit1)
			SetSliderOptionValue(aiOption, afValue, sFormatGold)
		ElseIf(aiOption == iOptionCoinPurseLimit2)
			fCoinPurseLimit2 = afValue
			gvSettingVisualizeCoinPurseLimit2.SetValue(fCoinPurseLimit2)
			SetSliderOptionValue(aiOption, afValue, sFormatGold)
		ElseIf(aiOption == iOptionCoinPurseLimit3)
			fCoinPurseLimit3 = afValue
			gvSettingVisualizeCoinPurseLimit3.SetValue(fCoinPurseLimit3)
			SetSliderOptionValue(aiOption, afValue, sFormatGold)
		ElseIf(aiOption == iOptionCoinPurseLimit4)
			fCoinPurseLimit4 = afValue
			gvSettingVisualizeCoinPurseLimit4.SetValue(fCoinPurseLimit4)
			SetSliderOptionValue(aiOption, afValue, sFormatGold)
		ElseIf(aiOption == iOptionCoinPurseLimit5)
			fCoinPurseLimit5 = afValue
			gvSettingVisualizeCoinPurseLimit5.SetValue(fCoinPurseLimit5)
			SetSliderOptionValue(aiOption, afValue, sFormatGold)
		ElseIf(aiOption == iOptionCoinPurseLimit6)
			fCoinPurseLimit6 = afValue
			gvSettingVisualizeCoinPurseLimit6.SetValue(fCoinPurseLimit6)
			SetSliderOptionValue(aiOption, afValue, sFormatGold)
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
				AGUSystem.SetSlotMaskForSlot(iIndex, True, aiIndex)
				iSlotMaskIndexLeft[iIndex] = aiIndex
			Else
				Int iIndex = iOptionSlotMaskRight.Find(aiOption)
				AGUSystem.SetSlotMaskForSlot(iIndex, False, aiIndex)
				iSlotMaskIndexRight[iIndex] = aiIndex
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
		ElseIf(aiOption == iOptionShieldAccomodate)
			SetInfoText("Moves shields a bit further from the player, if a backpack (slot 47) and/or a cloak (slots 40 and 46) is detected.")
		ElseIf(aiOption == iOptionShieldHide)
			SetInfoText("Shields don't show up on the player's back when a backpack (slot 47) and/or a cloak (slots 40 and 46) is detected.")
		ElseIf(aiOption == iOptionHotkeysSlotAlternative)
			SetInfoText("Equips and unequips items via script functions rather than by tapping the actual hotkey.")
		ElseIf(aiOption == iOptionCoinPurseToggle)
			SetInfoText("A coin purse, which grows and shrinks according to the player's wealth, is attached to the player's hip.")
		ElseIf(aiOption == iOptionTorchToggle)
			SetInfoText("A torch is attached to the player's hip, if the player has a torch and isn't wearing one of Frostfall's backpacks.")
		;ElseIf((iOptionSlotMaskLeft.Find(aiOption) >= 0) || (iOptionSlotMaskRight.Find(aiOption) >= 0))
		;	SetInfoText("The slot used by the item.")
		Else
			SetInfoText("")
		EndIf
	EndEvent

	Event OnOptionSelect(Int aiOption)
		If(aiOption == iOptionHotkeysSlotEnabled)
			bHotkeysSlotEnabled = !bHotkeysSlotEnabled
			gvSettingHotkeysSlotEnabled.SetValue(bHotkeysSlotEnabled as Int)
			AGUSystem.UnregisterForAllKeys()
			AGUSystem.SetupHotkeys()
			SetToggleOptionValue(aiOption, bHotkeysSlotEnabled)
		ElseIf(aiOption == iOptionHotkeysGroupEnabled)
			bHotkeysGroupEnabled = !bHotkeysGroupEnabled
			gvSettingHotkeysGroupEnabled.SetValue(bHotkeysGroupEnabled as Int)
			If(!bHotkeysGroupEnabled)
				AGUSystem.ResetGroupHotkeys()
			EndIf
			AGUSystem.UnregisterForAllKeys()
			AGUSystem.SetupHotkeys()
			SetToggleOptionValue(aiOption, bHotkeysGroupEnabled)
			ForcePageReset()
		ElseIf(aiOption == iOptionHotkeysSlotAlternative)
			bHotkeysSlotAlternative = !bHotkeysSlotAlternative
			gvSettingHotkeysSlotAlternative.SetValue(bHotkeysSlotAlternative as Int)
			AGUSystem.SetBoolSetting("HotkeySlotAlternative", bHotkeysSlotAlternative)
			SetToggleOptionValue(aiOption, bHotkeysSlotAlternative)
		ElseIf(aiOption == iOptionCoinPurseToggle)
			bCoinPurseToggle = !bCoinPurseToggle
			gvSettingVisualizeCoinPurse.SetValue(bCoinPurseToggle as Int)
			SetToggleOptionValue(aiOption, bCoinPurseToggle)
		ElseIf(aiOption == iOptionTorchToggle)
			bTorchToggle = !bTorchToggle
			gvSettingVisualizeTorch.SetValue(bTorchToggle as Int)
			SetToggleOptionValue(aiOption, bTorchToggle)
		ElseIf(aiOption == iOptionFluteToggle)
			bFluteToggle = !bFluteToggle
			gvSettingVisualizeFluteToggle.SetValue(bFluteToggle as Int)
			SetToggleOptionValue(aiOption, bFluteToggle)
		ElseIf(aiOption == iOptionLuteToggle)
			bLuteToggle = !bLuteToggle
			gvSettingVisualizeLuteToggle.SetValue(bLuteToggle as Int)
			SetToggleOptionValue(aiOption, bLuteToggle)
		ElseIf(aiOption == iOptionTorchNPCToggle)
			bTorchNPCToggle = !bTorchNPCToggle
			gvSettingVisualizeTorchNPC.SetValue(bTorchNPCToggle as Int)
			SetToggleOptionValue(aiOption, bTorchNPCToggle)
		ElseIf(aiOption == iOptionScrollToggle)
			bScrollToggle = !bScrollToggle
			gvSettingVisualizeScrolls.SetValue(bScrollToggle as Int)
			SetToggleOptionValue(aiOption, bScrollToggle)
		ElseIf(aiOption == iOptionPotionsToggle)
			bPotionsToggle = !bPotionsToggle
			gvSettingVisualizePotions.SetValue(bPotionsToggle as Int)
			SetToggleOptionValue(aiOption, bPotionsToggle)
		ElseIf(aiOption == iOptionQuestItemAzuraToggle)
			bQuestItemsAzuraToggle = !bQuestItemsAzuraToggle
			gvSettingVisualizeQuestItemAzura.SetValue(bQuestItemsAzuraToggle as Int)
			SetToggleOptionValue(aiOption, bQuestItemsAzuraToggle)
			;iSubMenuLevel1 = 2
		ElseIf(aiOption == iOptionQuestItemWuuthradToggle)
			bQuestItemsWuuthradToggle = !bQuestItemsWuuthradToggle
			gvSettingVisualizeQuestItemWuuthrad.SetValue(bQuestItemsWuuthradToggle as Int)
			SetToggleOptionValue(aiOption, bQuestItemsWuuthradToggle)
			;iSubMenuLevel1 = 2
		ElseIf(aiOption == iOptionQuestItemsToggle)
			bQuestItemsToggle = !bQuestItemsToggle
			gvSettingVisualizeQuestItems.SetValue(bQuestItemsToggle as Int)
			SetToggleOptionValue(aiOption, bQuestItemsToggle)
		ElseIf(aiOption == iOptionQuestItemCWDocumentsToggle)
			bQuestItemsCWDocumentsToggle = !bQuestItemsCWDocumentsToggle
			gvSettingVisualizeQuestItemCWDocuments.SetValue(bQuestItemsCWDocumentsToggle as Int)
			SetToggleOptionValue(aiOption, bQuestItemsCWDocumentsToggle)
			;iSubMenuLevel1 = 2
		ElseIf(aiOption == iOptionQuestItemElderScrollToggle)
			bQuestItemsElderScrollToggle = !bQuestItemsElderScrollToggle
			gvSettingVisualizeQuestItemElderScroll.SetValue(bQuestItemsElderScrollToggle as Int)
			SetToggleOptionValue(aiOption, bQuestItemsElderScrollToggle)
			;iSubMenuLevel1 = 2
		ElseIf(aiOption == iOptionQuestItemHagravenHeadToggle)
			bQuestItemsHagravenHeadToggle = !bQuestItemsHagravenHeadToggle
			gvSettingVisualizeQuestItemHagravenHead.SetValue(bQuestItemsHagravenHeadToggle as Int)
			SetToggleOptionValue(aiOption, bQuestItemsHagravenHeadToggle)
			;iSubMenuLevel1 = 2
		ElseIf(aiOption == iOptionQuestItemWindcallerHornToggle)
			bQuestItemsWindcallerHornToggle = !bQuestItemsWindcallerHornToggle
			gvSettingVisualizeQuestItemWindcallerHorn.SetValue( bQuestItemsWindcallerHornToggle as Int)
			SetToggleOptionValue(aiOption, bQuestItemsWindcallerHornToggle)
			;iSubMenuLevel1 = 2
		ElseIf(aiOption == iOptionQuestItemKlimmekSuppliesToggle)
			bQuestItemsKlimmekSuppliesToggle = !bQuestItemsKlimmekSuppliesToggle
			gvSettingVisualizeQuestItemKlimmekSupplies.SetValue(bQuestItemsKlimmekSuppliesToggle as Int)
			SetToggleOptionValue(aiOption, bQuestItemsKlimmekSuppliesToggle)
			;iSubMenuLevel1 = 2
		ElseIf(aiOption == iOptionQuestItemsAllowMultipleToggle)
			bQuestItemsAllowMultipleToggle = !bQuestItemsAllowMultipleToggle
			gvSettingVisualizeQuestItemsAllowMultiple.SetValue(bQuestItemsAllowMultipleToggle as Int)
			SetToggleOptionValue(aiOption, bQuestItemsAllowMultipleToggle)
			;iSubMenuLevel1 = 2
		ElseIf(aiOption == iOptionCoinPurseNPCToggle)
			bCoinPurseNPCToggle = !bCoinPurseNPCToggle
			gvSettingVisualizeCoinPurseNPC.SetValue(bCoinPurseNPCToggle as Int)
			SetToggleOptionValue(aiOption, bCoinPurseNPCToggle)
		ElseIf(aiOption == iOptionIngredientSatchelToggle)
			bIngredientSatchelToggle = !bIngredientSatchelToggle
			gvSettingVisualizeIngredients.SetValue(bIngredientSatchelToggle as Int)
			SetToggleOptionValue(aiOption, bIngredientSatchelToggle)
		ElseIf(aiOption == iOptionShieldAccomodate)
			bShieldAccomodate = !bShieldAccomodate
			gvSettingShieldAccomodate.SetValue(bShieldAccomodate as Int)
			AGUSystem.SetBoolSetting("ShieldAccomodate", bShieldAccomodate)
			SetToggleOptionValue(aiOption, bShieldAccomodate)
		ElseIf(aiOption == iOptionShieldHide)
			bShieldHide = !bShieldHide
			gvSettingShieldHide.SetValue(bShieldHide as Int)
			AGUSystem.SetBoolSetting("ShieldHide", bShieldHide)
			SetToggleOptionValue(aiOption, bShieldHide)
		ElseIf(aiOption == iOptionNPCVisualizationToggle)
			bNPCVisualizationToggle = !bNPCVisualizationToggle
			gvSettingVisualizeNPC.SetValue(bNPCVisualizationToggle as Int)
			SetToggleOptionValue(aiOption, bNPCVisualizationToggle)
		ElseIf(aiOption == iOptionPlayerVisualizationToggle)
			bPlayerVisualization = !bPlayerVisualization
			gvSettingVisualizePlayer.SetValue(bPlayerVisualization as Int)
			SetToggleOptionValue(aiOption, bPlayerVisualization)
		ElseIf(aiOption == iOptionCoinPursePosition)
			iCoinPursePosition += 1
			If(iCoinPursePosition == 2)
				iCoinPursePosition = 3
			ElseIf(iCoinPursePosition > 4)
				iCoinPursePosition = 0
			EndIf
			gvSettingVisualizeCoinPursePosition.SetValue(iCoinPursePosition)
			SetTextOptionValue(aiOption, sItemPosition[iCoinPursePosition])
			;iSubMenuLevel1 = 1
		ElseIf(aiOption == iOptionScrollPosition)
			iScrollPosition += 1
			If(iScrollPosition > 4)
				iScrollPosition = 0
			EndIf
			gvSettingVisualizeScrollsPosition.SetValue(iScrollPosition)
			SetTextOptionValue(aiOption, sItemPosition[iScrollPosition])
		ElseIf(aiOption == iOptionTorchPosition)
			iTorchPosition += 1
			If(iTorchPosition < 1)
				iTorchPosition = 1
			ElseIf(iTorchPosition > 3)
				iTorchPosition = 1
			EndIf
			gvSettingVisualizeTorchPosition.SetValue(iTorchPosition)
			SetTextOptionValue(aiOption, sItemPosition[iTorchPosition])
		ElseIf(aiOption == iOptionTorchNPCPosition)
			iTorchNPCPosition += 1
			If(iTorchNPCPosition < 1)
				iTorchNPCPosition = 1
			ElseIf(iTorchNPCPosition > 3)
				iTorchNPCPosition = 1
			EndIf
			gvSettingVisualizeTorchNPCPosition.SetValue(iTorchNPCPosition)
			SetTextOptionValue(aiOption, sItemPosition[iTorchNPCPosition])
		ElseIf(aiOption == iOptionCoinPurseNPCPosition)
			iCoinPurseNPCPosition += 1
			If(iCoinPurseNPCPosition == 2)
				iCoinPurseNPCPosition = 3
			ElseIf(iCoinPurseNPCPosition > 4)
				iCoinPurseNPCPosition = 0
			EndIf
			gvSettingVisualizeCoinPurseNPCPosition.SetValue(iCoinPurseNPCPosition)
			SetTextOptionValue(aiOption, sItemPosition[iCoinPurseNPCPosition])
		ElseIf(aiOption == iOptionIngredientSatchelPosition)
			iIngredientSatchelPosition += 1
			If(iIngredientSatchelPosition > 4)
				iIngredientSatchelPosition = 0
			EndIf
			gvSettingVisualizeIngredientsPosition.SetValue(iIngredientSatchelPosition)
			SetTextOptionValue(aiOption, sItemPosition[iIngredientSatchelPosition])
		ElseIf(aiOption == iOptionPotionsPosition)
			iPotionsPosition += 1
			If(iPotionsPosition > 4)
				iPotionsPosition = 0
			EndIf
			gvSettingVisualizePotionsPosition.Setvalue(iPotionsPosition)
			SetTextOptionValue(aiOption, sItemPosition[iPotionsPosition])
		ElseIf(aiOption == iOptionCoinPurseSettings)
			iSubMenuLevel1 = 1
			ForcePageReset()
		ElseIf(aiOption == iOptionQuestItemsSettings)
			iSubMenuLevel1 = 2
			ForcePageReset()
		EndIf
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
			SetToggleOptionValue(aiOption, bHotkeysSlotEnabled)
		ElseIf(aiOption == iOptionHotkeysGroupEnabled)
			bHotkeysGroupEnabled = False
			gvSettingHotkeysGroupEnabled.SetValue(bHotkeysGroupEnabled as Int)
			If(!bHotkeysGroupEnabled)
				AGUSystem.ResetGroupHotkeys()
			EndIf
			AGUSystem.UnregisterForAllKeys()
			AGUSystem.SetupHotkeys()
			SetToggleOptionValue(aiOption, bHotkeysGroupEnabled)
		ElseIf(aiOption == iOptionHotkeysSlotAlternative)
			bHotkeysSlotAlternative = False
			gvSettingHotkeysSlotAlternative.SetValue(bHotkeysSlotAlternative as Int)
			AGUSystem.SetBoolSetting("HotkeySlotAlternative", bHotkeysSlotAlternative)
			SetToggleOptionValue(aiOption, bHotkeysSlotAlternative)
		EndIf
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