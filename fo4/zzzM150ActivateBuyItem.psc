Scriptname zzzM150ActivateBuyItem extends ObjectReference Const

Int Property Price Auto Const
Int Property GoodsCount Auto Const
MiscObject Property payItem Auto Const
LeveledItem Property Goods Auto Const

Event OnActivate(ObjectReference akActionRef)
	if  akActionRef.GetItemCount(payitem) >= Price
		akActionRef.RemoveItem(payItem ,  Price )
		akActionRef.AddItem(Goods, GoodsCount , true)
		Debug.Notification("Thank you so much for your purchase.")
	else
		Debug.Notification("You are " + (Price - akActionRef.GetItemCount(payitem))  + "cap short.")
	endIf
endEvent
