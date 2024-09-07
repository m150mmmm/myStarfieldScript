Scriptname zzzM150RideActorScript extends Actor

Weapon Property DummyWeapon Auto Const

Weapon playerWeapon

Event OnActivate(ObjectReference akActionRef)
  Actor PlayerREF = Game.GetPlayer()
  if akActionRef == PlayerREF
    InputEnableLayer myLayer = InputEnableLayer.Create()
    myLayer.DisablePlayerControls()

    self.SetPlayerControls(true)
    self.EnableAI(false)
    self.EnableAI()
    self.GetActorBase().SetInvulnerable()

    Game.ForceFirstPerson()

    playerWeapon = PlayerREF.GetEquippedWeapon()
    if (playerWeapon != None)
      PlayerREF.UnequipItem(playerWeapon)
    endIf
    PlayerREF.AddItem(DummyWeapon, 1, true)
    PlayerREF.EquipItem(DummyWeapon, false, true)

    Utility.Wait(1)
    Game.ForceThirdPerson()
    RegisterForAnimationEvent(PlayerREF, "weaponSheathe")

    myLayer.EnablePlayerControls()
  endIf
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
  Actor PlayerREF = Game.GetPlayer()
  if (aksource == PlayerREF) && (asEventName == "weaponSheathe")
    self.SetPlayerControls(false)
    self.EnableAI(false)
    self.EnableAI()
    self.GetActorBase().SetInvulnerable(false)

    PlayerREF.RemoveItem(DummyWeapon, 1, true)
    PlayerREF.UnequipItem(DummyWeapon, false, true)
    if (playerWeapon != None)
      PlayerREF.EquipItem(playerWeapon)
    endIf
    UnregisterForAnimationEvent(PlayerREF, "weaponSheathe")
  endIf
endEvent