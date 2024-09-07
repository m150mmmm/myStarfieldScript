Scriptname zzzM150ItemsIntoLeveldItems extends Quest

LeveledItem[] Property TargetLeveldItems Auto Const
LeveledItem Property AddItems Auto Const
Message Property InitMsg Auto Const
Quest Property thisQuest Auto Const

Event OnQuestInit()
	int i = 0
	While (i < TargetLeveldItems.length)
		TargetLeveldItems[i].AddForm(AddItems, 1, 1)
		i += 1
	EndWhile
	InitMsg.Show()
	thisQuest.Stop()
EndEvent