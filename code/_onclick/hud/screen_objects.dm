/*
	Screen objects
	Todo: improve/re-implement

	Screen objects are only used for the hud and should not appear anywhere "in-game".
	They are used with the client/screen list and the screen_loc var.
	For more information, see the byond documentation on the screen_loc and screen vars.
*/
/obj/screen
	name = ""
	icon = 'icons/mob/screen1.dmi'
	layer = 20.0
	unacidable = 1
	var/obj/master = null	//A reference to the object in the slot. Grabs or items, generally.
	var/gun_click_time = -100 //I'm lazy.


/obj/screen/text
	icon = null
	icon_state = null
	mouse_opacity = 0
	screen_loc = "CENTER-7,CENTER-7"
	maptext_height = 480
	maptext_width = 480

/obj/screen/toggle_inv
	name = "toggle_inv"
	layer = 19
	icon_state = "x"

/obj/screen/close

/obj/screen/close/Click()
	if(master)
		if(istype(master, /obj/item/weapon/storage))
			var/obj/item/weapon/storage/S = master
			S.close(usr)
	return 1


/obj/screen/item_action
	var/obj/item/owner

/obj/screen/item_action/Click()
	if(!usr || !owner)				return 1
	if(usr.next_move >= world.time)	return

	usr.next_move = world.time + 6
	if(usr.stat || usr.restrained() || usr.stunned || usr.lying)	return 1
	if(!(owner in usr))												return 1

	owner.ui_action_click()
	return 1

//This is the proc used to update all the action buttons. It just returns for all mob types except ponys.
/mob/proc/update_action_buttons()
	return


/obj/screen/grab

/obj/screen/grab/Click()
	var/obj/item/weapon/grab/G = master
	G.s_click(src)
	return 1

/obj/screen/grab/attack_hand()
	return

/obj/screen/grab/attackby()
	return


/obj/screen/storage

/obj/screen/storage/Click()
	if(world.time <= usr.next_move)									return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)	return 1
	if (istype(usr.loc,/obj/mecha)) 								return 1// stops inventory actions in a mech

	if(master)
		var/obj/item/I = usr.get_active_hand()
		if(I)
			usr.ClickOn(master)
			usr.next_move = world.time+2
	return 1

/obj/screen/gun
	name = "gun"
	icon = 'icons/mob/screen1.dmi'
	master = null
	dir = 2

	move
		name = "Allow Walking";		icon_state = "no_walk0";	screen_loc = ui_gun2
	run
		name = "Allow Running";		icon_state = "no_run0";		screen_loc = ui_gun3
	item
		name = "Allow Item Use";	icon_state = "no_item0";	screen_loc = ui_gun1
	mode		//dir = 1
		name = "Toggle Gun Mode";	icon_state = "gun0";		screen_loc = ui_gun_select




/obj/screen/zone_rotate              // Стрелочки для переключения псевдо 3д режима куклы
	icon = 'icons/mob/zone_sel.dmi'
	screen_loc = ui_zonemode
	var/obj/screen/zone/connect

	left_arrow
		name = "left arrow"
		icon_state = "zone_sel_lb"
	right_arrow
		name = "right arrow"
		icon_state = "zone_sel_rb"

	Click()
		if(!connect)	return

		if(connect.d3_mode == "")
			var/obj/screen/zone_switch/switcher = locate(/obj/screen/zone_switch) in connect.connect_list
			if(switcher)	switcher.switch_mode()

		if(name=="left arrow")	connect.dir = turn(connect.dir, 45)
		else					connect.dir = turn(connect.dir, -45)

		for(var/obj/screen/zone_sel/ZS in connect.connect)
			ZS.dir = connect.dir
			ZS.pixel_list = get_pixel_list(ZS)
		update_icon()



/obj/screen/zone_switch
	name = "switch mode"
	icon = 'icons/mob/zone_sel.dmi'
	icon_state = "zone_sel_ab"
	screen_loc = ui_zonemode
	var/obj/screen/zone/connect

	proc/switch_mode()
		if(!connect)	return

		if(icon_state == "zone_sel_mb")
			connect.d3_mode = ""
			icon_state = "zone_sel_ab"
		else
			connect.d3_mode = "3d_"
			icon_state = "zone_sel_mb"

		for(var/obj/screen/zone_sel/ZS in connect.connect)
			ZS.icon_state = "[connect.d3_mode][ZS.name]"
			ZS.dir = connect.dir
			ZS.pixel_list = get_pixel_list(ZS)
		connect.icon_state = "[connect.d3_mode]zone"
		connect.update_icon()

	Click()
		switch_mode()
		update_icon()

