var/global/list/gear_datums = list()
var/global/list/uspell_datums = list()


/obj/item/weapon/light_spark
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "light"
	alpha = 200

/*
Общая система заклинаний:
  Куллдаун после деактивации
  Трата сытности на попытку активации заклинания и его поддержание
  Шанс успеха исходя из сложности и концентрации
  Долгосрочные заклинания имеют максимум времени действия
  Одновременно может действовать только одно долгосрочное заклинание
*/


/mob/living/carbon/pony/var/tmp/switch_ulight = 0
/mob/living/carbon/pony/var/tmp/record_loc
/mob/living/carbon/pony/verb
	strong_light()
		set category = "Unicorn Spells"
		set name = "Strong light"
		set desc = "Strong light about you."
		if(switch_ulight == 0)
			SetLuminosity(luminosity+3)
			switch_ulight = 1
			spawn(150)
				if(switch_ulight == 1)
					SetLuminosity(luminosity-3)
					switch_ulight = 0
					update_tail_showing()
		else
			SetLuminosity(luminosity-3)
			switch_ulight = 0
		update_tail_showing()

	light()
		set category = "Unicorn Spells"
		set name = "Light"
		set desc = "Light about you."
		if(switch_ulight == 0)
			SetLuminosity(luminosity+1)
			switch_ulight = 1
			spawn(400)
				if(switch_ulight == 1)
					SetLuminosity(luminosity-1)
					switch_ulight = 0
					update_tail_showing()
		else
			SetLuminosity(luminosity-1)
			switch_ulight = 0
		update_tail_showing()

	clean()
		set name = "Cleaner"
		set desc = "Cleaning you."
		set category = "Unicorn Spells"
		var/obj/item/weapon/reagent_containers/spray/cleaner/H = new/obj/item/weapon/reagent_containers/spray/cleaner
		H.Spray_at(usr, usr, 1)
		del H

	health_scan(var/mob/living/carbon/M in view(1))
		set name = "Health scan"
		set desc = "Analogy of using health analyzer."
		set category = "Unicorn Spells"
		if(M != usr)
			var/obj/item/device/healthanalyzer/H = new/obj/item/device/healthanalyzer
			H.attack(M, usr)
			del H

	cyber_scan(var/mob/living/carbon/M in view(1))
		set name = "Cyber scan"
		set desc = "Analogy of using cyber analyzer."
		set category = "Unicorn Spells"
		if(M != usr)
			var/obj/item/device/robotanalyzer/H = new/obj/item/device/robotanalyzer
			H.attack(M, usr)
			del H

	tele_glass()
		set name = "Telekinetic glass"
		set desc = "Liquid telekinesis."
		set category = "Unicorn"
		var/obj/item/weapon/reagent_containers/glass/G = new/obj/item/weapon/reagent_containers/glass
		var/icon/I = G.icon
		I.Blend(rgb(r_aura, g_aura, b_aura), ICON_ADD)
		G.icon = I
		G.alpha = 100
		G.Move(locate(x, y, z))
		UnarmedAttack(G)
		spawn(500)
			var/obj/O = locate(G)
			G.afterattack(G, usr, 1)
			spawn(6)	del G

	dist_light()
		set name = "Distance light"
		set desc = "Beam of light."
		set category = "Unicorn"
		var/obj/item/weapon/light_spark/L = new/obj/item/weapon/light_spark
		var/icon/I = L.icon
		I.Blend(rgb(r_aura, g_aura, b_aura))
		L.icon = I
		L.Move(locate(x, y, z))


	hair_transform(var/mob/living/carbon/pony/P in view(1))
		set name = "Morph"
		set desc = "Transform you hair's."
		set category = "Unicorn"
		var/list/valid_hair = list()
		var/list/valid_facial = list()
		var/list/valid_tail = list()
		for(var/path in typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair)
			var/datum/sprite_accessory/hair/H = new path()
			if(gender == MALE && H.gender == FEMALE)	continue
			if(gender == FEMALE && H.gender == MALE)	continue
			if(!(species.name in H.species_allowed))	continue
			valid_hair += H.name
		for(var/path in typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/facial_hair)
			var/datum/sprite_accessory/facial_hair/H = new path()
			if(gender == MALE && H.gender == FEMALE)	continue
			if(gender == FEMALE && H.gender == MALE)	continue
			if(!(species.name in H.species_allowed))	continue
			valid_hair += H.name
		for(var/path in typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair)
			var/datum/sprite_accessory/ptail/H = new path()
			if(gender == MALE && H.gender == FEMALE)	continue
			if(gender == FEMALE && H.gender == MALE)	continue
			if(!(species.name in H.species_allowed))	continue
			valid_hair += H.name

		f_style = pick(valid_facial)
		h_style = pick(valid_hair)
		ptail_style = pick(valid_tail)
		regenerate_icons()


	hot()
		set name = "Heat"
		set desc = "Heating food, ponies and you."
		set category = "Unicorn"
		var/list/Li = list()
		for(var/atom/A in view(1))
			if(istype(A, /obj/item/weapon/reagent_containers/food) || istype(A, /mob/living/carbon/pony))
				Li += A
		if(Li.len == 0)	return
		var/target = input(usr, "Choose your target", "Target")  as null|anything in Li
		if(target in view(1))
			if(istype(target, /obj/item/weapon/reagent_containers/food))	target:heat_food(target:heating+1)
			else	target:bodytemperature += 5


	concentration()
		set name = "High concentration"
		set desc = "Very high concentration for strong telekinesis."
		set category = "Unicorn"

	fruit_transform(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in view(1))
		set name = "Organic transformation"
		set desc = "Banana to potato, yeah."
		set category = "Unicorn"
		G = new(G.loc, pick("chili", "potato", "tomato", "apple", "banana", "mushrooms", "plumphelmet", "towercap", "harebells", "poppies", "sunflowers", "grapes", "peanut", "cabbage", "corn", "carrot", "whitebeet", "watermelon", "pumpkin", "lime", "lemon", "orange", "ambrosia"))

	cold(var/mob/living/carbon/pony/P in view(1))
		set name = "Cooling"
		set desc = "Cooling ponies for... what?."
		set category = "Unicorn"
		P.bodytemperature -= 10

	blood_dam(var/mob/living/carbon/pony/P in view(1))
		set name = "Heel bleeding"
		set desc = "Analogy of bandages."
		set category = "Unicorn"
		var/obj/item/stack/medical/bruise_pack/B = new/obj/item/stack/medical/bruise_pack
		B.attack(P, usr)
		del B

	notpain(var/mob/living/carbon/pony/P in view(1))
		set name = "Pain relief"
		set desc = "Analogy of tramadol power's."
		set category = "Unicorn"
		P.reagents.add_reagent("tramadol", 3)
		P.reagents.add_reagent("adrenalin", 1)

	light_heel(var/mob/living/carbon/P in view(1))//Можно добавить настройку для аликорнов
		set name = "Light heel"
		set desc = "Little heel ponies."
		set category = "Unicorn"
		P.apply_damages(-5, -5)

	organ_scan(var/mob/living/carbon/pony/P in view(1))
		set name = "Organ analyze"
		set desc = "Analogy of using organ analyzer."
		set category = "Unicorn"



	crowbar()
		set name = "Telekinetic crowbar"
		set desc = "Use telekinesis as crowbar."
		set category = "Unicorn"
		if(!l_hand || !r_hand)
			var/obj/item/weapon/crowbar/C = new/obj/item/weapon/crowbar
			C.Move(locate(usr))
			C.attack_hand(usr)
			spawn(2000)	del C


	screwdriver()
		set name = "Telekinetic screwdriver"
		set desc = "Use telekinesis as screwdriver."
		set category = "Unicorn"
		if(!l_hand || !r_hand)
			var/obj/item/weapon/screwdriver/C = new/obj/item/weapon/screwdriver
			C.Move(locate(usr))
			C.attack_hand(usr)
			spawn(2000)	del C

	cut()
		set name = "Telekinetic cut"
		set desc = "Use telekinesis as cut."
		set category = "Unicorn"
		if(!l_hand || !r_hand)
			var/obj/item/weapon/wirecutters/C = new/obj/item/weapon/wirecutters
			C.Move(locate(usr))
			C.attack_hand(usr)
			spawn(2000)	del C

	brush()
		set name = "Telekinetic brush"
		set desc = "Analogy of archeology brush."
		set category = "Unicorn"
		if(!l_hand || !r_hand)
			var/obj/item/weapon/pickaxe/brush/C = new/obj/item/weapon/pickaxe/brush
			C.Move(locate(usr))
			C.attack_hand(usr)
			spawn(2000)	del C

	teleport()
		set name = "Teleport"
		set desc = "Teleportation to old record."
		set category = "Unicorn"
		var/list/Li = list("Record", "Teleport")
		var/target = input(usr, "Choose mod your teleportation", "Mod")  as null|anything in Li
		if(target == "Record")	record_loc = loc
		else if(record_loc)	Move(locate(record_loc))
		else usr << "Nope." //Тут функция отказа

	mag_boots()
		set name = "Telekinetic Anchoring"
		set desc = "Analogy of mag boots."
		set category = "Unicorn"

	cell_power()
		set name = "Charge of power"
		set desc = "Charging APC, robot's etc."
		set category = "Unicorn"
		var/list/Li = list()
		for(var/atom/A in view(2))
			if(istype(A, /obj/machinery/power/apc) || istype(A, /obj/item/weapon/cell) || ismob(A))
				if(istype(A, /obj/item/weapon/cell)) Li += A
				else for(var/obj/item/weapon/cell/C in A.contents) Li += C
		if(Li.len == 0)	return
		var/target = input(usr, "Choose your target", "Target")  as null|anything in Li
		//target.charge += min(500, target)

	welding()
		set name = "Welding heating"
		set desc = "Analogy of welding tool by manipulationg with aura."
		set category = "Unicorn"

	hoofcufs()
		set name = "Telekinetic hoofcufs"
		set desc = "Analogy of hoofcufs."
		set category = "Unicorn"

	disarm(var/mob/living/carbon/pony/P in view(1))
		set name = "Flash disarm"
		set desc = "Fast disarm."
		set category = "Unicorn"

	light_grenade()
		set name = "Flash"
		set desc = "Ligh grenade."
		set category = "Unicorn"

	glue(var/mob/living/carbon/P in view(4))
		set name = "Live telekinesis"
		set desc = "Slowdown ponies."
		set category = "Unicorn"

	party_shield()
		set name = "Body shield"
		set desc = "Strong armor about you body."
		set category = "Unicorn"

	hoof_shield()
		set name = "Shield"
		set desc = "Analogy of SWAT shield."
		set category = "Unicorn"

