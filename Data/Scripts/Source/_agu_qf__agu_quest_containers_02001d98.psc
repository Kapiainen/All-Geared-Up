;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname _AGU_QF__AGU_QUEST_Containers_02001D98 Extends Quest Hidden

;BEGIN ALIAS PROPERTY Ref
;ALIAS PROPERTY TYPE ReferenceAlias
ReferenceAlias Property Alias_Ref Auto
;END ALIAS PROPERTY

;BEGIN FRAGMENT Fragment_2
Function Fragment_2()
;BEGIN CODE
Alias_Ref.GetReference().BlockActivation(False)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
