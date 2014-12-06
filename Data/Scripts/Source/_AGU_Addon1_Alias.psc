Scriptname _AGU_Addon1_Alias extends ReferenceAlias  

;###################################################################################################################################################
;Properties
;###################################################################################################################################################

FormList Property flFavorites Auto
FormList Property flNonfavorites Auto
FormList[] Property flWeaponBase Auto
FormList[] Property flWeaponLeftWeapon Auto
FormList[] Property flWeaponLeftSheath Auto
FormList[] Property flWeaponRightWeapon Auto
FormList Property flStaffBase Auto
FormList Property flStaffLeft Auto
FormList Property flStaffRight Auto
FormList Property flShieldBase Auto
FormList Property flShieldBack Auto
FormList Property flShieldBackUnequipped Auto
FormList Property flArrowBase Auto
FormList Property flArrowBack Auto
FormList Property flBoltBase Auto
FormList Property flBoltBack Auto

;###################################################################################################################################################
;Local variables
;###################################################################################################################################################

Bool bUpdateFavorites = False
Bool bProcessingEquipping = False
Bool bProcessingUnequipping = False
Bool bAddonInitialized = False
Bool bAddonDisabled = False
Bool bExtraUnequipped = False
Actor PlayerRef

Bool bWeaponDrawn

;/kLeft*
0 - Sword
1 - Dagger
2 - War Axe
3 - Mace
4 - Staff
/;
Weapon[] kLeftBase
Armor[] kLeftWeapon
Armor[] kLeftSheath

Weapon kRightBase
Armor kRightWeapon

Armor kShieldBase
Armor kShieldBack
Armor kShieldBackUnequipped

Ammo kArrowBase
Armor kArrowBack

Ammo kBoltBase
Armor kBoltBack

Form Property kLeftHandBase Auto Hidden
Armor kLeftHandWeapon
Armor kLeftHandSheath

Weapon Property kRightHandBase Auto Hidden
Armor kRightHandWeapon

Weapon Property kExtraBase Auto Hidden
Armor Property kExtraWeapon Auto Hidden

SoundCategory audioUI

;###################################################################################################################################################
;Events
;###################################################################################################################################################

Event OnInit()
	If(IsAddonLoaded())
		Debug.Notification("Initializing 'All Geared Up - Walking Armory'")
		PlayerRef = Game.GetPlayer() as Actor
		;Declare new arrays
		kLeftBase = New Weapon[5]
		kLeftWeapon = New Armor[5]
		kLeftSheath = New Armor[5]

		;Register for vanilla events
		RegisterForAnimationEvent(PlayerRef, "WeaponDraw")
		RegisterForAnimationEvent(PlayerRef, "WeaponSheathe")

		audioUI = Game.GetFormFromFile(0x00064451, "Skyrim.esm") as SoundCategory
		
		;Register for SKSE events
		InitSKSE()
		ProcessInventory()
		bAddonInitialized = True
		Debug.Notification("'All Geared Up - Walking Armory' initialized")
	Else
		;Debug.Notification("Freezing 'All Geared Up - Walking Armory'")
		GoToState("Inert")
	EndIf
EndEvent

Event OnPlayerLoadGame()
	If(bAddonInitialized)
		If(IsAddonLoaded())
			;Debug.Notification("Refreshing 'All Geared Up - Walking Armory'")
			InitSKSE()
		Else
			bAddonInitialized = False
			bAddonDisabled = True
			ClearAllSlots()
			;Debug.Notification("Freezing 'All Geared Up - Walking Armory'")
			GoToState("Inert")
		EndIf
	Else
		If(bAddonDisabled)
			If(IsAddonLoaded())
				;Debug.Notification("Thawing 'All Geared Up - Walking Armory'")
				bAddonInitialized = True
				bAddonDisabled = False
				GoToState("")
				OnInit()
			EndIf
		Else
			If(IsAddonLoaded())
				;Debug.Notification("Thawing 'All Geared Up - Walking Armory'")
				bAddonInitialized = True
				GoToState("")
				OnInit()
			EndIf
		EndIf
	EndIf
EndEvent

Event OnMenuOpen(String asMenu)
	If(asMenu == "InventoryMenu")
		RegisterForKey(Input.GetMappedKey("Toggle POV"))
	EndIf
	UnequipSilent(kExtraWeapon)
EndEvent

Event OnKeyDown(Int aiKey)
	If(UI.IsMenuOpen("InventoryMenu"))
		;Debug.Notification("Update favorites once the menu closes")
		bUpdateFavorites = True
	EndIf
EndEvent

Event OnMenuClose(String asMenu)
	UnregisterForKey(Input.GetMappedKey("Toggle POV"))
	If(bUpdateFavorites)
		CheckFavorites()
		CheckNonfavorites()
	EndIf
	bUpdateFavorites = False
	Weapon kWeapon = kLeftHandBase as Weapon
	If(kWeapon)
		If(kWeapon != kExtraBase)
			Int iSlot = WeaponType(kWeapon)
			If(iSlot >= 0)
				If((PlayerRef.GetItemCount(kWeapon) > 1) && (kWeapon != kRightHandBase) && (WeaponType(kRightHandBase) != iSlot) && (!FindReplacementWeapon(kWeapon, iSlot)))
					FillExtraSlot(kWeapon, iSlot)
				EndIf
			Else
				ClearExtraSlot()
			EndIf
		Else
			If(kWeapon != kRightHandBase)
				EquipSilent(kExtraWeapon)
			Else
				ClearExtraSlot()
			EndIf
		EndIf
	Else
		ClearExtraSlot()
	EndIf
EndEvent

Event BeforeVanillaHotkey(Form akForm, Bool abWeaponDrawn)
	;Debug.Notification("Vanilla hotkey - Before tap")
	bWeaponDrawn = abWeaponDrawn
	If((!IsExtraSlotEmpty()) && (akForm == kExtraBase))
		ClearExtraSlot()
	EndIf
EndEvent

Event AfterVanillaHotkey(Form akForm, Bool abWeaponDrawn)
	;Debug.Notification("Vanilla hotkey - After tap")
EndEvent

Event BeforeSkyUIHotkey(Form akRightHand, Form akLeftHand, Bool abWeaponDrawn)
	;Debug.Notification("SkyUI hotkey - Before tap")
	bWeaponDrawn = abWeaponDrawn
	If((!IsExtraSlotEmpty()) && (akRightHand == kExtraBase))
		ClearExtraSlot()
	EndIf
EndEvent

Event AfterSkyUIHotkey(Form akRightHand, Form akLeftHand, Bool abWeaponDrawn)
	;Debug.Notification("SkyUI hotkey - After tap")
