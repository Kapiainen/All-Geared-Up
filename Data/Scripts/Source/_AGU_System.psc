Scriptname _AGU_System extends ReferenceAlias  

{All Geared Up - Adds support for displaying unequipped favorited and/or equipped items.}

;####################################################################################################################################################
;Imported classes
;####################################################################################################################################################
	Import Debug
	Import StringUtil
	Import Utility
	Import UI
	Import Input

;####################################################################################################################################################
;Properties
;####################################################################################################################################################
	;Armors used to display items on the player character
	Armor[] Property kSlotVisualLeft Auto
	Armor[] Property kSlotVisualRight Auto

	;Filtered inventory
	FormList Property kFLSTInventory Auto
	Bool bInventoryProcessed = False

	FormList Property kFLSTBackpacks Auto
	FormList Property kFLSTElderScrolls Auto

	;MCM settings
	GlobalVariable Property gvSettingHotkeysSlotEnabled Auto
	GlobalVariable Property gvSettingHotkeysGroupEnabled Auto
	GlobalVariable Property gvSettingShieldAccomodate Auto
	GlobalVariable Property gvSettingShieldHide Auto
	GlobalVariable Property gvSettingHotkeysSlotAlternative Auto
	GlobalVariable Property gvSettingVisualizeTorch Auto
	GlobalVariable Property gvWearingBackpackCloak Auto

	Int[] Property iHotkeySlot Auto Hidden

	;Visualized inventory
	FormList Property kFLSTRestoreHealth Auto
	FormList Property kFLSTRestoreMagicka Auto
	FormList Property kFLSTRestoreStamina Auto
	FormList Property kFLSTPotionsHealth Auto
	FormList Property kFLSTPotionsMagicka Auto
	FormList Property kFLSTPotionsStamina Auto
	FormList Property kFLSTScrolls Auto
	FormList Property kFLSTIngredients Auto
	Spell Property kSPELPlayerVisualization Auto

;####################################################################################################################################################
;Variables
;####################################################################################################################################################
	Actor PlayerRef
	Race kPlayerRace
	Int iSlotMaskCloak
	Int iSlotMaskBackpack = 0x00020000
	Bool bWearingCloak = False
	Bool bWearingBackpack = False
	Bool bHideShield = False

	;Time-out for visual slots
	Armor[] kSlotVisualDisabledLeft
	Armor[] kSlotVisualDisabledRight

	;Hotkeys
	Int iHotkeyFavorites
	Int[] iHotkeyRealSlot

	;States
	Bool bProcessingUnequip = False ;True when the OnObjectUnequipped event is running
	Bool bUpdateFavoritesList = False ;True when the player has (un)favorited one or more items
	Bool bHotkeyEquip = False ;True when an item was (un)equipped outside of menus
	Bool bProcessingHotkey = False ;True when the OnKeyDown event is processing a keystroke
	Bool bWeaponDrawn = False ;Whether or not weapons are drawn

	;Settings
	Bool bSettingShieldAccomodate = False
	Bool bSettingShieldHide = False
	Bool bSettingHotkeysSlotAlternative = False

	;Items in slots and items currently equipped in the player's hands
	Form kHandItemLeft ;Form of item currently equipped in the player's left hand
	Form[] kSlotItemLeft ;Forms of items displayed in the different slots
	String[] sSlotDrawnLeft ;Path to the item's mesh when weapons are drawn (or when a cloak is equipped in the case of shields)
	String[] sSlotSheathedLeft ;Path to the item's mesh when weapons are not drawn
	Int[] iSlotMaskLeft ;The SlotMask assigned to the ARMOs and ARMAs
	Form kHandItemRight ;Form of item currently equipped in the player's right hand
	Form[] kSlotItemRight ;Forms of items displayed in the different slots
	String[] sSlotDrawnRight ;Path to the item's mesh when weapons are drawn
	String[] sSlotSheathedRight ;Path to the item's mesh when weapons are not drawn
	Int[] iSlotMaskRight ;The SlotMask assigned to the ARMOs and ARMAs

	;SkyUI related stuff
	SKI_FavoritesManager Property SkyUI Auto Hidden ;SkyUI Favorites system script
	Form[] kGroupHandItemLeft ;Forms of items equipped in the left hand in SkyUI groups
	Form[] kGroupHandItemRight ;Forms of items equipped in the right hand in SkyUI groups
	Int[] iGroupHandItemIDLeft ;IDs of items equipped in the left hand in SkyUI groups
	Int[] iGroupHandItemIDRight ;IDs of items equipped in the right hand in SkyUI groups

	;Races to check for
	Race kRaceWerewolf
	Race kRaceVampireLord

	;Misc
	EquipSlot kEquipSlotTwoHanded
	SoundDescriptor kSNDRUnequipArmor

	Int[] iSlotMasks
	Int[] iSlotMaskIndexLeft
	Int[] iSlotMaskIndexRight

;####################################################################################################################################################
;Initialization and maintenance
;####################################################################################################################################################
	Event OnInit()
		bProcessingUnequip = True
		RegisterForSingleUpdate(2.0)
	EndEvent

	Event OnPlayerLoadGame()
		;Trace("OnPlayerLoadGame")
		Maintenance()
	EndEvent

	Event OnUpdate()
		PlayerRef = Game.GetPlayer()

		;Trace("OnInit")
		iSlotMaskCloak = 0x00000400 + 0x00010000 ;Slots 40 and 46
		kSlotItemLeft = New Form[9]
		sSlotDrawnLeft = New String[9]
		sSlotSheathedLeft = New String[9]
		iSlotMaskLeft = New Int[9]
		kSlotItemRight = New Form[9]
		sSlotDrawnRight = New String[9]
		sSlotSheathedRight = New String[9]
		iSlotMaskRight = New Int[9]

		kSlotVisualDisabledLeft = New Armor[9]
		kSlotVisualDisabledRight = New Armor[9]

		kGroupHandItemLeft = New Form[8]
		kGroupHandItemRight = New Form[8]
		iGroupHandItemIDLeft = New Int[8]
		iGroupHandItemIDRight = New Int[8]

		iHotkeySlot = New Int[16]
		iHotkeySlot[0] = 2
		iHotkeySlot[1] = 3
		iHotkeySlot[2] = 4
		iHotkeySlot[3] = 5
		iHotkeySlot[4] = 6
		iHotkeySlot[5] = 7
		iHotkeySlot[6] = 8
		iHotkeySlot[7] = 9
		iHotkeySlot[8] = -1
		iHotkeySlot[9] = -1
		iHotkeySlot[10] = -1
		iHotkeySlot[11] = -1
		iHotkeySlot[12] = -1
		iHotkeySlot[13] = -1
		iHotkeySlot[14] = -1
		iHotkeySlot[15] = -1

		iHotkeyRealSlot = New Int[8]

		;SlotMasks
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

		iSlotMaskIndexLeft = New Int[9]
		iSlotMaskIndexLeft[0] = 2 ;Sword
		iSlotMaskIndexLeft[1] = 6 ;Dagger
		iSlotMaskIndexLeft[2] = 8 ;War axe
		iSlotMaskIndexLeft[3] = 10 ;Mace
		iSlotMaskIndexLeft[4] = 0 ;Two-handed melee
		iSlotMaskIndexLeft[5] = 0 ;Bow
		iSlotMaskIndexLeft[6] = 12 ;Staff
		iSlotMaskIndexLeft[7] = 0 ;Crossbow
		iSlotMaskIndexLeft[8] = 15 ;Shield

		iSlotMaskIndexRight = New Int[9]
		iSlotMaskIndexRight[0] = 5 ;Sword
		iSlotMaskIndexRight[1] = 7 ;Dagger
		iSlotMaskIndexRight[2] = 9 ;War axe
		iSlotMaskIndexRight[3] = 11 ;Mace
		iSlotMaskIndexRight[4] = 14 ;Two-handed melee
		iSlotMaskIndexRight[5] = 0 ;Bow
		iSlotMaskIndexRight[6] = 13 ;Staff
		iSlotMaskIndexRight[7] = 0 ;Crossbow
		iSlotMaskIndexRight[8] = 0 ;Shield

		Form kCloak = PlayerRef.GetWornForm(iSlotMaskCloak)
		If(kCloak)
			bWearingCloak = True
		EndIf
		Form kBackpack = PlayerRef.GetWornForm(iSlotMaskBackpack)
		If(kBackpack)
			bWearingBackpack = True
		EndIf
		If((bWearingCloak) || (bWearingBackpack))
			gvWearingBackpackCloak.SetValue(1)
			If(bSettingShieldHide)
				If(IsSlotEquipped(8, True))
					UnequipSlot(8, True)
				EndIf
			ElseIf(bSettingShieldAccomodate)
				If(IsSlotEquipped(8, True))
					UnequipSlot(8, True)
				EndIf
				DrawSlot(8, True)
				If(bHotkeyEquip)
					EquipSlot(8, True)
				EndIf
			EndIf
		EndIf
		;kPlayerRace = PlayerRef.GetRace()
		bWeaponDrawn = PlayerRef.IsWeaponDrawn()

		RegisterForAnimations()

		Maintenance()
		OnRaceSwitchComplete()
		bProcessingUnequip = False
		Debug.Notification("Initialized All Geared Up 2.1.1")
	EndEvent