/mob/living/carbon/pony/proc/update_unicorn_verbs()
	for(var/type in typesof(/datum/spells)-/datum/spells)
		var/datum/spells/S = new type()
		if(verbs.Find(S.spell_verb) && !unicorn_spells.Find(S.spell_name))
			if(S.allowed_roles && S.allowed_roles.len > 0)
				if(!S.allowed_roles.Find(job))
					verbs -= S.spell_verb
			else
				verbs -= S.spell_verb
		else if(!verbs.Find(S.spell_verb) && unicorn_spells.Find(S.spell_name))
			if(S.allowed_roles && S.allowed_roles.len > 0)
				if(S.allowed_roles.Find(job))	verbs += S.spell_verb
			else	verbs += S.spell_verb


/hook/startup/proc/populate_gear_list()
	var/list/sort_categories = list(
		"[slot_head]"		= list(),
		"ears"				= list(),
		"[slot_glasses]" 	= list(),
		"[slot_wear_mask]"	= list(),
		"[slot_w_uniform]"	= list(),
		"[slot_tie]"		= list(),
		"[slot_wear_suit]"	= list(),
		"[slot_gloves]"		= list(),
		"[slot_shoes]"		= list(),
		"utility"			= list(),
		"misc"				= list(),
		"unknown"			= list(),
	)

	//create a list of gear datums to sort
	for(var/type in typesof(/datum/gear)-/datum/gear)
		var/datum/gear/G = new type()

		var/category = (G.sort_category in sort_categories)? G.sort_category : "unknown"
		sort_categories[category][G.display_name] = G

	for (var/category in sort_categories)
		gear_datums.Add(sortAssoc(sort_categories[category]))

	return 1


/hook/startup/proc/populate_spells_list()

	//create a list of gear datums to sort
	for(var/type in typesof(/datum/spells)-/datum/spells)
		var/datum/spells/S = new type()
		uspell_datums[S.spell_name] = S
	return 1