EndEvent

Event OnItemFavorited(Form akForm)
	;Debug.Notification("Favorited " +akForm.GetName())
	flFavorites.AddForm(akForm)
	flNonfavorites.RemoveAddedForm(akForm)
	Int iItemType = ItemType(akForm)
	If(iItemType >= 0)
		If(iItemType == 0)
			;Debug.Notification("Favorited a weapon")
			Weapon kWeapon = akForm as Weapon
			Int iSlot = WeaponType(kWeapon)
			If(iSlot >= 0)
				If(iSlot != 4)
					If(IsWeaponSlotEmpty(iSlot))
						;Debug.Notification("Slot is empty")
						FillWeaponSlot(kWeapon, iSlot)
						Int iCount = PlayerRef.GetItemCount(kLeftBase[iSlot])
						If(iCount > 1)
							;Debug.Notification("Multiple copies")
							EquipSilent(kLeftWeapon[iSlot])
						ElseIf(iCount == 1)
							;Debug.Notification("Single copy")
							If((kRightHandBase != None) && (kWeapon != kRightHandBase) && (WeaponType(kRightHandBase) == iSlot))
								;Debug.Notification("Right hand is filled with a weapon of the same type")
								EquipSilent(kLeftWeapon[iSlot])
							EndIf
						EndIf
					EndIf
				Else
					If(IsWeaponSlotEmpty(iSlot, True)) ;Right staff
						;Debug.Notification("Right staff slot is empty")
						FillWeaponSlot(kWeapon, iSlot, True)
						EquipSilent(kRightWeapon)
					EndIf
					If(IsWeaponSlotEmpty(iSlot)) ;Left staff
						FillWeaponSlot(kWeapon, iSlot)
						If(PlayerRef.GetItemCount(kWeapon) > 1)
							EquipSilent(kLeftWeapon[4])
						Else
							If(GetWeaponInSlot(4, True) != kWeapon)
								EquipSilent(kLeftWeapon[4])
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		ElseIf(iItemType == 1) ;Shield
			If(IsShieldSlotEmpty())
				FillShieldSlot(akForm as Armor)
				EquipSilent(kShieldBackUnequipped)
			EndIf
		ElseIf(iItemType == 2)
			Ammo kAmmo = akForm as Ammo
			If(IsNonBolt(kAmmo)) ;Arrow
				If(IsAmmoSlotEmpty())
					FillAmmoSlot(kAmmo)
					If(PlayerRef.GetWornForm(kArrowBack.GetSlotMask()) == None)
						EquipSilent(kArrowBack)
					EndIf
				EndIf
			Else ;Bolt
				If(IsAmmoSlotEmpty(False))
					FillAmmoSlot(kAmmo, False)
					If(PlayerRef.GetWornForm(kBoltBack.GetSlotMask()) == None)
						EquipSilent(kBoltBack)
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndEvent

