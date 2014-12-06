Scriptname _AGU_Containers_Alias extends ReferenceAlias  

Actor Property PlayerRef Auto
_AGU_MCM Property MCM  Auto

Event OnActivate(ObjectReference akActionRef)
	GoToState("Busy")
	If(akActionRef == PlayerRef)
		ObjectReference kRef = Self.GetReference()
		If(PlayerRef.IsWeaponDrawn())
			RegisterForMenu("ContainerMenu")
			MCM.Sheathe()
			MCM.DisableTweak()
		EndIf
		kRef.BlockActivation(False)
		kRef.Activate(PlayerRef)
		kRef = None
	EndIf
	GoToState("")
EndEvent

Event OnMenuClose(String asMenuName)
	UnregisterForMenu("ContainerMenu")
	Self.GetReference().BlockActivation()
	MCM.EnableTweak()
	MCM.Draw()
EndEvent

State Busy
	Event OnActivate(ObjectReference akActionRef)
	EndEvent

	Event OnMenuClose(String asMenuName)
	EndEvent
EndState
