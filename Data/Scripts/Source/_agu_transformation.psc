Scriptname _AGU_Transformation extends ReferenceAlias  

_AGU_MCM Property _AGU_QUEST_MCM Auto

Race PlayerRace

Event OnInit()
	PlayerRace = Game.GetPlayer().GetRace()
EndEvent

Event OnRaceSwitchComplete()
	If(UI.IsMenuOpen("RaceSex Menu"))
		;Debug.Notification("Race Menu")
		PlayerRace = Game.GetPlayer().GetRace()
	Else
		If(Game.GetPlayer().GetRace() == PlayerRace)
			;Debug.Notification("Transforming from a werewolf or vampire lord")
			_AGU_QUEST_MCM.bHideUnequippedWeapons = False
			_AGU_QUEST_MCM.EnableTweak()
		Else
			;Debug.Notification("Transforming into a werewolf or vampire lord")
			_AGU_QUEST_MCM.bHideUnequippedWeapons = True
			_AGU_QUEST_MCM.DisableTweak()
		EndIf
	EndIf
EndEvent
