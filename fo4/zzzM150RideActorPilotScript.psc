Scriptname zzzM150RideActorPilotScript extends Actor

GlobalVariable Property CompanionVertibirdEntryType Auto Const
GlobalVariable Property CompanionVertibirdEntryType_SnapIntoPosition Auto Const
GlobalVariable Property CompanionVertibirdEntryType_Exit Auto Const

ReferenceAlias Property CompanionAlias Auto Const
ReferenceAlias Property DogmeatAlias Auto Const

Keyword Property pAttachGunner Auto Const
Keyword Property pAttachPilot Auto Const

Faction Property CurrentCompanionFaction Auto Const

ActorBase Property DummyActor Auto Const

Bool Property isWithCompanion Auto Const
Bool Property isWithDog Auto Const
Bool Property isGetOffWarp Auto Const

Actor[] followers

Event OnActivate(ObjectReference akActionRef)
    Actor PlayerREF = Game.GetPlayer()
    if akActionRef == PlayerREF
        InputEnableLayer myLayer = InputEnableLayer.Create()
        myLayer.DisablePlayerControls()

        Game.ForceThirdPerson()
            
        Utility.Wait(6);パイロットのアニメーションで乗るのに6秒くらいかかる
            
        Game.FadeOutGame(false, true, 1.0, 1.0)

        Self.RegisterForRemoteEvent(PlayerREF, "OnGetUp"); 降りる時のアニメーションイベント登録

        self.SetPlayerControls(true)
        self.EnableAI(false)
        self.EnableAI()
        self.GetActorBase().SetInvulnerable()

        Game.ForceFirstPerson()
        Game.ForceThirdPerson()
        myLayer.EnablePlayerControls() ; プレーヤーコントロールON

        If (isWithCompanion)
            snapCompanion()
        endIf

    endIf
EndEvent

Event Actor.OnGetUp(Actor akSender, ObjectReference akFurniture)
  Actor PlayerREF = Game.GetPlayer()
  if (akSender == PlayerREF)
    Self.UnregisterForRemoteEvent(PlayerREF, "OnGetUp"); 降りる時のアニメーションイベント破棄

    self.SetPlayerControls(false)
    self.EnableAI(false)
    self.EnableAI()
    self.GetActorBase().SetInvulnerable(false)

    If (isWithCompanion)
        dismountCompanion()
    endIf

    PlayerREF.AddKeyword(pAttachGunner)
    PlayerREF.RemoveKeyword(pAttachPilot)

    If (isGetOffWarp)
        PlayerREF.moveTo(self)
    endIf

    ; DummyのActorと入れ替え
    self.placeAtMe(DummyActor)
    self.Delete()

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

    if (isWithDog)
        ; 犬肉がいる場合
        Actor DogmeatActor = DogmeatAlias.GetActorReference()
        if DogmeatActor && DogmeatActor.IsInFaction(CurrentCompanionFaction) == 1
            ;無敵化
            DogmeatAlias.GetActorReference().SetGhost()
        endif
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
    if (isWithDog)
        ; 犬肉がいる場合無敵化解除
        Actor DogmeatActor = DogmeatAlias.GetActorReference()
        if DogmeatActor && DogmeatActor.IsInFaction(CurrentCompanionFaction) == 1
            DogmeatActor.moveTo(PlayerREF)
            DogmeatAlias.GetActorReference().SetGhost(false)
            DogmeatActor.EvaluatePackage(false)
        endif
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