/datum/gear
	var/display_name       //Name/index. Must be unique.
	var/path               //Path to item.
	var/cost               //Number of points used. Items in general cost 1 point, storage/armor/gloves/special use costs 2 points.
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.
	var/whitelisted        //Term to check the whitelist for..
	var/sort_category

/datum/spells
	var/spell_name
	var/verb/spell_verb
	var/cost
	var/list/allowed_roles
	var/color


/datum/gear/New()
	..()
	if (!sort_category)
		sort_category = "[slot]"

// This is sorted both by slot and alphabetically! Don't fuck it up!
// Headslot items




/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/spells/light
	spell_name = "Light"
	spell_verb = /mob/living/carbon/pony/verb/light
	cost = 0

/datum/spells/strong_light
	spell_name = "Strong Light"
	cost = 1
	spell_verb = /mob/living/carbon/pony/verb/strong_light

/datum/spells/tele_glass
	spell_name = "Tele Glass"
	spell_verb = /mob/living/carbon/pony/verb/tele_glass
	cost = 1

/datum/spells/dist_light
	spell_name = "Distance Light"
	spell_verb = /mob/living/carbon/pony/verb/dist_light
	cost = 1

/datum/spells/morph
	spell_name = "Morph"
	spell_verb = /mob/living/carbon/pony/verb/hair_transform
	cost = 1

/datum/spells/clean
	spell_name = "Cleaner"
	spell_verb = /mob/living/carbon/pony/verb/clean
	cost = 2

/datum/spells/hot
	spell_name = "Hot Aura"
	spell_verb = /mob/living/carbon/pony/verb/hot
	cost = 2

/datum/spells/concentration
	spell_name = "High Tele-Concentration "
	spell_verb = /mob/living/carbon/pony/verb/concentration
	cost = 3

/datum/spells/fruit_transform
	spell_name = "Fruit Transformation"
	spell_verb = /mob/living/carbon/pony/verb/fruit_transform
	cost = 3
//////////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/spells/health_scan
	spell_name = "Health Scan"
	spell_verb = /mob/living/carbon/pony/verb/health_scan
	cost = 1
	color = "\blue\[MED]"
	allowed_roles = list("Chemist","Virologist","Chief Medical Officer", "Medical Doctor", "Geneticist", "Paramedic", "Xenobiologist")

/datum/spells/cold
	spell_name = "Cold Aura"
	spell_verb = /mob/living/carbon/pony/verb/cold
	cost = 1
	color = "\blue\[MED]"
	allowed_roles = list("Chemist","Virologist","Chief Medical Officer", "Medical Doctor", "Geneticist", "Paramedic", "Xenobiologist")

/datum/spells/blood_dam
	spell_name = "Blood Stop"
	spell_verb = /mob/living/carbon/pony/verb/blood_dam
	cost = 2
	color = "\blue\[MED]"
	allowed_roles = list("Chemist","Virologist","Chief Medical Officer", "Medical Doctor", "Geneticist", "Paramedic", "Xenobiologist")

/datum/spells/notpain
	spell_name = "Neurotroph"
	spell_verb = /mob/living/carbon/pony/verb/notpain
	cost = 2
	color = "\blue\[MED]"
	allowed_roles = list("Chemist","Virologist","Chief Medical Officer", "Medical Doctor", "Geneticist", "Paramedic", "Xenobiologist")

/datum/spells/light_heel
	spell_name = "Light Heel"
	spell_verb = /mob/living/carbon/pony/verb/light_heel
	cost = 3
	color = "\blue\[MED]"
	allowed_roles = list("Chemist","Virologist","Chief Medical Officer", "Medical Doctor", "Geneticist", "Paramedic", "Xenobiologist")

/datum/spells/organ_scan
	spell_name = "Organ Scanner"
	spell_verb = /mob/living/carbon/pony/verb/organ_scan
	cost = 2
	color = "\blue\[Head-MED]"
	allowed_roles = list("Chief Medical Officer")
/////////////////////////////////////////////////////////////////////////////////////////////////////
/datum/spells/crowbar
	spell_name = "Tele Crowbar"
	spell_verb = /mob/living/carbon/pony/verb/crowbar
	cost = 1
	color = "\yellow-phiolet\[SCI+ENG]"
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician", "Roboticist", "Scientist", "Research Director", "Xenobiologist")

/datum/spells/screwdriver
	spell_name = "Tele Screwdriver"
	spell_verb = /mob/living/carbon/pony/verb/screwdriver
	cost = 1
	color = "\yellow-phiolet\[SCI+ENG]"
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician", "Roboticist", "Scientist", "Research Director", "Xenobiologist")

/datum/spells/cut
	spell_name = "Tele Cut"
	spell_verb = /mob/living/carbon/pony/verb/cut
	cost = 1
	color = "\yellow-phiolet\[SCI+ENG]"
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician", "Roboticist", "Scientist", "Research Director", "Xenobiologist")

/datum/spells/cyber_scan
	spell_name = "Cyber Scanner"
	spell_verb = /mob/living/carbon/pony/verb/cyber_scan
	cost = 1
	color = "\[SCI]"
	allowed_roles = list("Roboticist", "Scientist", "Research Director", "Xenobiologist")

/datum/spells/brush
	spell_name = "Archeology Brush"
	spell_verb = /mob/living/carbon/pony/verb/brush
	cost = 2
	color = "\[SCI]"
	allowed_roles = list("Roboticist", "Scientist", "Research Director", "Xenobiologist", "Shaft Miner")

/datum/spells/teleport
	spell_name = "Teleport"
	spell_verb = /mob/living/carbon/pony/verb/teleport
	cost = 3
	color = "\[Head-SCI]"
	allowed_roles = list("Research Director")
	//////////////////////////////////////////////////////////////////////
/datum/spells/mag_boots
	spell_name = "Magnet Telekinesys"
	spell_verb = /mob/living/carbon/pony/verb/mag_boots
	cost = 2
	color = "\yellow\[ENG]"
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician")

/datum/spells/cell_power
	spell_name = "Charge of Power"
	spell_verb = /mob/living/carbon/pony/verb/cell_power
	cost = 3
	color = "\yellow\[ENG-SCI]"
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician", "Research Director", "Roboticist", "Scientist")

