Scriptname zzzM150ExchangeItemScript extends ObjectReference Const

message property nothingItemMes auto Const
MiscObject Property payItem Auto Const
LeveledItem Property changeItem Auto Const

int Property payItemCount = 1 Auto Const
int Property changeItemCount = 1 Auto Const

Event OnActivate(ObjectReference akActionRef)

	Actor PlayerREF = Game.GetPlayer()

	if akActionRef == PlayerREF
        if PlayerREF.GetItemCount(payItem) >= payItemCount
            PlayerREF.RemoveItem(payItem ,  payItemCount )
		    PlayerREF.AddItem(changeItem, changeItemCount , false)
        else
            ; You are short of caps.
            nothingItemMes.show()
        endIf
    endIf
EndEvent