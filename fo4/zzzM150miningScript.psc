Scriptname zzzM150miningScript extends ObjectReference

LeveledItem Property miningItem Auto Const
Weapon Property Pickaxe Auto Const
Activator Property deadVein Auto Const

message property noPickaxeMsg auto Const
message property activateMsg auto Const

int Property maxMiningCount = 5 Auto Const
int Property miningPercent = 50 Auto Const
int Property mineUnitCount = 1 Auto Const

int attackCount = 0


Event OnLoad()
    registerForHitEvent(self)
EndEvent

Event OnUnload()
	UnregisterForAllHitEvents()
EndEvent

event onReset()
	Self.Enable()
	attackCount = 0
endEvent


Event OnHit(ObjectReference akTarget, ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked, string asMaterialName)
	Actor PlayerREF = Game.GetPlayer()
	if akAggressor == PlayerREF
		if PlayerREF.GetEquippedWeapon() == Pickaxe
			if  attackCount < maxMiningCount
				int random = Utility.RandomInt()
				if (random < miningPercent)
					PlayerREF.AddItem(miningItem, mineUnitCount)
					attackCount = attackCount + 1
				endIf
			endIf
			if attackCount >= maxMiningCount
				ObjectReference newObj = Self.placeatme(deadVein)
				newObj.waitfor3dload()
				Utility.Wait(1)
				Self.Disable()
				UnregisterForAllHitEvents()
			endIf
		else
			noPickaxeMsg.show()
		endIf	
	endIf
	registerForHitEvent(self)
EndEvent


Event OnActivate(ObjectReference akActionRef)
	activateMsg.show()
EndEvent