/datum/spells/welding
	spell_name = "Welding Aura"
	spell_verb = /mob/living/carbon/pony/verb/welding
	cost = 3
	color = "\yellow\[Head-ENG]"
	allowed_roles = list("Chief Engineer")
	////////////////////////////////////////////////////////////////////////
/datum/spells/hoofcufs
	spell_name = "Tele Hoofcufs"
	spell_verb = /mob/living/carbon/pony/verb/hoofcufs
	cost = 1
	color = "\red\[SEC]"
	allowed_roles = list("Security Officer","Warden","Detective", "Head of Security", "Head of Personnal", "Captain")

/datum/spells/light_grenade
	spell_name = "Light Grenade"
	spell_verb = /mob/living/carbon/pony/verb/light_grenade
	cost = 1
	color = "\red\[SEC]"
	allowed_roles = list("Security Officer","Warden","Detective", "Head of Security", "Head of Personnal", "Captain")

/datum/spells/disarm
	spell_name = "Flash Disarm"
	spell_verb = /mob/living/carbon/pony/verb/disarm
	cost = 2
	color = "\red\[SEC]"
	allowed_roles = list("Security Officer","Warden","Detective", "Head of Security", "Head of Personnal", "Captain")

/datum/spells/glue
	spell_name = "Live Telekinesis"
	spell_verb = /mob/living/carbon/pony/verb/glue
	cost = 2
	color = "\red\[SEC]"
	allowed_roles = list("Security Officer","Warden","Detective", "Head of Security", "Head of Personnal", "Captain")

/datum/spells/party_shield
	spell_name = "Party Shield"
	spell_verb = /mob/living/carbon/pony/verb/party_shield
	cost = 3
	color = "\red\[SEC]"
	allowed_roles = list("Security Officer","Warden","Detective", "Head of Security", "Head of Personnal", "Captain")

/datum/spells/hoof_shield
	spell_name = "Hoof Shield"
	spell_verb = /mob/living/carbon/pony/verb/hoof_shield
	cost = 3
	color = "\red\[head-SEC]"
	allowed_roles = list("Head of Security")


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/gear/gbandana
	display_name = "bandana, green"
	path = /obj/item/clothing/head/greenbandana
	cost = 1
	slot = slot_head

/datum/gear/obandana
	display_name = "bandana, orange"
	path = /obj/item/clothing/head/orangebandana
	cost = 1
	slot = slot_head

/datum/gear/bandana
	display_name = "bandana, pirate-red"
	path = /obj/item/clothing/head/bandana
	cost = 1
	slot = slot_head

/datum/gear/bsec_beret
	display_name = "beret, blue (security)"
	path = /obj/item/clothing/head/beret/sec/alt
	cost = 1
	slot = slot_head
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/eng_beret
	display_name = "beret, engie-orange"
	path = /obj/item/clothing/head/beret/eng
	cost = 1
	slot = slot_head
//	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer")

/datum/gear/purp_beret
	display_name = "beret, purple"
	path = /obj/item/clothing/head/beret/jan
	cost = 1
	slot = slot_head

/datum/gear/red_beret
	display_name = "beret, red"
	path = /obj/item/clothing/head/beret
	cost = 1
	slot = slot_head

/datum/gear/sec_beret
	display_name = "beret, red (security)"
	path = /obj/item/clothing/head/beret/sec
	cost = 1
	slot = slot_head
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/bcap
	display_name = "cap, blue"
	path = /obj/item/clothing/head/soft/blue
	cost = 1
	slot = slot_head

/datum/gear/mailman
	display_name = "cap, blue station"
	path = /obj/item/clothing/head/mailman
	cost = 1
	slot = slot_head

/datum/gear/flatcap
	display_name = "cap, brown-flat"
	path = /obj/item/clothing/head/flatcap
	cost = 1
	slot = slot_head

/datum/gear/corpcap
	display_name = "cap, corporate (Security)"
	path = /obj/item/clothing/head/soft/sec/corp
	cost = 1
	slot = slot_head
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/gcap
	display_name = "cap, green"
	path = /obj/item/clothing/head/soft/green
	cost = 1
	slot = slot_head

 /datum/gear/grcap
	display_name = "cap, grey"
	path = /obj/item/clothing/head/soft/grey
	cost = 1
	slot = slot_head

 /datum/gear/ocap
	display_name = "cap, orange"
	path = /obj/item/clothing/head/soft/orange
	cost = 1
	slot = slot_head

/datum/gear/purcap
	display_name = "cap, purple"
	path = /obj/item/clothing/head/soft/purple
	cost = 1
	slot = slot_head

/datum/gear/raincap
	display_name = "cap, rainbow"
	path = /obj/item/clothing/head/soft/rainbow
	cost = 1
	slot = slot_head

/datum/gear/rcap
	display_name = "cap, red"
	path = /obj/item/clothing/head/soft/red
	cost = 1
	slot = slot_head

/datum/gear/ycap
	display_name = "cap, yellow"
	path = /obj/item/clothing/head/soft/yellow
	cost = 1
	slot = slot_head

/datum/gear/wcap
	display_name = "cap, white"
	path = /obj/item/clothing/head/soft/mime
	cost = 1
	slot = slot_head

/datum/gear/hairflower
	display_name = "hair flower pin"
	path = /obj/item/clothing/head/hairflower
	cost = 1
	slot = slot_head

/datum/gear/dbhardhat
	display_name = "hardhat, blue"
	path = /obj/item/clothing/head/hardhat/dblue
	cost = 2
	slot = slot_head

/datum/gear/ohardhat
	display_name = "hardhat, orange"
	path = /obj/item/clothing/head/hardhat/orange
	cost = 2
	slot = slot_head

/datum/gear/rhardhat
	display_name = "hardhat, red"
	path = /obj/item/clothing/head/hardhat/red
	cost = 2
	slot = slot_head

/datum/gear/yhardhat
	display_name = "hardhat, yellow"
	path = /obj/item/clothing/head/hardhat
	cost = 2
	slot = slot_head

/datum/gear/boater
	display_name = "hat, boatsman"
	path = /obj/item/clothing/head/boaterhat
	cost = 1
	slot = slot_head

 /datum/gear/bowler
	display_name = "hat, bowler"
	path = /obj/item/clothing/head/bowler
	cost = 1
	slot = slot_head

/datum/gear/fez
	display_name = "hat, fez"
	path = /obj/item/clothing/head/fez
	cost = 1
	slot = slot_head

