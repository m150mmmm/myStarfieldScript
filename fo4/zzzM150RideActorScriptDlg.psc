Scriptname zzzM150RideActorScriptDlg extends Actor

; pAttachPilotでアクターに乗るスクリプト2 ダミーアクターがいらないver

Keyword Property pAttachGunner Auto Const mandatory
Keyword Property pAttachPilot Auto Const mandatory

Keyword Property isPowerArmorFrame Auto Const

GlobalVariable Property CompanionVertibirdEntryType Auto Const
GlobalVariable Property CompanionVertibirdEntryType_SnapIntoPosition Auto Const
GlobalVariable Property CompanionVertibirdEntryType_Exit Auto Const

ReferenceAlias Property CompanionAlias Auto Const
ReferenceAlias Property DogmeatAlias Auto Const

Faction Property CurrentCompanionFaction Auto Const

Faction Property playerRidingFaction Auto Const

Bool Property isWithCompanion Auto Const
Bool Property isWithDog Auto Const

message property ActivateMenu auto
message property poworArmorMessage auto

Bool Property isGetOffWarp Auto Const

int property MenuRideId Auto Const
int property MenuToCollectId Auto Const

LeveledItem Property collectItemLL Auto Const

Sound Property engineSound Auto
int engineSoundInt

Event OnActivate(ObjectReference akActionRef)
  Actor PlayerREF = Game.GetPlayer()
  
  if akActionRef == PlayerREF
    if PlayerREF.HasKeyword(pAttachPilot)
        ; 乗る
        Game.SetCameraTarget(self as actor)
        
        InputEnableLayer myLayer = InputEnableLayer.Create()
        myLayer.DisablePlayerControls()

        Game.ForceThirdPerson(); 3rdじゃないとエラる
            
        Utility.Wait(6);パイロットのアニメーションで乗るのに6秒くらいかかる
            
        Game.FadeOutGame(false, true, 1.0, 1.0)

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

        engineSoundInt = engineSound.Play(self)
 	    Sound.SetInstanceVolume(engineSoundInt, 1)
        
        self.AddToFaction(playerRidingFaction)
    else
        ;Dlg
        if (PlayerREF.WornHasKeyword(isPowerArmorFrame))
            ; パワーアーマー着てる
            poworArmorMessage.show()
        else
            ;Dlg
            int ibutton = ActivateMenu.show()
            if ibutton == MenuRideId
                reActivate()
            elseIf ibutton == MenuToCollectId
                collectItem()
            endif
        endIf

    endIf
  endIf
EndEvent

; 降りる
Event OnExitFurniture(ObjectReference akActionRef)
    Actor PlayerREF = Game.GetPlayer()
    if (akActionRef == PlayerREF)

        self.RemoveFromFaction(playerRidingFaction)

        self.SetPlayerControls(false)
        self.EnableAI(false)
        self.EnableAI()
        self.GetActorBase().SetInvulnerable(false)

        If (isWithCompanion)
            dismountCompanion()
        endIf

        ; アタッチキーワード変更
        PlayerREF.AddKeyword(pAttachGunner)
        PlayerREF.RemoveKeyword(pAttachPilot)

        Sound.StopInstance(engineSoundInt)
        Game.SetCameraTarget(PlayerREF)
        self.BlockActivation()
        If (isGetOffWarp)
            PlayerREF.moveTo(self)
        endIf
    endIf
EndEvent

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
endFunction

; 再アクティベート
function reActivate ()
    Actor PlayerREF = Game.GetPlayer()
    self.BlockActivation(false)
    ; アタッチキーワード変更
    PlayerREF.AddKeyword(pAttachPilot)
    PlayerREF.RemoveKeyword(pAttachGunner)

    Game.FadeOutGame(true, true, 0, 1.0, true)
    
    Utility.Wait(1)
    self.Activate(PlayerREF)
endFunction

Event OnInit()
    self.BlockActivation()
EndEvent

;回収
function collectItem ()
  Game.GetPlayer().AddItem(collectItemLL, 1, false)
  self.Disable()
  self.KillEssential()
endFunction

; 消えないように
Event OnLoad()
	if Is3DLoaded()
	    RegisterForHitEvent(self, akAggressorFilter = Game.GetPlayer(), abMatch = true)
	endIf
EndEvent

Event OnDeath(Actor akKiller)
	UnregisterForAllHitEvents()
EndEvent
