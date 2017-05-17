/datum/hud/proc/make_hud(var/ui_style='icons/mob/screen1_White.dmi', var/ui_color = "#ffffff", var/ui_alpha = 255, var/mob/target=mymob)

	var/hud_type
	if(!target:species)			 // Тип интерфейса уже прописан в списке рас
		if(ismonkey(mymob))			hud_type = /datum/hud_data/animal//Остальное должно прописываться в соседнем файле
		else if(isbrain(mymob))		hud_type = /datum/hud_data/brain
		else if(isalien(mymob))		hud_type = /datum/hud_data/larva
		else if(isslime(mymob))		hud_type = /datum/hud_data/slime
		else if(isrobot(mymob))		hud_type = /datum/hud_data/robot
		else						return//Существа вроде призрака, ИИ и остальных внутриигрового интерфейса не имеют



	var/datum/hud_data/hud_data

	if(hud_type)	hud_data = new hud_type(mymob)
	else
		if(!istype(mymob))	hud_data = new(mymob)
		else				hud_data = target:species.hud

	if(hud_data.icon)	ui_style = hud_data.icon

	var/list/hud_elements = list()//Эти элементы видимы вне зависимости от желания игрока(Слепота и т.д.)
	src.hotkeybuttons = list()
	var/obj/screen/using


	//Создаем ХУД слоты, которые всегда добавляются в интерфейс
	var/has_hidden_gear
	var/list/combine_list = hud_data.adding_gear+hud_data.adding_intent
	for(var/gear_slot in combine_list)
		var/list/slot_data =  combine_list[gear_slot]

		if(gear_slot in hud_data.adding_gear)	using = new /obj/screen/inventory()
		else									using = new /obj/screen()


		if(!slot_data["noname"])	using.name = gear_slot
		if(slot_data["loc"])		using.screen_loc =  slot_data["loc"]
		if(slot_data["slot"])		using:slot_id = slot_data["slot"]

		if(slot_data["layer"])		using.layer = slot_data["layer"]
		else						using.layer = 19

		if(!slot_data["noicon"])	using.icon = ui_style
		using.alpha = ui_alpha
		using.color = ui_color

		if(slot_data["state"])	using.icon_state =  slot_data["state"]
		if(slot_data["dir"])  	using.set_dir(slot_data["dir"])

		switch(gear_slot)


			if("mov_intent")
				using.icon_state = (mymob.m_intent == "run" ? "running" : "walking")
				move_intent = using
				using.layer = 20

			if("resist")	src.hotkeybuttons += using
			if("drop")		src.hotkeybuttons += using
			if("module1")	mymob:inv1 = using
			if("module2")	mymob:inv2 = using
			if("module3")	mymob:inv3 = using

			if("act_intent")//Иконка режимов атаки
				using.layer = 20
				using.icon_state = "intent_"+mymob.a_intent
				action_intent = using
				hud_elements |= using

				var/list/obj/screen/small_sort_list = list()//Маленькие подиконки режимов
				if(ui_style != 'icons/mob/screen1.dmi')
					using = new /obj/screen( src );	using.name = "help";	help_intent = using;	small_sort_list += using
					using = new /obj/screen( src );	using.name = "disarm";	disarm_intent = using;	small_sort_list += using
					using = new /obj/screen( src );	using.name = "grab";	grab_intent = using;	small_sort_list += using
					using = new /obj/screen( src );	using.name = "harm";	hurt_intent = using;	small_sort_list += using

				for(var/obj/screen/gui in small_sort_list)
					gui.layer = 21
					gui.screen_loc = ui_acti
					var/icon/ico = new(ui_style, "black")
					ico.MapColors(0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0, -1,-1,-1,-1)
					switch(gui.name)
						if("help")		ico.DrawBox(rgb(255,255,255,1), 1,				1+ico.Height()/2, 	ico.Width()/2,	ico.Height())
						if("disarm")	ico.DrawBox(rgb(255,255,255,1), 1+ico.Width()/2,1+ico.Height()/2, 	ico.Width(),	ico.Height())
						if("grab")		ico.DrawBox(rgb(255,255,255,1), 1+ico.Width()/2,1, 					ico.Width(),	ico.Height()/2)
						if("harm")		ico.DrawBox(rgb(255,255,255,1), 1,				1, 					ico.Width()/2,	ico.Height()/2)

					gui.icon = ico
					src.adding += gui

		if(slot_data["hotkey"])		src.hotkeybuttons += using
		if(slot_data["toggle"])
			src.other  += using
			has_hidden_gear = 1
		else
			src.adding += using






	//Создаем ХУД слоты, видимость которых контролируется игрой
	combine_list = hud_data.hud_add+hud_data.hud_splash_add
	for(var/hud_slot in combine_list)
		var/list/slot_data = combine_list[hud_slot]

		switch(hud_slot)
			if("damage zone")	using = new /obj/screen/zone()
			if("emoji")			using = new /obj/screen/emoji()
			else				using = new /obj/screen()


		if(!slot_data["noname"])	using.name = hud_slot
		if(slot_data["loc"])		using.screen_loc = slot_data["loc"]
		if(!slot_data["noicon"])	using.icon = ui_style
		if(slot_data["state"])		using.icon_state = slot_data["state"]
		if(slot_data["layer"])		using.layer = slot_data["layer"]


		switch(hud_slot)
			if("throw", "store")
				using.color = ui_color
				using.alpha = ui_alpha
				mymob.throw_icon = using
				src.hotkeybuttons += mymob.throw_icon
			if("pull")
				mymob.pullin = using
				src.hotkeybuttons += mymob.pullin
			if("internal")			mymob.internals = using
			if("oxygen")			mymob.oxygen = using
			if("toxin")				mymob.toxin = using
			if("fire")				mymob.fire = using
			if("health")			mymob.healths = using
			if("pressure")			mymob.pressure = using
			if("body temperature")	mymob.bodytemp = using
			if("nutrition")			mymob.nutrition_icon = using
			if("flash")
				using.layer = 17
				mymob.flash = using
			if("blind")
				using.icon = 'icons/mob/screen1_full.dmi'
				using.name = " "
				using.mouse_opacity = 0
				using.invisibility = 101
				mymob.blind = using
			if("dmg")
				using.mouse_opacity = 0
				using.layer = 18.1
				using.icon = 'icons/mob/screen1_full.dmi'
				mymob.damageoverlay = using
			if("damage zone")
				using.name = "damage zone: [using:selecting.name]"
				using.color = ui_color
				using.alpha = ui_alpha
				mymob.zone_sel = using
				hud_elements |= using:connect_list


			if("cell")			mymob:cell = using		//Для роботов
			if("hands")			mymob:module = using

		hud_elements |= using



	for(var/datum/hand/H in mymob.list_hands)
		var/obj/screen/inventory/hand/hand_slot = H.slot
		switch(H.name)
			if("mouth")	for(var/obj/screen/alternative in src.adding+src.other)
				if(alternative.name=="mask")
					hand_slot.alternative = alternative
					break
		hand_slot.icon = ui_style
		hand_slot.alpha = ui_alpha
		hand_slot.color = ui_color
		src.adding += H.slot

	if(has_hidden_gear)
		using = new /obj/screen()
		using.name = "toggle"
		using.icon = ui_style
		using.alpha = ui_alpha
		using.color = ui_color
		using.icon_state = "other"
		using.screen_loc = ui_inventory
		using.layer = 20
		src.adding += using
		for(var/ix=-3, ix<=2, ix++) for(var/iy=1, iy>=-4, iy--)
			var/obj/screen/inventory/inv_box = new /obj/screen/inventory()
			inv_box.icon = ui_style
			inv_box.icon_state = "back_inventory-edge"

			switch(ix)
				if(-3)	switch(iy)
					if(1)		inv_box.set_dir(NORTHWEST)
					if(-4)		inv_box.set_dir(SOUTHWEST)
					else		inv_box.set_dir(WEST)

				if(2)	switch(iy)
					if(1)
						var/obj/screen/cross = new/obj/screen/toggle_inv()
						cross.screen_loc = "CENTER+[ix], CENTER+[iy]"
						src.other += cross
						inv_box.set_dir(NORTHEAST)
					if(-4)		inv_box.set_dir(SOUTHEAST)
					else		inv_box.set_dir(EAST)
				else	switch(iy)
					if(1)		inv_box.set_dir(NORTH)
					if(-4)		inv_box.set_dir(SOUTH)
					else		inv_box.icon_state = "back_inventory"

			inv_box.screen_loc = "CENTER+[ix], CENTER+[iy]"
			inv_box.layer = 18
			src.other += inv_box


	mymob.pain = new /obj/screen( null )

	//Handle the gun settings buttons
	mymob.gun_setting_icon = new /obj/screen/gun/mode(null)
	mymob.gun_setting_icon.alpha = ui_alpha
	hud_elements |= mymob.gun_setting_icon

	mymob.item_use_icon = new /obj/screen/gun/item(null);	mymob.item_use_icon.alpha = ui_alpha
	mymob.gun_move_icon = new /obj/screen/gun/move(null);	mymob.gun_move_icon.alpha = ui_alpha
	mymob.gun_run_icon = new /obj/screen/gun/run(null);		mymob.gun_run_icon.alpha = ui_alpha

	if(mymob.client)	if(mymob.client.gun_mode) // If in aim mode, correct the sprite
		mymob.gun_setting_icon.set_dir(2)

	/*	//Handle the gun settings buttons

	for(var/obj/item/weapon/gun/G in mymob) // If targeting someone, display other buttons
		if (G.aim_targets)
			mymob.item_use_icon = new /obj/screen/gun/item(null)
			if (mymob.client.target_can_click)
				mymob.item_use_icon.set_dir(1)
			src.adding += mymob.item_use_icon
			mymob.gun_move_icon = new /obj/screen/gun/move(null)
			if (mymob.client.target_can_move)
				mymob.gun_move_icon.set_dir(1)
				mymob.gun_run_icon = new /obj/screen/gun/run(null)
				if (mymob.client.target_can_run)
					mymob.gun_run_icon.set_dir(1)
				src.adding += mymob.gun_run_icon
			src.adding += mymob.gun_move_icon*/


	mymob.client.screen = null

	mymob.client.screen += hud_elements
	mymob.client.screen += src.adding + src.hotkeybuttons
	inventory_shown = 0;

	return