/datum/gear/tophat
	display_name = "hat, tophat"
	path = /obj/item/clothing/head/that
	cost = 1
	slot = slot_head

// Wig by Earthcrusher, blame him.
/datum/gear/philosopher_wig
	display_name = "natural philosopher's wig"
	path = /obj/item/clothing/head/philosopher_wig
	cost = 1
	slot = slot_head

/datum/gear/ushanka
	display_name = "ushanka"
	path = /obj/item/clothing/head/ushanka
	cost = 1
	slot = slot_head

// This was sprited and coded specifically for Zhan-Khazan characters. Before you
// decide that it's 'not even Taj themed' maybe you should read the wiki, gamer. ~ Z
/datum/gear/zhan_scarf
	display_name = "Zhan headscarf"
	path = /obj/item/clothing/head/pegasus/scarf
	cost = 1
	slot = slot_head
	whitelisted = "Pegasus"

// Eyes

/datum/gear/eyepatch
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	cost = 1
	slot = slot_glasses

/datum/gear/green_glasses
	display_name = "Glasses, green"
	path = /obj/item/clothing/glasses/gglasses
	cost = 1
	slot = slot_glasses

/datum/gear/prescriptionhipster
	display_name = "Glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster
	cost = 1
	slot = slot_glasses

/datum/gear/prescription
	display_name = "Glasses, prescription"
	path = /obj/item/clothing/glasses/regular
	cost = 1
	slot = slot_glasses

/datum/gear/monocle
	display_name = "Monocle"
	path = /obj/item/clothing/glasses/monocle
	cost = 1
	slot = slot_glasses

/datum/gear/scanning_goggles
	display_name = "scanning goggles"
	path = /obj/item/clothing/glasses/fluff/uzenwa_sissra_1
	cost = 1
	slot = slot_glasses

/datum/gear/sciencegoggles
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/science
	cost = 1
	slot = slot_glasses

/datum/gear/security
	display_name = "Security HUD"
	path = /obj/item/clothing/glasses/hud/security
	cost = 1
	slot = slot_glasses
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/thugshades
	display_name = "Sunglasses, Fat (Security)"
	path = /obj/item/clothing/glasses/sunglasses/big
	cost = 1
	slot = slot_glasses
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/prescriptionsun
	display_name = "sunglasses, presciption"
	path = /obj/item/clothing/glasses/sunglasses/prescription
	cost = 2
	slot = slot_glasses

// Mask

/datum/gear/sterilemask
	display_name = "sterile mask"
	path = /obj/item/clothing/mask/surgical
	slot = slot_wear_mask
	cost = 2

// Uniform slot

/datum/gear/blazer_blue
	display_name = "blazer, blue"
	path = /obj/item/clothing/under/blazer
	slot = slot_w_uniform
	cost = 1

/datum/gear/cheongsam
	display_name = "cheongsam, white"
	path = /obj/item/clothing/under/cheongsam
	slot = slot_w_uniform
	cost = 1

/datum/gear/kilt
	display_name = "kilt"
	path = /obj/item/clothing/under/kilt
	slot = slot_w_uniform
	cost = 1

/datum/gear/blackjumpskirt
	display_name = "jumpskirt, black"
	path = /obj/item/clothing/under/blackjumpskirt
	slot = slot_w_uniform
	cost = 1

/datum/gear/blackfjumpsuit
	display_name = "jumpsuit, female-black"
	path = /obj/item/clothing/under/color/blackf
	slot = slot_w_uniform
	cost = 1
/datum/gear/blackfjumpsuit
	display_name = "jumpsuit, rainbow"
	path = /obj/item/clothing/under/rainbow
	slot = slot_w_uniform
	cost = 1

/datum/gear/skirt_blue
	display_name = "plaid skirt, blue"
	path = /obj/item/clothing/under/dress/plaid_blue
	slot = slot_w_uniform
	cost = 1

/datum/gear/skirt_purple
	display_name = "plaid skirt, purple"
	path = /obj/item/clothing/under/dress/plaid_purple
	slot = slot_w_uniform
	cost = 1

/datum/gear/skirt_red
	display_name = "plaid skirt, red"
	path = /obj/item/clothing/under/dress/plaid_red
	slot = slot_w_uniform
	cost = 1

/datum/gear/skirt_black
	display_name = "skirt, black"
	path = /obj/item/clothing/under/blackskirt
	slot = slot_w_uniform
	cost = 1

/datum/gear/amishsuit
	display_name = "suit, amish"
	path = /obj/item/clothing/under/sl_suit
	slot = slot_w_uniform
	cost = 1

/datum/gear/blacksuit
	display_name = "suit, black"
	path = /obj/item/clothing/under/suit_jacket
	slot = slot_w_uniform
	cost = 1

/datum/gear/shinyblacksuit
	display_name = "suit, shiny-black"
	path = /obj/item/clothing/under/lawyer/black
	slot = slot_w_uniform
	cost = 1

/datum/gear/bluesuit
	display_name = "suit, blue"
	path = /obj/item/clothing/under/lawyer/blue
	slot = slot_w_uniform
	cost = 1

/datum/gear/burgundysuit
	display_name = "suit, burgundy"
	path = /obj/item/clothing/under/suit_jacket/burgundy
	slot = slot_w_uniform
	cost = 1

/datum/gear/checkeredsuit
	display_name = "suit, checkered"
	path = /obj/item/clothing/under/suit_jacket/checkered
	slot = slot_w_uniform
	cost = 1

/datum/gear/charcoalsuit
	display_name = "suit, charcoal"
	path = /obj/item/clothing/under/suit_jacket/charcoal
	slot = slot_w_uniform
	cost = 1

/datum/gear/execsuit
	display_name = "suit, executive"
	path = /obj/item/clothing/under/suit_jacket/really_black
	slot = slot_w_uniform
	cost = 1

/datum/gear/femaleexecsuit
	display_name = "suit, female-executive"
	path = /obj/item/clothing/under/suit_jacket/female
	slot = slot_w_uniform
	cost = 1

/datum/gear/gentlesuit
	display_name = "suit, gentlemen"
	path = /obj/item/clothing/under/gentlesuit
	slot = slot_w_uniform
	cost = 1

/datum/gear/navysuit
	display_name = "suit, navy"
	path = /obj/item/clothing/under/suit_jacket/navy
	slot = slot_w_uniform
	cost = 1