;####################################################################################################################################################
;Equipping and unequipping items
;####################################################################################################################################################
	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
		While(bProcessingUnequip)
			WaitMenuMode(0.1)
		EndWhile
		;Trace("Object equipped: " + akBaseObject.GetName())
		Int iType = GetSlotIndex(akBaseObject)
		If(iType >= 0)
			;Notification("Equipping: " + akBaseObject.GetName())
			If(iType == 8) ;Shields
				kHandItemLeft = akBaseObject
				If(bHotkeyEquip)
					UnequipSlot(iType, True)
				EndIf
				SetShieldSlotMask(True)
				If(kSlotItemLeft[iType] != akBaseObject)
					If(FillSlot(iType, True, akBaseObject))
						If((bSettingShieldAccomodate) && ((bWearingCloak) || (bWearingBackpack)))
							DrawSlot(iType, True)
						Else
							SheatheSlot(iType, True)
						EndIf
					EndIf
				EndIf
				If(bHotkeyEquip)
					If(bWeaponDrawn)
						;Do nothing
					Else
						If((bSettingShieldHide) && ((bWearingCloak) || (bWearingBackpack)))
						Else
							EquipSlot(iType, True)
						EndIf
					EndIf
				EndIf
			ElseIf((iType == 5) || (iType == 7)) ;Bows and crossbows
				kHandItemRight = akBaseObject
				kHandItemLeft = akBaseObject
			;ElseIf(iType == 6) ;Staves
			ElseIf(iType == 4) ;Two-handed melee weapons
				kHandItemRight = akBaseObject
				kHandItemLeft = akBaseObject
				If(kSlotItemRight[iType] != akBaseObject)
					If(FillSlot(iType, False, akBaseObject))
						SheatheSlot(iType, False)
					EndIf
				EndIf
			Else ;One-handed melee weapons and staves
				If((kHandItemRight != akBaseObject) && (PlayerRef.GetEquippedObject(1) == akBaseObject)) ;Right hand
					kHandItemRight = akBaseObject
					If(kSlotItemRight[iType] != akBaseObject)
						If(FillSlot(iType, False, akBaseObject))
							SheatheSlot(iType, False)
						EndIf
					EndIf
					If(PlayerRef.GetItemCount(akBaseObject) == 1)
						UnequipSlot(iType, True)
						ClearSlot(iType, True)
						If(FindReplacements(iType, True))
							If(bHotkeyEquip)
								EquipSlot(iType, True)
							EndIf
						EndIf
					EndIf
				ElseIf((kHandItemLeft != akBaseObject) && (PlayerRef.GetEquippedObject(0) == akBaseObject)) ;Left hand
					kHandItemLeft = akBaseObject
					If(bHotkeyEquip)
						UnequipSlot(iType, True)
					EndIf
					If(kSlotItemLeft[iType] != akBaseObject)
						If(FillSlot(iType, True, akBaseObject))
							SheatheSlot(iType, True)
						EndIf
					EndIf
					If(PlayerRef.GetItemCount(akBaseObject) == 1)
						UnequipSlot(iType, False)
						ClearSlot(iType, False)
						If(FindReplacements(iType, False))
							;SheatheSlot(iType, False)
							If(bHotkeyEquip)
								EquipSlot(iType, False)
							EndIf
						EndIf
					EndIf
					If(bHotkeyEquip)
						If(iType == 6)
							If(bWeaponDrawn)
								UnequipSlot(iType, True)
							Else
								EquipSlot(iType, True)
							EndIf
						Else
							If(bWeaponDrawn)
								DrawSlot(iType, True)
							Else
								SheatheSlot(iType, True)
							EndIf
							EquipSlot(iType, True)
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			If(akBaseObject as Spell) ;Two-handed spell
				If((akBaseObject as Spell).GetEquipType() == kEquipSlotTwoHanded)
					kHandItemRight = akBaseObject
					kHandItemLeft = akBaseObject
				Else ;One-handed spell
					If((kHandItemRight != akBaseObject) && (PlayerRef.GetEquippedObject(1) == akBaseObject)) ;Right hand
						kHandItemRight = akBaseObject
					ElseIf((kHandItemLeft != akBaseObject) && (PlayerRef.GetEquippedObject(0) == akBaseObject)) ;Left hand
						kHandItemLeft = akBaseObject
					EndIf
				EndIf
			ElseIf(akBaseObject as Light) ;Torch
				kHandItemLeft = akBaseObject
			ElseIf(akBaseObject as Armor) ;Check for cloaks and backpacks
				If((kSlotVisualLeft.Find(akBaseObject as Armor) < 0) && (kSlotVisualRight.Find(akBaseObject as Armor) < 0))
					If((!bWearingCloak) || (!bWearingBackpack))
						Int iSlotMask = (akBaseObject as Armor).GetSlotMask()
						If(iSlotMask == iSlotMaskCloak)
							bWearingCloak = True
							gvWearingBackpackCloak.SetValue(1)
						ElseIf(iSlotMask == iSlotMaskBackpack)
							bWearingBackpack = True
							gvWearingBackpackCloak.SetValue(1)
						EndIf
						If((bWearingCloak) || (bWearingBackpack))
							If(bSettingShieldHide)
								If(IsSlotEquipped(8, True))
									UnequipSlot(8, True)
								EndIf
							ElseIf(bSettingShieldAccomodate)
								If(IsSlotEquipped(8, True))
									UnequipSlot(8, True)
								EndIf
								DrawSlot(8, True)
								If(bHotkeyEquip)
									EquipSlot(8, True)
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndEvent

	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
		bProcessingUnequip = True
		;Trace("Object unequipped: " + akBaseObject.GetName())
		Int iType = GetSlotIndex(akBaseObject)
		If(iType >= 0)
			;Notification("Unequipping: " + akBaseObject.GetName())
			If(iType == 8) ;Shields
				kHandItemLeft = None
				If(bHotkeyEquip)
					UnequipSlot(iType, True)
				EndIf
				If(!Game.IsObjectFavorited(akBaseObject))
					ClearSlot(iType, True)
					SetShieldSlotMask(False)
				Else
					If(bHotkeyEquip)
						If(kSlotItemLeft[iType])
							If(!PlayerRef.GetEquippedShield())
								SetShieldSlotMask(False)
								EquipSlot(iType, True)
							EndIf
						EndIf
					Else
						SetShieldSlotMask(False)
					EndIf
				EndIf
			ElseIf((iType == 5) || (iType == 7)) ;Bows and crossbows
				kHandItemRight = None
				kHandItemLeft = None
			;ElseIf(iType == 6) ;Staves
			ElseIf(iType == 4) ;Two-handed melee weapons
				kHandItemRight = None
				kHandItemLeft = None
				If(!Game.IsObjectFavorited(akBaseObject))
					ClearSlot(iType, False)
				Else
					If(bHotkeyEquip)
						If(kSlotItemRight[iType])
							Int iNewType = GetSlotIndex(PlayerRef.GetEquippedObject(1))
							If(iNewType != iType)
								EquipSlot(iType, False)
							EndIf
						EndIf
					EndIf
				EndIf
			Else ;One-handed melee weapons
				Form kNewFormRight = PlayerRef.GetEquippedObject(1)
				Form kNewFormLeft = PlayerRef.GetEquippedObject(0)
				If((kHandItemRight == akBaseObject) && (kNewFormRight != kHandItemRight)) ;Right hand
					kHandItemRight = None
					If(!Game.IsObjectFavorited(akBaseObject))
						ClearSlot(iType, False)
					Else
						If(bHotkeyEquip)
							Int iNewType = GetSlotIndex(kNewFormRight)
							If(iNewType != iType) ;The new weapon is not going to replace this weapon
								EquipSlot(iType, False)
							EndIf
						EndIf
					EndIf
				ElseIf((kHandItemLeft == akBaseObject) && (kNewFormLeft != kHandItemLeft)) ;Left hand
					kHandItemLeft = None
					If(bHotkeyEquip)
						UnequipSlot(iType, True)
					EndIf
					If(!Game.IsObjectFavorited(akBaseObject))
						ClearSlot(iType, True)
					Else
						If(bHotkeyEquip)
							Int iNewType = GetSlotIndex(kNewFormLeft)
							If(iNewType != iType) ;The new weapon is not going to replace this weapon
								SheatheSlot(iType, True)
								EquipSlot(iType, True)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		Else
			If(akBaseObject as Spell) ;Two-handed spell
				If((akBaseObject as Spell).GetEquipType() == kEquipSlotTwoHanded)
					kHandItemRight = None
					kHandItemLeft = None
				Else ;One-handed spell
					If((kHandItemRight == akBaseObject) && (PlayerRef.GetEquippedObject(1) != kHandItemRight)) ;Right hand
						kHandItemRight = None
					ElseIf((kHandItemLeft == akBaseObject) && (PlayerRef.GetEquippedObject(0) != kHandItemLeft)) ;Left hand
						kHandItemLeft = None
					EndIf
				EndIf
			ElseIf(akBaseObject as Light) ;Torch
				kHandItemLeft = None
			ElseIf(akBaseObject as Armor) ;Check for cloaks and backpacks
				If((kSlotVisualLeft.Find(akBaseObject as Armor) < 0) && (kSlotVisualRight.Find(akBaseObject as Armor) < 0))
					If((bWearingCloak) || (bWearingBackpack))
						Int iSlotMask = (akBaseObject as Armor).GetSlotMask()
						If(iSlotMask == iSlotMaskCloak)
							bWearingCloak = False
						ElseIf(iSlotMask == iSlotMaskBackpack)
							bWearingBackpack = False
						EndIf
						If((!bWearingCloak) && (!bWearingBackpack))
							gvWearingBackpackCloak.SetValue(0)
							If(bSettingShieldHide)
								If((!IsSlotEquipped(8, True)) && (bHotkeyEquip))
									EquipSlot(8, True)
								EndIf
							ElseIf(bSettingShieldAccomodate)
								If(IsSlotEquipped(8, True))
									UnequipSlot(8, True)
								EndIf
								SheatheSlot(8, True)
								If(bHotkeyEquip)
									EquipSlot(8, True)
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		bProcessingUnequip = False
	EndEvent

	State HotkeyEquip
		Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
		EndEvent

		Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
		EndEvent
	EndState


