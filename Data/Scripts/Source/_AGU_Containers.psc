Scriptname _AGU_Containers extends Quest  

ReferenceAlias Property kAlias Auto
Actor Property PlayerRef Auto
ObjectReference kPreviousRef
FormList Property kAshPiles Auto 

Event OnInit()
	RegisterForCrossHairRef()
EndEvent

Function Init()
	UnregisterForCrosshairRef()
	RegisterForCrosshairRef()
EndFunction

Event OnCrosshairRefChange(ObjectReference akRef)
	If(PlayerRef.IsWeaponDrawn())
		If((akRef.GetBaseObject().GetType() == 28) || (akRef.GetType() == 62 && (akRef as Actor).IsDead()) || (kAshPiles.Find(akRef.GetBaseObject()) != -1))
			kPreviousRef.BlockActivation(False)
			If(kAshPiles.Find(akRef.GetBaseObject()) != -1)
				kPreviousRef = Game.FindClosestActorFromRef(akRef, 150)
				If(kPreviousRef.GetType() != 62 && !(kPreviousRef as Actor).IsDead())
					kPreviousRef = akRef
				EndIf
			Else
				kPreviousRef = akRef
			EndIf
			kAlias.ForceRefTo(kPreviousRef)
			kPreviousRef.BlockActivation()
		EndIf
	EndIf
EndEvent