/datum/pixel
	var/x
	var/y

	New(var/px, var/py)
		x = px;y = py

proc/get_pixel_list(var/obj/screen/zone_sel/O)
	var/icon/I = icon(O.icon, O.icon_state, O.dir)
	if(!findtext(O.icon_state, "3d_"))	 I = icon(O.icon, O.icon_state)

	var/list/datum/pixel/pixel_list = list()
	for(var/px=1, px<=32, px++)	for(var/py=1, py<=32, py++)
		if(I.GetPixel(px, py))
			var/datum/pixel/P = new/datum/pixel(px, py)
			pixel_list += P

	return pixel_list



/obj/screen/zone
	name = "damage zone"
	icon = 'icons/mob/zone_sel.dmi'
	icon_state = "zone"
	screen_loc = ui_zonesel
	layer = 19
	dir = WEST
	var/obj/screen/zone_sel/selecting
	var/list/obj/screen/zone_sel/connect = list()
	var/list/obj/screen/connect_list = list() //all
	var/d3_mode = ""




	New()		//При создании добавляем дополнительный интерфейс и определяем зоны
		..()
		var/list/paths = typesof(/obj/screen/zone_sel) - /obj/screen/zone_sel

		for(var/path in paths)
			var/obj/screen/zone_sel/ZL = new path()
			if(!selecting)
				selecting = ZL
				name = "damage zone: [ZL.name]"
			ZL.dir = dir
			ZL.pixel_list = get_pixel_list(ZL)
			connect += ZL

		var/obj/screen/zone_switch/ZS = new /obj/screen/zone_switch()
		ZS.connect = src
		connect_list += ZS

		var/obj/screen/zone_rotate/left_arrow/ZA1 = new /obj/screen/zone_rotate/left_arrow()
		ZA1.connect = src
		connect_list += ZA1

		var/obj/screen/zone_rotate/right_arrow/ZA2 = new /obj/screen/zone_rotate/right_arrow()
		ZA2.connect = src
		connect_list += ZA2
		update_icon()

	update_icon()
		var/icon/I = icon(icon, icon_state)
		if(selecting)
			//if(d3_mode=="")
			switch(selecting.name)//Перенаправление с невидимых иконок
				if("ears")	selecting = locate(/obj/screen/zone_sel/head) in connect
				if("neck")	selecting = locate(/obj/screen/zone_sel/head) in connect
				if("horn")	selecting = locate(/obj/screen/zone_sel/head) in connect
				if("wings")	selecting = locate(/obj/screen/zone_sel/chest) in connect
				if("tail")	selecting = locate(/obj/screen/zone_sel/groin) in connect

			name = "damage zone: [selecting.name]"
			var/icon/I_add = icon(selecting.icon, selecting.icon_state)
			I.Blend(I_add, ICON_OVERLAY)

		overlays.len = 0
		overlays += image(I)


/obj/screen/zone/Click(location, control, params)  //Выбор прицельной зоны
	var/obj/screen/zone_sel/old_selecting = selecting //We're only going to update_icon() if there's been a change

	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])

	for(var/obj/screen/zone_sel/ZS in connect)
		for(var/datum/pixel/P in ZS.pixel_list)
			if(icon_x==P.x && icon_y==P.y)
				selecting = ZS
				update_icon()
				break
		if(old_selecting != selecting)	break

	return 1


/obj/screen/zone_sel			//Список зон. Это реализовано в виде обьектов для гибкого взаимодействия с пикселями иконок
	icon = 'icons/mob/zone_sel.dmi'
	var/list/datum/pixel/pixel_list = list()


	eyes				//I think when upper then more high the priority
		name = "eyes"
	ears
		name = "ears"
	mouth
		name = "mouth"
	wings
		name = "wings"
	horn
		name = "horn"
	chest
		name = "chest"
	groin
		name = "groin"
	r_hand
		name = "r_hand"
	l_hand
		name = "l_hand"
	r_arm
		name = "r_arm"
	l_arm
		name = "l_arm"
	r_foot
		name = "r_foot"
	l_foot
		name = "l_foot"
	r_leg
		name = "r_leg"
	l_leg
		name = "l_leg"
	tail
		name = "tail"
	head
		name = "head"
	neck
		name = "neck"

	New()
		..()
		icon_state = "[name]"





