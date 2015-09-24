mob/living/carbon/var/home_mob
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
	var/mob/living/carbon/pony/user = new/living/carbon/pony
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
		user.b_aura = b_aura
		user.g_aura = g_aura
		user.r_aura = r_aura
		user.b_eyes = b_eyes
		user.g_eyes = g_eyes
		user.r_eyes = r_eyes
		user.b_facial = b_facial
		user.g_facial = g_facial
		user.r_facial = r_facial
		user.b_hair = b_hair
		user.g_hair = g_hair
		user.r_hair = r_hair
		user.b_ptail = b_ptail
		user.g_ptail = g_ptail
		user.r_ptail = r_ptail
		user.b_skin = b_skin
		user.g_skin = g_skin
		user.r_skin = r_skin
		user.f_style = f_style
		user.h_style = h_style
		user.ptail_style = ptail_style
		user.name = name
		user.voice = name
		user.flavor_texts = flavor_texts
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
		user.b_hair = b_facial
		user.g_hair = g_facial
		user.r_hair = r_facial
		user.b_ptail = b_facial
		user.g_ptail = g_facial
		user.r_ptail = r_facial
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
	user.SetLuminosity(brightness_on)
	user.ckey = ckey
	user.regenerate_icon()
	End
	spawn(time)
		if(user && user.home_mob && !user.home_mob.ckey)
			user.home_mob.ckey = user.ckey
			del user
