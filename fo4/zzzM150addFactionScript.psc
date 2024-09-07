Scriptname zzzM150addFactionEnchScript extends activemagiceffect

Faction Property setFaction Auto

EVENT OnEffectStart(Actor akTarget, Actor akCaster)
	akTarget.AddToFaction(setFaction)
endEVENT
	
EVENT OnEffectFinish(Actor akTarget, Actor akCaster)
	akTarget.RemoveFromFaction(setFaction)
endEVENT

