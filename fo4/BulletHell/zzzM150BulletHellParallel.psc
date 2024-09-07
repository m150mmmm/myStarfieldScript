Scriptname zzzM150BulletHellParallel extends ObjectReference

Group Base_Properties
    int Property shotCount Auto Const
    int Property unitOneSideCount Auto Const
    Float Property unitDistance Auto Const
    Float Property targetOffsetZ Auto Const
EndGroup

Group Offset_Properties
    Float Property offsetX Auto Const
    Float Property offsetY Auto Const
    Float Property offsetZ Auto Const
EndGroup

Group Time_Properties
    Float Property WaitTime Auto Const
    Float Property WaitTimeUnit Auto Const
EndGroup

Group Etc_Properties
    Activator Property casterMarker Auto Const
    Activator Property targetMarker Auto Const
    spell property castSpell auto Const
    Sound Property fireSound  Auto Const
EndGroup
;-------------------------------------------------------------
Float casterX
Float casterY
Float casterZ
Float distance = 100.0

Event onLoad()
    Utility.Wait(0.5)

    casterX = self.GetPositionX() + offsetX
    casterY = self.GetPositionY() + offsetY
    casterZ = self.GetPositionZ() + offsetZ
    self.TranslateTo(casterX, casterY, casterZ, 0, 0, 0, 99999)
    Utility.Wait(0.5)

    ShotAll()
    
	Self.Delete()
EndEvent

function ShotAll ()
    Actor PlayerREF = Game.GetPlayer()
    Float playerAngle = PlayerREF.GetAngleZ()

    ObjectReference[] targets = new ObjectReference[unitOneSideCount * 2 + 1]
    ObjectReference[] casters = new ObjectReference[unitOneSideCount * 2 + 1]

    int i = 0
    int ii = 0
    while (i < unitOneSideCount * 2 + 1)
        casters[i] = self.PlaceAtMe(casterMarker)
        casters[i].waitfor3dload()
        casters[i].MoveTo(casters[i], Math.sin(playerAngle + 90) * distance * ii, Math.cos(playerAngle + 90) * distance * ii, 0)
        targets[i] = self.PlaceAtMe(targetMarker)
        targets[i].waitfor3dload()
        targets[i].MoveTo(casters[i], Math.sin(playerAngle) * distance, Math.cos(playerAngle) * distance, targetOffsetZ)
        if (i != 0)
            i += 1
            casters[i] = self.PlaceAtMe(casterMarker)
            casters[i].waitfor3dload()
            casters[i].MoveTo(casters[i], -Math.sin(playerAngle + 90) * distance * ii, -Math.cos(playerAngle + 90) * distance * ii, 0)
            targets[i] = self.PlaceAtMe(targetMarker)
            targets[i].waitfor3dload()
            targets[i].MoveTo(casters[i], Math.sin(playerAngle) * distance, Math.cos(playerAngle) * distance, targetOffsetZ)
            i += 1
        else
            i += 1
        endIf
        ii += 1
    endwhile

    i = 0

    ; 撃つ回数で回す
    while (i < shotCount)
        shotSpell(targets, casters, PlayerREF)
        i += 1
        Utility.Wait(WaitTime)
    endwhile

    i = 0
    while (i < targets.length)
        targets[i].Delete()
        casters[i].Delete()
        i += 1
    endwhile
    
endFunction

; 発射---------------------------------------------------------------------
function shotSpell (ObjectReference[] targets, ObjectReference[] casters, Actor akBlameActor)
     
    int i = 0
    while (i < targets.length)
        fireSound.play(self)
        castSpell.RemoteCast(casters[i], akBlameActor, targets[i])
        i += 1
        Utility.Wait(WaitTimeUnit)
    endwhile
    
endFunction