Event OnItemUnfavorited(Form akForm)
	;Debug.Notification("Unfavorited " +akForm.GetName())
	flNonfavorites.AddForm(akForm)
	flFavorites.RemoveAddedForm(akForm)
	Int iItemType = ItemType(akForm)
	If(iItemType >= 0)
		If(iItemType == 0)
			Weapon kWeapon = akForm as Weapon
			Int iSlot = WeaponType(kWeapon)
			If(iSlot >= 0)
				If(PlayerRef.GetEquippedWeapon(True) != akForm)
					Bool bEquipped = False
					If(PlayerRef.IsEquipped(kLeftWeapon[iSlot]))
						bEquipped = True
					EndIf
					ClearWeaponSlot(iSlot)
					kWeapon = FindReplacementWeapon(akForm, iSlot)
					If(kWeapon)
						FillWeaponSlot(kWeapon, iSlot)
						If(bEquipped)
							EquipSilent(kLeftWeapon[iSlot])
						EndIf
					EndIf
				Else
					If(kExtraBase == kWeapon)
						ClearExtraSlot()
					EndIf
				EndIf
				If(iSlot == 4)
					If(PlayerRef.GetEquippedWeapon() != akForm)
						Bool bEquipped = False
						If(PlayerRef.IsEquipped(kRightWeapon))
							bEquipped = True
						EndIf
						ClearWeaponSlot(iSlot, True)
						kWeapon = FindReplacementWeapon(akForm, iSlot, True)
						If(kWeapon)
							FillWeaponSlot(kWeapon, iSlot, True)
							If(bEquipped)
								EquipSilent(kRightWeapon)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		ElseIf(iItemType == 1) ;Shield
			If((!PlayerRef.IsEquipped(akForm)) && (kShieldBase == akForm))
				Bool bEquipped = False
				If(PlayerRef.IsEquipped(kShieldBackUnequipped))
					bEquipped = True
				EndIf
				ClearShieldSlot()
				Armor kShield = FindReplacementShield(akForm)
				If(kShield)
					FillShieldSlot(kShield)
					If(bEquipped)
						EquipSilent(kShieldBackUnequipped)
					EndIf
				EndIf
			EndIf
		ElseIf(iItemType == 2)
			Ammo kAmmo = akForm as Ammo
			If(IsNonBolt(kAmmo)) ;Arrow
				If((!PlayerRef.IsEquipped(kAmmo)) && (kArrowBase == kAmmo))
					Bool bEquipped = False
					If(PlayerRef.IsEquipped(kArrowBack))
						bEquipped = True
					EndIf
					ClearAmmoSlot()
					kAmmo = FindReplacementAmmo(akForm)
					If(kAmmo)
						FillAmmoSlot(kAmmo)
						If(bEquipped)
							EquipSilent(kArrowBack)
						EndIf
					EndIf
				EndIf
			Else ;Bolt
				If((!PlayerRef.IsEquipped(kAmmo)) && (kBoltBase == kAmmo))
					Bool bEquipped = False
					If(PlayerRef.IsEquipped(kBoltBack))
						bEquipped = True
					EndIf
					ClearAmmoSlot(False)
					kAmmo = FindReplacementAmmo(akForm, False)
					If(kAmmo)
						FillAmmoSlot(kAmmo, False)
						If(bEquipped)
							EquipSilent(kBoltBack)
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndEvent

Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	bProcessingUnequipping = True
	If(flFavorites.Find(akBaseObject) >= 0)
		Int iItemType = ItemType(akBaseObject)
		If(iItemType >= 0)
			String sDebug = "Unequipped a favorited " +akBaseObject.GetName()
			If(iItemType == 0)
				Weapon kWeapon = akBaseObject as Weapon
				Int iSlot = WeaponType(kWeapon)
				If(iSlot >= 0)
					If((PlayerRef.GetEquippedWeapon(True) != kWeapon) && (kWeapon == kLeftHandBase)) ;Left hand
						sDebug = sDebug + " from the left hand"
						If(PlayerRef.GetItemCount(kWeapon) > 1)
							EquipSilent(kLeftHandWeapon)
						Else
							RemoveSilent(kLeftHandSheath)
							RemoveSilent(kLeftHandWeapon)
						EndIf
						ClearLeftHand()
						If(kWeapon == kExtraBase)
							ClearExtraSlot()
						EndIf
					ElseIf((PlayerRef.GetEquippedWeapon() != kWeapon) && (kWeapon == kRightHandBase)) ;Right hand
						sDebug = sDebug + " from the right hand"
						EquipSilent(kRightHandWeapon)
						ClearRightHand()
					EndIf
				Else
					If((PlayerRef.GetEquippedWeapon(True) != kWeapon) && (kWeapon == kLeftHandBase)) ;Left hand
						ClearLeftHand()
					EndIf
					If((PlayerRef.GetEquippedWeapon() != kWeapon) && (kWeapon == kRightHandBase)) ;Right hand
						ClearRightHand()
					EndIf
				EndIf
			ElseIf(iItemType == 1) ;Shield
				EquipSilent(kShieldBackUnequipped)
				ClearLeftHand()
			ElseIf(iItemType == 2)
				Ammo kAmmo = akBaseObject as Ammo
				If(IsNonBolt(kAmmo)) ;Arrow
					If(PlayerRef.GetItemCount(kAmmo) == 0) ;Ran out of this ammo
						ClearAmmoSlot()
					EndIf
				Else ;Bolt
					If(PlayerRef.GetItemCount(kAmmo) == 0) ;Ran out of this ammo
						ClearAmmoSlot(False)
					EndIf
				EndIf
			EndIf
			;Debug.Notification(sDebug)
		Else
			;Debug.Notification("Unequipped something of no interest")
		EndIf
	Else
		Int iItemType = ItemType(akBaseObject)
		If(iItemType >= 0)
			String sDebug = "Unequipped a nonfavorited " +akBaseObject.GetName()
			If(iItemType == 0)
				Weapon kWeapon = akBaseObject as Weapon
				Int iSlot = WeaponType(kWeapon)
				If(iSlot >= 0)
					If(iSlot != 4)
						If((PlayerRef.GetEquippedWeapon(True) != kWeapon) && (kWeapon == kLeftHandBase)) ;Left hand
							sDebug = sDebug + " from the left hand"
							ClearWeaponSlot(iSlot)
							ClearLeftHand()
						ElseIf((PlayerRef.GetEquippedWeapon() != kWeapon) && (kWeapon == kRightHandBase)) ;Right hand
							sDebug = sDebug + " from the right hand"
							ClearRightHand()
						EndIf
					Else
						If((PlayerRef.GetEquippedWeapon(True) != kWeapon) && (kWeapon == kLeftHandBase)) ;Left hand
							sDebug = sDebug + " from the left hand (staff)"
							ClearWeaponSlot(iSlot)
							ClearLeftHand()
						ElseIf((PlayerRef.GetEquippedWeapon() != kWeapon) && (kWeapon == kRightHandBase)) ;Right hand
							sDebug = sDebug + " from the right hand (staff)"
							ClearWeaponSlot(iSlot, True)
							ClearRightHand()
						EndIf
					EndIf
				Else
					If((PlayerRef.GetEquippedWeapon(True) != kWeapon) && (kWeapon == kLeftHandBase)) ;Left hand
						ClearLeftHand()
					EndIf
					If((PlayerRef.GetEquippedWeapon() != kWeapon) && (kWeapon == kRightHandBase)) ;Right hand
						ClearRightHand()
					EndIf
				EndIf
			ElseIf(iItemType == 1) ;Shield
				ClearShieldSlot()
				ClearLeftHand()
			ElseIf(iItemType == 2)
				Ammo kAmmo = akBaseObject as Ammo
				If(IsNonBolt(kAmmo)) ;Arrow
					ClearAmmoSlot()
				Else ;Bolt
					ClearAmmoSlot(False)
				EndIf
			EndIf
			;Debug.Notification(sDebug)
		Else
			;Debug.Notification("Unequipped something of no interest")
		EndIf
	EndIf
	bProcessingUnequipping = False
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	bProcessingEquipping = True
	While(bProcessingUnequipping)
		Utility.WaitMenuMode(0.1)
	EndWhile
	Int iItemType = ItemType(akBaseObject)
	If(iItemType >= 0)
		String sDebug = "Equipped a(n) " +akBaseObject.GetName()
		If(iItemType == 0)
			Weapon kWeapon = akBaseObject as Weapon
			Int iSlot = WeaponType(kWeapon)
			If(iSlot >= 0)
				If((PlayerRef.GetEquippedWeapon(True) == kWeapon) && (kWeapon != kLeftHandBase)) ;Left hand
					If(iSlot != 4)
						sDebug = sDebug + " in the left hand"
						;MIGHT BE REDUNDANT
						EquipSilent(kLeftHandWeapon)
						If(kShieldBase)
							EquipSilent(kShieldBackUnequipped)
						EndIf
						FillWeaponSlot(kWeapon, iSlot)
						FillLeftHand(iSlot)
						If((PlayerRef.GetItemCount(kWeapon) > 1) && (kWeapon != kRightHandBase) && (WeaponType(kRightHandBase) != iSlot))
							If(!FindReplacementWeapon(kWeapon, iSlot))
								If(!IsExtraSlotEmpty())
									ClearExtraSlot()
								EndIf
								FillExtraSlot(kWeapon, iSlot)
								If(!Utility.IsInMenuMode())
									EquipSilent(kExtraWeapon)
								EndIf
							EndIf
						EndIf
					Else
						sDebug = sDebug + " in the left hand (staff)"
						;Debug.Notification("Equipping a staff (left)")
						EquipSilent(kLeftHandWeapon)
						If(kShieldBase)
							EquipSilent(kShieldBackUnequipped)
						EndIf
						FillWeaponSlot(kWeapon, iSlot)
						FillLeftHand(iSlot)
						If(PlayerRef.GetItemCount(kWeapon) == 1)
							If(kWeapon == GetWeaponInSlot(iSlot, True))
								ClearWeaponSlot(iSlot, True)
								;Fill with another weapon of the same type, if it exists
								Weapon kStaff = FindReplacementWeapon(akBaseObject, iSlot, True)
								If(kStaff)
									FillWeaponSlot(kStaff, iSlot, True)
									EquipSilent(kRightWeapon)
								EndIf
							EndIf
						EndIf
						If((IsWeaponSlotEmpty(0, True)) && (PlayerRef.GetItemCount(kWeapon) > 1))
							FillWeaponSlot(kWeapon, iSlot, True)
							EquipSilent(kRightWeapon)
						EndIf
					EndIf
				ElseIf((PlayerRef.GetEquippedWeapon() == kWeapon) && (kWeapon != kRightHandBase)) ;Right hand
					If(iSlot != 4)
						sDebug = sDebug + " in the right hand"
						EquipSilent(kRightHandWeapon)
						FillWeaponSlot(kWeapon, iSlot, True)
						FillRightHand(kWeapon, iSlot)
						If(PlayerRef.GetItemCount(kWeapon) == 1)
							If(kWeapon == GetWeaponInSlot(iSlot))
								ClearWeaponSlot(iSlot)
								;Fill with another weapon of the same type, if it exists
								kWeapon = FindReplacementWeapon(akBaseObject, iSlot)
								If(kWeapon)
									FillWeaponSlot(kWeapon, iSlot)
									EquipSilent(kLeftWeapon[iSlot])
								EndIf
							EndIf
						EndIf
						Weapon kWeaponLeft = kLeftHandBase as Weapon
						If(kWeaponLeft)
							If(PlayerRef.GetItemCount(kWeaponLeft) > 1)
								If(kWeaponLeft != kRightHandBase)
									If(WeaponType(kWeaponLeft) != iSlot)
										Int iSlotLeft = WeaponType(kWeaponLeft)
										If(!FindReplacementWeapon(kWeaponLeft, iSlotLeft))
											If(!IsExtraSlotEmpty())
												ClearExtraSlot()
											EndIf
											FillExtraSlot(kWeaponLeft, iSlotLeft)
											EquipSilent(kExtraWeapon)
										EndIf
									Else
										ClearExtraSlot()
									EndIf
								Else
									ClearExtraSlot()
								EndIf
							EndIf
						EndIf
					Else
						sDebug = sDebug + " in the right hand (staff)"
						;Debug.Notification("Equipping a staff (right)")
						EquipSilent(kRightHandWeapon)
						FillWeaponSlot(kWeapon, iSlot, True)
						FillRightHand(kWeapon, iSlot)
						If(PlayerRef.GetItemCount(kWeapon) == 1)
							If(kWeapon == GetWeaponInSlot(iSlot))
								ClearWeaponSlot(iSlot)
								;Fill with another weapon of the same type, if it exists
								Weapon kStaff = FindReplacementWeapon(akBaseObject, iSlot)
								If(kStaff)
									FillWeaponSlot(kStaff, iSlot)
									EquipSilent(kLeftWeapon[iSlot])
								EndIf
							EndIf
						EndIf
						If((IsWeaponSlotEmpty(iSlot)) && (PlayerRef.GetItemCount(kWeapon) > 1))
							FillWeaponSlot(kWeapon, iSlot)
							EquipSilent(kLeftWeapon[iSlot])
						EndIf
					EndIf
				EndIf
			Else ;Two handed weapon
				If(kShieldBase)
					EquipSilent(kShieldBackUnequipped)
				EndIf
				If((PlayerRef.GetEquippedWeapon(True) == kWeapon) && (kWeapon != kLeftHandBase)) ;Left hand
					sDebug = sDebug + " in the left hand (wrong)"
					EquipSilent(kLeftHandWeapon)
					kLeftHandBase = kWeapon
				EndIf
				If((PlayerRef.GetEquippedWeapon() == kWeapon) && (kWeapon != kRightHandBase)) ;Right hand
					sDebug = sDebug + " in the right hand (wrong)"
					EquipSilent(kRightHandWeapon)
					kRightHandBase = kWeapon
				EndIf

			EndIf
		ElseIf(iItemType == 1) ;Shield
			EquipSilent(kLeftHandWeapon)
			FillShieldSlot(akBaseObject as Armor)
			FillLeftHand(0, True)
		ElseIf(iItemType == 2)
			Ammo kAmmo = akBaseObject as Ammo
			If(IsNonBolt(kAmmo)) ;Arrow
				FillAmmoSlot(kAmmo)
				If(!IsAmmoSlotEmpty(False))
					EquipSilent(kBoltBack)
				EndIf
			Else ;Bolt
				FillAmmoSlot(kAmmo, False)
				If(!IsAmmoSlotEmpty())
					EquipSilent(kArrowBack)
				EndIf
			EndIf
		EndIf
		;Debug.Notification(sDebug)
	Else
		;Debug.Notification("Equipped something of no interest")
	EndIf
	bProcessingEquipping = False
	;Debug.Notification("Finished processing equipping of " +akBaseObject.GetName())
