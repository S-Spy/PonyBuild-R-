//H.spell_list += new /obj/effect/proc_holder/spell/targeted/projectile/magic_missile(H)

/mob/living/carbon/pony/proc/update_unicorn_verbs()
	for(var/type in typesof(/datum/spells)-/datum/spells)
		var/datum/spells/S = new type()
		if(!(S.spell_name in unicorn_spells))
			verbs -= S.spell_verb

/mob/living/carbon/pony/verb
	strong_light()//OK
		set category = "Unicorn"
		set name = "Strong light"
		set desc = "Strong light about you."
		if(horn_light == 1)
			SetLuminosity(luminosity-3)
			horn_light = 0
			cooldown[1] = 1
			spawn(250)	cooldown[1]=0
		else//Включение
			if(prob(concentration(1)) || nutrition < 20 || horn_light != 0 || cooldown[1] == 1)
				usr << "You can't use this spell!"
				return //Проверка доступности долгосрочного заклинания
			SetLuminosity(luminosity+3)
			nutrition -= 6
			horn_light = 1
			update_icons()
			for(var/i=1, i < 50, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 1)
					if(nutrition > 2)	nutrition--
					else	break
			if(horn_light == 1)//Отключение с таймером
				SetLuminosity(luminosity-3)
				horn_light = 0
				cooldown[1] = 1
				spawn(250)	cooldown[1]=0
		update_icons()

	light()//OK
		set category = "Unicorn"
		set name = "Light"
		set desc = "Light about you."
		if(horn_light == 2)//Отключение при повторном запуске
			SetLuminosity(luminosity-1)
			horn_light = 0
			cooldown[2] = 1
			spawn(100)	cooldown[2] = 0
		else//Включение
			if(prob(concentration(1)) || nutrition < 10 || horn_light != 0 || cooldown[2] == 1)
				usr << "You can't use this spell!"
				return  //Проверка доступности долгосрочного заклинания
			SetLuminosity(luminosity+1)
			nutrition -= 4
			horn_light = 1
			update_icons()
			for(var/i=1, i < 90, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(20)
				if(horn_light == 2)
					if(nutrition > 2)	nutrition--
					else	break
			if(horn_light == 2)
				SetLuminosity(luminosity-1)
				horn_light = 0
				cooldown[2] = 1
				spawn(100)	cooldown[2] = 0
		update_icons()

	clean()//OK
		set name = "Cleaner"
		set desc = "Cleaning you or others."
		set category = "Unicorn"
		if(prob(concentration(2)) || nutrition < 30 || horn_light_short != 0 || cooldown[3] == 1)
			usr << "You can't use this spell!"
			return
		cooldown[3] = 1
		spawn(1000)	cooldown[3] = 0
		horn_light_short = 1
		update_icons()
		sleep(10)
		var/obj/item/weapon/reagent_containers/spray/cleaner/H = new/obj/item/weapon/reagent_containers/spray/cleaner
		H.Spray_at(usr, usr, 1)
		nutrition -= 18
		del H
		sleep(5)
		horn_light_short = 0
		update_icons()

	tele_glass()//OK
		set name = "Telekinetic glass"
		set desc = "Liquid telekinesis."
		set category = "Unicorn"
		var/obj/item/weapon/reagent_containers/glass/G
		if(horn_light == 6)
			if(!G)	for(var/obj/item/weapon/reagent_containers/glass/g in usr.contents)
				if(findtext(g.name, "Tele") != 0 )
					G = g
					break
			var/obj/O = locate(/turf) in G.loc
			G.afterattack(O, usr, 1)
			spawn(6)	del G
			cooldown[6] = 1
			spawn(200)	cooldown[6] = 0
			horn_light = 0
		else
			if(prob(concentration(1)) || nutrition < 20 || horn_light != 0 || cooldown[6] == 1)
				usr << "You can't use this spell!"
				return
			G = new/obj/item/weapon/reagent_containers/glass
			var/icon/I = G.icon
			I.Blend(rgb(r_aura, g_aura, b_aura), ICON_ADD)
			G.icon = I
			G.alpha = 100
			G.Move(locate(x, y, z))
			G.name = "Tele [name]"
			UnarmedAttack(G)
			nutrition -= 5
			horn_light = 6
			update_icons()
			for(var/i=1, i < 180, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 6)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 6)
				var/obj/O = locate(/turf) in G.loc
				G.afterattack(O, usr, 1)
				spawn(6)	del G
				cooldown[6] = 1
				spawn(200)	cooldown[6] = 0
				horn_light = 0
		update_icons()

	dist_light()//OK
		set name = "Distance light"
		set desc = "Beam of light."
		set category = "Unicorn"
		var/obj/item/weapon/light_spark/L
		if(horn_light == 7)
			if(!L)	L = locate(/obj/item/weapon/light_spark) in usr.contents
			del L
			cooldown[7] = 1
			spawn(300)	cooldown[7] = 0
			horn_light = 0
		else
			if(prob(concentration(1)) || nutrition < 20 || horn_light != 0 || cooldown[7] == 1)
				usr << "You can't use this spell!"
				return
			L = new/obj/item/weapon/light_spark
			var/icon/I = L.icon
			I.Blend(rgb(r_aura, g_aura, b_aura))
			L.icon = I
			L.Move(locate(x, y, z))
			nutrition -= 8
			horn_light = 7
			update_icons()
			for(var/i=1, i < 40, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 7)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 7)
				del L
				cooldown[7] = 1
				spawn(300)	cooldown[7] = 0
				horn_light = 0
		update_icons()

	hair_transform(var/mob/living/carbon/pony/P in view(1))//OK
		set name = "Morph"
		set desc = "Transform you hair's."
		set category = "Unicorn"
		if(prob(concentration(2)) || nutrition < 30 || horn_light_short != 0 || cooldown[8] == 1)
			usr << "You can't use this spell!"
			return
		horn_light_short = 1
		update_icons()
		cooldown[8] = 1
		spawn(1300)	cooldown[8] = 0
		sleep(10)
		var/list/valid_hair = list()
		var/list/valid_facial = list()
		var/list/valid_tail = list()
		for(var/path in typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair)
			var/datum/sprite_accessory/hair/H = new path()
			if(P.gender == MALE && H.gender == FEMALE)	continue
			if(P.gender == FEMALE && H.gender == MALE)	continue
			if(!(P.species.name in H.species_allowed))	continue
			valid_hair += H.name
		for(var/path in typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/facial_hair)
			var/datum/sprite_accessory/facial_hair/H = new path()
			if(P.gender == MALE && H.gender == FEMALE)	continue
			if(P.gender == FEMALE && H.gender == MALE)	continue
			if(!(P.species.name in H.species_allowed))	continue
			valid_hair += H.name
		for(var/path in typesof(/datum/sprite_accessory/hair) - /datum/sprite_accessory/hair)
			var/datum/sprite_accessory/pony_tail/H = new path()
			if(P.gender == MALE && H.gender == FEMALE)	continue
			if(P.gender == FEMALE && H.gender == MALE)	continue
			if(!(P.species.name in H.species_allowed))	continue
			valid_hair += H.name

		nutrition -= 23
		if(prob(concentration(5)))	P.f_style = pick(valid_facial)
		if(prob(concentration(5)))	P.h_style = pick(valid_hair)
		if(prob(concentration(5)))	P.pony_tail_style = pick(valid_tail)
		P.regenerate_icons()
		sleep(5)
		horn_light_short = 0
		update_icons()

	hot()//OK
		set name = "Heat"
		set desc = "Heating food, ponies and you."
		set category = "Unicorn"
		if(prob(concentration(2)) || nutrition < 30 || horn_light_short != 0 || cooldown[9] == 1)
			usr << "You can't use this spell!"
			return
		var/list/Li = list()
		for(var/atom/A in view(1))
			if(istype(A, /obj/item/weapon/reagent_containers/food) || istype(A, /mob/living/carbon/pony))
				Li += A
		if(Li.len == 0)	return
		var/target = input(usr, "Choose your target", "Target")  as null|anything in Li
		if(target in view(1))
			horn_light_short = 1
			cooldown[9] = 1
			spawn(210)	cooldown[9] = 0
			update_icons()
			sleep(10)
			if(istype(target, /obj/item/weapon/reagent_containers/food))	target:heat_food(target:heating+1)
			else	target:bodytemperature += 5
			nutrition -= 22
			sleep(5)
			horn_light_short = 0
			update_icons()

	concentrate()
		set name = "High concentration"
		set desc = "Very high concentration for strong telekinesis."
		set category = "Unicorn"
		if(horn_light == 10)
			cooldown[10] = 1
			spawn(700)	cooldown[10] = 0
			horn_light = 0
		else
			if(prob(concentration(3)) || nutrition < 40 || horn_light != 0 || cooldown[10] == 1)
				usr << "You can't use this spell!"
				return
			nutrition -= 12
			horn_light = 10
			update_icons()
			for(var/i=1, i < 300, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 10)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 10)
				cooldown[10] = 1
				spawn(700)	cooldown[10] = 0
				horn_light = 0
		update_icons()

	fruit_transform(var/obj/item/weapon/reagent_containers/food/snacks/grown/G in view(1))//OK
		set name = "Organic transformation"
		set desc = "Banana to potato, yeah."
		set category = "Unicorn"
		if(prob(concentration(3)) || nutrition < 40 || horn_light_short != 0 || cooldown[11] == 1)
			usr << "You can't use this spell!"
			return
		horn_light_short = 1
		update_icons()
		cooldown[11] = 1
		spawn(900)	cooldown[11] = 0
		sleep(10)
		G = new(G.loc, pick("chili", "potato", "tomato", "apple", "banana", "mushrooms", "plumphelmet", "towercap", "harebells", "poppies", "sunflowers", "grapes", "peanut", "cabbage", "corn", "carrot", "whitebeet", "watermelon", "pumpkin", "lime", "lemon", "orange", "ambrosia"))
		if(prob(50))	del G
		nutrition -= 26
		sleep(5)
		horn_light_short = 1
		update_icons()

	cold(var/mob/living/carbon/pony/P in view(1))//OK
		set name = "Cooling"
		set desc = "Makes ponies 20% cooler... Khm, colder."
		set category = "Unicorn"
		if(prob(concentration(1)) || nutrition < 20 || horn_light_short != 0 || cooldown[12] == 1)
			usr << "You can't use this spell!"
			return
		horn_light_short = 1
		cooldown[12] = 1
		spawn(250)	cooldown[12] = 0
		update_icons()
		sleep(10)
		P.bodytemperature -= 10
		nutrition -= 13
		sleep(5)
		horn_light_short = 0
		update_icons()

	health_scan()//OK
		set name = "Health scan"
		set desc = "Analogy of using health analyzer."
		set category = "Unicorn"
		if(prob(concentration(1)) || nutrition < 20 || horn_light_short != 0 || cooldown[4] == 1)
			usr << "You can't use this spell!"
			return
		cooldown[4] = 1
		spawn(200)	cooldown[4] = 0
		horn_light_short = 4
		update_icons()
		sleep(10)
		var/list/mobs = list()
		for(var/mob/living/carbon/M in view(1))
			if(M != usr)	mobs += M
		var/mob/living/carbon/M = input(usr, "Choose your target", "Target")  as null|anything in mobs
		var/obj/item/device/healthanalyzer/H = new/obj/item/device/healthanalyzer
		H.attack(M, usr)
		nutrition -= 10
		del H
		sleep(5)
		horn_light_short = 0
		update_icons()

	blood_dam(var/mob/living/carbon/pony/P in view(1))
		set name = "Heel bleeding"
		set desc = "Analogy of bandages."
		set category = "Unicorn"
		if(prob(concentration(2)) || nutrition < 30 || horn_light_short != 0 || cooldown[13] == 1)
			usr << "You can't use this spell!"
			return
		horn_light_short = 1
		cooldown[13] = 1
		spawn(700)	cooldown[13] = 0
		update_icons()
		sleep(10)
		var/obj/item/stack/medical/bruise_pack/B = new/obj/item/stack/medical/bruise_pack
		B.attack(P, usr)
		nutrition -= 22
		del B
		sleep(5)
		horn_light_short = 0
		update_icons()

	notpain(var/mob/living/carbon/pony/P in view(1))
		set name = "Pain relief"
		set desc = "Easing of pain."
		set category = "Unicorn"
		if(prob(concentration(2)) || nutrition < 30 || horn_light_short != 0 || cooldown[14] == 1)
			usr << "You can't use this spell!"
			return
		horn_light_short = 1
		cooldown[14] = 1
		spawn(700)	cooldown[14] = 0
		update_icons()
		sleep(10)
		P.reagents.add_reagent("tramadol", 3)
		P.reagents.add_reagent("adrenalin", 1)
		nutrition -= 21
		sleep(5)
		horn_light_short = 0
		update_icons()

	light_heel(var/mob/living/carbon/P in view(1))//Можно добавить настройку для аликорнов
		set name = "Light heel"
		set desc = "Little heel ponies."
		set category = "Unicorn"
		if(prob(concentration(3)) || nutrition < 40 || horn_light_short != 0 || cooldown[15] == 1)
			usr << "You can't use this spell!"
			return
		horn_light_short = 1
		cooldown[12] = 1
		spawn(1200)	cooldown[15] = 0
		update_icons()
		sleep(10)
		P.apply_damages(-5, -5)
		nutrition -= 33
		sleep(5)
		horn_light_short = 0
		update_icons()

	organ_scan(var/mob/living/carbon/pony/P in view(1))
		set name = "Organ analyze"
		set desc = "Analogy of using organ analyzer."
		set category = "Unicorn"
		return
		if(prob(concentration(3)) || nutrition < 40 || horn_light_short != 0 || cooldown[16] == 1)
			usr << "You can't use this spell!"
			return
		horn_light_short = 1
		cooldown[16] = 1
		spawn(600)	cooldown[16] = 0
		update_icons()
		sleep(10)
		nutrition -= 27
		sleep(5)
		horn_light_short = 0
		update_icons()

	crowbar()
		set name = "Telekinetic crowbar"
		set desc = "Use telekinesis as crowbar."
		set category = "Unicorn"
		var/obj/item/weapon/crowbar/C
		if(horn_light == 17)
			if(!C)	C = locate(/obj/item/weapon/crowbar) in usr.contents
			del C
			horn_light = 0
			cooldown[17] = 1
			spawn(150) cooldown[17] = 0
		else
			var/has_free_hand
			for(var/datum/hand/H in list_hands)
				if(!H.item_in_hand)
					has_free_hand = 1
					break
			if(!has_free_hand || prob(concentration(1)) || nutrition < 20 || horn_light != 0 || cooldown[17] == 1)
				usr << "You can't use this spell!"
				return
			nutrition -= 7
			C = new/obj/item/weapon/crowbar
			C.Move(locate(usr))
			C.attack_hand(usr)
			horn_light = 17
			update_icons()
			for(var/i=1, i < 40, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 17)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 17)
				del C
				horn_light = 0
				cooldown[17] = 1
				spawn(150) cooldown[17] = 0
		update_icons()


	screwdriver()
		set name = "Telekinetic screwdriver"
		set desc = "Use telekinesis as screwdriver"
		set category = "Unicorn"
		var/obj/item/weapon/screwdriver/C
		if(horn_light == 18)
			if(!C)	C = locate(/obj/item/weapon/screwdriver) in usr.contents
			del C
			horn_light = 0
			cooldown[18] = 1
			spawn(150) cooldown[18] = 0
		else
			var/has_free_hand
			for(var/datum/hand/H in list_hands)
				if(!H.item_in_hand)
					has_free_hand = 1
					break
			if(!has_free_hand || prob(concentration(1)) || nutrition < 20 || horn_light != 0 || cooldown[18] == 1)
				usr << "You can't use this spell!"
				return
			nutrition -= 7
			C = new/obj/item/weapon/screwdriver
			C.Move(locate(usr))
			C.attack_hand(usr)
			horn_light = 18
			update_icons()
			for(var/i=1, i < 40, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 18)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 18)
				del C
				horn_light = 0
				cooldown[18] = 1
				spawn(150) cooldown[18] = 0
		update_icons()

	cut()
		set name = "Telekinetic cut"
		set desc = "Use telekinesis as cut."
		set category = "Unicorn"
		var/obj/item/weapon/wirecutters/C
		if(horn_light == 19)
			if(!C)	C = locate(/obj/item/weapon/wirecutters) in usr.contents
			del C
			horn_light = 0
			cooldown[19] = 1
			spawn(150) cooldown[19] = 0
		else
			var/has_free_hand
			for(var/datum/hand/H in list_hands)
				if(!H.item_in_hand)
					has_free_hand = 1
					break
			if(!has_free_hand || prob(concentration(1)) || nutrition < 20 || horn_light != 0 || cooldown[19] == 1)
				usr << "You can't use this spell!"
				return
			nutrition -= 7
			C = new/obj/item/weapon/wirecutters
			C.Move(locate(usr))
			C.attack_hand(usr)
			horn_light = 19
			update_icons()
			for(var/i=1, i < 40, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 19)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 19)
				del C
				horn_light = 0
				cooldown[19] = 1
				spawn(150) cooldown[19] = 0
		update_icons()

	cyber_scan()//OK
		set name = "Cyber scan"
		set desc = "Analogy of using cyber analyzer."
		set category = "Unicorn"
		if(prob(concentration(1)) || nutrition < 20 || horn_light_short != 0 || cooldown[5] == 1)
			usr << "You can't use this spell!"
			return
		var/list/mobs = list()
		for(var/mob/living/carbon/M in view(1))
			if(M != usr)	mobs += M
		var/mob/living/carbon/M = input(usr, "Choose your target", "Target")  as null|anything in mobs
		cooldown[5] = 1
		spawn(250)	cooldown[5] = 0
		horn_light_short = 1
		update_icons()
		sleep(10)
		var/obj/item/device/robotanalyzer/H = new/obj/item/device/robotanalyzer
		H.attack(M, usr)
		nutrition -= 12
		del H
		sleep(5)
		horn_light_short = 0
		update_icons()


	brush()
		set name = "Telekinetic brush"
		set desc = "Analogy of archeology brush."
		set category = "Unicorn"
		var/obj/item/weapon/pickaxe/brush/C
		if(horn_light == 20)
			if(!C)	C = locate(/obj/item/weapon/pickaxe/brush) in usr.contents
			if(!C)	return
			del C
			horn_light = 0
			cooldown[20] = 1
			spawn(300) cooldown[20] = 0
		else
			var/has_free_hand
			for(var/datum/hand/H in list_hands)
				if(!H.item_in_hand)
					has_free_hand = 1
					break
			if(!has_free_hand || prob(concentration(2)) || nutrition < 30 || horn_light != 0 || cooldown[20] == 1)
				usr << "You can't use this spell!"
				return
			nutrition -= 10
			C = new/obj/item/weapon/pickaxe/brush
			C.Move(locate(usr))
			C.attack_hand(usr)
			horn_light = 20
			update_icons()
			for(var/i=1, i < 1800, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 20)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 20)
				del C
				horn_light = 0
				cooldown[20] = 1
				spawn(300) cooldown[20] = 0
		update_icons()

	teleport()
		set name = "Teleport"
		set desc = "Teleportation to old record."
		set category = "Unicorn"
		if(prob(concentration(3)) || nutrition < 40 || horn_light_short != 0 || cooldown[21] == 1)
			usr << "You can't use this spell!"
			return//Заклинания 1-5 по расам
		var/list/Li = list("Record", "Teleport")
		var/target = input(usr, "Choose mod your teleportation", "Mod")  as null|anything in Li
		horn_light_short = 1
		update_icons()
		var mod = 0
		//if(record_loc)	mod = sqrt((x-record_loc.x)^2 + (y-record_loc.y)^2)*sqrt((z-record_loc.z)^2)
		sleep(10)
		if(target == "Record")	record_loc = loc
		else if(record_loc && nutrition < 15+mod)//+гипотенуза расстояния
			cooldown[21] = 1
			nutrition -= (15+mod)
			spawn(1800)	cooldown[21] = 0
			Move(locate(record_loc))
		else usr << "You can't use this spell!" //Тут функция отказа
		sleep(5)
		horn_light_short = 0
		update_icons()

	mag_boots()
		set name = "Telekinetic Anchoring"
		set desc = "Analogy of mag boots."
		set category = "Unicorn"
		return
		if(horn_light == 22)
			horn_light = 0
			cooldown[2] = 1
			spawn(600) cooldown[22] = 0
		else
			if(prob(concentration(2)) || nutrition < 30 || horn_light != 0 || cooldown[22] == 1)
				usr << "You can't use this spell!"
				return
			nutrition -= 11
			horn_light = 22
			update_icons()
			for(var/i=1, i < 100, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 22)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 22)
				horn_light = 0
				cooldown[2] = 1
				spawn(600) cooldown[22] = 0
		update_icons()

	cell_power()
		set name = "Charge of power"
		set desc = "Charging APC, robot's etc."
		set category = "Unicorn"
		if(prob(concentration(3)) || nutrition < 40 || horn_light_short != 0 || cooldown[23] == 1)
			usr << "You can't use this spell!"
			return
		var/list/Li = list()
		for(var/atom/A in view(2))
			if(istype(A, /obj/machinery/power/apc) || istype(A, /obj/item/weapon/cell) || ismob(A))
				if(istype(A, /obj/item/weapon/cell)) Li += A
				else for(var/obj/item/weapon/cell/C in A.contents) Li += C
		if(Li.len == 0)	return
		var/obj/item/weapon/cell/target = input(usr, "Choose your target", "Target")  as null|anything in Li
		horn_light_short = 1
		cooldown[23] = 1
		spawn(750)	cooldown[23] = 0
		update_icons()
		sleep(10)
		target.charge += min(500, target.maxcharge-target.charge)
		nutrition -= 30
		sleep(5)
		horn_light_short = 0
		update_icons()

	welding()
		set name = "Welding heating"
		set desc = "Unweld this wall. Right now."
		set category = "Unicorn"
		var/obj/item/weapon/weldingtool/C
		if(horn_light == 24)
			if(!C)	C = locate(/obj/item/weapon/weldingtool) in usr.contents
			del C
			horn_light = 0
			cooldown[24] = 1
			spawn(1000) cooldown[24] = 0
		else
			var/has_free_hand
			for(var/datum/hand/H in list_hands)
				if(!H.item_in_hand)
					has_free_hand = 1
					break
			if(!has_free_hand || prob(concentration(2)) || nutrition < 30 || horn_light != 0 || cooldown[24] == 1)
				usr << "You can't use this spell!"
				return
			nutrition -= 30
			C = new/obj/item/weapon/weldingtool
			C.Move(locate(usr))
			C.attack_hand(usr)
			horn_light = 24
			update_icons()
			for(var/i=1, i < 240, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 24)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 24)
				del C
				horn_light = 0
				cooldown[24] = 1
				spawn(1000) cooldown[24] = 0
		update_icons()

	hoofcufs()
		set name = "Telekinetic hoofcufs"
		set desc = "Analogy of hoofcufs."
		set category = "Unicorn"
		var/obj/item/weapon/handcuffs/C
		if(horn_light == 25)
			if(!C)	C = locate(/obj/item/weapon/handcuffs) in usr.contents//Нужен другой способ поиска
			if(!C)	return
			del C
			horn_light = 0
			cooldown[25] = 1
			spawn(250) cooldown[25] = 0
		else
			var/has_free_hand
			for(var/datum/hand/H in list_hands)
				if(!H.item_in_hand)
					has_free_hand = 1
					break
			if(!has_free_hand || prob(concentration(1)) || nutrition < 20 || horn_light != 0 || cooldown[25] == 1)
				usr << "You can't use this spell!"
				return
			C = new/obj/item/weapon/handcuffs
			C.Move(locate(usr))
			C.attack_hand(usr)
			var/icon/I = C.icon
			I.Blend(rgb(r_aura, g_aura, b_aura))
			C.icon = I
			del I
			nutrition -= 8
			horn_light = 25
			update_icons()
			for(var/i=1, i < 240, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 25)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 25)
				del C
				horn_light = 0
				cooldown[25] = 1
				spawn(250) cooldown[25] = 0
		update_icons()

	disarm()
		set name = "Flash disarm"
		set desc = "Fast disarm."
		set category = "Unicorn"
		if(prob(concentration(2)) || nutrition < 30 || horn_light_short != 0 || cooldown[26] == 1)
			usr << "You can't use this spell!"
			return
		var/list/mobs = list()
		for(var/mob/living/carbon/pony/P in view(1))
			if(P != usr)	mobs += P
		var/mob/living/carbon/pony/P = input(usr, "Choose your target", "Target")  as null|anything in mobs
		P.apply_effect(3, WEAKEN, 0)
		nutrition -= 25
		horn_light_short = 1
		cooldown[26] = 1
		spawn(150)	cooldown[26] = 0
		update_icons()
		sleep(5)
		horn_light_short = 0
		update_icons()



	light_grenade()
		set name = "Flash"
		set desc = "Ligh grenade."
		set category = "Unicorn"
		if(prob(concentration(1)) || nutrition < 20 || horn_light_short != 0 || cooldown[27] == 1)
			usr << "You can't use this spell!"
			return
		for(var/mob/M in view(3))
			flick("flash", M)
		horn_light_short = 1
		nutrition -= 13
		cooldown[27] = 1
		spawn(240)	cooldown[27] = 0
		update_icons()
		sleep(5)
		horn_light_short = 0
		update_icons()



	glue(var/mob/living/carbon/P in view(4))
		set name = "Live telekinesis"
		set desc = "Slowdown ponies."
		set category = "Unicorn"
		return
		if(horn_light == 28)
			horn_light = 0
			cooldown[28] = 1
			update_icons()
			spawn(300) cooldown[28] = 0
		else
			if(prob(concentration(2)) || nutrition < 30 || horn_light != 0 || cooldown[28] == 1)
				usr << "You can't use this spell!"
				return
			nutrition -= 15
			horn_light = 28
			update_icons()
			for(var/i=1, i < 15, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 28)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 28)
				horn_light = 0
				cooldown[28] = 1
				update_icons()
				spawn(300) cooldown[28] = 0
		update_icons()

	party_shield()
		set name = "Body shield"
		set desc = "Strong armor about you body."
		set category = "Unicorn"
		var/obj/item/clothing/suit/S
		if(horn_light == 29)
			if(!S)	S = locate(/obj/item/clothing/suit) in usr.contents
			if(!S)	return
			S.armor -= list(20, 15, 10, 10, 5, 0, 0)
			horn_light = 0
			cooldown[29] = 1
			spawn(800) cooldown[29] = 0
		else
			if(prob(concentration(3)) || nutrition < 30 || horn_light != 0 || cooldown[29] == 1)
				usr << "You can't use this spell!"
				return
			S = locate(/obj/item/clothing/suit) in usr.contents
			if(!S)	return
			nutrition -= 18
			S.armor += list(20, 15, 10, 10, 5, 0, 0)
			var/icon/I = S.icon
			I.Blend(rgb(r_aura, g_aura, b_aura))
			S.icon = I
			del I
			horn_light = 29
			update_icons()
			for(var/i=1, i < 200, i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 29)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 29)
				S.armor -= list(20, 15, 10, 10, 5, 0, 0)
				horn_light = 0
				cooldown[29] = 1
				spawn(800) cooldown[29] = 0
		update_icons()

	hoof_shield()//OK
		set name = "Shield"
		set desc = "Analogy of SWAT shield."
		set category = "Unicorn"
		var/obj/item/weapon/shield/riot/C
		if(horn_light == 30)
			horn_light = 0
			if(!C)	C = locate(/obj/item/weapon/shield/riot) in usr.contents
			if(!C)	return
			del C
			cooldown[30] = 1
			spawn(900) cooldown[30] = 0
		else
			var/has_free_hand
			for(var/datum/hand/H in list_hands)
				if(!H.item_in_hand)
					has_free_hand = 1
					break
			if(!has_free_hand || prob(concentration(3)) || nutrition < 30 || horn_light != 0 || cooldown[30] == 1)
				usr << "You can't use this spell!"
				return
			nutrition -= 20
			C = new/obj/item/weapon/shield/riot
			var/icon/I = C.icon
			I.Blend(rgb(r_aura, g_aura, b_aura))
			C.icon = I
			del I
			C.Move(locate(usr))
			C.attack_hand(usr)
			horn_light = 30
			update_icons()
			for(var/i=1; i < 50; i++) //Постепенное отнятие сытности для долгосрочных заклинаний
				sleep(10)
				if(horn_light == 30)
					if(nutrition > 2)	nutrition--
					else break
			if(horn_light == 30)
				horn_light = 0
				del C
				cooldown[30] = 1
				spawn(900) cooldown[30] = 0
		update_icons()
