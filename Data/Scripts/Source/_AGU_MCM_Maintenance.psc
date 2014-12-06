Scriptname _AGU_MCM_Maintenance extends ReferenceAlias  

_AGU_MCM Property MCM  Auto
_AGU_Containers Property Containers Auto

Event OnPlayerLoadGame()
	MCM.RefreshRegistrations()
	If(MCM.bMCM_ContainerMechanism)
		Containers.Init()
	EndIf
EndEvent