EndEvent

Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	Int iItemType = ItemType(akBaseItem)
	String sDebug = ""
	If(iItemType >= 0)
		Int iCount = PlayerRef.GetItemCount(akBaseItem)
		If(Game.IsObjectFavorited(akBaseItem))
			If(flFavorites.Find(akBaseItem) < 0)
				flFavorites.AddForm(akBaseItem)
			EndIf
		Else
			If(flNonfavorites.Find(akBaseItem) < 0)
				flNonfavorites.AddForm(akBaseItem)
			EndIf
		EndIf
		If(iItemType == 0)
			sDebug = "Received a weapon"
			If(Game.IsObjectFavorited(akBaseItem))
				Weapon kWeapon = akBaseItem as Weapon
				Int iSlot = WeaponType(kWeapon)
				If(iSlot >= 0)
					If(iSlot != 4)
						If((iCount > 1) && ((kLeftWeapon[iSlot] == None) || (kLeftBase[iSlot] == kWeapon)))
							FillWeaponSlot(kWeapon, iSlot)
							EquipSilent(kLeftWeapon[iSlot])
						EndIf
					Else
						If((iCount > 1) && ((kRightWeapon == None) || (kRightBase == kWeapon)))
							FillWeaponSlot(kWeapon, iSlot, True)
							EquipSilent(kRightWeapon)
						EndIf
						If((iCount > 1) && ((kLeftWeapon[iSlot] == None) || (kLeftBase[iSlot] == kWeapon)))
							FillWeaponSlot(kWeapon, iSlot)
							EquipSilent(kLeftWeapon[iSlot])
						EndIf
					EndIf
				EndIf
			EndIf
		ElseIf(iItemType == 1)
			sDebug = "Received a shield"
			If(Game.IsObjectFavorited(akBaseItem))
				If(IsShieldSlotEmpty())
					FillShieldSlot(akBaseItem as Armor)
					EquipSilent(kShieldBackUnequipped)
				EndIf
			EndIf
		ElseIf(iItemType == 2)
			If(Game.IsObjectFavorited(akBaseItem))
				Ammo kAmmo = akBaseItem as Ammo
				If(IsNonBolt(kAmmo))
					sDebug = "Received arrows"
				Else
					sDebug = "Received bolts"
				EndIf
			EndIf
		EndIf
	Else
		sDebug = "Received something of no interest"
	EndIf
	;Debug.Notification(sDebug)
