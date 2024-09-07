Scriptname zzzM150TaxiScript extends Actor

GlobalVariable Property CompanionVertibirdEntryType Auto Const mandatory
GlobalVariable Property CompanionVertibirdEntryType_Board Auto Const mandatory
GlobalVariable Property CompanionVertibirdEntryType_SnapIntoPosition Auto Const mandatory
GlobalVariable Property CompanionVertibirdEntryType_Exit Auto Const mandatory

ReferenceAlias Property CompanionAlias Auto Const
ReferenceAlias Property DogmeatAlias Auto Const

Faction Property CurrentCompanionFaction Auto Const

Int Property price Auto Const
MiscObject Property taxiFlgItem Auto Const
GlobalVariable property destinationID auto

ObjectReference[] property dummyActors auto

ObjectReference property waitMarker auto

Keyword Property powerArmorKeyword Auto Const

Keyword Property pAttachGunner Auto Const
Keyword Property pAttachPilot Auto Const
Keyword Property pAttachPassenger Auto Const
Keyword Property pAttachSlot1 Auto Const
Keyword Property pAttachDogmeat Auto Const

Race Property RaceHuman Auto Const
Race Property RaceHumanChild Auto Const
Race Property RaceGhoul Auto Const
Race Property RaceGhoulChild Auto Const
Race Property RaceSynthValentine Auto Const
Race Property RaceSynth1 Auto Const
Race Property RaceSynth2 Auto Const

Race Property RaceDogMeat Auto Const
Race Property RaceDogRaider Auto Const

GlobalVariable property companionActorHasAttachPassenger Auto Const
GlobalVariable property companionActorHasAttachSlot1 Auto Const
GlobalVariable property dogMeatActorHasAttachDogmeat Auto Const

message property takingMenu auto
message property getUpMenu auto

GlobalVariable property playerHasAttachPilot Auto Const
GlobalVariable property playerHasAttachGunner Auto Const

GlobalVariable property ridingTaxiId Auto Const

Actor[] followers

; 乗る
Event OnActivate(ObjectReference akActionRef)
    Actor PlayerREF = Game.GetPlayer()
    if akActionRef == PlayerREF
        ; プレーヤーコントロールOFF
        InputEnableLayer myLayer = InputEnableLayer.Create()
        myLayer.DisablePlayerControls()
        
        Game.ForceThirdPerson()
        
        Utility.Wait(6);パイロットのアニメーションで乗るのに6秒くらいかかる
        
        Game.FadeOutGame(false, true, 1.0, 1.0)

        Self.RegisterForRemoteEvent(PlayerREF, "OnGetUp"); 降りる時のアニメーションイベント登録
        myLayer.EnablePlayerControls() ; プレーヤーコントロールON
        Game.RemovePlayerCaps(price) ; 支払い

        self.AddItem(taxiFlgItem, 1, true) ; 乗物のpackage変えるキーアイテムadd

        Game.ForceFirstPerson()
        Game.ForceThirdPerson()

        takingMenu.show() ; Thank you for taking.

        snapCompanion()
        
        PlayerREF.SetGhost() ; プレーヤー無敵化
        self.EvaluatePackage(false) ; 乗物package走査
    endIf
    
EndEvent

; 降りる
Event Actor.OnGetUp(Actor akSender, ObjectReference akFurniture)
    Actor PlayerREF = Game.GetPlayer()
    if (akSender == PlayerREF)
        Self.UnregisterForRemoteEvent(PlayerREF, "OnGetUp"); 降りる時のアニメーションイベント破棄
        ; プレーヤーコントロールOFF
        InputEnableLayer myLayer = InputEnableLayer.Create()
        myLayer.DisablePlayerControls()

        self.RemoveItem(taxiFlgItem, 1) ; 乗物のpackage変えるキーアイテムremove
        destinationID.SetValue(0) ; 行先IDリセット

        dismountCompanion()

        Utility.Wait(1)

        ; DummyのActorと入れ替え
        dummyActors[ridingTaxiId.GetValueInt()].moveTo(self)
        self.moveTo(waitMarker)

        PlayerREF.SetGhost(false) ; プレーヤー無敵化解除
        myLayer.EnablePlayerControls() ; プレーヤーコントロールON

        getUpMenu.show() ; We look forward to serving you again soon.

        ; キーワードを元に戻す
        if playerHasAttachPilot.Getvalue() == 1 as float && PlayerREF.HasKeyword(pAttachPilot) == false
            PlayerREF.AddKeyword(pAttachPilot)
        elseIf playerHasAttachPilot.Getvalue() == 0 as float && PlayerREF.HasKeyword(pAttachPilot) == true
            PlayerREF.RemoveKeyword(pAttachPilot)
        endIf

        if playerHasAttachGunner.Getvalue() == 1 as float && PlayerREF.HasKeyword(pAttachGunner) == false
            PlayerREF.AddKeyword(pAttachGunner)
        elseIf playerHasAttachGunner.Getvalue() == 0 as float && PlayerREF.HasKeyword(pAttachGunner) == true
            PlayerREF.RemoveKeyword(pAttachGunner)
        endIf

        playerHasAttachPilot.SetValue(0 as float)
        playerHasAttachGunner.SetValue(0 as float)

    endIf