;####################################################################################################################################################
;Hotkey system and updating the favorites list
;####################################################################################################################################################
	Event OnKeyDown(int aiKey)
		;Trace("Hotkey pressed: " + aiKey)
		If(!bProcessingHotkey)
			bProcessingHotkey = True
			If(!IsTextInputEnabled())
				If(aiKey == iHotkeyFavorites)
					If(IsMenuOpen("InventoryMenu"))
						bUpdateFavoritesList = True
						UnregisterForKey(iHotkeyFavorites)
					EndIf
				Else
					Int iSlot = iHotkeySlot.Find(aiKey)
					If(iSlot >= 0)
						If(IsInMenuMode())
							If(IsMenuOpen("FavoritesMenu"))
								If(iSlot < 8) ;Slots 1-8
									TapKey(iHotkeyRealSlot[iSlot])
								Else ;Groups 1-8
									iSlot -= 8
								EndIf
							EndIf
						Else
							If(iSlot < 8) ;Slots 1-8
								If(bSettingHotkeysSlotAlternative)
									Form kForm = Game.GetHotkeyBoundObject(iSlot)
									If(kForm)
										Int iType = GetSlotIndex(kForm)
										If(iType >= 0)
											If(iType == 8) ;Shields
												If(PlayerRef.IsEquipped(kForm))
													PlayerRef.UnequipItemEx(kForm)
												Else
													PlayerRef.EquipItemEx(kForm)
												EndIf
											ElseIf((iType == 7) || (iType == 5) || (iType == 4)) ;Crossbows, bows and two-handed melee weapons
												If(PlayerRef.IsEquipped(kForm))
													PlayerRef.UnequipItemEx(kForm)
												Else
													UnequipSlot(iType, False)
													PlayerRef.EquipItemEx(kForm)
												EndIf
											Else ;One-handed weapons
												Int iCount = PlayerRef.GetItemCount(kForm)
												If(iCount == 1)
													If(PlayerRef.IsEquipped(kForm))
														PlayerRef.UnequipItemEx(kForm)
													Else
														UnequipSlot(iType, False)
														PlayerRef.EquipItemEx(kForm, 1)
													EndIf
												ElseIf(iCount > 1)
													If(PlayerRef.GetEquippedObject(1) != kForm)
														UnequipSlot(iType, False)
														PlayerRef.EquipItemEx(kForm, 1)
													ElseIf(PlayerRef.GetEquippedObject(0) != kForm)
														UnequipSlot(iType, True)
														PlayerRef.EquipItemEx(kForm, 2)
													EndIf
												EndIf
											EndIf
										Else ;Armor, spells, potions, arrows
											If(kForm as Spell)
												If(PlayerRef.GetEquippedObject(0) != kForm)
													PlayerRef.EquipSpell((kForm as Spell), 0)
												ElseIf(PlayerRef.GetEquippedObject(1) != kForm)
													PlayerRef.EquipSpell((kForm as Spell), 1)
												EndIf
											ElseIf(kForm as Shout)
												PlayerRef.EquipShout(kForm as Shout)
											Else
												If(PlayerRef.IsEquipped(kForm))
													PlayerRef.UnequipItemEx(kForm)
												Else
													PlayerRef.EquipItemEx(kForm)
												EndIf
											EndIf
										EndIf
									EndIf
								Else
									;Equipping the hotkey bound item is handled here, unequipping of to-be-replaced items is handled in OnObjectUnequipped
									Form kForm = Game.GetHotkeyBoundObject(iSlot)
									If(kForm)
										Int iType = GetSlotIndex(kForm)
										;Notification("iType = " + iType)
										If(iType >= 0)
											Form kRight = PlayerRef.GetEquippedObject(1)
											Form kLeft = PlayerRef.GetEquippedObject(0)
											If(iType == 8) ;Shields
											ElseIf((iType == 7) || (iType == 5) || (iType == 4)) ;Crossbows, bows and two-handed melee weapons
												If(!PlayerRef.IsEquipped(kForm))
													UnequipSlot(iType, False)
												EndIf
											Else ;One-handed weapons
												Int iCount = PlayerRef.GetItemCount(kForm)
												If(iCount == 1)
													If(!PlayerRef.IsEquipped(kForm))
														UnequipSlot(iType, False)
													EndIf
												ElseIf(iCount > 1)
													If(PlayerRef.GetEquippedObject(1) != kForm)
														UnequipSlot(iType, False)
													ElseIf(PlayerRef.GetEquippedObject(0) != kForm)
														UnequipSlot(iType, True)
													EndIf
												EndIf
											EndIf
											GoToState("HotkeyEquip")
											TapKey(iHotkeyRealSlot[iSlot])
											GoToState("")
											If(PlayerRef.GetEquippedObject(1) != kRight)
												OnObjectUnequipped(kRight, None)
											EndIf
											If(PlayerRef.GetEquippedObject(0) != kLeft)
												OnObjectUnequipped(kLeft, None)
											EndIf
											If(PlayerRef.IsEquipped(kForm))
												OnObjectEquipped(kForm, None)
											EndIf
										Else ;Armor, spells, potions, arrows, etc.
											TapKey(iHotkeyRealSlot[iSlot])
										EndIf
									EndIf
								EndIf
							Else ;Groups 1-8
								;Trace("Hotkey - Group")
								iSlot -= 8
								If(kGroupHandItemRight[iSlot])
									Int iType = GetSlotIndex(kGroupHandItemRight[iSlot])
									If(iType >= 0)
										UnequipSlot(iType, False)
									EndIf
								EndIf
								SkyUI.GroupUse(iSlot)
								Int iARMOR_FLAG = SkyUI.GROUP_FLAG_UNEQUIP_ARMOR
								If(SkyUI.GetGroupFlag(iSlot, iARMOR_FLAG))
									EquipSlots()
								EndIf
							EndIf
							;OnUpdate() ;Debugging
						EndIf
					EndIf
				EndIf
			EndIf
			bProcessingHotkey = False
		EndIf
	EndEvent

	Event OnMenuOpen(string asMenuName)
		;Trace("Opening menu: " + asMenuName)
		If(asMenuName == "InventoryMenu")
			bHotkeyEquip = False
			UnequipSlots()
			If(Game.UsingGamepad())
				iHotkeyFavorites = GetMappedKey("Jump")
			Else
				iHotkeyFavorites = GetMappedKey("Toggle POV")
			EndIf
			RegisterForKey(iHotkeyFavorites)
		Else;If((asMenuName == "ContainerMenu") || (asMenuName == "FavoritesMenu"))
			bHotkeyEquip = False
			UnequipSlots()
		EndIf
	EndEvent

	Event OnMenuClose(string asMenuName)
		;Trace("Closing menu: " + asMenuName)
		If(asMenuName == "InventoryMenu")
			If(bUpdateFavoritesList)
				UpdateFavorites()
			EndIf
			bUpdateFavoritesList = False
			UnregisterForKey(iHotkeyFavorites)
		EndIf
		EquipSlots()
		bHotkeyEquip = True
	EndEvent

