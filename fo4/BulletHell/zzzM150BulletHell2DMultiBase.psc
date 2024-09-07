Scriptname zzzM150BulletHell2DMultiBase extends ObjectReference

Group Base_Properties
    Activator[] Property Casters Auto Const
EndGroup

Group Offset_Properties
    Float Property offsetX Auto Const
    Float Property offsetY Auto Const
    Float Property offsetZ Auto Const
EndGroup

Group Etc_Properties
    Float Property radius Auto Const
EndGroup
;-------------------------------------------------------------
Float casterX
Float casterY
Float casterZ

Float unitAngle

Event onLoad()
    Utility.Wait(0.5)

    Actor PlayerREF = Game.GetPlayer()
    Float playerAngle = PlayerREF.GetAngleZ()

    unitAngle = 360.0 / Casters.length

    casterX = self.GetPositionX() + offsetX
    casterY = self.GetPositionY() + offsetY
    casterZ = self.GetPositionZ() + offsetZ
    self.TranslateTo(casterX, casterY, casterZ, 0, 0, 0, 99999)
    Utility.Wait(0.5)

    int i = 0
    while (i < Casters.length)
        ObjectReference caster = self.PlaceAtMe(Casters[i])
        Float r = playerAngle + unitAngle * i
        if (360 <= r)
                r -= 360
        endIf
        caster.waitfor3dload()
        caster.TranslateTo( \
        casterX + Math.sin(r) * radius, \
        casterY + Math.cos(r) * radius, \
        casterZ, \
        0, 0, 0, 99999)
        i += 1
    endwhile
    
	Self.Delete()
EndEvent



