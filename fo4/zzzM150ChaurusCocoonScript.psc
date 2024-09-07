Scriptname zzzM150ChaurusCocoonScript extends ObjectReference Const

Explosion Property cocoonExplosion Auto Const
ActorBase Property summonActor Auto Const
Furniture Property brokenCoccon Auto Const

Event OnLoad()
    registerForHitEvent(self)
EndEvent

Event OnUnload()
	UnregisterForAllHitEvents()
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string asMaterialName)
	UnregisterForAllHitEvents()
	Self.placeatme(cocoonExplosion)
	Self.placeAtMe(summonActor)
	ObjectReference coccoon = Self.placeAtMe(brokenCoccon)
	coccoon.waitfor3dload()
	Self.Disable()
EndEvent

Event OnActivate(ObjectReference akActionRef)
	UnregisterForAllHitEvents()
	Self.placeatme(cocoonExplosion)
	Self.placeAtMe(summonActor)
	ObjectReference coccoon = Self.placeAtMe(brokenCoccon)
	coccoon.waitfor3dload()
	Self.Disable()
EndEvent