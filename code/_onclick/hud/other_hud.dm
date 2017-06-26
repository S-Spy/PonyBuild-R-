/datum/hud_data/animal
	icon = 'icons/mob/screen1_old.dmi'
	adding_gear = list(//Полный контроль. "Руки" вставляются через другую функцию
		//"i_clothing"    =  list("type"=/obj/screen/inventory,"loc" = ui_iclothing, 	"slot" = slot_w_uniform, "state" = "center", 		"dir" = SOUTH,	"toggle" = 1),
		//"o_clothing"    =  list("type"=/obj/screen/inventory,"loc" = ui_oclothing, 	"slot" = slot_wear_suit, "state" = "equip",  		"dir" = SOUTH,	"toggle" = 1),
		"mask" 		  	  =  list("type"=/obj/screen/inventory,"loc" = ui_mask,      	"slot" = slot_wear_mask, "state" = "mouth_inactive"								),
		//"gloves" 	  	  =  list("type"=/obj/screen/inventory,"loc" = ui_gloves,    	"slot" = slot_gloves,    "state" = "gloves", 						"toggle" = 1),
		//"eyes" 		  =  list("type"=/obj/screen/inventory,"loc" = ui_glasses,   	"slot" = slot_glasses,   "state" = "glasses",						"toggle" = 1),
		//"l_ear" 		  =  list("type"=/obj/screen/inventory,"loc" = ui_l_ear,     	"slot" = slot_l_ear,     "state" = "ears",   						"toggle" = 1),
		//"r_ear" 		  =  list("type"=/obj/screen/inventory,"loc" = ui_r_ear,     	"slot" = slot_r_ear,     "state" = "ears",   						"toggle" = 1),
		//"head" 		  =  list("type"=/obj/screen/inventory,"loc" = ui_head,      	"slot" = slot_head,      "state" = "hair",   						"toggle" = 1),
		//"shoes"		  =  list("type"=/obj/screen/inventory,"loc" = ui_shoes,     	"slot" = slot_shoes,     "state" = "shoes",  						"toggle" = 1),
		//"suit storage"  =  list("type"=/obj/screen/inventory,"loc" = ui_sstore1,   	"slot" = slot_s_store,   "state" = "belt",   		"dir" = 8					),
		"back" 			  =  list("type"=/obj/screen/inventory,"loc" = ui_back,      	"slot" = slot_back,      "state" = "back",   		"dir" = NORTH,  "toggle" = 1),
		//"id" 			  =  list("type"=/obj/screen/inventory,"loc" = ui_id,        	"slot" = slot_wear_id,   "state" = "id",     		"dir" = NORTH				),
		//"storage1" 	  =  list("type"=/obj/screen/inventory,"loc" = ui_storage1,  	"slot" = slot_l_store,   "state" = "pocket"										),
		//"storage2"	  =  list("type"=/obj/screen/inventory,"loc" = ui_storage2,  	"slot" = slot_r_store,   "state" = "pocket"										),
		//"belt"		  =  list("type"=/obj/screen/inventory,"loc" = ui_belt,      	"slot" = slot_belt,      "state" = "belt"										),
		"swap"			  =  list("type"=/obj/screen/inventory,"loc" = ui_swaphand, 						     "state" = "swap",  		"dir" = SOUTH				),
		)
	adding_intent = list(
		"background"	=  list(				 		"state" = "back_inventory-edge", "toggle" = 1					 ),
		"mov_intent"	=  list("loc" = ui_movi, 										 				"dir" = SOUTHWEST),
		//"resist"		=  list("loc" = ui_pull_resist, "state" = "act_resist", 										 ),
		"drop"			=  list("loc" = ui_drop_throw, 	"state" = "drop", 												 ),
		"act_intent"	=  list("loc" = ui_acti,	 					 								"dir" = SOUTHWEST),
		//"equip"		=  list("loc" = ui_equip,	 	"state" = "act_equip", 											 )
		)
	hud_add = list(
		"throw"				=  list("loc" = ui_drop_throw, 	"state" = "act_throw_off"),
		"pull"				=  list("loc" = ui_pull_resist, "state" = "pull0" 		 ),
		"internal"			=  list("loc" = ui_internal,	"state" = "internal0" 	 ),
		"oxygen"			=  list("loc" = ui_oxygen, 		"state" = "oxy0" 		 ),
		//"toxin"			=  list("loc" = ui_toxin,	 	"state" = "tox0" 		 ),
		"fire"				=  list("loc" = ui_fire, 		"state" = "fire0" 		 ),
		"health"			=  list("loc" = ui_health, 		"state" = "health0" 	 ),
		"pressure"			=  list("loc" = ui_pressure, 	"state" = "pressure0" 	 ),
		"body temperature"	=  list("loc" = ui_temp, 		"state" = "temp1" 		 ),
		//"nutrition"		=  list("loc" = ui_nutrition, 	"state" = "nutrition0" 	 ),
		"damage zone"		=  list("type"=/obj/screen/zone, "loc" = ui_zonesel, 	"noicon"= 1, "noname" = 1)
		)
	hud_splash_add = list(
		"flash"				=  list("loc" = "1,1 to 15,15", "state" = "blank", 			 				),
		//"blind"			=  list("loc" = "1,1", 			"state" = "blackimageoverlay",	"noicon" = 1),
		//"dmg"				=  list("loc" = "1,1",	 		"state" = "oxydamageoverlay0",	"noicon" = 1)
		)



