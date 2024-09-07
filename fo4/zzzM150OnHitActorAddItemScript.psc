Scriptname zzzM150OnHitActorAddItemScript extends Actor Const

LeveledItem Property ChangeItemLL Auto Const

Event OnLoad()
	if Is3DLoaded()
	    RegisterForHitEvent(self, akAggressorFilter = Game.GetPlayer(), abMatch = true)
	endIf
EndEvent

Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string asMaterialName)
  Game.GetPlayer().AddItem(ChangeItemLL, 1, false)
  self.Disable()
  self.KillEssential()
EndEvent

Event OnDeath(Actor akKiller)
	UnregisterForAllHitEvents()
EndEvent
