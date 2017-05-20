/mob/living/simple_animal/bugangel
	name = "\improper Generallegion"
	desc = "Fallen angel of testing and bugsearching."
	icon = 'icons/mob/Angel.dmi'
	icon_state = "Angel"
	icon_living = "Angel"
	icon_dead = "AngelDead"
	pixel_x = -32

	speak = list("HELP ME I'M STUCK, I'M STUCK!!!","Arhimag, fix this shit!","FUCKING COMMUNICATIONS ISN'T WORKING, AAAAAGH!!","K-k-kill me p-p-please...","I'M GONNA BUG YOUR TINY CODE, YOU FEATURESUCKER!!")
	speak_emote = list("cries","howls","growls")
	emote_hear = list("cries","giggles")
	emote_see = list("shakes his head","laughs like crazy")

	speak_chance = 1//1% (1 in 100) chance every tick; So about once per 150 seconds, assuming an average tick is 1.5s
	turns_per_move = 5

	response_help  = "hugs"
	response_disarm = "gently moves aside"
	response_harm   = "swats"
	stop_automated_movement = 1
	universal_speak = 1

	var/bugangel_sleep_max = 100
	var/bugangel_sleep_dur = 100

	var/bugangel_speed = 5 //"Delay in world ticks between movement." according to byond. Yeah, that's BS but it does directly affect movement. Higher number = slower.

/mob/living/simple_animal/bugangel/death()
	walk(src,0)
	..()

/mob/living/simple_animal/bugangel/proc/spinning()
	for()
		sleep(100)
		var/bugged = rand(0,10)
		if(bugged==10)
			icon_state = "BugAngel"
			sleep(40)
			icon_state = "Angel"

/mob/living/simple_animal/bugangel/New()
	..()
	spinning()