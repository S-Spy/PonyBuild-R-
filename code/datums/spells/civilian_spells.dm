//H.spell_list += new /obj/effect/proc_holder/spell/targeted/projectile/magic_missile(H)

/mob/living/carbon/pony/proc/update_unicorn_verbs()
	return/*
	for(var/type in typesof(/datum/spells)-/datum/spells)
		var/datum/spells/S = new type()
		if(!(S.spell_name in unicorn_spells))
			verbs -= S.spell_verb*/

/*
1. Спеллы мага и единорогов должны быть одного рода
Следовательно, нужна переменная "обычности"

2. В обычных заклинаниях идет проверка на концентрацию
3. Должна быть общая функция активного спелла(Обычного)

Процесс получения заклинаний для мага и обычных:
1. Если это civilian, то добавить через setup, но только те, которые не ограничены тегом (ONLYBOOKS)
2. Все можно получить через книгу за SP. У мага-антагониста +30 к SP и заклинания изначально обнуляются, так как он обладает техникой управления памятью
3. Прежде чем добавить заклинание, нужно изучить необходимую школу(1-5 SP)
4. Знание школы не добавляет заклинаний. Только теорию о ней, что позволит изучение заклинаний из книг
5. Стоимость заклинания = уровень концентрации(Для магов это влияет только на количество заклинаний(Еще у них действует шанс крита). Иначе на шанс успеха) * стоимость школы * маг?1|2(Нет|Да)
6. Уровни концентрации разнятся от 1 до 8. 8 - Божественный уровень, только в особых случаях. 7 только через книги. 6 очень редкое...
7. Заклинания делятся на AOE и TARGETED(Себя или другиз). AOE требуют концентрацию уровнем не ниже 3 и для civilian реже, чем для мага
8. Не CIVILIAN заклинания чаще всего требуют произношения заклинаний. CIVILIAN всегда безмолвны. За исключением тех, что можно выучить через книги, да и то не всегда
9. Так же, заклинания делятся на затрачиваемые(Вроде кражи душ) и перезаряжаемые. Перезаряжаемые CIVILIAN делятся на долгосрочные(Невозможно использовать другие CIVILIAN заклинания) и краткосрочные(То же, что и долгосрочные, но на 2-3 секунды)
10. Заклинания для немагов тратят нутриенты*уровень концентрации. Для магов тратится мана*концентрация
11. Для магов иногда требуется особая артефактная одежда
12. Для магов доступны заклинания поглощения, навроде кражи здоровья
13. Книжные или визардовские заклинания могут издавать искры
14. Для магов расстояние заклинаний доступно до 7 метров. Для немагов максимум до 5
15. Все заклинания могут обладать спрайтами из 'icons/obj/wizard.dmi
16. Заклинания могут быть совместными. Но это отдельно. Требуется концентрация минимум 3





*/
/*Школы:
Деформация (Abjuration): магия защиты и атаки.
Призыв (Conjuration): призывает и телепортирует существ и объекты.
Ворожба (Divination): усиление знаний и характеристик.
Очарование (Enchantment): манипулирует сознанием.
Проявление (Evocation): контролирует магическую энергию.
Иллюзия (Illusion): создает обманные эффекты и изображения.
Некромантия (Necromancy): магия нежити, смерти и высасывания физических характеристик.
Превращение (Transmutation): манипулирует физическими телами и объектами.
http://www.ddonline.ru/con1879.html
*/



/obj/effect/proc_holder/spell/targeted/civilian//Свет доступен по умолчанию
	name = "Light"
	desc = "Light about your horn."

	school = "evocation" //Название школы. Пока не использовалось
	spell_level = 1
	cooldown = 10


	charge_type = "recharge" //can be recharge or charges, see charge_max and charge_counter descriptions; can also be based on the holder's vars now, use "holder_var" for that

	charge_max = null//время перезарядки в мс если charge_type = "recharge" или начинает зарядку если charge_type = "charges"
	charge_counter = 0 //can only cast spells if it equals recharge, ++ each decisecond if charge_type = "recharge" or -- each cast if charge_type = "charges"

	holder_var_type = "bruteloss" //используется только если charge_type = "holder_var"
	holder_var_amount = 20 //same. The amount adjusted with the mob's var when the spell is used

	clothes_req = 0 //Нужна ли одежда мага
	stat_allowed = 0 //see if it requires being conscious/alive, need to set to 1 for ghostpells
	invocation = null //Что говорит маг при кастовании
	invocation_type = "none" //Может быть none, whisper и shout
	range = 5 //Расстояние действия заклинания; радиус действия массового(aoe) заклинания spells
	message = "" //whatever it says to the guy affected by it
	selection_type = "view" //Может быть "range" или "view"

	overlay = 0
	overlay_icon = 'icons/obj/wizard.dmi'
	overlay_icon_state = "spell"
	overlay_lifespan = 0

	sparks_spread = 0
	sparks_amt = 0 //cropped at 10
	smoke_spread = 0 //1 - harmless, 2 - harmful
	smoke_amt = 0 //cropped at 10

	critfailchance = 0

	New()
		..()
		if(!charge_max)
			charge_max = level*level*20


