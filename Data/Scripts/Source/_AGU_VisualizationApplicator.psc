Scriptname _AGU_VisualizationApplicator extends activemagiceffect  

{All Geared Up - Adds an ability to NPCs that come in contact with the cloak ability that the player has.}

Spell Property kSPELVisualizationNPC Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	If(akTarget)
		akTarget.AddSpell(kSPELVisualizationNPC)
	EndIf
EndEvent