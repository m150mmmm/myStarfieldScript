Scriptname zzzM150OnEffectStartSummonActorScript extends activemagiceffect

ActorBase[] Property summonActorList Auto Const

Event OnEffectStart(Actor akTarget, Actor akCaster)
    int i = 0
		while (i < summonActorList.length)
			akCaster.placeAtMe(summonActorList[i])
			i += 1
		endwhile
EndEvent