;####################################################################################################################################################
;Items being added and removed
;####################################################################################################################################################
	Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
		;Trace("Item added: " + akBaseItem.GetName() + " (" + aiItemCount + ")")
		Int iType = GetSlotIndex(akBaseItem)
		If(iType >= 0)
			If(Game.IsObjectFavorited(akBaseItem))
				If(iType == 8)
					If(FindReplacements(iType, True))
						If(bHotkeyEquip)
							EquipSlot(iType, True)
						EndIf
					EndIf
				ElseIf(iType == 7)
				ElseIf(iType == 5)
				ElseIf(iType == 4)
					If(FindReplacements(iType, False))
						If(bHotkeyEquip)
							EquipSlot(iType, False)
						EndIf
					EndIf
				Else
					Int iCount = PlayerRef.GetItemCount(akBaseItem)
					If(iCount > 1)
						If(FindReplacements(iType, False))
							If(bHotkeyEquip)
								EquipSlot(iType, False)
							EndIf
						EndIf
						If(FindReplacements(iType, True))
							If(bHotkeyEquip)
								EquipSlot(iType, True)
							EndIf
						EndIf
					ElseIf(iCount == 1)
						If(FindReplacements(iType, False))
							If(bHotkeyEquip)
								EquipSlot(iType, False)
							EndIf
						ElseIf(FindReplacements(iType, True))
							If(bHotkeyEquip)
								EquipSlot(iType, True)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			kFLSTInventory.AddForm(akBaseItem)
		Else
			If(akBaseItem as Potion)
				MagicEffect kMGEF = (akBaseItem as Potion).GetNthEffectMagicEffect(0)
				If(kFLSTRestoreHealth.Find(kMGEF) >= 0)
					kFLSTPotionsHealth.AddForm(akBaseItem)
				ElseIf(kFLSTRestoreMagicka.Find(kMGEF) >= 0)
					kFLSTPotionsMagicka.AddForm(akBaseItem)
				ElseIf(kFLSTRestoreStamina.Find(kMGEF) >= 0)
					kFLSTPotionsStamina.AddForm(akBaseItem)
				EndIf
			ElseIf(akBaseItem as Scroll)
				kFLSTScrolls.AddForm(akBaseItem)
			ElseIf(akBaseItem as Ingredient)
				kFLSTIngredients.AddForm(akBaseItem)
			EndIf
		EndIf
	EndEvent

	Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		;Trace("Item removed: " + akBaseItem.GetName() + " (" + aiItemCount + ")")
		Int iType = GetSlotIndex(akBaseItem)
		If(iType >= 0)
			Int iCount = PlayerRef.GetItemCount(akBaseItem)
			If(iCount == 1)
				If((kSlotItemLeft[iType] == akBaseItem) && (kHandItemLeft != akBaseItem)) ;Left hand
					UnequipSlot(iType, True)
					ClearSlot(iType, True)
					If(FindReplacements(iType, True))
						If(bHotkeyEquip)
							EquipSlot(iType, True)
						EndIf
					EndIf
				ElseIf((kSlotItemRight[iType] == akbaseItem) && (kHandItemRight != akBaseItem)) ;Right hand
					UnequipSlot(iType, False)
					ClearSlot(iType, False)
					If(FindReplacements(iType, False))
						If(bHotkeyEquip)
							EquipSlot(iType, False)
						EndIf
					EndIf
				EndIf
			ElseIf(iCount == 0)
				If(kSlotItemLeft[iType] == akBaseItem) ;Left hand
					UnequipSlot(iType, True)
					ClearSlot(iType, True)
					If(FindReplacements(iType, True))
						If(bHotkeyEquip)
							EquipSlot(iType, True)
						EndIf
					EndIf
				EndIf
				If(kSlotItemRight[iType] == akBaseItem) ;Right hand
					UnequipSlot(iType, False)
					ClearSlot(iType, False)
					If(FindReplacements(iType, False))
						If(bHotkeyEquip)
							EquipSlot(iType, False)
						EndIf
					EndIf
				EndIf
				kFLSTInventory.RemoveAddedForm(akBaseItem)
			EndIf
		Else
			If(akBaseItem as Armor)
				If((kSlotVisualLeft.Find(akBaseItem as Armor) >= 0) || (kSlotVisualRight.Find(akBaseItem as Armor) >= 0))
					If(PlayerRef.GetItemCount(akBaseItem) == 0)
						PlayerRef.AddItem(akBaseItem)
					EndIf
				EndIf
			EndIf
		EndIf
	EndEvent

;####################################################################################################################################################
;Sheathing and drawing weapons
;####################################################################################################################################################
	Event OnAnimationEvent(ObjectReference akSource, string asEventName) ;WeaponDraw fires after leaving a menu, which one entered with weapons drawn
		Float fAttenuation = kSNDRUnequipArmor.GetDecibelAttenuation()
		Int iVariance = kSNDRUnequipArmor.GetDecibelVariance()
		kSNDRUnequipArmor.SetDecibelAttenuation(100.0)
		kSNDRUnequipArmor.SetDecibelVariance(0)
		;Trace("Animation event: " + asEventName)
		If(asEventName == "WeaponDraw")
			bWeaponDrawn = True
		ElseIf(asEventName == "WeaponSheathe")
			bWeaponDrawn = False
		EndIf
		If(kHandItemLeft)
			Int iType = kSlotItemLeft.Find(kHandItemLeft)
			If(iType >= 0)
				If(asEventName == "WeaponDraw")
					If(iType == 8) ;Shield
						UnequipSlot(iType, True)
					ElseIf(iType == 6) ;Staff
						UnequipSlot(iType, True)
					Else
						UnequipSlot(iType, True)
						DrawSlot(iType, True)
						EquipSlot(iType, True)
					EndIf
				ElseIf(asEventName == "WeaponSheathe")
					If(iType == 8)
						EquipSlot(iType, True)
					ElseIf(iType == 6) ;Staff
						EquipSlot(iType, True)
					Else
						UnequipSlot(iType, True)
						SheatheSlot(iType, True)
						EquipSlot(iType, True)
					EndIf
				EndIf
			EndIf
		EndIf
		If(kHandItemRight)
			Int iType = kSlotItemRight.Find(kHandItemRight)
			If(iType >= 0)
				If(asEventName == "WeaponDraw")
					If(iType == 6) ;Staff
						UnequipSlot(iType, False)
					EndIf
				ElseIf(asEventName == "WeaponSheathe")
					If(iType == 6) ;Staff
						EquipSlot(iType, False)
					EndIf
				EndIf
			EndIf
		EndIf
		kSNDRUnequipArmor.SetDecibelVariance(iVariance)
		kSNDRUnequipArmor.SetDecibelAttenuation(fAttenuation)
	EndEvent

;####################################################################################################################################################
;Race switching
;####################################################################################################################################################
	Event OnRaceSwitchComplete()
		;Trace("Race switch completed")
		Race kNewPlayerRace = PlayerRef.GetRace()
		;Notification("New race: " + kNewPlayerRace.GetName())
		If(((kPlayerRace != kRaceWerewolf) && (kPlayerRace != kRaceVampireLord)) && ((kNewPlayerRace == kRaceWerewolf) || (kNewPlayerRace == kRaceVampireLord)))
			;Notification("Turned into Werewolf or Vampire Lord")
			UnregisterForAllMenus()
			UnregisterForAnimations()
			UnequipSlots()
		ElseIf(((kPlayerRace == kRaceWerewolf) || (kPlayerRace == kRaceVampireLord)) && ((kNewPlayerRace != kRaceWerewolf) && (kNewPlayerRace != kRaceVampireLord)))
			;Notification("Turned into a non-Werewolf or non-Vampire Lord race")
			RegisterForMenus()
			RegisterForAnimations()
			EquipSlots()
			Wait(1.0)
			PlayerRef.RemoveSpell(kSPELPlayerVisualization)
			Wait(1.0)
			PlayerRef.AddSpell(kSPELPlayerVisualization, False)
		EndIf
		kPlayerRace = kNewPlayerRace
	EndEvent

