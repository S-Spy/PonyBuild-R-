#define BUGANGEL_PERCH 1		//Sitting/sleeping, not moving
#define BUGANGEL_SWOOP 2		//Moving towards or away from a target
#define BUGANGEL_WANDER 4		//Moving without a specific target in mind

//Intents
#define BUGANGEL_ATTACK 16	//Flying towards a target to attack it
#define BUGANGEL_RETURN 32	//Flying towards its perch
#define BUGANGEL_FLEE 64		//Flying away from its attacker


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

	var/bugangel_state = BUGANGEL_WANDER
	var/bugangel_sleep_max = 100
	var/bugangel_sleep_dur = 100
	var/bugangel_dam_zone = list("chest", "head", "l_arm", "l_leg", "r_arm", "r_leg") //For ponys, select a bodypart to attack

	var/bugangel_speed = 5 //"Delay in world ticks between movement." according to byond. Yeah, that's BS but it does directly affect movement. Higher number = slower.

	var/list/speech_buffer = list()

	//Bugangel will generally sit on their pertch unless something catches their eye.
	//These vars store their preffered perch and if they dont have one, what they can use as a perch
	var/obj/bugangel_perch = null
	var/obj/desired_perches = list(/obj/structure/cultgirder, 		/obj/structure/cult/forge, \
									/obj/structure/cult/pylon,		/obj/structure/cult/talisman, \
									/obj/structure/cult/tome,			/obj/machinery/showcase)

	bugangel_sleep_dur = bugangel_sleep_max //In case someone decides to change the max without changing the duration var

/mob/living/simple_animal/bugangel/death()
	walk(src,0)
	..()

/*
 * Attack responces
 */
//ponys, monkeys, aliens
/mob/living/simple_animal/bugangel/attack_hand(mob/living/carbon/M as mob)
	..()
	if(client) return
	if(!stat && M.a_intent == "hurt")

		icon_state = "BugAngel" //It is going to be flying regardless of whether it flees or attacks
		sleep(40)
		icon_state = "Angel"

		if(bugangel_state == BUGANGEL_PERCH)
			bugangel_sleep_dur = pbugangel_sleep_max //Reset it's sleep timer if it was perched

		bugangel_state = BUGANGEL_SWOOP //The bugangel just got hit, it WILL move, now to pick a direction..

		if(M.health < 95) //Weakened mob? Fight back!
			bugangel_state |= BUGANGEL_ATTACK
		else
			bugangel_state |= BUGANGEL_FLEE		//Otherwise, fly like a bat out of hell!
	return

//Mobs with objects
/mob/living/simple_animal/bugangel/attackby(var/obj/item/O as obj, var/mob/user as mob)
	..()
	if(!stat && !client && !istype(O, /obj/item/stack/medical))
		if(O.force)
			if(bugangel_state == BUGANGEL_PERCH)
				bugangel_sleep_dur = bugangel_sleep_max //Reset it's sleep timer if it was perched

			bugangel_interest = user
			bugangel_state = BUGANGEL_SWOOP | BUGANGEL_FLEE
	return

//Bullets
/mob/living/simple_animal/bugangel/bullet_act(var/obj/item/projectile/Proj)
	..()
	if(!stat && !client)
		if(bugangel_state == BUGANGEL_PERCH)
			bugangel_sleep_dur = bugangel_sleep_max //Reset it's sleep timer if it was perched

		bugangel_interest = null
		bugangel_state = BUGANGEL_WANDER //OWFUCK, Been shot! RUN LIKE HELL!
		bugangel_been_shot += 5
	return


/*
 * AI - Not really intelligent, but I'm calling it AI anyway.
 */
/mob/living/simple_animal/bugangel/Life()
	..()

	//Sprite and AI update for when a bugangel gets pulled
	if(pulledby && stat == CONSCIOUS)
		if(!client)
			bugangel_state = BUGANGEL_WANDER
		return

	if(client || stat)
		return //Lets not force players or dead/incap bugangels to move

	if(!isturf(src.loc) || !canmove || buckled)
		return //If it can't move, dont let it move. (The buckled check probably isn't necessary thanks to canmove)


//-----SLEEPING
	if(bugangel_state == BUGANGEL_PERCH)
		if(bugangel_perch && bugangel_perch.loc != src.loc) //Make sure someone hasnt moved our perch on us
			if(bugangel_perch in view(src))
				bugangel_state = BUGANGEL_SWOOP | BUGANGEL_RETURN
				return
			else
				bugangel_state = BUGANGEL_WANDER
				return

		if(--bugangel_sleep_dur) //Zzz
			return

		else
			//This way we only call the stuff below once every [sleep_max] ticks.
			bugangel_sleep_dur = bugangel_sleep_max

			return

