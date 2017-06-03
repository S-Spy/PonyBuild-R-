/datum/hud_data
	var/icon              // If set, overrides ui_style.
	var/list/equip_slots = list() // Checked by mob_can_equip().

	// Contains information on the position and tag for all inventory slots
	// to be drawn for the mob. This is fairly delicate, try to avoid messing with it
	// unless you know exactly what it does.
	var/list/adding_gear = list(//Полный контроль. "Руки" вставляются через другую функцию
		"i_clothing"    =  list("loc" = ui_iclothing, 	"slot" = slot_w_uniform, "state" = "center", 		"dir" = SOUTH,	"toggle" = 1),
		"o_clothing"    =  list("loc" = ui_oclothing, 	"slot" = slot_wear_suit, "state" = "equip",  		"dir" = SOUTH,	"toggle" = 1),
		"mask" 		    =  list("loc" = ui_mask,      	"slot" = slot_wear_mask, "state" = "mask",							"toggle" = 1),
		"gloves" 	    =  list("loc" = ui_gloves,    	"slot" = slot_gloves,    "state" = "gloves", 						"toggle" = 1),
		"eyes" 		    =  list("loc" = ui_glasses,   	"slot" = slot_glasses,   "state" = "glasses",						"toggle" = 1),
		"l_ear" 	    =  list("loc" = ui_l_ear,     	"slot" = slot_l_ear,     "state" = "ears",   						"toggle" = 1),
		"r_ear" 	    =  list("loc" = ui_r_ear,     	"slot" = slot_r_ear,     "state" = "ears",   						"toggle" = 1),
		"head" 		    =  list("loc" = ui_head,      	"slot" = slot_head,      "state" = "hair",   						"toggle" = 1),
		"shoes"		    =  list("loc" = ui_shoes,     	"slot" = slot_shoes,     "state" = "shoes",  						"toggle" = 1),
		"suit storage"  =  list("loc" = ui_sstore1,   	"slot" = slot_s_store,   "state" = "belt",   		"dir" = 8					),
		"back" 		    =  list("loc" = ui_back,      	"slot" = slot_back,      "state" = "back",   		"dir" = NORTH,  "toggle" = 1),
		"id" 			=  list("loc" = ui_id,        	"slot" = slot_wear_id,   "state" = "id",     		"dir" = NORTH				),
		"storage1" 		=  list("loc" = ui_storage1,  	"slot" = slot_l_store,   "state" = "pocket"										),
		"storage2"		=  list("loc" = ui_storage2,  	"slot" = slot_r_store,   "state" = "pocket"										),
		"belt"			=  list("loc" = ui_belt,      	"slot" = slot_belt,      "state" = "belt"										),
		"swap"			=  list("loc" = ui_swaphand, 						     "state" = "swap",  		"dir" = SOUTH				),
		)

	var/list/adding_intent = list(
		"mov_intent"	=  list("loc" = ui_movi, 														"dir" = SOUTHWEST),
		"resist"		=  list("loc" = ui_pull_resist, "state" = "act_resist", 										 ),
		"drop"			=  list("loc" = ui_drop_throw, 	"state" = "act_drop", 											 ),
		"act_intent"	=  list("loc" = ui_acti,	 					 								"dir" = SOUTHWEST),
		"equip"			=  list("loc" = ui_equip,	 	"state" = "act_equip", 											 )
		)

	var/list/hud_add = list(
		"throw"				=  list("loc" = ui_drop_throw, 	"state" = "act_throw_off"						 ),
		"pull"				=  list("loc" = ui_pull_resist, "state" = "pull0" 								 ),
		"internal"			=  list("loc" = ui_internal,	"state" = "internal0" 							 ),
		"oxygen"			=  list("loc" = ui_oxygen, 		"state" = "oxy0" 								 ),
		"toxin"				=  list("loc" = ui_toxin,	 	"state" = "tox0" 								 ),
		"fire"				=  list("loc" = ui_fire, 		"state" = "fire0" 								 ),
		"health"			=  list("loc" = ui_health, 		"state" = "health0" 							 ),
		"pressure"			=  list("loc" = ui_pressure, 	"state" = "pressure0"							 ),
		"body temperature"	=  list("loc" = ui_temp, 		"state" = "temp1" 								 ),
		"nutrition"			=  list("loc" = ui_nutrition, 	"state" = "nutrition0" 							 ),
		"emoji"				=  list("loc" = ui_emoji, 		"state" = "0", "noicon"	= 1						 ),
		"damage zone"		=  list("loc" = ui_zonesel, 	"noicon"= 1, "noname" = 1						 )
	)
	var/list/hud_splash_add = list(
		"flash"				=  list("loc" = "1,1 to 15,15", "state" = "blank", 			 				),
		"blind"				=  list("loc" = "1,1", 			"state" = "blackimageoverlay",	"noicon" = 1),
		"dmg"				=  list("loc" = "1,1",	 		"state" = "oxydamageoverlay0",	"noicon" = 1)
		)



/datum/hud_data/New(var/mob/mymob)
	..()
	for(var/slot in adding_gear)
		equip_slots |= adding_gear[slot]["slot"]

	if(mymob && mymob.list_hands.len)
		equip_slots |= slot_handcuffed

	if(slot_back in equip_slots)
		equip_slots |= slot_in_backpack

	if(slot_w_uniform in equip_slots)
		equip_slots |= slot_tie

	equip_slots |= slot_legcuffed

/datum/hud_data/diona
	adding_gear = list(
		"i_clothing" =   list("loc" = ui_iclothing, "slot" = slot_w_uniform, "state" = "center", "toggle" = 1, "dir" = SOUTH),
		"o_clothing" =   list("loc" = ui_shoes,     "slot" = slot_wear_suit, "state" = "equip",  "toggle" = 1, "dir" = SOUTH),
		"l_ear" =        list("loc" = ui_gloves,    "slot" = slot_l_ear,     "state" = "ears",   "toggle" = 1),
		"head" =         list("loc" = ui_oclothing, "slot" = slot_head,      "state" = "hair",   "toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "slot" = slot_s_store,   "state" = "belt",   "dir" = 8),
		"back" =         list("loc" = ui_back,      "slot" = slot_back,      "state" = "back",   "dir" = NORTH),
		"id" =           list("loc" = ui_id,        "slot" = slot_wear_id,   "state" = "id",     "dir" = NORTH),
		"storage1" =     list("loc" = ui_storage1,  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "slot" = slot_r_store,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "slot" = slot_belt,      "state" = "belt")
		)