/obj/effect/proc_holder/spell/targeted/civilian/light
	name = "Light"
	desc = "Light about your horn."

	spell_level = 1
	cooldown = 250

	cast()//list/targets
		usr.SetLuminosity(luminosity+1)

	spell_off(user)
		SetLuminosity(luminosity-1)
		..()


/obj/effect/proc_holder/spell/targeted/civilian/strong_light
	name = "Strong Light"
	desc = "Intensive light aura about you."

	spell_level = 2
	cooldown = 250

	cast()//list/targets
		usr.SetLuminosity(luminosity+3)

	spell_off(user)
		SetLuminosity(luminosity-3)
		..()

/obj/effect/proc_holder/spell/targeted/civilian/teleport_cleaner
	name = "Cleaner Teleport"
	desc = "Teleport this inks to the space!"

	//school =
	spell_level = 3

	cast()//list/targets
		var/obj/item/weapon/reagent_containers/spray/cleaner/H = new/obj/item/weapon/reagent_containers/spray/cleaner
		H.Spray_at(usr, usr, 1)
		del H


/obj/effect/proc_holder/spell/targeted/civilian/tele_liquid
	name = "Tele liquid"
	desc = "Liquid telekinesis"

	spell_level = 2
	cooldown = 200
	var/obj/item/weapon/reagent_containers/glass/G

	cast()//list/targets
		var/mob/living/carbon/pony/user = usr
		G = new/obj/item/weapon/reagent_containers/glass
		var/icon/I = new/icon(G.icon, G.icon_state)
		I.Blend(rgb(user.r_aura, user.g_aura, user.b_aura), ICON_ADD)
		G.icon = I
		G.alpha = 100
		G.Move(locate(x, y, z))
		G.name = "Tele [name]"
		if(usr.free_hand())
			usr.put_in_free_hand(G)

	spell_off(user)
		var/obj/O = locate(/turf) in G.loc
		G.afterattack(O, usr, 1)
		del G
		..()

/obj/item/weapon/light_spark
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "light"
	alpha = 200
	luminosity = 2

/obj/effect/proc_holder/spell/targeted/civilian/dist_light
	name = "Distance light"
	desc = "Remote light ball"

	spell_level = 3
	cooldown = 300
	var/obj/item/weapon/light_spark/L

	cast()//list/targets
		var/mob/living/carbon/pony/user = usr
		L = new/obj/item/weapon/light_spark
		var/icon/I = new/icon(L.icon, L.icon_state)
		I.Blend(rgb(user.r_aura, user.g_aura, user.b_aura))
		L.icon = I
		L.Move(locate(x, y, z))
		if(usr.free_hand())
			usr.put_in_free_hand(L)

	spell_off(user)
		del L
		..()

/obj/effect/proc_holder/spell/targeted/civilian/hair_transform
	name = "Hair Morph"
	desc = "Transform your hair's."

	spell_level = 4

	cast()//list/targets
		var/mob/living/carbon/pony/P = usr
		var/mob/living/carbon/pony/user = usr
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
			valid_facial += H.name
		for(var/path in typesof(/datum/sprite_accessory/pony_tail) - /datum/sprite_accessory/pony_tail)
			var/datum/sprite_accessory/pony_tail/H = new path()
			if(P.gender == MALE && H.gender == FEMALE)	continue
			if(P.gender == FEMALE && H.gender == MALE)	continue
			if(!(P.species.name in H.species_allowed))	continue
			valid_tail += H.name

		if(prob(user.concentration(level)))	P.f_style = pick(valid_facial)
		if(prob(user.concentration(level)))	P.h_style = pick(valid_hair)
		if(prob(user.concentration(level)))	P.pony_tail_style = pick(valid_tail)
		P.update_icons()


/obj/effect/proc_holder/spell/targeted/civilian/hot_aura
	name = "Hot Aura"
	desc = "Heating food, ponies and sometime you."

	spell_level = 3
	var/list/Li = list()

	cast()//list/targets
		for(var/atom/A in view(1))
			if(istype(A, /obj/item/weapon/reagent_containers/food) || istype(A, /mob/living/carbon/pony))
				Li += A
		var/target = input(usr, "Choose your target", "Target")  as null|anything in Li
		if(istype(target, /obj/item/weapon/reagent_containers/food))
			target:heat_food(target:heating+1)
		else
			target:bodytemperature += 5
		usr.nutrition -= 20