//-----WANDERING - This is basically a 'I dont know what to do yet' state
	else if(bugangel_state == BUGANGEL_WANDER)
		//Stop movement, we'll set it later
		walk(src, 0)

		//Wander around aimlessly. This will help keep the loops from searches down
		//and possibly move the mob into a new are in view of something they can use
		if(prob(90))
			step(src, pick(cardinal))
			return

		else //Have an item but no perch? Find one!
			bugangel_perch = search_for_perch()
			if(bugangel_perch)
				bugangel_state = BUGANGEL_SWOOP | BUGANGEL_RETURN
				return

//-----RETURNING TO PERCH
	else if(bugangel_state == (BUGANGEL_SWOOP | BUGANGEL_RETURN))
		walk(src, 0)
		if(!bugangel_perch || !isturf(bugangel_perch.loc)) //Make sure the perch exists and somehow isnt inside of something else.
			bugangel_perch = null
			bugangel_state = BUGANGEL_WANDER
			return

		if(in_range(src, bugangel_perch))
			src.loc = bugangel_perch.loc
			bugangel_state = BUGANGEL_PERCH
			return

		walk_to(src, bugangel_perch, 1, bugangel_speed)
		return

//-----FLEEING
	else if(bugangel_state == (BUGANGEL_SWOOP | BUGANGEL_FLEE))
		walk(src,0)
		if(!bugangel_interest || !isliving(bugangel_interest)) //Sanity
			bugangel_state = BUGANGEL_WANDER

		walk_away(src, bugangel_interest, 1, bugangel_speed-bugangel_been_shot)
		bugangel_been_shot--
		return

//-----ATTACKING
	else if(bugangel_state == (BUGANGEL_SWOOP | BUGANGEL_ATTACK))

		//If we're attacking a nothing, an object, a turf or a ghost for some stupid reason, switch to wander
		if(!bugangel_interest || !isliving(bugangel_interest))
			bugangel_interest = null
			bugangel_state = BUGANGEL_WANDER
			return

		var/mob/living/L = bugangel_interest

		//If the mob is close enough to interact with
		if(in_range(src, bugangel_interest))

			//If the mob we've been chasing/attacking dies or falls into crit, check for loot!
			if(L.stat)
				if(bugangel_perch in view(src)) //If we have a home nearby, go to it, otherwise find a new home
					bugangel_state = BUGANGEL_SWOOP | BUGANGEL_RETURN
				else
					bugangel_state = BUGANGEL_WANDER
				return

			//Time for the hurt to begin!
			var/damage = rand(20,30)

			if(ispony(bugangel_interest))
				var/mob/living/carbon/pony/H = bugangel_interest
				var/datum/organ/external/affecting = H.get_organ(ran_zone(pick(bugangel_dam_zone)))

				H.apply_damage(damage, BRUTE, affecting, H.run_armor_check(affecting, "melee"), sharp=1)
				visible_emote(pick("pecks [H]'s [affecting].", "cuts [H]'s [affecting] with its talons."))

			else
				L.adjustBruteLoss(damage)
				visible_emote(pick("crushes [L].", "slashes [L]."))
			return

		//Otherwise, fly towards the mob!
		else
			walk_to(src, bugangel_interest, 1, bugangel_speed)
		return
//-----STATE MISHAP
	else //This should not happen. If it does lets reset everything and try again
		walk(src,0)
		bugangel_interest = null
		bugangel_perch = null
		drop_held_item()
		bugangel_state = BUGANGEL_WANDER
		return

/*
 * Procs
 */

/mob/living/simple_animal/bugangel/movement_delay()
	if(client && stat == CONSCIOUS && bugangel_state != "parrot_fly")
		icon_state = "parrot_fly"
	..()

/mob/living/simple_animal/bugangel/proc/search_for_perch()
	for(var/obj/O in view(src))
		for(var/path in desired_perches)
			if(istype(O, path))
				return O
	return null


/*
 * Verbs - These are actually procs, but can be used as verbs by player-controlled bugangels.
 */

/mob/living/simple_animal/bugangel/proc/perch_player()
	set name = "Sit"
	set category = "bugangel"
	set desc = "Sit on a nice comfy perch."

	if(stat || !client)
		return

	if(icon_state == "parrot_fly")
		for(var/atom/movable/AM in view(src,1))
			for(var/perch_path in desired_perches)
				if(istype(AM, perch_path))
					src.loc = AM.loc
					icon_state = "parrot_sit"
					return
	src << "\red There is no perch nearby to sit on."
	return