/obj/screen/Click(location, control, params)
	if(!usr)	return 1


	switch(name)
		if("toggle", "toggle_inv")
			if(usr.hud_used.inventory_shown)
				usr.hud_used.inventory_shown = 0
				usr.client.screen -= usr.hud_used.other
			else
				usr.hud_used.inventory_shown = 1
				usr.client.screen += usr.hud_used.other

			usr.hud_used.hidden_inventory_update()

		if("equip")
			if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
				return 1
			if(ispony(usr))
				var/mob/living/carbon/pony/H = usr
				H.quick_equip()

		if("resist")
			if(isliving(usr))
				var/mob/living/L = usr
				L.resist()

		if("mov_intent")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(C.legcuffed)
					C << "<span class='notice'>You are legcuffed! You cannot run until you get [C.legcuffed] removed!</span>"
					C.m_intent = "walk"	//Just incase
					C.hud_used.move_intent.icon_state = "walking"
					return 1
				switch(usr.m_intent)
					if("fly")
						usr.m_intent = "walk"
						usr.hud_used.move_intent.icon_state = "walking"
					if("run")
						if(C.species.flags & HAS_WINGS)
							usr.m_intent = "fly"
							usr.hud_used.move_intent.icon_state = "flying"
						else
							usr.m_intent = "walk"
							usr.hud_used.move_intent.icon_state = "walking"
					if("walk")
						usr.m_intent = "run"
						usr.hud_used.move_intent.icon_state = "running"
		if("m_intent")
			if(!usr.m_int)
				switch(usr.m_intent)
					if("run")	usr.m_int = "13,14"
					if("walk")	usr.m_int = "14,14"
					if("face")	usr.m_int = "15,14"
					if("fly")	usr.m_int = "16,14"
			else	usr.m_int = null
		if("face")
			usr.m_intent = "face"
			usr.m_int = "15,14"
		if("walk")
			usr.m_intent = "walk"
			usr.m_int = "14,14"
		if("run")
			usr.m_intent = "run"
			usr.m_int = "13,14"
		if("fly")
			usr.m_intent = "fly"
			usr.m_int = "16,14"
		if("Reset Machine")	usr.unset_machine()
		if("internal")
			if(iscarbon(usr))
				var/mob/living/carbon/C = usr
				if(!C.stat && !C.stunned && !C.paralysis && !C.restrained())
					if(C.internal)
						C.internal = null
						C << "<span class='notice'>No longer running on internals.</span>"
						if(C.internals)		C.internals.icon_state = "internal0"
					else
						var/no_mask
						if(!(C.wear_mask && C.wear_mask.flags & AIRTIGHT))
							var/mob/living/carbon/pony/H = C
							if(!(H.head && H.head.flags & AIRTIGHT))	no_mask = 1

						if(no_mask)
							C << "<span class='notice'>You are not wearing a suitable mask or helmet.</span>"
							return 1
						else
							var/list/nicename = null
							var/list/tankcheck = C.list_items_in_hands()
							var/breathes = "oxygen"    //default, we'll check later
							var/list/contents = list()
							var/from = "on"


							if(ispony(C))
								var/mob/living/carbon/pony/H = C
								breathes = H.species.breath_type
								nicename = list ("suit", "back", "belt", "right hand", "left hand", "left pocket", "right pocket")
								tankcheck += list (H.s_store, C.back, H.belt, H.l_store, H.r_store)
							else
								nicename = list("right hand", "left hand", "back")
								tankcheck += C.back

							// Rigs are a fucking pain since they keep an air tank in nullspace.
							if(istype(C.back,/obj/item/weapon/rig))
								var/obj/item/weapon/rig/rig = C.back
								if(rig.air_supply)
									from = "in"
									nicename |= "hardsuit"
									tankcheck |= rig.air_supply

							for(var/i=1, i<tankcheck.len+1, ++i)
								if(istype(tankcheck[i], /obj/item/weapon/tank))
									var/obj/item/weapon/tank/t = tankcheck[i]
									if (!isnull(t.manipulated_by) && t.manipulated_by != C.real_name && findtext(t.desc,breathes))
										contents.Add(t.air_contents.total_moles)	//Someone messed with the tank and put unknown gasses
										continue					//in it, so we're going to believe the tank is what it says it is
									switch(breathes)
																		//These tanks we're sure of their contents
										if("nitrogen") 							//So we're a bit more picky about them.

											if(t.air_contents.gas["nitrogen"] && !t.air_contents.gas["oxygen"])
												contents.Add(t.air_contents.gas["nitrogen"])
											else
												contents.Add(0)

										if ("oxygen")
											if(t.air_contents.gas["oxygen"] && !t.air_contents.gas["phoron"])
												contents.Add(t.air_contents.gas["oxygen"])
											else
												contents.Add(0)

										// No races breath this, but never know about downstream servers.
										if ("carbon dioxide")
											if(t.air_contents.gas["carbon_dioxide"] && !t.air_contents.gas["phoron"])
												contents.Add(t.air_contents.gas["carbon_dioxide"])
											else
												contents.Add(0)


								else
									//no tank so we set contents to 0
									contents.Add(0)

							//Alright now we know the contents of the tanks so we have to pick the best one.

							var/best = 0
							var/bestcontents = 0
							for(var/i=1, i <  contents.len + 1 , ++i)
								if(!contents[i])
									continue
								if(contents[i] > bestcontents)
									best = i
									bestcontents = contents[i]


							//We've determined the best container now we set it as our internals

							if(best)
								C << "<span class='notice'>You are now running on internals from [tankcheck[best]] [from] your [nicename[best]].</span>"
								C.internal = tankcheck[best]


							if(C.internal)
								if(C.internals)
									C.internals.icon_state = "internal1"
							else
								C << "<span class='notice'>You don't have a[breathes=="oxygen" ? "n oxygen" : addtext(" ",breathes)] tank.</span>"
		if("act_intent")
			usr.a_intent_change("right")
		if("help")
			usr.a_intent = "help"
			usr.hud_used.action_intent.icon_state = "intent_help"
		if("harm")
			usr.a_intent = "hurt"
			usr.hud_used.action_intent.icon_state = "intent_hurt"
		if("grab")
			usr.a_intent = "grab"
			usr.hud_used.action_intent.icon_state = "intent_grab"
		if("disarm")
			usr.a_intent = "disarm"
			usr.hud_used.action_intent.icon_state = "intent_disarm"

		if("pull")
			usr.stop_pulling()
		if("throw")
			if(!usr.stat && isturf(usr.loc) && !usr.restrained())
				usr:toggle_throw_mode()
		if("drop")
			usr.drop_item_v()

		if("module")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
