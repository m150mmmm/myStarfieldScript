Scriptname zzzM150RideActorScriptWithCompanion extends Actor

Weapon Property DummyWeapon Auto Const

GlobalVariable Property CompanionVertibirdEntryType Auto Const mandatory
GlobalVariable Property CompanionVertibirdEntryType_SnapIntoPosition Auto Const mandatory
GlobalVariable Property CompanionVertibirdEntryType_Exit Auto Const mandatory

ReferenceAlias Property CompanionAlias Auto Const
ReferenceAlias Property DogmeatAlias Auto Const

Faction Property CurrentCompanionFaction Auto Const

Weapon playerWeapon
Actor[] followers

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

    snapCompanion()
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
    dismountCompanion()
  endIf
endEvent


; 乗物にコンパニオンをスナップ
function snapCompanion()
    ; コンパニオンがいる場合
    Actor CompanionActor = CompanionAlias.GetActorReference()
    if CompanionActor && CompanionActor.IsInFaction(CurrentCompanionFaction) == 1
        ; 無敵化
        CompanionAlias.GetActorReference().SetGhost()
    endif

    ; 犬肉がいる場合
    Actor DogmeatActor = DogmeatAlias.GetActorReference()
    if DogmeatActor && DogmeatActor.IsInFaction(CurrentCompanionFaction) == 1
        ;無敵化
        DogmeatAlias.GetActorReference().SetGhost()
    endif

    ; フォロワーModなどを使っている場合にここまでで拾えなかったフォロワーを無敵化
    followers = Game.GetPlayerFollowers()
    int i = 0
    while (i < followers.length)
        followers[i].SetGhost()
        i += 1
    endwhile
    ; コンパニオンを乗せる
    CompanionVertibirdEntryType.SetValue(CompanionVertibirdEntryType_SnapIntoPosition.GetValue())
endFunction

; 乗物からコンパニオンを降ろす
function dismountCompanion()
    Actor PlayerREF = Game.GetPlayer()
    ; コンパニオンを降ろす
    CompanionVertibirdEntryType.SetValue(CompanionVertibirdEntryType_Exit.GetValue())

    ; コンパニオンがいる場合無敵化解除
    Actor CompanionActor = CompanionAlias.GetActorReference()
    if CompanionActor && CompanionActor.IsInFaction(CurrentCompanionFaction) == 1
        CompanionActor.moveTo(PlayerREF)
        CompanionAlias.GetActorReference().SetGhost(false)
        CompanionActor.EvaluatePackage(false)
    endif

    ; 犬肉がいる場合無敵化解除
    Actor DogmeatActor = DogmeatAlias.GetActorReference()
    if DogmeatActor && DogmeatActor.IsInFaction(CurrentCompanionFaction) == 1
        DogmeatActor.moveTo(PlayerREF)
        DogmeatAlias.GetActorReference().SetGhost(false)
        DogmeatActor.EvaluatePackage(false)
    endif
    ; フォロワーModなどを使っている場合にここまでで拾えなかったフォロワーを無敵化解除
    int i = 0
    while (i < followers.length)
        followers[i].moveTo(PlayerREF)
        followers[i].SetGhost(false)
        followers[i].EvaluatePackage(false)
        i += 1
    endwhile
endFunction