/mob/living/carbon/pony/verb/toggle_hotkey_verbs()
	set category = "OOC"
	set name = "Toggle hotkey buttons"
	set desc = "This disables or enables the user interface buttons which can be used with hotkeys."

	if(hud_used.hotkey_ui_hidden)
		client.screen += hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 0
	else
		client.screen -= hud_used.hotkeybuttons
		hud_used.hotkey_ui_hidden = 1


/mob/living/carbon/pony/update_action_buttons()
	var/num = 1
	if(!hud_used) return
	if(!client) return

	if(!hud_used.hud_shown)	//Hud toggled to minimal
		return

	client.screen -= hud_used.item_action_list

	hud_used.item_action_list = list()
	for(var/obj/item/I in src)
		if(I.icon_action_button)
			var/obj/screen/item_action/A = new(hud_used)

			//A.icon = 'icons/mob/screen1_action.dmi'
			//A.icon_state = I.icon_action_button
			A.icon = ui_style2icon(client.prefs.UI_style)
			A.icon_state = "template"
			var/image/img = image(I.icon, A, I.icon_state)
			img.pixel_x = 0
			img.pixel_y = 0
			A.overlays += img

			if(I.action_button_name)	A.name = I.action_button_name
			else						A.name = "Use [I.name]"

			A.owner = I
			hud_used.item_action_list += A
			switch(num)
				if(1)	A.screen_loc = ui_action_slot1
				if(2)	A.screen_loc = ui_action_slot2
				if(3)	A.screen_loc = ui_action_slot3
				if(4)	A.screen_loc = ui_action_slot4
				if(5)
					A.screen_loc = ui_action_slot5
					break //5 slots available, so no more can be added.
			num++
	src.client.screen += src.hud_used.item_action_list

//Used for new pony mobs created by cloning/goleming/etc.
/mob/living/carbon/pony/proc/set_cloned_appearance()
	f_style = "Shaved"
	//if(dna.species == "Earthpony") //no more xenos losing ears/tentacles
	h_style = pick("Short Hair")
	cutie_mark = "Blank"
	pony_tail_style = "Short Tail"
	regenerate_icons()
