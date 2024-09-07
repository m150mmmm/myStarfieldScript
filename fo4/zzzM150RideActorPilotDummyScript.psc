Scriptname zzzM150RideActorPilotDummyScript extends Actor

message property poworArmorMessage auto

ActorBase property rideActor auto

Keyword Property pAttachGunner Auto Const
Keyword Property pAttachPilot Auto Const

Keyword Property powerArmorKeyword Auto Const

LeveledItem Property ChangeItemLL Auto Const

Event OnActivate(ObjectReference akActionRef)
    Actor PlayerREF = Game.GetPlayer()
	if akActionRef == PlayerREF
        if (PlayerREF.WornHasKeyword(powerArmorKeyword))
            poworArmorMessage.show()
        else
            reActivate()
        endIf
    endIf
    
EndEvent

;　実際に乗るActorを呼び出してそちらをactivateする
function reActivate ()
    Actor PlayerREF = Game.GetPlayer()

    InputEnableLayer myLayer = InputEnableLayer.Create()
    myLayer.DisablePlayerControls()

    ; プレーヤーのアタッチキーワード変更
    PlayerREF.AddKeyword(pAttachPilot)
    PlayerREF.RemoveKeyword(pAttachGunner)

    self.SetAlpha(0.0,True)

    ObjectReference Vehicle = self.placeAtMe(rideActor)
    Game.FadeOutGame(true, true, 0, 1.0, true)
    Utility.Wait(1)
    Vehicle.waitfor3dload()

    Vehicle.Activate(PlayerREF)

    myLayer.EnablePlayerControls()
    UnregisterForAllHitEvents()
    self.delete()
endFunction



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
