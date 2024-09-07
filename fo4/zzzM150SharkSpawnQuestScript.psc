Scriptname zzzM150SharkSpawnQuestScript extends ReferenceAlias

Weather[] Property targetWeathers Auto Const
ActorBase Property spawnActor Auto Const

Int Property spawnPercent Auto Const

Int Property spawnActorCountMin Auto Const
Int Property spawnActorCountMax Auto Const

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    checkSpawn()
EndEvent

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
    if (aeCombatState == 0)
      checkSpawn()
    endIf
EndEvent

function checkSpawn ()
  ; 屋外セルである
  if Weather.GetSkyMode() == 3
    Weather currentWeather = Weather.GetCurrentWeather()
    int i = 0
    while (i < targetWeathers.length)
      ; ターゲットの天候である
      if (targetWeathers[i] == currentWeather)
        int random = Utility.RandomInt()
        ; スポーン確率ヒット
        if (random < spawnPercent)
          spawnActors()
        endIf
      endIf
      i += 1
    endwhile
  endif
endFunction

function spawnActors ()
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