/datum/gear/redsuit
	display_name = "suit, red"
	path = /obj/item/clothing/under/suit_jacket/red
	slot = slot_w_uniform
	cost = 1

/datum/gear/redlawyer
	display_name = "suit, lawyer-red"
	path = /obj/item/clothing/under/lawyer/red
	slot = slot_w_uniform
	cost = 1

/datum/gear/oldmansuit
	display_name = "suit, old-man"
	path = /obj/item/clothing/under/lawyer/oldman
	slot = slot_w_uniform
	cost = 1

/datum/gear/purplesuit
	display_name = "suit, purple"
	path = /obj/item/clothing/under/lawyer/purpsuit
	slot = slot_w_uniform
	cost = 1

/datum/gear/tansuit
	display_name = "suit, tan"
	path = /obj/item/clothing/under/suit_jacket/tan
	slot = slot_w_uniform
	cost = 1

/datum/gear/whitesuit
	display_name = "suit, white"
	path = /obj/item/clothing/under/scratch
	slot = slot_w_uniform
	cost = 1

/datum/gear/whitebluesuit
	display_name = "suit, white-blue"
	path = /obj/item/clothing/under/lawyer/bluesuit
	slot = slot_w_uniform
	cost = 1

/datum/gear/sundress
	display_name = "sundress"
	path = /obj/item/clothing/under/sundress
	slot = slot_w_uniform
	cost = 1

/datum/gear/sundress_white
	display_name = "sundress, white"
	path = /obj/item/clothing/under/sundress_white
	slot = slot_w_uniform
	cost = 1

/datum/gear/uniform_captain
	display_name = "uniform, captain's dress"
	path = /obj/item/clothing/under/dress/dress_cap
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Captain")

/datum/gear/corpsecsuit
	display_name = "uniform, corporate (Security)"
	path = /obj/item/clothing/under/rank/security/corp
	cost = 1
	slot = slot_w_uniform
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/uniform_hop
	display_name = "uniform, HoP's dress"
	path = /obj/item/clothing/under/dress/dress_hop
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform_hr
	display_name = "uniform, HR director (HoP)"
	path = /obj/item/clothing/under/dress/dress_hr
	slot = slot_w_uniform
	cost = 1
	allowed_roles = list("Head of Personnel")

/datum/gear/navysecsuit
	display_name = "uniform, navyblue (Security)"
	path = /obj/item/clothing/under/rank/security/navyblue
	cost = 1
	slot = slot_w_uniform
	allowed_roles = list("Security Officer","Head of Security","Warden")

// Attachments

/datum/gear/armband_cargo
	display_name = "armband, cargo"
	path = /obj/item/clothing/accessory/armband/cargo
	slot = slot_tie
	cost = 1

/datum/gear/armband_emt
	display_name = "armband, EMT"
	path = /obj/item/clothing/accessory/armband/medgreen
	slot = slot_tie
	cost = 1

/datum/gear/armband_engineering
	display_name = "armband, engineering"
	path = /obj/item/clothing/accessory/armband/engine
	slot = slot_tie
	cost = 1

/datum/gear/armband_hydroponics
	display_name = "armband, hydroponics"
	path = /obj/item/clothing/accessory/armband/hydro
	slot = slot_tie
	cost = 1

/datum/gear/armband_medical
	display_name = "armband, medical"
	path = /obj/item/clothing/accessory/armband/med
	slot = slot_tie
	cost = 1

/datum/gear/armband
	display_name = "armband, red"
	path = /obj/item/clothing/accessory/armband
	slot = slot_tie
	cost = 1

/datum/gear/armband_science
	display_name = "armband, science"
	path = /obj/item/clothing/accessory/armband/science
	slot = slot_tie
	cost = 1

