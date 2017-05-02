/*
Thanks for downloading J_AI libary. Using this will unlock a whole new level of game AI.
Version 3.00
	Added resets after mobs walk back
	Added freeze settings for mobs
	Added coward setting for AI's
	Added corpse support
	Added support for npc talking and a base to a shop system
	Added varible "respawns" for mobs, if set to zero the mob will delete after they die.

	"J_Effect_Demo.dm" has been added to show people how to make attack effects.


Version 2.50
	Added in visual effecets for attacking
	An option for bump attack (for players)
	When a mob attacks another from behind damage now gets boosted by 10,20 more points
	Made it so mobs cannot do any actions if a Client attached mob isnt arround
	Added support for agressive mobs also protectors (Aka Town Guards)
	Added support to turn off auto movemnt for mobs

Version 2.00
	Updated the comments and code to make it alot easier to read
	Fixed a few bugs i found while testing
	Added a leveling system in which introduced 3 new varibles xp, xpmax and give_xp

Version 1.50
	Updated the commented code as well as fixed moving for the NPC's which should now work
	a heck of alot better.

Features:
	AI
	Combat system
	Commented code so you know what you are messing with
	And a few little miscellaneous features

Introduces the following procedures:
	J_AI()
	J_dienpc()
	J_Death()
	J_Level()
	J_Attack()
	J_getdmg()
	J_getatt()
	J_WB()
	J_Target()
	J Meters
		J_showbars()
		J_hidebars()
		J_updatebar()
		J_update()
	set_start()
	ishome()
	JAI_walk()
	three_steps()
			Made by Johan411.
No credit is needed but very appreciated.

*/