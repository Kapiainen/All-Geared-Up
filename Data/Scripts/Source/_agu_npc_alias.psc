Scriptname _AGU_NPC_Alias extends ReferenceAlias  

Bool bCrossbow
Form kCrossbow
Int iCount
Actor kNPC
ObjectReference Property kXMarker Auto
Container Property kChest Auto

Event OnInit()
	If(Self.GetReference() != None)
		kNPC = Self.GetReference() as Actor
		bCrossbow = False
		If(kNPC.GetEquippedItemType(1) == 12)
			bCrossbow = True
			kCrossbow = kNPC.GetEquippedObject(1)
			;Debug.Notification("Crossbow equipped")
		EndIf
	EndIf
EndEvent

Event OnObjectEquipped(Form akBaseObject, ObjectReference akReference)
	If((kNPC.GetEquippedItemType(1) == 12) && akBaseObject as Weapon)
		kCrossbow = akBaseObject
		;Debug.Notification("Crossbow equipped")
	EndIf
	
	If(kCrossbow)
		;Debug.Notification("kCrossbow: " +kCrossbow.GetName())
		If(kCrossbow != akBaseObject)
			;Debug.Notification("Removing crossbow")
			iCount = kNPC.GetItemCount(kCrossbow)
			ObjectReference kRef = kXMarker.PlaceAtMe(kChest)
			kNPC.RemoveItem(kCrossbow, iCount, False, kRef)
			kRef.RemoveAllItems(kNPC)
			kRef.Delete()
			kRef = None
			kCrossbow = None
		EndIf
	EndIf
EndEvent
