Scriptname zzzM150BulletHell3DLimitAngle extends ObjectReference

Group Base_Properties
    int Property shotCount Auto Const
    Float Property unitAngle Auto Const
    {min:5.0}
    Float Property diffAngle Auto Const
    Bool Property isClockwise Auto Const
EndGroup

Group Offset_Properties
    Float Property offsetX Auto Const
    Float Property offsetY Auto Const
    Float Property offsetZ Auto Const
EndGroup

Group Limit_Properties
    Float Property startAngle Auto Const
    {0 - 360}
    Float Property endAngle Auto Const
    {0 - 360}
    Bool Property reverseStartAndEndAngle Auto Const
    {false: startAngle <= angle <= endAngle}
EndGroup

Group Time_Properties
    Float Property WaitTime Auto Const
    Float Property WaitTimeUnit Auto Const
EndGroup

Group Etc_Properties
    Activator Property targetMarker Auto Const
    spell property castSpell auto Const
    Sound Property fireSound  Auto Const
    Bool Property reverseCaster Auto Const
    Float Property radius Auto Const
EndGroup

Group Z_Base_Properties
    Float Property AngleZ Auto Const
    {-90 - 90}
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

    ShotAll()
    
	Self.Delete()
EndEvent

function ShotAll ()
    Actor PlayerREF = Game.GetPlayer()
    Float playerAngle = PlayerREF.GetAngleZ()

    ;Zの角度作成
    float HeightZ
    float r = Math.abs(AngleZ)
    float radiusZ = Math.cos(r) * radius
    if (0 <= AngleZ)
        HeightZ = Math.sin(r) * radius
    else
        HeightZ = -Math.sin(r) * radius
    endIf
    
    int shotCountIndex = 0

    ; 撃つ回数で回す
    while (shotCountIndex < shotCount)
        ;-----------------------------------------------------------------------
        float nowAngle = 0

        ; 発射回数分の配列を作成
        int fireCount = 0
        while (nowAngle < 360)
            Float angle = nowAngle + diffAngle * shotCountIndex
            if (boolAngleLimit(angle))
                fireCount += 1
            endIf
            nowAngle += unitAngle
        endWhile

        float[] Angles = new float[fireCount]
        float[] ArrayX = new float[fireCount]
        float[] ArrayY = new float[fireCount]
        
        fireCount = 0
        if (!reverseStartAndEndAngle)
            if (isClockwise)
                nowAngle = 0
                while (nowAngle < 360)
                    Float angle = nowAngle + diffAngle * shotCountIndex
                    if (startAngle <= angle && angle <= endAngle)
                        Angles[fireCount] = angle
                        fireCount += 1
                    endIf
                    nowAngle += unitAngle
                endWhile
            else
                nowAngle = 360
                while (nowAngle > 0)
                    Float angle = nowAngle - diffAngle * shotCountIndex
                    if (startAngle <= angle && angle <= endAngle)
                        Angles[fireCount] = angle
                        fireCount += 1
                    endIf
                    nowAngle -= unitAngle
                endWhile
            endIf
        else
            if (isClockwise)
                nowAngle = 0
                while (nowAngle < 360)
                    Float angle = nowAngle + diffAngle * shotCountIndex
                    if (endAngle <= angle)
                        Angles[fireCount] = angle
                        fireCount += 1
                    endIf
                    nowAngle += unitAngle
                endWhile
                nowAngle = 0
                while (nowAngle < 360)
                    Float angle = nowAngle + diffAngle * shotCountIndex
                    if (angle <= startAngle)
                        Angles[fireCount] = angle
                        fireCount += 1
                    endIf
                    nowAngle += unitAngle
                endWhile
            else
                nowAngle = 360
                while (nowAngle > 0)
                    Float angle = nowAngle - diffAngle * shotCountIndex
                    if (angle <= startAngle)
                        Angles[fireCount] = angle
                        fireCount += 1
                    endIf
                    nowAngle -= unitAngle
                endWhile
                nowAngle = 360
                while (nowAngle > 0)
                    Float angle = nowAngle - diffAngle * shotCountIndex
                    if (endAngle <= angle)
                        Angles[fireCount] = angle
                        fireCount += 1
                    endIf
                    nowAngle -= unitAngle
                endWhile
            endIf
        endIf

        fireCount = 0
        while (fireCount < Angles.length)
            r = Angles[fireCount] + playerAngle
            if (360 <= r)
                r -= 360
            endIf
            ArrayX[fireCount] = Math.sin(r) * radiusZ
            ArrayY[fireCount] = Math.cos(r) * radiusZ
            fireCount += 1
        endWhile

        shotSpell(ArrayX, ArrayY, HeightZ, PlayerREF)
        ;-----------------------------------------------------------------------
        shotCountIndex += 1
        Utility.Wait(WaitTime)
    endwhile
 
endFunction

; 発射---------------------------------------------------------------------
function shotSpell (Float[] ArrayX, Float[] ArrayY, Float FloatZ, Actor akBlameActor)
    ObjectReference[] targets = new ObjectReference[ArrayX.length]
    
    int i = 0
    while (i < ArrayX.length)
        targets[i] = self.PlaceAtMe(targetMarker)
        targets[i].waitfor3dload()
        targets[i].MoveTo(self, ArrayX[i], ArrayY[i], FloatZ)
        i += 1
    endwhile
    
    i = 0
    if (AngleZ == -90 || AngleZ == 90)
        fireSound.play(self)
        if (!reverseCaster)
            castSpell.RemoteCast(self, akBlameActor, targets[i])
        else
            castSpell.RemoteCast(targets[i], akBlameActor, self)
        endIf
        targets[i].Delete()
    else 
        if (!reverseCaster)
            while (i < targets.length)
                fireSound.play(self)
                castSpell.RemoteCast(self, akBlameActor, targets[i])
                targets[i].Delete()
                i += 1
                Utility.Wait(WaitTimeUnit)
            endwhile
        else
            while (i < targets.length)
                fireSound.play(self)
                castSpell.RemoteCast(targets[i], akBlameActor, self)
                targets[i].Delete()
                i += 1
                Utility.Wait(WaitTimeUnit)
            endwhile
        endIf
    endIf

    i = 0
    while (i < targets.length)
        targets[i].Delete()
        i += 1
    endwhile
    
endFunction

; 発射許可角度内かどうか-----------------------------------------------------
Bool function boolAngleLimit (float angle)
    if (!reverseStartAndEndAngle)
        return startAngle <= angle && angle <= endAngle
    else
        return angle <= startAngle || endAngle <= angle
    endIf
endFunction