;####################################################################################################################################################
;SkyUI mod events
;####################################################################################################################################################
	Event OnGroupAdd(String asEventName, String asStrArg, Float afNumArg, Form akSender)
		Int iGroup = afNumArg as Int
		Int iItemID = asStrArg as Int
		Form kForm = SkyUI.GetFormFromItemId(iGroup, iItemID)
		If(kForm as Weapon)
			If((kForm as Weapon).GetEquipType() == kEquipSlotTwoHanded)
				If(!kGroupHandItemRight[iGroup])
					iGroupHandItemIDRight[iGroup] = iItemID
					kGroupHandItemRight[iGroup] = kForm
					iGroupHandItemIDLeft[iGroup] = iItemID
					kGroupHandItemLeft[iGroup] = kForm
				EndIf
			Else
				If(!kGroupHandItemRight[iGroup])
					iGroupHandItemIDRight[iGroup] = iItemID
					kGroupHandItemRight[iGroup] = kForm
				ElseIf(!kGroupHandItemLeft[iGroup])
					iGroupHandItemIDLeft[iGroup] = iItemID
					kGroupHandItemLeft[iGroup] = kForm
				EndIf
			EndIf
		ElseIf(kForm as Spell)
			If((kForm as Spell).GetEquipType() == kEquipSlotTwoHanded)
				iGroupHandItemIDRight[iGroup] = iItemID
				kGroupHandItemRight[iGroup] = kForm
				iGroupHandItemIDLeft[iGroup] = iItemID
				kGroupHandItemLeft[iGroup] = kForm
			Else
				If(!kGroupHandItemRight[iGroup])
					iGroupHandItemIDRight[iGroup] = iItemID
					kGroupHandItemRight[iGroup] = kForm
				ElseIf(!kGroupHandItemLeft[iGroup])
					iGroupHandItemIDLeft[iGroup] = iItemID
					kGroupHandItemLeft[iGroup] = kForm
				EndIf
			EndIf
		ElseIf((kForm as Armor).IsShield())
			If(!kGroupHandItemLeft[iGroup])
				iGroupHandItemIDLeft[iGroup] = iItemID
				kGroupHandItemLeft[iGroup] = kForm
			EndIf
		ElseIf(kForm as Light)
			If(!kGroupHandItemLeft[iGroup])
				iGroupHandItemIDLeft[iGroup] = iItemID
				kGroupHandItemLeft[iGroup] = kForm
			EndIf
		EndIf
	EndEvent

	Event OnSaveEquipState(String asEventName, String asStrArg, Float afNumArg, Form akSender)
		Int iGroup = afNumArg as Int
		Int iItemID = asStrArg as Int
		Int iMainHandID = UI.GetInt("FavoritesMenu", "_root.MenuHolder.Menu_mc.rightHandItemId")
		Int iOffHandID = UI.GetInt("FavoritesMenu", "_root.MenuHolder.Menu_mc.leftHandItemId")
		Form kMainHand = SkyUI.GetFormFromItemId(iGroup, iMainHandID)
		Form kOffHand = SkyUI.GetFormFromItemId(iGroup, iOffHandID)
		If(kMainHand)
			iGroupHandItemIDRight[iGroup] = iMainHandID
			kGroupHandItemRight[iGroup] = kMainHand
		Else
			iGroupHandItemIDRight[iGroup] = 0
			kGroupHandItemRight[iGroup] = None
		EndIf
		If(kOffHand)
			iGroupHandItemIDLeft[iGroup] = iOffHandID
			kGroupHandItemLeft[iGroup] = kOffHand
		Else
			iGroupHandItemIDLeft[iGroup] = 0
			kGroupHandItemLeft[iGroup] = None
		EndIf
	EndEvent

	Event OnGroupRemove(String asEventName, String asStrArg, Float afNumArg, Form akSender)
		Int iGroup = afNumArg as Int
		Int iItemID = asStrArg as Int
		If(iItemID == iGroupHandItemIDRight[iGroup])
			iGroupHandItemIDRight[iGroup] = 0
			kGroupHandItemRight[iGroup] = None
			If(iItemID == iGroupHandItemIDLeft[iGroup])
				iGroupHandItemIDLeft[iGroup] = 0
				kGroupHandItemLeft[iGroup] = None
			Else
				If(kGroupHandItemLeft[iGroup] as Weapon)
					If(PlayerRef.GetItemCount(kGroupHandItemLeft[iGroup]) > 1)
						iGroupHandItemIDRight[iGroup] = iGroupHandItemIDLeft[iGroup]
						kGroupHandItemRight[iGroup] = kGroupHandItemLeft[iGroup]
					Else
						iGroupHandItemIDRight[iGroup] = iGroupHandItemIDLeft[iGroup]
						kGroupHandItemRight[iGroup] = kGroupHandItemLeft[iGroup]
						iGroupHandItemIDLeft[iGroup] = 0
						kGroupHandItemLeft[iGroup] = None
					EndIf
				ElseIf(kGroupHandItemLeft[iGroup] as Spell)
					iGroupHandItemIDRight[iGroup] = iGroupHandItemIDLeft[iGroup]
					kGroupHandItemRight[iGroup] = kGroupHandItemLeft[iGroup]
				EndIf
			EndIf
		ElseIf(iItemID == iGroupHandItemIDLeft[iGroup])
			iGroupHandItemIDLeft[iGroup] = 0
			kGroupHandItemLeft[iGroup] = None
		EndIf
	EndEvent