/datum/hud_data/larva
	icon = 'icons/mob/screen1_alien.dmi'
	adding_gear = list()
	adding_intent = list(
		"mov_intent"	=  list("loc" = ui_movi, 										 				"dir" = SOUTHWEST),
		)
	hud_add = list(
		"fire"				=  list("loc" = ui_fire, 		"state" = "fire0" 		 ),
		"health"			=  list("loc" = ui_alien_health,"state" = "health0" 	 )
		)
	hud_splash_add = list(
		"flash"				=  list("loc" = "1,1 to 15,15", "state" = "blank", 			 				),
		"blind"				=  list("loc" = "1,1", 			"state" = "blackimageoverlay",	"noicon" = 1),
		)


/datum/hud_data/brain
	adding_gear = list()
	adding_intent = list()
	hud_add = list()
	hud_splash_add = list(
		"blind"				=  list("loc" = "1,1", 			"state" = "blackimageoverlay",	"noicon" = 1),
		)


/datum/hud_data/blob
	adding_gear = list()
	adding_intent = list()
	hud_add = list()
	hud_add = list(
		"internal"			=  list("loc" = ui_internal,	"state" = "block"),
		"health"			=  list("loc" = ui_health, 		"state" = "block")
		)


/datum/hud_data/slime
	adding_gear = list()
	adding_intent = list(
		"act_intent"	=  list("loc" = ui_zonesel,		"dir" = SOUTHWEST)
		)
	hud_add = list()
	hud_splash_add = list()

/datum/hud_data/robot
	icon = 'icons/mob/screen1_robot.dmi'
	adding_gear = list()

	adding_intent = list(
		"act_intent"	=  list("loc" = ui_acti,	 					 			"dir" = SOUTHWEST),
		"radio"		    =  list("loc" = ui_movi,			"state" = "radio",		"dir" = SOUTHWEST),
		"module1"		=  list("loc" = ui_inv1, 			"state" = "inv1",		"dir" = SOUTHWEST),
		"module2"		=  list("loc" = ui_inv2, 			"state" = "inv2",		"dir" = SOUTHWEST),
		"module3"		=  list("loc" = ui_inv3, 			"state" = "inv3",		"dir" = SOUTHWEST),
		"panel"			=  list("loc" = ui_borg_panel, 		"state" = "panel"						 )

		)

	hud_add = list(
		"oxygen"			=  list("loc" = ui_oxygen, 			"state" = "oxy0" 		),
		"fire"				=  list("loc" = ui_fire, 			"state" = "fire0" 		),
		"health"			=  list("loc" = ui_borg_health, 	"state" = "health0"		),
		"body temperature"	=  list("loc" = ui_zonesel, 			"state" = "temp1" 		),
		"damage zone"		=  list("type"=/obj/screen/zone, "loc" = ui_nutrition, 	"noicon"= 1, "noname" = 1),
		"pull"				=  list("loc" = ui_borg_pull, 		"state" = "pull0" 		),
		"module"			=  list("loc" = ui_borg_module, 	"state" = "nomod"		),
		"cell"				=  list("loc" = ui_toxin, 			"state" = "charge-empty"),
		"store"				=  list("loc" = ui_borg_store, 		"state" = "store"		),
		"inventory"			=  list("loc" = ui_borg_inventory, 	"state" = "inventory"	)
		)
	hud_splash_add = list(
		"flash"				=  list("loc" = "1,1 to 15,15", "state" = "blank", 			 				),
		//"blind"				=  list("loc" = "1,1", 			"state" = "blackimageoverlay",	"noicon" = 1)
		)
var/obj/screen/robot_inventory




//Эти функции вызываются при нажатии на кнопку в рамках hud'a
/datum/hud/proc/toggle_show_robot_modules()
	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	r.shown_robot_modules = !r.shown_robot_modules
	update_robot_modules_display()


/datum/hud/proc/update_robot_modules_display()
	if(!isrobot(mymob))
		return

	var/mob/living/silicon/robot/r = mymob

	if(r.shown_robot_modules)
		//Modules display is shown
		//r.client.screen += robot_inventory	//"store" icon

		if(!r.module)
			usr << "<span class='danger'>No module selected</span>"
			return

		if(!r.module.modules)
			usr << "<span class='danger'>Selected module has no modules to select</span>"
			return

		if(!r.robot_modules_background)
			return

		var/display_rows = -round(-(r.module.modules.len) / 8)
		r.robot_modules_background.screen_loc = "CENTER-4:16,SOUTH+1:7 to CENTER+3:16,SOUTH+[display_rows]:7"
		r.client.screen += r.robot_modules_background

		var/x = -4	//Start at CENTER-4,SOUTH+1
		var/y = 1

		//Unfortunately adding the emag module to the list of modules has to be here. This is because a borg can
		//be emagged before they actually select a module. - or some situation can cause them to get a new module
		// - or some situation might cause them to get de-emagged or something.
		if(r.emagged)
			if(!(r.module.emag in r.module.modules))
				r.module.modules.Add(r.module.emag)
		else
			if(r.module.emag in r.module.modules)
				r.module.modules.Remove(r.module.emag)

		for(var/atom/movable/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is not currently active
				r.client.screen += A
				if(x < 0)
					A.screen_loc = "CENTER[x]:16,SOUTH+[y]:7"
				else
					A.screen_loc = "CENTER+[x]:16,SOUTH+[y]:7"
				A.layer = 20

				x++
				if(x == 4)
					x = -4
					y++

	else
		//Modules display is hidden
		//r.client.screen -= robot_inventory	//"store" icon
		for(var/atom/A in r.module.modules)
			if( (A != r.module_state_1) && (A != r.module_state_2) && (A != r.module_state_3) )
				//Module is not currently active
				r.client.screen -= A
		r.shown_robot_modules = 0
		r.client.screen -= r.robot_modules_background