//				if(R.module)
//					R.hud_used.toggle_show_robot_modules()
//					return 1
				R.pick_module()

		if("inventory")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
					R.hud_used.toggle_show_robot_modules()
					return 1
				else
					R << "You haven't selected a module yet."

		if("radio")
			if(issilicon(usr))
				usr:radio_menu()
		if("panel")
			if(issilicon(usr))
				usr:installed_modules()

		if("store")
			if(isrobot(usr))
				var/mob/living/silicon/robot/R = usr
				if(R.module)
					R.uneq_active()
					R.hud_used.update_robot_modules_display()
				else
					R << "You haven't selected a module yet."

		if("module1")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(1)

		if("module2")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(2)

		if("module3")
			if(istype(usr, /mob/living/silicon/robot))
				usr:toggle_module(3)

		if("Allow Walking")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetMove()
			gun_click_time = world.time

		if("Disallow Walking")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetMove()
			gun_click_time = world.time

		if("Allow Running")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetRun()
			gun_click_time = world.time

		if("Disallow Running")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetRun()
			gun_click_time = world.time

		if("Allow Item Use")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetClick()
			gun_click_time = world.time


		if("Disallow Item Use")
			if(gun_click_time > world.time - 30)	//give them 3 seconds between mode changes.
				return
			if(!istype(usr.equipped(),/obj/item/weapon/gun))
				usr << "You need your gun in your active hand to do that!"
				return
			usr.client.AllowTargetClick()
			gun_click_time = world.time

		if("Toggle Gun Mode")
			usr.client.ToggleGunMode()

		else
			return 0
	return 1


/obj/screen/inventory
	var/slot_id	//The indentifier for the slot. It has nothing to do with ID cards

	hand
		var/obj/screen/alternative
		var/datum/hand/parent
		layer = 19
		icon = 'icons/mob/screen1_White.dmi'



/obj/screen/inventory/Click()
	// At this point in client Click() code we have passed the 1/10 sec check and little else
	// We don't even know if it's a middle click
	if(world.time <= usr.next_move)
		return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return 1
	if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return 1
	if(istype(src,/obj/screen/inventory/hand))
		usr.swap_hand(src)
		usr.next_move = world.time+2
		return 1

	switch(name)
		if("swap")
			usr:swap_hand()
		else
			if(usr.attack_ui(slot_id))
				usr.update_inv_hands(0)
				usr.next_move = world.time+6
	return 1
