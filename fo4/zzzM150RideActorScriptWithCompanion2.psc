Scriptname zzzM150RideActorScriptWithCompanion2 extends Actor

Weapon Property DummyWeapon Auto Const

GlobalVariable Property CompanionVertibirdEntryType Auto Const mandatory
GlobalVariable Property CompanionVertibirdEntryType_SnapIntoPosition Auto Const mandatory
GlobalVariable Property CompanionVertibirdEntryType_Exit Auto Const mandatory

ReferenceAlias Property CompanionAlias Auto Const
ReferenceAlias Property DogmeatAlias Auto Const

Faction Property CurrentCompanionFaction Auto Const

Weapon playerWeapon
Actor[] followers

int Property MaxSpeed Auto Const
int Property MinSpeed Auto Const
int Property DefaultSpeed Auto Const
int Property StepSpeedAccelerator Auto Const
int Property StepSpeedBrake Auto Const

ActorValue Property speedMult Auto Const

int rideFlg

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

    rideFlg = 1
    while (rideFlg == 1)
        StartTimer(0.5)
        Utility.Wait(0.5)
    endwhile
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

    rideFlg = 0
    CancelTimer()
    self.SetValue(speedMult, DefaultSpeed)
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

; スピード制御
Float selfX
Float selfY

int newSpeed = 0
Event OnTimer(int aiTimerID)
    if Math.abs(self.GetPositionX() - selfX) < 40 && Math.abs(self.GetPositionY() - selfY) < 40 ;停車中
        newSpeed = MinSpeed
    elseif self.IsRunning() ;run
        newSpeed = self.GetValue(speedMult) as int + StepSpeedAccelerator
        if newSpeed > MaxSpeed
            newSpeed = MaxSpeed
        endIf
    else ; walk
        newSpeed = self.GetValue(speedMult) as int - StepSpeedBrake
        if newSpeed < MinSpeed
            newSpeed = MinSpeed
        endIf
    endIf

    self.SetValue(speedMult, newSpeed)

    selfX = self.GetPositionX()
    selfY = self.GetPositionY()

endEvent
