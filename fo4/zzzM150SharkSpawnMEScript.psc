Scriptname zzzM150SharkSpawnMEScript extends activemagiceffect

Weather Property targetWeather Auto Const
ActorBase Property spawnActor Auto Const

Int Property spawnActorCountMin Auto Const
Int Property spawnActorCountMax Auto Const

Int Property durationTimeMin Auto Const
Int Property durationTimeMax Auto Const

message property unuseableMessage auto

int myCoolTimerID = 99
 
Event OnEffectStart(Actor akTarget, Actor akCaster)
    ; 屋外セルである
    if Weather.GetSkyMode() == 3
        spawnActors()
    else
        unuseableMessage.show()
    endif
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
    Weather.ReleaseOverride()
    CancelTimer(myCoolTimerID)
endEvent

Event OnTimer(int aiTimerID)	
  If aiTimerID == myCoolTimerID
    ; 屋外セルである
    if Weather.GetSkyMode() == 3
        spawnActors()
    else
        unuseableMessage.show()
        CancelTimer(myCoolTimerID)
    EndIf
  EndIf
EndEvent

function spawnActors ()
  int durationTime = Utility.RandomInt(durationTimeMin, durationTimeMax)
  StartTimer(durationTime, myCoolTimerID)

  targetWeather.SetActive()

  Actor PlayerREF = Game.GetPlayer()
  float x = PlayerREF.GetPositionX()
  float y = PlayerREF.GetPositionY()
  float z = PlayerREF.GetPositionZ()

  int actorCount = Utility.RandomInt(spawnActorCountMin, spawnActorCountMax)
  int i = 0
  while (i < actorCount)
    Actor newActor = PlayerREF.PlaceAtMe(spawnActor, 1) as Actor
    newActor.SetPosition(\
      -1000 + 2000 * Utility.RandomFloat() + x,\
      -1000 + 2000 * Utility.RandomFloat() + y,\
      z\
    )
    newActor.MoveTo(newActor, 0, 0, 5000)
    newActor.PushActorAway(newActor, 0)
    newActor.StopCombat()
    i += 1
    Utility.Wait(1)
  endwhile
endFunction