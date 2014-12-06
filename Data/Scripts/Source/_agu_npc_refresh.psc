Scriptname _AGU_NPC_Refresh extends Quest  

ObjectReference Property PlayerRef Auto
GlobalVariable Property _AGU_GLOBVAR_NPC_UpdateFrequency Auto
GlobalVariable Property _AGU_GLOBVAR_NPC_Radius Auto
Quest Property _AGU_QUEST_NPC_Aliases Auto

Float Function DistanceBetween(Float[] afA, Float[] afB)
	Float dist = Math.Sqrt(Math.Pow((afA[0]-afB[0]), 2.0)+Math.Pow((afA[1]-afB[1]), 2.0)+Math.Pow((afA[2]-afB[2]), 2.0))
	Return dist
EndFunction

Float[] a
Float[] b

Event OnInit()
	a = new Float[3]
	b = new Float[3]
	a[0] = PlayerRef.GetPositionX()
	a[1] = PlayerRef.GetPositionY()
	a[2] = PlayerRef.GetPositionZ()
	_AGU_QUEST_NPC_Aliases.Start()
	RegisterForSingleUpdate(_AGU_GLOBVAR_NPC_UpdateFrequency.GetValue())
EndEvent

Event OnUpdate()
	b[0] = PlayerRef.GetPositionX()
	b[1] = PlayerRef.GetPositionY()
	b[2] = PlayerRef.GetPositionZ()
	If(DistanceBetween(a, b) >= _AGU_GLOBVAR_NPC_Radius.GetValue())
		;Debug.Notification("Refreshing NPC aliases")
		_AGU_QUEST_NPC_Aliases.Stop()
		_AGU_QUEST_NPC_Aliases.Start()
		a[0] = b[0]
		a[1] = b[1]
		a[2] = b[2]
	EndIf
	RegisterForSingleUpdate(_AGU_GLOBVAR_NPC_UpdateFrequency.GetValue())
EndEvent