endEvent

; 乗物にコンパニオンをスナップ
function snapCompanion()
    ; コンパニオンがいる場合
    Actor CompanionActor = CompanionAlias.GetActorReference()
    if CompanionActor && CompanionActor.IsInFaction(CurrentCompanionFaction) == 1
        Race CompanionActorRace = CompanionActor.GetRace()

        ; キーワード関連の処理
        if CompanionActor.HasKeyword(pAttachPassenger) == true
            companionActorHasAttachPassenger.SetValue(1 as float)
        else
            companionActorHasAttachPassenger.SetValue(0 as float)
        endIf
        if CompanionActor.HasKeyword(pAttachSlot1) == true
            companionActorHasAttachSlot1.SetValue(1 as float)
        else
            companionActorHasAttachSlot1.SetValue(0 as float)
        endIf

        ; コンパニオンがPA着てる場合
        if CompanionActor.WornHasKeyword(powerArmorKeyword) == true
            if CompanionActor.HasKeyword(pAttachPassenger) == true
				CompanionActor.RemoveKeyword(pAttachPassenger)
			endIf

            if CompanionActor.HasKeyword(pAttachSlot1) == false
                CompanionActor.AddKeyword(pAttachSlot1)
			endIf
        ; 人間、シンス、グール
        elseIf (CompanionActorRace == RaceHuman || CompanionActorRace == RaceGhoul || CompanionActorRace == RaceSynthValentine || CompanionActorRace == RaceHumanChild || CompanionActorRace == RaceGhoulChild || CompanionActorRace == RaceSynth1 || CompanionActorRace == RaceSynth2)
            if CompanionActor.HasKeyword(pAttachPassenger) == false
                CompanionActor.AddKeyword(pAttachPassenger)
			endIf
        ; それ以外
        else
            if CompanionActor.HasKeyword(pAttachSlot1) == false
                CompanionActor.AddKeyword(pAttachSlot1)
			endIf
        endIf

        ; 無敵化
        CompanionAlias.GetActorReference().SetGhost()
    endif

    ; 犬肉がいる場合
    Actor DogmeatActor = DogmeatAlias.GetActorReference()
    if DogmeatActor && DogmeatActor.IsInFaction(CurrentCompanionFaction) == 1

        if DogmeatActor.HasKeyword(pAttachDogmeat) == true
            dogMeatActorHasAttachDogmeat.SetValue(1 as float)
        else
            dogMeatActorHasAttachDogmeat.SetValue(0 as float)
        endIf

        Race DogmeatActorRace = DogmeatActor.GetRace()
        if (DogmeatActorRace == RaceDogMeat || DogmeatActorRace == RaceDogRaider)
            if DogmeatActor.HasKeyword(pAttachDogmeat) == false
                DogmeatActor.AddKeyword(pAttachDogmeat)
            endIf
        endIf

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

        ; キーワードを元に戻す
        if companionActorHasAttachPassenger.Getvalue() == 1 as float && CompanionActor.HasKeyword(pAttachPassenger) == false
            CompanionActor.AddKeyword(pAttachPassenger)
        elseIf companionActorHasAttachPassenger.Getvalue() == 0 as float && CompanionActor.HasKeyword(pAttachPassenger) == true
            CompanionActor.RemoveKeyword(pAttachPassenger)
        endIf

        if companionActorHasAttachSlot1.Getvalue() == 1 as float && CompanionActor.HasKeyword(pAttachSlot1) == false
            CompanionActor.AddKeyword(pAttachSlot1)
        elseIf companionActorHasAttachSlot1.Getvalue() == 0 as float && CompanionActor.HasKeyword(pAttachSlot1) == true
            CompanionActor.RemoveKeyword(pAttachSlot1)
        endIf
    endif

    ; 犬肉がいる場合無敵化解除
    Actor DogmeatActor = DogmeatAlias.GetActorReference()
    if DogmeatActor && DogmeatActor.IsInFaction(CurrentCompanionFaction) == 1
        DogmeatActor.moveTo(PlayerREF)
        DogmeatAlias.GetActorReference().SetGhost(false)
        DogmeatActor.EvaluatePackage(false)

        ; キーワードを元に戻す
        if dogMeatActorHasAttachDogmeat.Getvalue() == 1 as float && DogmeatActor.HasKeyword(pAttachDogmeat) == false
            DogmeatActor.AddKeyword(pAttachDogmeat)
        elseIf dogMeatActorHasAttachDogmeat.Getvalue() == 0 as float && DogmeatActor.HasKeyword(pAttachDogmeat) == true
            DogmeatActor.RemoveKeyword(pAttachDogmeat)
        endIf
    endif

    ; フォロワーModなどを使っている場合にここまでで拾えなかったフォロワーを無敵化解除
    int i = 0
    while (i < followers.length)
        followers[i].moveTo(PlayerREF)
        followers[i].SetGhost(false)
        followers[i].EvaluatePackage(false)
        i += 1
    endwhile

    companionActorHasAttachPassenger.SetValue(0 as float)
    companionActorHasAttachSlot1.SetValue(0 as float)
    dogMeatActorHasAttachDogmeat.SetValue(0 as float)

endFunction
