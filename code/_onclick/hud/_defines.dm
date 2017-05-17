/*
	These defines specificy screen locations.  For more information, see the byond documentation on the screen_loc var.

	The short version:

	Everything is encoded as strings because apparently that's how Byond rolls.

	"1,1" is the bottom left square of the user's screen.  This aligns perfectly with the turf grid.
	"1:2,3:4" is the square (1,3) with pixel offsets (+2, +4); slightly right and slightly above the turf grid.
	Pixel offsets are used so you don't perfectly hide the turf under them, that would be crappy.

	The size of the user's screen is defined by client.view (indirectly by world.view), in our case "15x15".
	Therefore, the top right corner (except during admin shenanigans) is at "15,15"
*/

//Upper left action buttons, displayed when you pick up an item that has this enabled.
#define ui_action_slot1 "1:6,14:26"
#define ui_action_slot2 "2:8,14:26"
#define ui_action_slot3 "3:10,14:26"
#define ui_action_slot4 "4:12,14:26"
#define ui_action_slot5 "5:14,14:26"
#define ui_action_slot6 "6:14,14:26"

//Lower left, persistant menu
#define ui_inventory "1:6,3:5"

//Lower center, persistant menu
#define ui_sstore1 "3:10,1:5"
#define ui_id "4:12,1:5"
#define ui_belt "5:14,1:5"

#define ui_equip null
#define ui_swaphand1 "7,1:2"
#define ui_swaphand2 "8,1:2"
#define ui_storage1 "9:18,1:5"
#define ui_storage2 "10:20,1:5"

#define ui_alien_head "4:12,1:5"	//aliens
#define ui_alien_oclothing "5:14,1:5"	//aliens

#define ui_inv1 "7,1:5"			//borgs
#define ui_inv2 "8,1:5"			//borgs
#define ui_inv3 "9,1:5"			//borgs
#define ui_borg_store "10,1:5"	//borgs
#define ui_borg_inventory "6,1:5"//borgs

#define ui_monkey_mask "5:14,1:5"	//monkey
#define ui_monkey_back "6:14,1:5"	//monkey

//Lower right, persistant menu
#define ui_dropbutton "1,2:5"
#define ui_drop_throw "1:6,2:5"
#define ui_pull_resist "1:5,1:5"
#define ui_acti "13:26,1:5"
#define ui_movi "12:24,1:5"

#define ui_zonesel "14:28,1:5"
#define ui_zonemode "14:28,2:5"
#define ui_acti_alt "14:28,1:5" //alternative intent switcher for when the interface is hidden (F12)

#define ui_borg_pull "12:24,2:7"
#define ui_borg_module "13:26,2:7"
#define ui_borg_panel "EAST:-4,2:7"

//Gun buttons
#define ui_gun1 "13:26,3:7"
#define ui_gun2 "14:28, 4:7"
#define ui_gun3 "13:26,4:7"
#define ui_gun_select "EAST:-4,3:7"

//Upper-middle right (damage indicators)
#define ui_toxin "EAST:-4,13:27"
#define ui_fire "EAST:-4,12:25"
#define ui_oxygen "EAST:-4,11:23"
#define ui_pressure "EAST:-4,10:21"

#define ui_alien_toxin "EAST:-4,13:25"
#define ui_alien_fire "EAST:-4,12:25"
#define ui_alien_oxygen "EAST:-4,11:25"

//Middle right (status indicators)
#define ui_emoji "EAST:-4,NORTH-1:11"
#define ui_nutrition "EAST:-4,5:11"
#define ui_temp "EAST:-4,6:13"
#define ui_health "EAST:-4,7:15"
#define ui_internal "EAST:-4,8:17"
									//borgs
#define ui_borg_health "EAST:-4,6:13" //borgs have the health display where ponys have the pressure damage indicator.
#define ui_alien_health "EAST:-4,6:13" //aliens have the health display where ponys have the pressure damage indicator.

//Pop-up inventory
#define ui_shoes "7:16,5:-8"

#define ui_iclothing "6:12,6:-4"
#define ui_oclothing "7:16,6:-4"
#define ui_gloves null

#define ui_glasses "6:12,7"
#define ui_mask "7:16,7"
#define ui_l_ear "6:12,8:4"
#define ui_r_ear "8:19,8:4"
#define ui_back "8:18,6:-2"

#define ui_head "7:16,8:4"

//Intent small buttons
#define ui_help_small "12:8,1:1"
#define ui_disarm_small "12:15,1:18"
#define ui_grab_small "12:32,1:18"
#define ui_harm_small "12:39,1:1"

//See active_slots.dm
#define ui_hand1 "6:16,1:5"
#define ui_hand2 "8:16,1:5"
#define ui_hand3 "7:16,1:12"

#define ui_hstore1 "5,5"
#define ui_sleep "EAST+1, NORTH-13"
#define ui_rest "EAST+1, NORTH-14"


#define ui_iarrowleft "SOUTH-1,11"
#define ui_iarrowright "SOUTH-1,13"
