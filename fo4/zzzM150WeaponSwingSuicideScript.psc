Scriptname zzzM150WeaponSwingSuicideScript extends Actor Conditional

Explosion Property SuicideExplosion Auto Const
String Property animEventName Auto Const
;weaponSwing

LeveledItem Property ChangeItemLL Auto Const

Event OnLoad()
	if Is3DLoaded()
	    RegisterForAnimationEvent(self, animEventName)
	    RegisterForHitEvent(self, akAggressorFilter = Game.GetPlayer(), abMatch = true)
	endIf
EndEvent

;Event OnUnload()
;	UnregisterForAllHitEvents()
;EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	if (akSource == self) && (asEventName == animEventName)
		blowUp()
	endIf
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string asMaterialName)
	Game.GetPlayer().AddItem(ChangeItemLL, 1, false)
  	UnregisterForAllHitEvents()
    self.Delete()
EndEvent

Event OnDeath(Actor akKiller)
	blowUp()
EndEvent

function blowUp()
	placeatme(SuicideExplosion)
	UnregisterForAllHitEvents()
	self.Delete()
endFunction
