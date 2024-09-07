Scriptname zzzM150BulletHell3DBase extends ObjectReference

Group Base_Properties
    int Property shotCount Auto Const
    Activator[] Property Casters Auto Const
EndGroup

Group Offset_Properties
    Float Property offsetX Auto Const
    Float Property offsetY Auto Const
    Float Property offsetZ Auto Const
EndGroup

Group Time_Properties
    Float Property WaitTime Auto Const
EndGroup

;-------------------------------------------------------------
Float casterX
Float casterY
Float casterZ

Event onLoad()
    Utility.Wait(0.5)

    casterX = self.GetPositionX() + offsetX
    casterY = self.GetPositionY() + offsetY
    casterZ = self.GetPositionZ() + offsetZ
    self.TranslateTo(casterX, casterY, casterZ, 0, 0, 0, 99999)
    Utility.Wait(0.5)

    int i = 0
    while (i < shotCount)
        int ii = 0
        while (ii < Casters.length)
            self.PlaceAtMe(Casters[ii])
            ii += 1
        endwhile
        Utility.Wait(WaitTime)
        i += 1
    endwhile
	Self.Delete()
EndEvent


