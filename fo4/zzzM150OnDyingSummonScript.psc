Scriptname zzzM150OnDyingSummonScript extends activemagiceffect

Activator Property onDyingActivator Auto Const
Explosion Property onDyingExplosion Auto Const
ActorBase[] Property onDyingSummonActorList Auto Const
Int Property delayTime Auto Const
Bool Property isAttachAshPile Auto Const
Bool Property isDeadHidden Auto Const

actor selfRef

Event OnEffectStart(Actor akTarget, Actor akCaster)
  	selfRef = akCaster
EndEvent

Event OnDying(Actor akKiller)
    Utility.Wait(delayTime)
    selfRef.placeAtMe(onDyingExplosion)
    if  isAttachAshPile
      selfRef.AttachAshPile(onDyingActivator)
  	endIf
    if  isDeadHidden
      selfRef.SetAlpha(0.0,True)
  	endIf

		int i = 0
		while (i < onDyingSummonActorList.length)
			selfRef.placeAtMe(onDyingSummonActorList[i])
			i += 1
		endwhile
EndEvent
