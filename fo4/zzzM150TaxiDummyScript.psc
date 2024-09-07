Scriptname zzzM150TaxiDummyScript extends Actor

Int Property price Auto Const
message property taxiMenu auto
message property poworArmorMessage auto
message property shortMoneyMenu auto

GlobalVariable property destinationID auto

ObjectReference property rideActor auto

ObjectReference property waitMarker auto

Keyword Property pAttachGunner Auto Const
Keyword Property pAttachPilot Auto Const

Keyword Property powerArmorKeyword Auto Const

GlobalVariable property playerHasAttachPilot Auto Const
GlobalVariable property playerHasAttachGunner Auto Const

int property taxiId Auto Const
GlobalVariable property ridingTaxiId Auto Const

Event OnActivate(ObjectReference akActionRef)

    Actor PlayerREF = Game.GetPlayer()
    destinationID.SetValue(0)
	if akActionRef == PlayerREF
        if (PlayerREF.WornHasKeyword(powerArmorKeyword))
            poworArmorMessage.show()
        elseIf  PlayerREF.GetItemCount(Game.GetCaps()) >= price
                
            int ibutton = taxiMenu.show()
            if ibutton == 0    ;やめる
                destinationID.SetValue(0)
            else
                reActivate(ibutton)
            endif
        else
            ; You are short of caps.
            shortMoneyMenu.show()
        endIf
    endIf
    
EndEvent

;　実際に乗るActorを呼び出してそちらをactivateする
function reActivate (int i)
    Actor PlayerREF = Game.GetPlayer()

    ridingTaxiId.SetValue(taxiId)

    if PlayerREF.HasKeyword(pAttachPilot) == true
        playerHasAttachPilot.SetValue(1 as float)
    else
        playerHasAttachPilot.SetValue(0 as float)
    endIf

    if PlayerREF.HasKeyword(pAttachGunner) == true
        playerHasAttachGunner.SetValue(1 as float)
    else
        playerHasAttachGunner.SetValue(0 as float)
    endIf

    ; プレーヤーのアタッチキーワード変更
    PlayerREF.AddKeyword(pAttachPilot)
    PlayerREF.RemoveKeyword(pAttachGunner)

    ; 行先IDセット
    destinationID.SetValue(i)

    rideActor.moveTo(self)
    self.moveTo(waitMarker)
    rideActor.waitfor3dload()
    
    Game.FadeOutGame(true, true, 0, 1.0, true)
    Utility.Wait(1)
    rideActor.Activate(PlayerREF)
endFunction