/datum/gear/armpit
	display_name = "holster, armpit"
	path = /obj/item/clothing/accessory/holster/armpit
	slot = slot_tie
	cost = 1
	allowed_roles = list("Captain", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective")

/datum/gear/hip
	display_name = "holster, hip"
	path = /obj/item/clothing/accessory/holster/hip
	slot = slot_tie
	cost = 1
	allowed_roles = list("Captain", "Head of Personnel", "Security Officer", "Warden", "Head of Security", "Detective")

/datum/gear/waist
	display_name = "holster, waist"
	path = /obj/item/clothing/accessory/holster/waist
	slot = slot_tie
	cost = 1
	allowed_roles = list("Captain", "Head of Personnel", "Security Officer", "Warden", "Head of Security", "Detective")

/datum/gear/tie_blue
	display_name = "tie, blue"
	path = /obj/item/clothing/accessory/blue
	slot = slot_tie
	cost = 1

/datum/gear/tie_red
	display_name = "tie, red"
	path = /obj/item/clothing/accessory/red
	slot = slot_tie
	cost = 1

/datum/gear/tie_horrible
	display_name = "tie, socially disgraceful"
	path = /obj/item/clothing/accessory/horrible
	slot = slot_tie
	cost = 1

/datum/gear/brown_vest
	display_name = "webbing, engineering"
	path = /obj/item/clothing/accessory/storage/brown_vest
	slot = slot_tie
	cost = 1
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer")

/datum/gear/black_vest
	display_name = "webbing, security"
	path = /obj/item/clothing/accessory/storage/black_vest
	slot = slot_tie
	cost = 1
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing
	slot = slot_tie
	cost = 2

// Suit slot

/datum/gear/apron
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	cost = 1
	slot = slot_wear_suit

/datum/gear/bomber
	display_name = "bomber jacket"
	path = /obj/item/clothing/suit/storage/toggle/bomber
	cost = 2
	slot = slot_wear_suit

/datum/gear/leather_jacket
	display_name = "leather jacket, black"
	path = /obj/item/clothing/suit/storage/leather_jacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/leather_jacket_nt
	display_name = "leather jacket, NanoTrasen, black"
	path = /obj/item/clothing/suit/storage/leather_jacket/nanotrasen
	cost = 2
	slot = slot_wear_suit

/datum/gear/brown_jacket
	display_name = "leather jacket, brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/brown_jacket_nt
	display_name = "leather jacket, NanoTrasen, brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	cost = 2
	slot = slot_wear_suit

/datum/gear/hazard_vest
	display_name = "hazard vest"
	path = /obj/item/clothing/suit/storage/hazardvest
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie
	display_name = "hoodie, grey"
	path = /obj/item/clothing/suit/storage/toggle/hoodie
	cost = 2
	slot = slot_wear_suit

/datum/gear/hoodie/black
	display_name = "hoodie, black"
	path = /obj/item/clothing/suit/storage/toggle/hoodie/black
	cost = 2

/datum/gear/unicorn_mantle
	display_name = "hide mantle (Unicorn)"
	path = /obj/item/clothing/suit/unicorn/mantle
	cost = 1
	slot = slot_wear_suit
	whitelisted = "Unicorn"

/datum/gear/labcoat
	display_name = "labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	cost = 2
	slot = slot_wear_suit

/datum/gear/bluelabcoat
	display_name = "labcoat, blue"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue
	cost = 2
	slot = slot_wear_suit

/datum/gear/greenlabcoat
	display_name = "labcoat, green"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/green
	cost = 2
	slot = slot_wear_suit

/datum/gear/orangelabcoat
	display_name = "labcoat, orange"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/orange
	cost = 2
	slot = slot_wear_suit

/datum/gear/purplelabcoat
	display_name = "labcoat, purple"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/purple
	cost = 2
	slot = slot_wear_suit

/datum/gear/redlabcoat
	display_name = "labcoat, red"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/red
	cost = 2
	slot = slot_wear_suit

/datum/gear/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1
	slot = slot_wear_suit

/datum/gear/bponcho
	display_name = "poncho, blue"
	path = /obj/item/clothing/suit/poncho/blue
	cost = 1
	slot = slot_wear_suit

/datum/gear/gponcho
	display_name = "poncho, green"
	path = /obj/item/clothing/suit/poncho/green
	cost = 1
	slot = slot_wear_suit

/datum/gear/pponcho
	display_name = "poncho, purple"
	path = /obj/item/clothing/suit/poncho/purple
	cost = 1
	slot = slot_wear_suit

/datum/gear/rponcho
	display_name = "poncho, red"
	path = /obj/item/clothing/suit/poncho/red
	cost = 1
	slot = slot_wear_suit

/datum/gear/poncho
	display_name = "poncho, tan"
	path = /obj/item/clothing/suit/poncho
	cost = 1
	slot = slot_wear_suit

/datum/gear/unicorn_robe
	display_name = "roughspun robe (Unicorn)"
	path = /obj/item/clothing/suit/unicorn/robe
	cost = 1
	slot = slot_wear_suit
//	whitelisted = "Unicorn" // You don't have a monopoly on a robe!

/datum/gear/blue_lawyer_jacket
	display_name = "suit jacket, blue"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/purple_lawyer_jacket
	display_name = "suit jacket, purple"
	path = /obj/item/clothing/suit/storage/lawyer/purpjacket
	cost = 2
	slot = slot_wear_suit

/datum/gear/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/suit/suspenders
	cost = 1
	slot = slot_wear_suit

/datum/gear/wcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/suit/wcoat
	cost = 1
	slot = slot_wear_suit

/datum/gear/zhan_furs
	display_name = "Zhan-Khazan furs (Pegasus)"
	path = /obj/item/clothing/suit/pegasus/furs
	cost = 1
	slot = slot_wear_suit
	whitelisted = "Pegasus" // You do have a monopoly on a fur suit tho

// Gloves

/datum/gear/black_gloves
	display_name = "gloves, black"
	path = /obj/item/clothing/gloves/black
	cost = 2
	slot = slot_gloves

/datum/gear/blue_gloves
	display_name = "gloves, blue"
	path = /obj/item/clothing/gloves/blue
	cost = 2
	slot = slot_gloves

/datum/gear/brown_gloves
	display_name = "gloves, brown"
	path = /obj/item/clothing/gloves/brown
	cost = 2
	slot = slot_gloves

/datum/gear/light_brown_gloves
	display_name = "gloves, light-brown"
	path = /obj/item/clothing/gloves/light_brown
	cost = 2
	slot = slot_gloves

/datum/gear/green_gloves
	display_name = "gloves, green"
	path = /obj/item/clothing/gloves/green
	cost = 2
	slot = slot_gloves

/datum/gear/grey_gloves
	display_name = "gloves, grey"
	path = /obj/item/clothing/gloves/grey
	cost = 2
	slot = slot_gloves

/datum/gear/latex_gloves
	display_name = "gloves, latex"
	path = /obj/item/clothing/gloves/latex
	cost = 2
	slot = slot_gloves


/datum/gear/orange_gloves
	display_name = "gloves, orange"
	path = /obj/item/clothing/gloves/orange
	cost = 2
	slot = slot_gloves

/datum/gear/purple_gloves
	display_name = "gloves, purple"
	path = /obj/item/clothing/gloves/purple
	cost = 2
	slot = slot_gloves

/datum/gear/rainbow_gloves
	display_name = "gloves, rainbow"
	path = /obj/item/clothing/gloves/rainbow
	cost = 2
	slot = slot_gloves

/datum/gear/red_gloves
	display_name = "gloves, red"
	path = /obj/item/clothing/gloves/red
	cost = 2
	slot = slot_gloves

/datum/gear/white_gloves
	display_name = "gloves, white"
	path = /obj/item/clothing/gloves/white
	cost = 2
	slot = slot_gloves

// Shoelocker

/datum/gear/jackboots
	display_name = "jackboots"
	path = /obj/item/clothing/shoes/jackboots
	cost = 1
	slot = slot_shoes

/datum/gear/toeless_jackboots
	display_name = "toe-less jackboots"
	path = /obj/item/clothing/shoes/jackboots/fluff/kecer_eldraran
	cost = 1
	slot = slot_shoes

/datum/gear/sandal
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal
	cost = 1
	slot = slot_shoes

/datum/gear/black_shoes
	display_name = "shoes, black"
	path = /obj/item/clothing/shoes/black
	cost = 1
	slot = slot_shoes

/datum/gear/blue_shoes
	display_name = "shoes, blue"
	path = /obj/item/clothing/shoes/blue
	cost = 1
	slot = slot_shoes

/datum/gear/brown_shoes
	display_name = "shoes, brown"
	path = /obj/item/clothing/shoes/brown
	cost = 1
	slot = slot_shoes

/datum/gear/laceyshoes
	display_name = "shoes, classy"
	path = /obj/item/clothing/shoes/laceup
	cost = 1
	slot = slot_shoes

/datum/gear/dress_shoes
	display_name = "shoes, dress"
	path = /obj/item/clothing/shoes/laceup
	cost = 1
	slot = slot_shoes

/datum/gear/green_shoes
	display_name = "shoes, green"
	path = /obj/item/clothing/shoes/green
	cost = 1
	slot = slot_shoes

/datum/gear/leather
	display_name = "shoes, leather"
	path = /obj/item/clothing/shoes/leather
	cost = 1
	slot = slot_shoes

/datum/gear/orange_shoes
	display_name = "shoes, orange"
	path = /obj/item/clothing/shoes/orange
	cost = 1
	slot = slot_shoes

/datum/gear/purple_shoes
	display_name = "shoes, purple"
	path = /obj/item/clothing/shoes/purple
	cost = 1
	slot = slot_shoes

/datum/gear/rainbow_shoes
	display_name = "shoes, rainbow"
	path = /obj/item/clothing/shoes/rainbow
	cost = 1
	slot = slot_shoes

/datum/gear/red_shoes
	display_name = "shoes, red"
	path = /obj/item/clothing/shoes/red
	cost = 1
	slot = slot_shoes

/datum/gear/white_shoes
	display_name = "shoes, white"
	path = /obj/item/clothing/shoes/white
	cost = 1
	slot = slot_shoes

/datum/gear/yellow_shoes
	display_name = "shoes, yellow"
	path = /obj/item/clothing/shoes/yellow
	cost = 1
	slot = slot_shoes

// "Useful" items - I'm guessing things that might be used at work?

/datum/gear/briefcase
	display_name = "briefcase"
	path = /obj/item/weapon/storage/briefcase
	sort_category = "utility"
	cost = 2

/datum/gear/clipboard
	display_name = "clipboard"
	path = /obj/item/weapon/clipboard
	sort_category = "utility"
	cost = 1

/datum/gear/folder_blue
	display_name = "folder, blue"
	path = /obj/item/weapon/folder/blue
	sort_category = "utility"
	cost = 1

/datum/gear/folder_grey
	display_name = "folder, grey"
	path = /obj/item/weapon/folder
	sort_category = "utility"
	cost = 1

/datum/gear/folder_red
	display_name = "folder, red"
	path = /obj/item/weapon/folder/red
	sort_category = "utility"
	cost = 1

/datum/gear/folder_white
	display_name = "folder, white"
	path = /obj/item/weapon/folder/white
	sort_category = "utility"
	cost = 1

/datum/gear/folder_yellow
	display_name = "folder, yellow"
	path = /obj/item/weapon/folder/yellow
	sort_category = "utility"
	cost = 1

/datum/gear/paicard
	display_name = "personal AI device"
	path = /obj/item/device/paicard
	sort_category = "utility"
	cost = 2

// The rest of the trash.

/datum/gear/ashtray
	display_name = "ashtray, plastic"
	path = /obj/item/ashtray/plastic
	sort_category = "misc"
	cost = 1

/datum/gear/cane
	display_name = "cane"
	path = /obj/item/weapon/cane
	sort_category = "misc"
	cost = 1

/datum/gear/dice
	display_name = "d20"
	path = /obj/item/weapon/dice/d20
	sort_category = "misc"
	cost = 1

/datum/gear/cards
	display_name = "deck of cards"
	path = /obj/item/weapon/deck
	sort_category = "misc"
	cost = 1

/datum/gear/flask
	display_name = "flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/barflask
	sort_category = "misc"
	cost = 1

/datum/gear/vacflask
	display_name = "vacuum-flask"
	path = /obj/item/weapon/reagent_containers/food/drinks/flask/vacuumflask
	sort_category = "misc"
	cost = 1
/datum/gear/blipstick
	display_name = "lipstick, black"
	path = /obj/item/weapon/lipstick/black
	sort_category = "misc"
	cost = 1

/datum/gear/jlipstick
	display_name = "lipstick, jade"
	path = /obj/item/weapon/lipstick/jade
	sort_category = "misc"
	cost = 1

/datum/gear/plipstick
	display_name = "lipstick, purple"
	path = /obj/item/weapon/lipstick/purple
	sort_category = "misc"
	cost = 1

/datum/gear/rlipstick
	display_name = "lipstick, red"
	path = /obj/item/weapon/lipstick
	sort_category = "misc"
	cost = 1

/datum/gear/smokingpipe
	display_name = "pipe, smoking"
	path = /obj/item/clothing/mask/smokable/pipe
	sort_category = "misc"
	cost = 1

/datum/gear/cornpipe
	display_name = "pipe, corn"
	path = /obj/item/clothing/mask/smokable/pipe/cobpipe
	sort_category = "misc"
	cost = 1

/datum/gear/matchbook
	display_name = "matchbook"
	path = /obj/item/weapon/storage/box/matches
	sort_category = "misc"
	cost = 1

/datum/gear/comb
	display_name = "purple comb"
	path = /obj/item/weapon/haircomb
	sort_category = "misc"
	cost = 1

/datum/gear/zippo
	display_name = "zippo"
	path = /obj/item/weapon/flame/lighter/zippo
	sort_category = "misc"
	cost = 1

/*/datum/gear/combitool
	display_name = "combi-tool"
	path = /obj/item/weapon/combitool
	cost = 3*/

// Stuff worn on the ears. Items here go in the "ears" sort_category but they must not use
// the slot_r_ear or slot_l_ear as the slot, or else players will spawn with no headset.
/datum/gear/earmuffs
	display_name = "earmuffs"
	path = /obj/item/clothing/ears/earmuffs
	cost = 1
	sort_category = "ears"

/datum/gear/skrell_chain
	display_name = "skrell headtail-wear, female, chain"
	path = /obj/item/clothing/ears/skrell/chain
	cost = 1
	sort_category = "ears"
	whitelisted = "Skrell"

/datum/gear/skrell_plate
	display_name = "skrell headtail-wear, male, bands"
	path = /obj/item/clothing/ears/skrell/band
	cost = 1
	sort_category = "ears"
	whitelisted = "Skrell"

/datum/gear/skrell_cloth_male
	display_name = "skrell headtail-wear, male, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_male
	cost = 1
	sort_category = "ears"
	whitelisted = "Skrell"

/datum/gear/skrell_cloth_female
	display_name = "skrell headtail-wear, female, cloth"
	path = /obj/item/clothing/ears/skrell/cloth_female
	cost = 1
	sort_category = "ears"
	whitelisted = "Skrell"
