ScriptName zzzM150GunChangeModuleAtBash extends ObjectReference

ObjectMod Property Module0 Auto Const
ObjectMod Property Module1 Auto Const

int nowMod = 0
Event OnEquipped(Actor akActor)
    Utility.Wait(1)
    If akActor == Game.GetPlayer()
	    Self.RegisterForAnimationEvent(akActor as ObjectReference, "weaponSwing")
    EndIf
EndEvent

Event OnUnequipped(Actor akActor)
	Self.UnregisterForAnimationEvent(akActor as ObjectReference, "weaponSwing")
EndEvent

Event OnAnimationEvent(ObjectReference akSource, string asEventName)
	If (asEventName == "weaponSwing")
        Utility.Wait(1)
		changeMod()
	EndIf
EndEvent

Function changeMod()
    If (nowMod == 0)
        self.RemoveMod(Module0)
        self.AttachMod(Module1, 1)
        nowMod = 1
    Else
        self.RemoveMod(Module1)
        self.AttachMod(Module0, 1)
        nowMod = 0
    EndIf
EndFunction