EndEvent

Event OnItemRemoved(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	Int iItemType = ItemType(akBaseItem)
	String sDebug = ""
	If(iItemType >= 0)
		Int iCount = PlayerRef.GetItemCount(akBaseItem)
		If(Game.IsObjectFavorited(akBaseItem))
			If(flFavorites.Find(akBaseItem) >= 0)
				flFavorites.RemoveAddedForm(akBaseItem)
			EndIf
		Else
			If(flNonfavorites.Find(akBaseItem) >= 0)
				flNonfavorites.RemoveAddedForm(akBaseItem)
			EndIf
		EndIf
		If(iItemType == 0)
			sDebug = "Lost a weapon"
			Weapon kWeapon = akBaseItem as Weapon
			Int iSlot = WeaponType(kWeapon)
			If(iSlot >= 0)
				If(iSlot != 4)
					If(iCount <= 1)
						If(kLeftBase.Find(kWeapon) >= 0)
							If(PlayerRef.GetEquippedWeapon(True) != kWeapon)
								Bool bEquipped = False
								If(PlayerRef.IsEquipped(kLeftWeapon[iSlot]))
									bEquipped = True
								EndIf
								ClearWeaponSlot(iSlot)
								kWeapon = FindReplacementWeapon(kWeapon, iSlot)
								If(kWeapon)
									FillWeaponSlot(kWeapon, iSlot)
									If(bEquipped)
										EquipSilent(kLeftWeapon[iSlot])
									EndIf
								EndIf
							Else
								If(kExtraBase == kWeapon)
									ClearExtraSlot()
								EndIf
							EndIf
						EndIf
					EndIf
				Else
					If(iCount == 0)
						If(kLeftBase[iSlot] == kWeapon)
							Bool bEquipped = False
							If(PlayerRef.IsEquipped(kLeftWeapon[iSlot]))
								bEquipped = True
							EndIf
							ClearWeaponSlot(iSlot)
							Weapon kReplacement = FindReplacementWeapon(kWeapon, iSlot)
							If(kReplacement)
								FillWeaponSlot(kReplacement, iSlot)
								If(bEquipped)
									EquipSilent(kLeftWeapon[iSlot])
								EndIf
							EndIf
						EndIf
						If(kRightBase == kWeapon)
							Bool bEquipped = False
							If(PlayerRef.IsEquipped(kRightWeapon))
								bEquipped = True
							EndIf
							ClearWeaponSlot(iSlot, True)
							Weapon kReplacement = FindReplacementWeapon(kWeapon, iSlot, True)
							If(kReplacement)
								FillWeaponSlot(kReplacement, iSlot, True)
								If(bEquipped)
									EquipSilent(kRightWeapon)
								EndIf
							EndIf
						EndIf
					ElseIf(iCount == 1)
						If(kLeftBase[iSlot] == kWeapon)
							Bool bEquipped = False
							If(PlayerRef.IsEquipped(kLeftWeapon[iSlot]))
								bEquipped = True
							EndIf
							ClearWeaponSlot(iSlot)
							Weapon kReplacement = FindReplacementWeapon(kWeapon, iSlot)
							If(kReplacement)
								FillWeaponSlot(kReplacement, iSlot)
								If(bEquipped)
									EquipSilent(kLeftWeapon[iSlot])
								EndIf
							EndIf
						ElseIf(kRightBase == kWeapon)
							Bool bEquipped = False
							If(PlayerRef.IsEquipped(kRightWeapon))
								bEquipped = True
							EndIf
							ClearWeaponSlot(iSlot, True)
							Weapon kReplacement = FindReplacementWeapon(kWeapon, iSlot, True)
							If(kReplacement)
								FillWeaponSlot(kReplacement, iSlot, True)
								If(bEquipped)
									EquipSilent(kRightWeapon)
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		ElseIf(iItemType == 1)
			sDebug = "Lost a shield"
			If((kShieldBase == akBaseItem) && (iCount == 0))
				Bool bEquipped = False
				If(PlayerRef.IsEquipped(kShieldBackUnequipped))
					bEquipped = True
				EndIf
				ClearShieldSlot()
				Armor kShield = FindReplacementShield()
				If(kShield)
					FillShieldSlot(kShield)
					If(bEquipped)
						EquipSilent(kShieldBackUnequipped)
					EndIf
				EndIf
			EndIf
		ElseIf(iItemType == 2)
			Ammo kAmmo = akBaseItem as Ammo
			If(IsNonBolt(kAmmo))
				sDebug = "Lost arrows"
				If((kArrowBase == kAmmo) && (iCount == 0))
					Bool bEquipped = False
					If(PlayerRef.IsEquipped(kArrowBack))
						bEquipped = True
					EndIf
					ClearAmmoSlot()
					kAmmo = FindReplacementAmmo(kAmmo)
					If(kAmmo)
						FillAmmoSlot(kAmmo)
						If(bEquipped)
							EquipSilent(kArrowBack)
						EndIf
					EndIf
				EndIf
			Else
				sDebug = "Lost bolts"
				If((kBoltBase == kAmmo) && (iCount == 0))
					Bool bEquipped = False
					If(PlayerRef.IsEquipped(kBoltBack))
						bEquipped = True
					EndIf
					ClearAmmoSlot(False)
					kAmmo = FindReplacementAmmo(kAmmo, False)
					If(kAmmo)
						FillAmmoSlot(kAmmo, False)
						If(bEquipped)
							EquipSilent(kBoltBack)
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	Else
		sDebug = "Lost something of no interest"
	EndIf
	;Debug.Notification(sDebug)
EndEvent

Event OnAnimationEvent(ObjectReference akSource, String asEvent)
	If(asEvent == "WeaponDraw")
		;Do stuff
		If(kLeftHandBase == kShieldBase)
			UnequipSilent(kLeftHandWeapon)
		ElseIf(kLeftHandBase == kLeftBase[4])
			UnequipSilent(kLeftHandWeapon)
		ElseIf(kLeftBase.Find(kLeftHandBase as Weapon) >= 0) ;If((kLeftHandBase == kLeftBase[0]) || (kLeftHandBase == kLeftBase[1]) || (kLeftHandBase == kLeftBase[2]) || (kLeftHandBase == kLeftBase[3]))
			EquipSilent(kLeftHandSheath)
		EndIf
		If(kRightHandWeapon)
			UnequipSilent(kRightHandWeapon)
		EndIf
		While(PlayerRef.GetAnimationVariableBool("IsEquipping"))
			Utility.Wait(0.1)
		EndWhile
	Else ;Sheathe
		;Do stuff
		If(kLeftHandBase == kShieldBase)
			EquipSilent(kLeftHandWeapon)
		ElseIf(kLeftHandBase == kLeftBase[4])
			EquipSilent(kLeftHandWeapon)
		ElseIf(kLeftBase.Find(kLeftHandBase as Weapon) >= 0) ;If((kLeftHandBase == kLeftBase[0]) || (kLeftHandBase == kLeftBase[1]) || (kLeftHandBase == kLeftBase[2]) || (kLeftHandBase == kLeftBase[3]))
			EquipSilent(kLeftHandWeapon)
		EndIf
		If(kRightHandWeapon)
			EquipSilent(kRightHandWeapon)
		EndIf
		While(PlayerRef.GetAnimationVariableBool("IsUnequipping"))
			Utility.Wait(0.1)
		EndWhile
	EndIf
EndEvent

;###################################################################################################################################################
;Functions
;###################################################################################################################################################
Function ClearAllSlots()
	flFavorites.Revert()
	flNonfavorites.Revert()
	ClearRightHand()
	ClearLeftHand()
	ClearWeaponSlot(0)
	ClearWeaponSlot(1)
	ClearWeaponSlot(2)
	ClearWeaponSlot(3)
	ClearWeaponSlot(4)
	ClearWeaponSlot(4, True)
	ClearExtraSlot()
	ClearShieldSlot()
	ClearAmmoSlot()
	ClearAmmoSlot(False)
EndFunction

Function ClearRightHand()
	kRightHandBase = None
	kRightHandWeapon = None
EndFunction

Function ClearLeftHand()
	kLeftHandBase = None
	kLeftHandWeapon = None
	kLeftHandSheath = None
EndFunction

Function FillRightHand(Weapon akWeapon,Int aiSlot = 0)
	If((!bWeaponDrawn) || (Utility.IsInMenuMode()))
		bWeaponDrawn = PlayerRef.IsWeaponDrawn()
	EndIf
	kRightHandBase = akWeapon
	If(aiSlot == 4)
		kRightHandWeapon = kRightWeapon
		If(!bWeaponDrawn)
			EquipSilent(kRightHandWeapon)
		EndIf
	Else
		kRightHandWeapon = None
	EndIf
EndFunction

Function FillLeftHand(Int aiSlot = 0, Bool abShield = False)
	If((!bWeaponDrawn) || (Utility.IsInMenuMode()))
		bWeaponDrawn = PlayerRef.IsWeaponDrawn()
	EndIf
	If(!abShield)
		If(aiSlot != 4)
			kLeftHandBase = kLeftBase[aiSlot]
			kLeftHandWeapon = kLeftWeapon[aiSlot]
			kLeftHandSheath = kLeftSheath[aiSlot]
			If(bWeaponDrawn)
				EquipSilent(kLeftHandSheath)
			Else
				EquipSilent(kLeftHandWeapon)
			EndIf
		Else
			kLeftHandBase = kLeftBase[aiSlot]
			kLeftHandWeapon = kLeftWeapon[aiSlot]
			kLeftHandSheath = None
			If(!bWeaponDrawn)
				EquipSilent(kLeftHandWeapon)
			EndIf
		EndIf
	Else
		kLeftHandBase = kShieldBase
		kLeftHandWeapon = kShieldBack
		kLeftHandSheath = kShieldBackUnequipped
		If(!bWeaponDrawn)
			EquipSilent(kLeftHandWeapon)
		EndIf
	EndIf
EndFunction

Function FillWeaponSlot(Weapon akWeapon, Int aiSlot = 0, Bool abRightHand = False)
	If(akWeapon != None)
		If(!abRightHand)
			If(aiSlot != 4)
				If(!IsWeaponSlotEmpty(aiSlot))
					ClearWeaponSlot(aiSlot)
				EndIf
				Int iIndex = flWeaponBase[aiSlot].Find(akWeapon)
				If(iIndex >= 0)
					kLeftBase[aiSlot] = akWeapon
					kLeftWeapon[aiSlot] = flWeaponLeftWeapon[aiSlot].GetAt(iIndex) as Armor
					kLeftSheath[aiSlot] = flWeaponLeftSheath[aiSlot].GetAt(iIndex) as Armor
				Else
					kLeftBase[aiSlot] = None
					kLeftWeapon[aiSlot] = None
					kLeftSheath[aiSlot] = None
				EndIf
			Else
				If(!IsWeaponSlotEmpty(4))
					ClearWeaponSlot(aiSlot)
				EndIf
				Int iIndex = flStaffBase.Find(akWeapon)
				If(iIndex >= 0)
					kLeftBase[aiSlot] = akWeapon
					kLeftWeapon[aiSlot] = flStaffLeft.GetAt(iIndex) as Armor
					kLeftSheath[aiSlot] = None
				Else
					kLeftBase[aiSlot] = None
					kLeftWeapon[aiSlot] = None
					kLeftSheath[aiSlot] = None
				EndIf
			EndIf
		Else
			If(aiSlot == 4)
				If(!IsWeaponSlotEmpty(4, True))
					ClearWeaponSlot(aiSlot, True)
				EndIf
				Int iIndex = flStaffBase.Find(akWeapon)
				If(iIndex >= 0)
					kRightBase = akWeapon
					kRightWeapon = flStaffRight.GetAt(iIndex) as Armor
				Else
					kRightBase = None
					kRightWeapon = None
				EndIf
			Else
				kRightBase = None
				kRightWeapon = None
			EndIf
		EndIf
	EndIf
EndFunction

Function FillExtraSlot(Weapon akWeapon, Int aiSlot = 0)
	If((akWeapon != None) && (aiSlot != 4))
		If(!IsExtraSlotEmpty())
			ClearExtraSlot()
		EndIf
		Int iIndex = flWeaponBase[aiSlot].Find(akWeapon)
		If(iIndex >= 0)
			kExtraBase = akWeapon
			kExtraWeapon = flWeaponRightWeapon[aiSlot].GetAt(iIndex) as Armor
		Else
			kExtraBase = None
			kExtraWeapon = None
		EndIf
	EndIf
EndFunction

Function FillShieldSlot(Armor akShield)
	If(akShield != None)
		If(!IsShieldSlotEmpty())
			ClearShieldSlot()
		EndIf
		Int iIndex = flShieldBase.Find(akShield)
		If(iIndex >= 0)
			kShieldBase = akShield
			kShieldBack = flShieldBack.GetAt(iIndex) as Armor
			kShieldBackUnequipped = flShieldBackUnequipped.GetAt(iIndex) as Armor
		Else
			kShieldBase = None
			kShieldBack = None
			kShieldBackUnequipped = None
		EndIf
	EndIf
EndFunction

Function FillAmmoSlot(Ammo akAmmo, Bool abNonBolt = True)
	If(akAmmo != None)
		If(abNonBolt)
			If(!IsAmmoSlotEmpty())
				ClearAmmoSlot()
			EndIf
			Int iIndex = flArrowBase.Find(akAmmo)
			If(iIndex >= 0)
				kArrowBase = akAmmo
				kArrowBack = flArrowBack.GetAt(iIndex) as Armor
			Else
				kArrowBase = None
				kArrowBack = None
			EndIf
		Else
			If(!IsAmmoSlotEmpty(False))
				ClearAmmoSlot(False)
			EndIf
			Int iIndex = flBoltBase.Find(akAmmo)
			If(iIndex >= 0)
				kBoltBase = akAmmo
				kBoltBack = flBoltBack.GetAt(iIndex) as Armor
			Else
				kBoltBase = None
				kBoltBack = None
			EndIf
		EndIf
	EndIf
EndFunction

Bool Function IsWeaponSlotEmpty(Int aiSlot = 0, Bool abRightHand = False)
	If(!abRightHand)
		If(kLeftBase[aiSlot] == None)
			Return True
		Else
			Return False
		EndIf
	Else
		If(kRightBase == None)
			Return True
		Else
			Return False
		EndIf
	EndIf
EndFunction

Bool Function IsExtraSlotEmpty()
	If(kExtraBase == None)
		Return True
	Else
		Return False
	EndIf
EndFunction

Bool Function IsShieldSlotEmpty()
	If(kShieldBase == None)
		Return True
	Else
		Return False
	EndIf
EndFunction

Bool Function IsAmmoSlotEmpty(Bool abNonBolt = True)
	If(abNonBolt)
		If(kArrowBase == None)
			Return True
		Else
			Return False
		EndIf
	Else
		If(kBoltBase == None)
			Return True
		Else
			Return False
		EndIf
	EndIf
EndFunction

Weapon Function GetWeaponInSlot(Int aiSlot = 0, Bool abRightHand = False)
	If(!abRightHand)
		Return kLeftBase[aiSlot]
	Else
		Return kRightBase
	EndIf
EndFunction

Armor Function GetShieldInSlot()
	Return kShieldBase
EndFunction

Ammo Function GetAmmoInSlot(Bool abNonBolt = True)
	If(abNonBolt)
		Return kArrowBase
	Else
		Return kBoltBase
	EndIf
EndFunction

Function ClearWeaponSlot(Int aiSlot = 0, Bool abRightHand = False)
	If(!abRightHand)
		RemoveSilent(kLeftWeapon[aiSlot])
		RemoveSilent(kLeftSheath[aiSlot])
		kLeftBase[aiSlot] = None
		kLeftWeapon[aiSlot] = None
		kLeftSheath[aiSlot] = None
	Else
		RemoveSilent(kRightWeapon)
		kRightBase = None
		kRightWeapon = None
	EndIf
EndFunction

Function ClearExtraSlot()
	RemoveSilent(kExtraWeapon)
	kExtraBase = None
	kExtraWeapon = None
EndFunction

Function ClearShieldSlot()
	RemoveSilent(kShieldBack)
	RemoveSilent(kShieldBackUnequipped)
	kShieldBase = None
	kShieldBack = None
	kShieldBackUnequipped = None
EndFunction

Function ClearAmmoSlot(Bool abNonBolt = True)
	If(abNonBolt)
		RemoveSilent(kArrowBack)
		kArrowBase = None
		kArrowBack = None
	Else
		RemoveSilent(kBoltBack)
		kBoltBase = None
		kBoltBack = None
	EndIf
EndFunction

Weapon Function FindReplacementWeapon(Form akForm = None, Int aiSlot = 0, Bool abRightHand = False)
	Weapon kWeapon = akForm as Weapon
	Weapon kCandidate
	If(!abRightHand)
		Int iSize = flFavorites.GetSize()
		While(iSize >= 0)
			kCandidate = flFavorites.GetAt(iSize) as Weapon
			If((kCandidate != None) && (kCandidate != kWeapon) && (WeaponType(kCandidate) == aiSlot))
				If((!PlayerRef.IsEquipped(kCandidate)) || ((PlayerRef.IsEquipped(kCandidate)) && (PlayerRef.GetItemCount(kCandidate) > 1)))
					Return kCandidate
				EndIf
			EndIf
			iSize -= 1
		EndWhile
	Else
		Int iSize = flFavorites.GetSize()
		While(iSize >= 0)
			kCandidate = flFavorites.GetAt(iSize) as Weapon
			If((kCandidate != None) && (kCandidate != kWeapon) && (WeaponType(kCandidate) == 4))
				If(PlayerRef.IsEquipped(kCandidate))
					If(PlayerRef.GetItemCount(kCandidate) > 2)
						Return kCandidate
					EndIf
				Else
					Return kCandidate
				EndIf
			EndIf
			iSize -= 1
		EndWhile
	EndIf
EndFunction

Armor Function FindReplacementShield(Form akForm = None)
	Armor kShield = akForm as Armor
	Armor kCandidate
	Int iSize = flFavorites.GetSize()
	While(iSize >= 0)
		kCandidate = flFavorites.GetAt(iSize) as Armor
		If((kCandidate != None) && (kCandidate != kShield) && (kCandidate.IsShield()))
			Return kCandidate
		EndIf
		iSize -= 1
	EndWhile
EndFunction

Ammo Function FindReplacementAmmo(Form akForm = None, Bool abNonBolt = True)
	Ammo kAmmo = akForm as Ammo
	Ammo kCandidate
	If(abNonBolt)
		Int iSize = flFavorites.GetSize()
		While(iSize >= 0)
			kCandidate = flFavorites.GetAt(iSize) as Ammo
			If(kCandidate != None) && (kCandidate != kAmmo) && (flArrowBase.Find(kCandidate) >= 0)
				Return kCandidate
			EndIf
			iSize -= 1
		EndWhile
	Else
		Int iSize = flFavorites.GetSize()
		While(iSize >= 0)
			kCandidate = flFavorites.GetAt(iSize) as Ammo
			If(kCandidate != None) && (kCandidate != kAmmo) && (flBoltBase.Find(kCandidate) >= 0)
				Return kCandidate
			EndIf
			iSize -= 1
		EndWhile
	EndIf
EndFunction

Int Function ItemType(Form akForm)
	If(akForm != None)
		Weapon kWeapon = akForm as Weapon
		Armor kArmor = akForm as Armor
		Ammo kAmmo = akForm as Ammo
		If(kWeapon)
			If(IsOneHandedWeapon(kWeapon))
				Return 0
			Else
				Return -1
			EndIf
		ElseIf(kArmor)
			If(IsShieldArmor(kArmor))
				Return 1
			Else
				Return -1
			EndIf
		ElseIf(kAmmo)
			If(IsAmmo(kAmmo))
				Return 2
			Else
				Return -1
			EndIf
		Else
			Return -1
		EndIf
	Else
		Return -1
	EndIf
EndFunction

Int Function WeaponType(Weapon akWeapon)
	If(akWeapon != None)
		Int iType = akWeapon.GetWeaponType() - 1
		If(iType > 3) ;Not a sword, dagger, war axe or mace
			If(akWeapon.IsStaff())
				iType = 4
			Else
				iType = -1
			EndIf
		ElseIf(iType < 0)
			iType = -1
		EndIf
		Return iType
	Else
		Return -1
	EndIf
EndFunction

Bool Function IsOneHandedWeapon(Weapon akWeapon)
	If(akWeapon != None)
		If((akWeapon.IsSword()) || (akWeapon.IsDagger()) || (akWeapon.IsWarAxe()) || (akWeapon.IsMace()) || (akWeapon.IsStaff()))
			Return True
		Else
			Return False
		EndIf
	Else
		Return False
	EndIf
EndFunction

Bool Function IsShieldArmor(Armor akArmor)
	If(akArmor != None)
		If(akArmor.IsShield())
			Return True
		Else
			Return False
		EndIf
	Else
		Return False
	EndIf
EndFunction

Bool Function IsAmmo(Ammo akAmmo)
	If(akAmmo != None)
		Return True
	Else
		Return False
	EndIf
EndFunction

Bool Function IsNonBolt(Ammo akAmmo)
	If(akAmmo != None)
		If(flBoltBase.Find(akAmmo) >= 0)
			Return False
		Else
			Return True
		EndIf
	Else
		Return False
	EndIf
EndFunction

Function CheckFavorites()
	Int iSize = flFavorites.GetSize()
	Form kForm
	While(iSize >= 0)
		kForm = flFavorites.GetAt(iSize)
		If((kForm != None) && (!Game.IsObjectFavorited(kForm)))
			OnItemUnfavorited(kForm)
		EndIf
		iSize -= 1
	EndWhile
EndFunction

Function CheckNonfavorites()
	Int iSize = flNonfavorites.GetSize()
	Form kForm
	While(iSize >= 0)
		kForm = flNonfavorites.GetAt(iSize)
		If((kForm != None) && (Game.IsObjectFavorited(kForm)))
			OnItemFavorited(kForm)
		EndIf
		iSize -= 1
	EndWhile
EndFunction

Function EquipSilent(Form akForm)
	If(akForm != None)
		audioUI.Mute()
		PlayerRef.EquipItem(akForm, False, True)
		audioUI.Unmute()
	EndIf
EndFunction

Function UnequipSilent(Form akForm)
	If(akForm != None)
		audioUI.Mute()
		PlayerRef.UnequipItem(akForm, False, True)
		audioUI.Unmute()
	EndIf
EndFunction

Function RemoveSilent(Form akForm)
	If(akForm != None)
		audioUI.Mute()
		PlayerRef.RemoveItem(akForm, PlayerRef.GetItemCount(akForm), True)
		audioUI.Unmute()
	EndIf
EndFunction

Bool Function IsAddonLoaded()
	If(Game.GetModByName("All Geared Up - Walking Armory.esp") != 255)
		Return True
	Else
		Return False
	EndIf
EndFunction

Function InitSKSE()
	UnregisterForMenu("InventoryMenu")
	UnregisterForMenu("FavoritesMenu")
	UnregisterForMenu("ContainerMenu")
	RegisterForMenu("InventoryMenu")
	RegisterForMenu("FavoritesMenu")
	RegisterForMenu("ContainerMenu")
EndFunction

Function ProcessInventory()
	flFavorites.Revert()
	flNonfavorites.Revert()
	Form kForm
	Int iSize = PlayerRef.GetNumItems()
	While(iSize >= 0)
		kForm = PlayerRef.GetNthForm(iSize)
		Bool bProcess = False
		If(kForm as Weapon)
			bProcess = True
		ElseIf(kForm as Armor)
			If((kForm as Armor).IsShield())
				bProcess = True
			EndIf
		ElseIf(kForm as Ammo)
			bProcess = True
		EndIf
		If(bProcess)
			If(Game.IsObjectFavorited(kForm))
				If(flFavorites.Find(kForm) < 0)
					flFavorites.AddForm(kForm)
					;Debug.Notification("Favorites +1 = " +flFavorites.GetSize())
				EndIf
			Else
				If(flNonfavorites.Find(kForm) < 0)
					flNonfavorites.AddForm(kForm)
					;Debug.Notification("Favorites -1 = " +flFavorites.GetSize())
				EndIf
			EndIf
		EndIf
		iSize -= 1
	EndWhile
	kForm = None
	;Debug.Notification("Favorites: " +flFavorites.GetSize() + ", nonfavorites: " +flNonfavorites.GetSize())
EndFunction

;###################################################################################################################################################
;Empty events
;###################################################################################################################################################

State Inert
	Event OnMenuOpen(String asMenu)
	EndEvent

	Event OnKeyDown(Int aiKey)
	EndEvent

	Event OnMenuClose(String asMenu)
	EndEvent

	Event BeforeVanillaHotkey(Form akForm, Bool abWeaponDrawn)
	EndEvent

	Event AfterVanillaHotkey(Form akForm, Bool abWeaponDrawn)
	EndEvent

	Event BeforeSkyUIHotkey(Form akRightHand, Form akLeftHand, Bool abWeaponDrawn)
	EndEvent

	Event AfterSkyUIHotkey(Form akRightHand, Form akLeftHand, Bool abWeaponDrawn)
	EndEvent

	Event OnItemFavorited(Form akForm)
	EndEvent

	Event OnItemUnfavorited(Form akForm)
	EndEvent

	Event OnObjectUnequipped(Form akBaseObject, ObjectReference akReference)
	EndEvent

	Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	EndEvent

	Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	EndEvent

	Event OnItemRemoved(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	EndEvent

	Event OnAnimationEvent(ObjectReference akSource, String asEvent)
	EndEvent
EndState