/obj/effect/proc_holder/spell/targeted/civilian/cold_aura
	name = "Cold Aura"
	desc = "Makes ponies to 20% cooler... Khm, colder."

	spell_level = 3
	var/list/Li = list()

	cast()//list/targets
		for(var/mob/living/carbon/pony/P in view(1))
			Li += P
		var/target = input(usr, "Choose your target", "Target")  as null|anything in Li
		target:bodytemperature -= 10
		usr.nutrition -= 20


/obj/effect/proc_holder/spell/targeted/civilian/concentrate
	name = "High concentration"
	desc = "Very high concentration of your mind for strong spells."

	spell_level = 6
	var/LC = 0

	cast()//list/targets
		var/mob/living/carbon/pony/user = usr
		if(!user.concentrate_mod)
			user.nutrition -= 70
			user.concentrate_mod = 1
			LC = 1
			spawn(1)	for(var/i=1, i < 300, i++)
				sleep(10)
				if(user.nutrition > 50 && user.concentrate_mod)
					user.nutrition--
				else
					LC = 0
					spell_off()
		else
			LC = 0
			spell_off()

	spell_off()
		..()
		if(LC)	name = "High concentration \[ACTIVE\]"
		else
			var/mob/living/carbon/pony/user = usr
			user.concentrate_mod = 0



/*
/obj/effect/proc_holder/spell/targeted/civilian/fruit_transform
	name = "Organic transformation"
	desc = "Banana to potato, yeah."

	spell_level = 5

	cast()
		G = new(G.loc, pick("chili", "potato", "tomato", "apple", "banana", "mushrooms", "plumphelmet", "towercap", "harebells", "poppies", "sunflowers", "grapes", "peanut", "cabbage", "corn", "carrot", "whitebeet", "watermelon", "pumpkin", "lime", "lemon", "orange", "ambrosia"))
		if(prob(50))	del G*/


/obj/effect/proc_holder/spell/targeted/civilian/health_scan
	name = "Health scan"
	desc = "Analogy of using health analyzer."

	spell_level = 2

	cast()//list/targets
		var/list/mob/living/carbon/mobs = list()
		for(var/mob/living/carbon/M in view(1))
			if(M != usr)	mobs += M//Нерф магов
		var/mob/living/carbon/M = input(usr, "Choose your target", "Target")  as null|anything in mobs
		var/obj/item/device/healthanalyzer/H = new/obj/item/device/healthanalyzer
		H.attack(M, usr)
		del H

/*/obj/effect/proc_holder/spell/targeted/civilian/organ_scan
	name = "Organ analyze"
	desc = "Analogy of using organ analyzer."

	level = 3

	cast()//list/targets
		for(var/mob/living/carbon/M in view(1))
			if(M != usr)	mobs += M//Нерф магов
		var/mob/living/carbon/M = input(usr, "Choose your target", "Target")  as null|anything in mobs
		var/obj/item/device/healthanalyzer/H = new/obj/item/device/healthanalyzer
		H.attack(M, usr)
		del H*/

/obj/effect/proc_holder/spell/targeted/civilian/heel_bleeding
	name = "Heel bleeding"
	desc = "Analogy of bandages."

	spell_level = 5

	cast()//list/targets
		var/list/mob/living/carbon/mobs = list()
		for(var/mob/living/carbon/M in view(1))//Таргетирование можно сделать через общий код
			if(M != usr)	mobs += M//Нерф магов
		var/mob/living/carbon/M = input(usr, "Choose your target", "Target")  as null|anything in mobs
		var/obj/item/stack/medical/bruise_pack/B = new/obj/item/stack/medical/bruise_pack
		B.attack(M, usr)
		del B

/obj/effect/proc_holder/spell/targeted/civilian/notpain
	name = "Pain relief"
	desc = "Easing of pain."

	spell_level = 5

	cast()//list/targets
		var/list/mob/living/carbon/mobs = list()
		for(var/mob/living/carbon/M in view(1))//Таргетирование можно сделать через общий код
			if(M != usr)	mobs += M//Нерф магов
		var/mob/living/carbon/M = input(usr, "Choose your target", "Target")  as null|anything in mobs
		M.reagents.add_reagent("tramadol", 3)
		M.reagents.add_reagent("adrenalin", 1)

/obj/effect/proc_holder/spell/targeted/civilian/light_heal
	name = "Light heal"
	desc = "Little heel for anything creatures."

	level = 4

	cast()//list/targets
		var/list/mob/living/carbon/mobs = list()
		for(var/mob/living/carbon/M in view(1))//Таргетирование можно сделать через общий код
			if(M != usr)	mobs += M//Нерф магов
		var/mob/living/carbon/M = input(usr, "Choose your target", "Target")  as null|anything in mobs
		M.apply_damages(-5, -5)


/*
/mob/living/carbon/pony/verb

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
		update_icons()*/
