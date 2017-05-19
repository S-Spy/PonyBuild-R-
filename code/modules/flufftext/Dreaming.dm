/obj/effect/landmark/dreams/cementery_spider
	name = "c_spider"

/obj/effect/landmark/dreams/stranger
	var/has_pony = 0
	name = "stranger"

/obj/effect/landmark/dreams/cementery_zombie
	name = "c_zombie"




var/list/dreams = list(
	"an ID card","a bottle","a familiar face","a crewmember","a toolbox","a security officer","the captain",
	"voices from all around","deep space","a doctor","the engine","a traitor","an ally","darkness",
	"light","a scientist","a monkey","a catastrophe","a loved one","a gun","warmth","freezing","the sun",
	"a hat","the Luna","a ruined station","a planet","phoron","air","the medical bay","the bridge","blinking lights",
	"a blue light","an abandoned laboratory","Alia","mercenaries","blood","healing","power","respect",
	"riches","space","a crash","happiness","pride","a fall","water","flames","ice","melons","flying","the eggs","money",
	"the head of personnel","the head of security","a chief engineer","a research director","a chief medical officer",
	"the detective","the warden","a member of the internal affairs","a station engineer","the janitor","atmospheric technician",
	"the quartermaster","a cargo technician","the botanist","a shaft miner","the psychologist","the chemist","the geneticist",
	"the virologist","the roboticist","the chef","the bartender","the chaplain","the librarian","a mouse","an ert member",
	"a beach","the holodeck","a smokey room","a voice","the cold","a mouse","an operating table","the bar","the rain","a alicorn",
	"a unicorn","a pegasus","the ai core","the mining station","the research station","a beaker of strange liquid",
	)

/mob/living/carbon/var/dreaming

mob/living/carbon/proc/dream()
	dreaming = 1

	spawn(0)
		for(var/i = rand(1,4),i > 0, i--)
			src << "\blue <i>... [pick(dreams)] ...</i>"
			sleep(rand(40,70))
			if(paralysis <= 0)
				dreaming = 0
				return 0
		usr:dreaming = 0
		if(ispony(usr))
			if(!home_mob && prob(30))	usr:goto_dream()
		return 1

mob/living/carbon/proc/handle_dreams()
	if(client && !dreaming && prob(5))
		dream()


mob/living/carbon/pony/dreamer

mob/living/carbon/pony/proc/goto_dream(var/time = 0, var/daemon_dream)//antagonist=Странник, зомби, фредди
	if(!time)	time = rand(200, 6000) //20 секунд - 10 минут

	/*Итак, сон, точнее переход в локацию
	1. Находим место, куда перемещаться - ок
	2. Создаем клона с внешностью и именем
	3. Перемещаем сознание и сохраняем оригинал
	4. Активируем таймер


	*/


	//-----Находим место куда перемещаться и резервируем только для одного пони-----
	var/list/target_lands = list()
	for(var/obj/effect/landmark/dreams/stranger/S in world)
		if(!S.has_pony)		target_lands += S//Для начала сделаем сон для одного странника. Потом для остальных



	var/obj/effect/landmark/dreams/stranger/target_land = pick(target_lands)
	if(!target_land)	return
	target_land.has_pony = 1


	//-----Создаем клона с похожей внешностью-----
	var/mob/living/carbon/pony/clone = new/mob/living/carbon/pony(target_land.loc)
	if(!clone)	return

	clone.home_mob = usr

	clone.gender = gender
	clone.languages = languages
	if(!daemon_dream)	clone.silent = 1
	clone.health = 30
	clone.maxHealth = 30
	clone.a_intent = "harm"
	clone.hud_used.action_intent.icon_state = "intent_hurt"
	clone.m_intent = "walk"
	clone.nutrition = 2

	//-----------Внешность-----------
	clone.b_aura = b_aura
	clone.g_aura = g_aura
	clone.r_aura = r_aura
	clone.b_eyes = b_eyes
	clone.g_eyes = g_eyes
	clone.r_eyes = r_eyes
	clone.b_facial = b_facial
	clone.g_facial = g_facial
	clone.r_facial = r_facial
	clone.b_hair = b_hair
	clone.g_hair = g_hair
	clone.r_hair = r_hair
	clone.b_tail = b_tail
	clone.g_tail = g_tail
	clone.r_tail = r_tail
	clone.b_skin = b_skin
	clone.g_skin = g_skin
	clone.r_skin = r_skin
	clone.f_style = f_style
	clone.h_style = h_style
	clone.pony_tail_style = pony_tail_style
	clone.name = name
	clone.voice = name
	clone.flavor_texts = usr:flavor_texts
	clone.flavor_text = flavor_text


	//Даем фонарь, обязательно
	var/obj/item/device/flashlight/lantern/LAMP = new/obj/item/device/flashlight/lantern()
	LAMP.brightness_on = 3
	//LAMP.initialize()
	//if(prob(50))
	clone.put_in_free_hand(LAMP)

	//clone.SetLuminosity(LAMP.brightness_on)
	clone.regenerate_icons()//Обновляем иконку клона
	clone.ckey = ckey

	spawn(0)
		var/subtime = 0
		for()
			clone.home_mob.sleeping = 50

			var/wake_up

			if(!daemon_dream && clone.health < 5)//Если клону плохо и это не демонический сон, то проснуться
				wake_up = 1

			if(clone.health > 5 && time <= subtime)//Если клону хорошо и время вышло, то проснуться. Даже если это демонический сон
				wake_up = 1

			if(wake_up && clone.home_mob)//Если тело осталось, то проснуться
				clone.home_mob.ckey = clone.ckey
				clone.home_mob.sleeping = 5
				del clone

			sleep(50)		//Каждые 5 секунд
			subtime += 50
