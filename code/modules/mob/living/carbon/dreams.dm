mob/living/carbon/pony/dreamer


mob/living/carbon/proc/goto_dream(var/time = 0, var/unsleep = 0, var/number = 0, var/antagonist = 0)//Странник, зомби, фредди
	if(number < 1 || number > 6)	number = rand(1, 6)
	if(time < 1)	time = rand(200, 6000)
	var/list/target_land = list()
	switch(number)
		if(1)	for(var/obj/effect/landmark/dreams/stranger1/S in world)	target_land += S
		if(2)	for(var/obj/effect/landmark/dreams/stranger2/S in world)	target_land += S
		if(3)	for(var/obj/effect/landmark/dreams/stranger3/S in world)	target_land += S
		if(4)	for(var/obj/effect/landmark/dreams/stranger4/S in world)	target_land += S
		if(5)	for(var/obj/effect/landmark/dreams/stranger5/S in world)	target_land += S
		if(6)	for(var/obj/effect/landmark/dreams/stranger6/S in world)	target_land += S
	var/mob/living/carbon/pony/user = new/mob/living/carbon/pony
	if(unsleep == 1)
		user = usr
		goto End
	user.home_mob = usr
	user.gender = gender
	user.languages = languages
	user.silent = 1
	user.health = 30
	user.maxHealth = 30
	user.a_intent = "harm"
	user.m_intent = "walk"
	user.nutrition = 2
	if(ispony(usr))
		user.b_aura = usr:b_aura
		user.g_aura = usr:g_aura
		user.r_aura = usr:r_aura
		user.b_eyes = usr:b_eyes
		user.g_eyes = usr:g_eyes
		user.r_eyes = usr:r_eyes
		user.b_facial = usr:b_facial
		user.g_facial = usr:g_facial
		user.r_facial = usr:r_facial
		user.b_hair = usr:b_hair
		user.g_hair = usr:g_hair
		user.r_hair = usr:r_hair
		user.b_ptail = usr:b_ptail
		user.g_ptail = usr:g_ptail
		user.r_ptail = usr:r_ptail
		user.b_skin = usr:b_skin
		user.g_skin = usr:g_skin
		user.r_skin = usr:r_skin
		user.f_style = usr:f_style
		user.h_style = usr:h_style
		user.ptail_style = usr:ptail_style
		user.name = name
		user.voice = name
		user.flavor_texts = usr:flavor_texts
		user.flavor_text = flavor_text
	else
		user.b_aura = rand(1,250)
		user.g_aura = rand(1,250)
		user.r_aura = rand(1,250)
		user.b_eyes = rand(1, 120)
		user.g_eyes = rand(1, 120)
		user.r_eyes = rand(1, 120)
		user.b_facial = rand(1, 190)
		user.g_facial = rand(1, 190)
		user.r_facial = rand(1, 190)
		user.b_hair = user.b_facial
		user.g_hair = user.g_facial
		user.r_hair = user.r_facial
		user.b_ptail = user.b_facial
		user.g_ptail = user.g_facial
		user.r_ptail = user.r_facial
		user.b_skin = rand(1, 240)
		user.g_skin = rand(1, 240)
		user.r_skin = rand(1, 240)
		user.f_style = "Shaved"
		user.h_style = "Vinyl Hair"
		user.ptail_style = "Short Tail"
		user.name = "Stranger"
	var/obj/item/device/flashlight/lantern/LAMP = new/obj/item/device/flashlight/lantern
	LAMP.brightness_on = 3
	LAMP.initialize()
	if(prob(50))	user.l_hand = LAMP
	else	user.r_hand = LAMP

	user.SetLuminosity(LAMP.brightness_on)
	user.regenerate_icons()
	End
	var/mob/living/carbon/P = user.home_mob
	user.ckey = ckey
	spawn(time)
		if(user && P && !P.ckey)
			P.ckey = user.ckey
			P.sleeping = 1
			del user
		else
			user.silent = 0
