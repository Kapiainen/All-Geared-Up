Scriptname _AGU_Transformation extends ReferenceAlias  

_AGU_MCM Property _AGU_QUEST_MCM Auto

Race PlayerRace ;Deprecated

;Version 1.1.2
Race WerewolfRace
Race VampireLordRace

Event OnInit()
	;PlayerRace = Game.GetPlayer().GetRace() ;Deprecated
	WerewolfRace = Game.GetFormFromFile(0x000CDD84, "Skyrim.esm") as Race
	VampireLordRace = Game.GetFormFromFile(0x0200283A, "Dawnguard.esm") as Race
EndEvent

Event OnPlayerLoadGame()
	WerewolfRace = Game.GetFormFromFile(0x000CDD84, "Skyrim.esm") as Race
	VampireLordRace = Game.GetFormFromFile(0x0200283A, "Dawnguard.esm") as Race
EndEvent

Event OnRaceSwitchComplete()
	Race NewRace = Game.GetPlayer().GetRace()
	If((NewRace == WerewolfRace) || (NewRace == VampireLordRace))
		;Debug.Notification("Transforming into a werewolf or vampire lord")
		_AGU_QUEST_MCM.bHideUnequippedWeapons = True
		_AGU_QUEST_MCM.DisableTweak()
	Else
		;Debug.Notification("Transforming from a werewolf or vampire lord")
		_AGU_QUEST_MCM.bHideUnequippedWeapons = False
		_AGU_QUEST_MCM.EnableTweak()
	EndIf
EndEvent