;####################################################################################################################################################
;Functions
;####################################################################################################################################################
	Function Maintenance()
		If(kSNDRUnequipArmor == None)
			kSNDRUnequipArmor = Game.GetFormFromFile(0x0003E60B, "Skyrim.esm") as SoundDescriptor
		EndIf

		UnequipSlots()

		Int i = 0
		If(!bInventoryProcessed)
			Int iSize = PlayerRef.GetNumItems()
			While(i < iSize)
				Form kForm = PlayerRef.GetNthForm(i)
				Int iType = GetSlotIndex(kForm)
				If(iType >= 0)
					kFLSTInventory.AddForm(kForm)
				Else
					If(kForm as Potion)
						MagicEffect kMGEF = (kForm as Potion).GetNthEffectMagicEffect(0)
						If(kFLSTRestoreHealth.Find(kMGEF) >= 0)
							kFLSTPotionsHealth.AddForm(kForm)
						ElseIf(kFLSTRestoreMagicka.Find(kMGEF) >= 0)
							kFLSTPotionsMagicka.AddForm(kForm)
						ElseIf(kFLSTRestoreStamina.Find(kMGEF) >= 0)
							kFLSTPotionsStamina.AddForm(kForm)
						EndIf
					ElseIf(kForm as Scroll)
						kFLSTScrolls.AddForm(kForm)
					ElseIf(kForm as Ingredient)
						kFLSTIngredients.AddForm(kForm)
					EndIf
				EndIf
				i += 1
			EndWhile
			bInventoryProcessed = True
		EndIf

		i = 0
		;Get Vampire Lord Race
		If(kRaceVampireLord == None)
			If(Game.GetModByName("Dawnguard.esm") != 255)
				kRaceVampireLord = Game.GetFormFromFile(0x0200283A, "Dawnguard.esm") as Race
			EndIf
		EndIf

		If(kFLSTElderScrolls.GetSize() == 2)
			If(Game.GetModByName("Dawnguard.esm") != 255)
				kFLSTElderScrolls.AddForm(Game.GetFormFromFile(0x020118F9, "Dawnguard.esm") as Book)
				kFLSTElderScrolls.AddForm(Game.GetFormFromFile(0x02011A13, "Dawnguard.esm") as Book)
			EndIf
		EndIf

		If(kEquipSlotTwoHanded == None)
			kEquipSlotTwoHanded = Game.GetFormFromFile(0x00013f45, "Skyrim.esm") as EquipSlot
		EndIf

		If(kRaceWerewolf == None)
			kRaceWerewolf = Game.GetFormFromFile(0x000CDD84, "Skyrim.esm") as Race
		EndIf

		If(kFLSTBackpacks.GetSize() == 0)
			If(Game.GetModByName("Chesko_Frostfall.esp") != 255)
				FormList kFLST = Game.GetFormFromFile(0x0202C274, "Chesko_Frostfall.esp") as FormList
				Int iSize = kFLST.GetSize()
				i = 0
				While(i < iSize)
					Form kForm = kFLST.GetAt(i)
					;If(kFLSTBackpacks.Find(kForm) < 0)
						kFLSTBackpacks.AddForm(kForm)
					;EndIf
					i += 1
				EndWhile
			EndIf
		EndIf

		;Set slotmasks
		i = 0
		While(i < 9)
			SetSlotMaskForSlot(i, True, iSlotMaskIndexLeft[i])
			SetSlotMaskForSlot(i, False, iSlotMaskIndexRight[i])
			i += 1
		EndWhile

		;Add missing slots
		i = 0
		While(i < 9)
			If(kSlotVisualLeft[i])
				Int iLeftCount = PlayerRef.GetItemCount(kSlotVisualLeft[i])
				If(iLeftCount == 0)
					PlayerRef.AddItem(kSlotVisualLeft[i], 1, True)
				ElseIf(iLeftCount > 1)
					PlayerRef.RemoveItem(kSlotVisualLeft[i], (iLeftCount - 1), True)
				EndIf
			EndIf
			If(kSlotVisualRight[i])
				Int iRightCount = PlayerRef.GetItemCount(kSlotVisualRight[i])
				If(iRightCount == 0)
					PlayerRef.AddItem(kSlotVisualRight[i], 1, True)
				ElseIf(iRightCount > 1)
					PlayerRef.RemoveItem(kSlotVisualRight[i], (iRightCount - 1), True)
				EndIf
			EndIf
			i += 1
		EndWhile

		;Refresh SKSE registrations
		UnregisterForAllModEvents()
		If(SkyUI == None)
			If(Game.GetModByName("SkyUI.esp") != 255)
				SkyUI = Game.GetFormFromFile(0x0000082A, "SkyUI.esp") as SKI_FavoritesManager
			EndIf
		EndIf
		If(SkyUI)
			RegisterForModEvent("SKIFM_groupAdd", "OnGroupAdd")
			RegisterForModEvent("SKIFM_groupRemove", "OnGroupRemove")
			RegisterForModEvent("SKIFM_saveEquipState", "OnSaveEquipState")
		EndIf

		;Update real slot hotkeys, in case they have changed
		iHotkeyRealSlot[0] = GetMappedKey("Hotkey1")
		iHotkeyRealSlot[1] = GetMappedKey("Hotkey2")
		iHotkeyRealSlot[2] = GetMappedKey("Hotkey3")
		iHotkeyRealSlot[3] = GetMappedKey("Hotkey4")
		iHotkeyRealSlot[4] = GetMappedKey("Hotkey5")
		iHotkeyRealSlot[5] = GetMappedKey("Hotkey6")
		iHotkeyRealSlot[6] = GetMappedKey("Hotkey7")
		iHotkeyRealSlot[7] = GetMappedKey("Hotkey8")

		;Register for hotkeys
		UnregisterForAllKeys()
		SetupHotkeys()

		UnregisterForAllMenus()
		RegisterForMenus()

		SetBoolSetting("ShieldAccomodate", (gvSettingShieldAccomodate.GetValueInt() as Bool))
		SetBoolSetting("ShieldHide", (gvSettingShieldHide.GetValueInt() as Bool))
		SetBoolSetting("HotkeySlotAlternative", (gvSettingHotkeysSlotAlternative.GetValueInt() as Bool))

		i = 0
		bWeaponDrawn = PlayerRef.IsWeaponDrawn()
		While(i < kSlotVisualLeft.Length)
			If(kSlotItemLeft[i])
				If(i == 8)
					If((bWearingCloak) || (bWearingBackpack))
						If(bSettingShieldAccomodate)
							DrawSlot(i, True)
						ElseIf(bSettingShieldHide)
							DrawSlot(i, True)
						Else
							SheatheSlot(i, True)
						EndIf
					Else
						SheatheSlot(i, True)
					EndIf
				Else
					If(PlayerRef.IsEquipped(kSlotItemLeft[i]))
						If(bWeaponDrawn)
							DrawSlot(i, True)
						Else
							SheatheSlot(i, True)
						EndIf
					Else
						SheatheSlot(i, True)
					EndIf
				EndIf
			EndIf
			If(kSlotItemRight[i])
				If(PlayerRef.IsEquipped(kSlotItemRight[i]))
					If(bWeaponDrawn)
						DrawSlot(i, False)
					Else
						SheatheSlot(i, False)
					EndIf
				Else
					SheatheSlot(i, False)
				EndIf
			EndIf
			i += 1
		EndWhile

		EquipSlots()
	EndFunction

	Function RegisterForMenus()
		RegisterForMenu("InventoryMenu")
		RegisterForMenu("ContainerMenu")
		RegisterForMenu("FavoritesMenu")
		RegisterForMenu("TweenMenu")
	EndFunction

	Function SetupHotkeys()
		If((SkyUI) && (gvSettingHotkeysGroupEnabled.GetValueInt() as Bool))
			Int[] iSkyUIHotkeys = SkyUI.GetGroupHotkeys()
			Int i = 0
			While(i < 8)
				If(iSkyUIHotkeys[i] != -1)
					iHotkeySlot[i + 8] = iSkyUIHotkeys[i]
					SkyUI.SetGroupHotkey(i, -1)
				EndIf
				i += 1
			EndWhile
		Else
			Int i = 8
			While(i < 16)
				iHotkeySlot[i] = -1
				i += 1
			EndWhile
		EndIf
		RegisterForSlotHotkeys()
	EndFunction

	Function ResetGroupHotkeys()
		Int i = 0
		While(i < 8)
			If(iHotkeySlot[i + 8] != -1)
				SkyUI.SetGroupHotkey(i, iHotkeySlot[i + 8])
				iHotkeySlot[i + 8] = -1
			EndIf
			i += 1
		EndWhile
	EndFunction

	Function RegisterForSlotHotkeys()
		Int i = 0
		If(gvSettingHotkeysSlotEnabled.GetValueInt() as Bool)
			While(i < 8)
				If(iHotkeySlot[i] >= 1)
					RegisterForKey(iHotkeySlot[i])
				EndIf
				i += 1
			EndWhile
		EndIf
		i = 8
		If(gvSettingHotkeysGroupEnabled.GetValueInt() as Bool)
			While(i < 16)
				If(iHotkeySlot[i] >= 1)
					RegisterForKey(iHotkeySlot[i])
				EndIf
				i += 1
			EndWhile
		EndIf
	EndFunction

	Int Function GetSlotIndex(Form akBase)
		;-1 = Irrelevant
		;0 = Swords
		;1 = Daggers
		;2 = War axes
		;3 = Maces
		;4 = Greatswords, Battleaxes and warhammers
		;5 = Bows
		;6 = Staves
		;7 = Crossbows
		;8 = Shields
		If(akBase)
			Weapon kWeapon = akBase as Weapon
			If(kWeapon)
				Int iType = kWeapon.GetWeaponType() - 1 ;Removes fists from the list
				If(iType > 4)
					iType = iType - 1 ;Combines two-handed melee weapons into one slot
				EndIf
				Return iType
			EndIf
			Armor kArmor = akBase as Armor
			If(kArmor)
				If(kArmor.IsShield())
					Return 8
				EndIf
			EndIf
		EndIf
		Return -1
	EndFunction

	Function DrawSlot(Int aiParam, Bool abLeft = False)
		If((aiParam >= 0) && (aiParam <= 8))
			If(abLeft)
				kSlotVisualLeft[aiParam].GetNthArmorAddon(0).SetModelPath(sSlotDrawnLeft[aiParam], False, False)
			Else
				kSlotVisualRight[aiParam].GetNthArmorAddon(0).SetModelPath(sSlotDrawnRight[aiParam], False, False)
			EndIf
		EndIf
	EndFunction

	Function SheatheSlot(Int aiParam, Bool abLeft = False)
		If((aiParam >= 0) && (aiParam <= 8))
			If(abLeft)
				If(kSlotVisualLeft[aiParam])
					kSlotVisualLeft[aiParam].GetNthArmorAddon(0).SetModelPath(sSlotSheathedLeft[aiParam], False, False)
				EndIf
			Else
				If(kSlotVisualRight[aiParam])
					kSlotVisualRight[aiParam].GetNthArmorAddon(0).SetModelPath(sSlotSheathedRight[aiParam], False, False)
				EndIf
			EndIf
		EndIf
	EndFunction

	Function EquipSlots()
		;Trace("Equipping slots")
		If(bWeaponDrawn)
			;Left hand
			If(kSlotItemLeft[0]) ;Sword
				If(kSlotItemLeft[0] == kHandItemLeft)
					DrawSlot(0, True)
				Else
					SheatheSlot(0, True)
				EndIf
				EquipSlot(0, True)
			EndIf
			If(kSlotItemLeft[1]) ;Dagger
				If(kSlotItemLeft[1] == kHandItemLeft)
					DrawSlot(1, True)
				Else
					SheatheSlot(1, True)
				EndIf
				EquipSlot(1, True)
			EndIf
			If(kSlotItemLeft[2]) ;War Axe
				If(kSlotItemLeft[2] == kHandItemLeft)
					DrawSlot(2, True)
				Else
					SheatheSlot(2, True)
				EndIf
				EquipSlot(2, True)
			EndIf
			If(kSlotItemLeft[3]) ;Mace
				If(kSlotItemLeft[3] == kHandItemLeft)
					DrawSlot(3, True)
				Else
					SheatheSlot(3, True)
				EndIf
				EquipSlot(3, True)
			EndIf
			If(kSlotItemLeft[6]) ;Staff
				If(kSlotItemLeft[6] == kHandItemLeft)
					;Do nothing
				Else
					EquipSlot(6, True)
				EndIf
			EndIf
			If(kSlotItemLeft[8]) ;Shield
				If(kSlotItemLeft[8] == kHandItemLeft)
					;Do nothing
				Else
					EquipSlot(8, True)
				EndIf
			EndIf

			;Right hand
			If((kSlotItemRight[0]) && (kHandItemRight != kSlotItemRight[0])) ;Sword
				EquipSlot(0, False)
			EndIf
			If((kSlotItemRight[1]) && (kHandItemRight != kSlotItemRight[1])) ;Dagger
				EquipSlot(1, False)
			EndIf
			If((kSlotItemRight[2]) && (kHandItemRight != kSlotItemRight[2])) ;War Axe
				EquipSlot(2, False)
			EndIf
			If((kSlotItemRight[3]) && (kHandItemRight != kSlotItemRight[3])) ;Mace
				EquipSlot(3, False)
			EndIf
			If((kSlotItemRight[4]) && (kHandItemRight != kSlotItemRight[4])) ;Two-handed melee
				EquipSlot(4, False)
			EndIf
			If(kSlotItemRight[6]) ;Staff
				If(kSlotItemRight[6] == kHandItemRight)
					;Do nothing
				Else
					EquipSlot(6, False)
				EndIf
			EndIf
		Else
			;Left hand
			If(kSlotItemLeft[0]) ;Sword
				EquipSlot(0, True)
			EndIf
			If(kSlotItemLeft[1]) ;Dagger
				EquipSlot(1, True)
			EndIf
			If(kSlotItemLeft[2]) ;War Axe
				EquipSlot(2, True)
			EndIf
			If(kSlotItemLeft[3]) ;Mace
				EquipSlot(3, True)
			EndIf
			If(kSlotItemLeft[6]) ;Staff
				EquipSlot(6, True)
			EndIf
			If(kSlotItemLeft[8]) ;Shield
				EquipSlot(8, True)
			EndIf

			;Right hand
			If((kSlotItemRight[0]) && (kHandItemRight != kSlotItemRight[0])) ;Sword
				EquipSlot(0, False)
			EndIf
			If((kSlotItemRight[1]) && (kHandItemRight != kSlotItemRight[1])) ;Dagger
				EquipSlot(1, False)
			EndIf
			If((kSlotItemRight[2]) && (kHandItemRight != kSlotItemRight[2])) ;War Axe
				EquipSlot(2, False)
			EndIf
			If((kSlotItemRight[3]) && (kHandItemRight != kSlotItemRight[3])) ;Mace
				EquipSlot(3, False)
			EndIf
			If((kSlotItemRight[4]) && (kHandItemRight != kSlotItemRight[4])) ;Two-handed melee
				EquipSlot(4, False)
			EndIf
			If(kSlotItemRight[6]) ;Staff
				EquipSlot(6, False)
			EndIf
		EndIf
	EndFunction

	Function UnequipSlots()
		Float fAttenuation = kSNDRUnequipArmor.GetDecibelAttenuation()
		Int iVariance = kSNDRUnequipArmor.GetDecibelVariance()
		kSNDRUnequipArmor.SetDecibelAttenuation(100.0)
		kSNDRUnequipArmor.SetDecibelVariance(0)
		;Trace("Unequipping slots")
		Int i = 0
		While(i < 9)
			UnequipSlot(i, True)
			UnequipSlot(i, False)
			i += 1
		EndWhile
		kSNDRUnequipArmor.SetDecibelVariance(iVariance)
		kSNDRUnequipArmor.SetDecibelAttenuation(fAttenuation)
	EndFunction

	Function EquipSlot(Int aiParam, Bool abLeft = False)
		If((aiParam >= 0) && (aiParam <= 8))
			;Trace("Equipping slot at index " + aiParam)
			If(abLeft)
				If((aiParam == 8) && (bSettingShieldHide) && (bWearingCloak) && (bWearingBackpack))
					Return
				EndIf
				If(kSlotVisualLeft[aiParam])
					PlayerRef.EquipItemEx(kSlotVisualLeft[aiParam], 0, False, False)
				EndIf
			Else
				If(kSlotVisualRight[aiParam])
					PlayerRef.EquipItemEx(kSlotVisualRight[aiParam], 0, False, False)
				EndIf
			EndIf
		EndIf
	EndFunction

	Function UnequipSlot(Int aiParam, Bool abLeft = False)
		If((aiParam >= 0) && (aiParam <= 8))
			;Trace("Unequipping slot at index " + aiParam)
			If(abLeft)
				If(kSlotVisualLeft[aiParam])
					PlayerRef.UnequipItem(kSlotVisualLeft[aiParam], False, True)
				EndIf
				
			Else
				If(kSlotVisualRight[aiParam])
					PlayerRef.UnequipItem(kSlotVisualRight[aiParam], False, True)
				EndIf
			EndIf
		EndIf
	EndFunction

	Bool Function SetShieldSlotMask(Bool abEnable)
		If((kSlotVisualLeft[8]) && (kSlotVisualLeft[8]))
			If(abEnable)
				kSlotVisualLeft[8].GetNthArmorAddon(0).AddSlotToMask(0x00000200)
				Return True
			Else
				kSlotVisualLeft[8].GetNthArmorAddon(0).RemoveSlotFromMask(0x00000200)
				Return True
			EndIf
		EndIf
		Return False
	EndFunction

	Bool Function FillSlot(Int aiParam, Bool abLeft = False, Form akBase)
		If((aiParam >= 0) && (aiParam <= 8) && (akBase))
			If((abLeft) && (kSlotVisualLeft[aiParam]))
			ElseIf((!abLeft) && (kSlotVisualRight[aiParam]))
			Else
				Return False
			EndIf
			String sPath = ""
			If(aiParam == 8) ;Shield
				If(abLeft)
					kSlotItemLeft[aiParam] = akBase
					sPath = (akBase as Armor).GetNthArmorAddon(0).GetModelPath(False, False)
					sSlotDrawnLeft[aiParam] = AppendModelPath(sPath, "OnBackClk")
					sSlotSheathedLeft[aiParam] = AppendModelPath(sPath, "OnBack")
				EndIf
			ElseIf((aiParam == 5) || (aiParam == 7)) ;Bows and crossbows
			ElseIf(aiParam == 6) ;Staves
				sPath = (akBase as Weapon).GetModelPath()
				If(abLeft)
					kSlotItemLeft[aiParam] = akBase
					sSlotDrawnLeft[aiParam] = ""
					sSlotSheathedLeft[aiParam] = AppendModelPath(sPath, "Left")
				Else
					kSlotItemRight[aiParam] = akBase
					sSlotDrawnRight[aiParam] = ""
					sSlotSheathedRight[aiParam] = AppendModelPath(sPath, "Right")
				EndIf
			ElseIf(aiParam == 4) ;Two-handed melee
				sPath = (akBase as Weapon).GetModelPath()
				kSlotItemRight[aiParam] = akBase
				sSlotDrawnRight[aiParam] = ""
				sSlotSheathedRight[aiParam] = sPath
			Else ;One-handed melee
				sPath = (akBase as Weapon).GetModelPath()
				If(abLeft)
					kSlotItemLeft[aiParam] = akBase
					sSlotDrawnLeft[aiParam] = AppendModelPath(sPath, "Sheath")
					sSlotSheathedLeft[aiParam] = AppendModelPath(sPath, "Left")
				Else
					kSlotItemRight[aiParam] = akBase
					sSlotDrawnRight[aiParam] = ""
					sSlotSheathedRight[aiParam] = sPath
				EndIf
			EndIf
			Return True
		EndIf
		Return False
	EndFunction

	Function ClearSlot(Int aiParam, Bool abLeft = False)
		If((aiParam >= 0) && (aiParam <= 8))
			If(abLeft)
				If(kSlotVisualLeft[aiParam])
					kSlotItemLeft[aiParam] = None
					sSlotDrawnLeft[aiParam] = ""
					sSlotSheathedLeft[aiParam] = ""
					kSlotVisualLeft[aiParam].GetNthArmorAddon(0).SetModelPath("", False, False)
				EndIf
			Else
				If(kSlotVisualRight[aiParam])
					kSlotItemRight[aiParam] = None
					sSlotDrawnRight[aiParam] = ""
					sSlotSheathedRight[aiParam] = ""
					kSlotVisualRight[aiParam].GetNthArmorAddon(0).SetModelPath("", False, False)
				EndIf
			EndIf
		EndIf
	EndFunction

	String Function AppendModelPath(String asTarget, String asSuffix)
		;"OnBack" Regular shield
		;"OnBackClk" Shield, when cloak is equipped
		;"Left" Weapon
		;"Sheath" Weapon
		;"Right" Staff specific
		String sBase = StringUtil.Substring(asTarget, 0, (StringUtil.GetLength(asTarget) - 4))
		sBase = sBase + asSuffix + ".nif"
		Return sBase
	EndFunction

	Bool Function IsSlotEquipped(Int aiParam, Bool abLeft = False)
		If((aiParam >= 0) && (aiParam <= 8))
			If(abLeft)
				If(kSlotVisualLeft[aiParam])
					Return PlayerRef.IsEquipped(kSlotVisualLeft[aiParam])
				EndIf
			Else
				If(kSlotVisualRight[aiParam])
					Return PlayerRef.IsEquipped(kSlotVisualRight[aiParam])
				EndIf
			EndIf
		EndIf
		Return False
	EndFunction

	Function UpdateFavorites()
		;Clear slots of unfavorited items
		Int iNum = 0
		While(iNum < 9)
			If((kSlotItemLeft[iNum]) && (kHandItemLeft != kSlotItemLeft[iNum]) && (!Game.IsObjectFavorited(kSlotItemLeft[iNum])))
				ClearSlot(iNum, True)
			EndIf
			If((kSlotItemRight[iNum]) && (kHandItemRight != kSlotItemRight[iNum]) && (!Game.IsObjectFavorited(kSlotItemRight[iNum])))
				ClearSlot(iNum, False)
			EndIf
			iNum += 1
		EndWhile

		FindReplacements()
	EndFunction

	Bool Function FindReplacements(Int aiParam = -1, Bool abLeft = False)
		;Fill empty slots with favorited items
		Int iNum = kFLSTInventory.GetSize();PlayerRef.GetNumItems()
		If(iNum > 0)
			Int i = 0
			While(i < iNum)
				Form kForm = kFLSTInventory.GetAt(i) ;PlayerRef.GetNthForm(i)
				If(Game.IsObjectFavorited(kForm))
					Int iType = GetSlotIndex(kForm)
					If(iType >= 0)
						If(aiParam == -1) ;Update all
							If(iType == 8)
								If((kSlotItemLeft[iType] == None) && (kSlotVisualLeft[iType]))
									If(FillSlot(iType, True, kForm))
										UnequipSlot(iType, True)
										If((bWearingCloak) || (bWearingBackpack))
											DrawSlot(iType, True)
										Else
											SheatheSlot(iType, True)
										EndIf
									EndIf
								EndIf
							ElseIf(iType == 4)
								If((kSlotItemRight[iType] == None) && (kSlotVisualRight[iType]))
									If(FillSlot(iType, False, kForm))
										UnequipSlot(iType, False)
										SheatheSlot(iType, False)
									EndIf
								EndIf
							Else
								Int iCount = PlayerRef.GetItemCount(kForm)
								If(iCount > 1)
									If((kSlotItemRight[iType] == None) && (kSlotVisualRight[iType]))
										If(FillSlot(iType, False, kForm))
											UnequipSlot(iType, False)
											SheatheSlot(iType, False)
										EndIf
									EndIf
									If((kSlotItemLeft[iType] == None) && (kSlotVisualLeft[iType]))
										If(FillSlot(iType, True, kForm))
											UnequipSlot(iType, True)
											SheatheSlot(iType, True)
										EndIf
									EndIf
								ElseIf(iCount == 1)
									If((kSlotItemRight[iType] == None) && (kSlotItemLeft[iType] != kForm) && (kSlotVisualRight[iType]))
										If(FillSlot(iType, False, kForm))
											UnequipSlot(iType, False)
											SheatheSlot(iType, False)
										EndIf
									ElseIf((kSlotItemLeft[iType] == None) && (kSlotItemRight[iType] != kForm) && (kSlotVisualLeft[iType]))
										If(FillSlot(iType, True, kForm))
											UnequipSlot(iType, True)
											SheatheSlot(iType, True)
										EndIf
									EndIf
								EndIf
							EndIf
						Else
							If(iType == aiParam)
								If(abLeft)
									If(PlayerRef.GetItemCount(kForm) > 1)
										If((kSlotItemLeft[iType] == None) && (kSlotVisualLeft[iType]))
											If(FillSlot(iType, True, kForm))
												UnequipSlot(iType, True)
												SheatheSlot(iType, True)
												Return True
											EndIf
										EndIf
									Else
										If((kSlotVisualRight[iType]) && (kSlotItemRight[iType] != kForm))
											If((kSlotItemLeft[iType] == None) && (kSlotVisualLeft[iType]))
												If(FillSlot(iType, True, kForm))
													UnequipSlot(iType, True)
													SheatheSlot(iType, True)
													Return True
												EndIf
											EndIf
										EndIf
									EndIf
								Else
									If(PlayerRef.GetItemCount(kForm) > 1)
										If((kSlotItemRight[iType] == None) && (kSlotVisualRight[iType]))
											If(FillSlot(iType, False, kForm))
												UnequipSlot(iType, False)
												SheatheSlot(iType, False)
												Return True
											EndIf
										EndIf
									Else
										If((kSlotVisualLeft[iType]) && (kSlotItemLeft[iType] != kForm))
											If((kSlotItemRight[iType] == None) && (kSlotVisualRight[iType]))
												If(FillSlot(iType, False, kForm))
													UnequipSlot(iType, False)
													SheatheSlot(iType, False)
													Return True
												EndIf
											EndIf
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				i += 1
			EndWhile
		EndIf
		Return False
	EndFunction

	Function RegisterForAnimations()
		RegisterForAnimationEvent(PlayerRef, "WeaponDraw")
		RegisterForAnimationEvent(PlayerRef, "WeaponSheathe")
	EndFunction

	Function UnregisterForAnimations()
		UnregisterForAnimationEvent(PlayerRef, "WeaponDraw")
		UnregisterForAnimationEvent(PlayerRef, "WeaponSheathe")
	EndFunction

	Function SetBoolSetting(String asParam, Bool abValue)
		If(asParam != "")
			If(asParam == "ShieldAccomodate")
				If((bSettingShieldAccomodate) && (!abValue))
					If(bHotkeyEquip)
						EquipSlot(8, True)
					EndIf
				EndIf
				bSettingShieldAccomodate = abValue
			ElseIf(asParam == "ShieldHide")
				If((bSettingShieldHide) && (!abValue))
					If(IsSlotEquipped(8, True))
						UnequipSlot(8, True)
					EndIf
					SheatheSlot(8, True)
					If(bHotkeyEquip)
						EquipSlot(8, True)
					EndIf
				EndIf
				bSettingShieldHide = abValue
			ElseIf(asParam == "HotkeySlotAlternative")
				bSettingHotkeysSlotAlternative = abValue
			EndIf
		EndIf
	EndFunction

	Bool Function GetBoolSetting(String asParam)
		If(asParam != "")
			If(asParam == "ShieldAccomodate")
				Return bSettingShieldAccomodate
			ElseIf(asParam == "ShieldHide")
				Return bSettingShieldHide
			ElseIf(asParam == "HotkeySlotAlternative")
				Return bSettingHotkeysSlotAlternative
			EndIf
		EndIf
	EndFunction

	Function DisableSlot(Int aiParam, Bool abLeft = False)
		If((aiParam >= 0) && (aiParam <= 8))
			If(abLeft)
				If(kSlotVisualLeft[aiParam])
					kSlotVisualDisabledLeft[aiParam] = kSlotVisualLeft[aiParam]
					kSlotVisualLeft[aiParam] = None
				EndIf
			Else
				If(kSlotVisualRight[aiParam])
					kSlotVisualDisabledRight[aiParam] = kSlotVisualRight[aiParam]
					kSlotVisualRight[aiParam] = None
				EndIf
			EndIf
		EndIf
	EndFunction

	Function EnableSlot(Int aiParam, Bool abLeft = False)
		If((aiParam >= 0) && (aiParam <= 8))
			If(abLeft)
				If(kSlotVisualDisabledLeft[aiParam])
					kSlotVisualLeft[aiParam] = kSlotVisualDisabledLeft[aiParam]
					kSlotVisualDisabledLeft[aiParam] = None
				EndIf
			Else
				If(kSlotVisualDisabledRight[aiParam])
					kSlotVisualRight[aiParam] = kSlotVisualDisabledRight[aiParam]
					kSlotVisualDisabledRight[aiParam] = None
				EndIf
			EndIf
		EndIf
	EndFunction

	Function SetSlotMaskForSlot(Int aiSlot, Bool abLeft = False, Int aiSlotMaskIndex)
		If((aiSlot >= 0) && (aiSlot <= 8) && (aiSlotMaskIndex >= 0))
			If(abLeft)
				Int iIndex = aiSlot
				Int iOldSlotMask = iSlotMasks[iSlotMaskIndexLeft[iIndex]]
				Int iNewSlotMask = iSlotMasks[aiSlotMaskIndex]
				iSlotMaskIndexLeft[iIndex] = aiSlotMaskIndex
				If(iOldSlotMask == 0x00000000) ;Enabling
					EnableSlot(iIndex, True)
				EndIf
				If(kSlotVisualLeft[iIndex])
					If(iOldSlotMask != 0x00000000)
						kSlotVisualLeft[iIndex].RemoveSlotFromMask(iOldSlotMask)
						kSlotVisualLeft[iIndex].GetNthArmorAddon(0).RemoveSlotFromMask(iOldSlotMask)
					EndIf
					If(iNewSlotMask != 0x00000000)
						kSlotVisualLeft[iIndex].AddSlotToMask(iNewSlotMask)
						kSlotVisualLeft[iIndex].GetNthArmorAddon(0).AddSlotToMask(iNewSlotMask)
					EndIf
				EndIf
				If(iNewSlotMask == 0x00000000) ;Disabling
					DisableSlot(iIndex, True)
				EndIf
			Else
				Int iIndex = aiSlot
				Int iOldSlotMask = iSlotMasks[iSlotMaskIndexRight[iIndex]]
				Int iNewSlotMask = iSlotMasks[aiSlotMaskIndex]
				iSlotMaskIndexRight[iIndex] = aiSlotMaskIndex
				If(iOldSlotMask == 0x00000000)
					EnableSlot(iIndex, False)
				EndIf
				If(kSlotVisualRight[iIndex])
					If(iOldSlotMask != 0x00000000)
						kSlotVisualRight[iIndex].RemoveSlotFromMask(iOldSlotMask)
						kSlotVisualRight[iIndex].GetNthArmorAddon(0).RemoveSlotFromMask(iOldSlotMask)
					EndIf
					If(iNewSlotMask != 0x00000000)
						kSlotVisualRight[iIndex].AddSlotToMask(iNewSlotMask)
						kSlotVisualRight[iIndex].GetNthArmorAddon(0).AddSlotToMask(iNewSlotMask)
					EndIf
				EndIf
				If(iNewSlotMask == 0x00000000)
					DisableSlot(iIndex, False)
				EndIf
			EndIf
		EndIf
	EndFunction