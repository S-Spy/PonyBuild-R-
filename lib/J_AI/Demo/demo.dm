
turf
	icon='icons.dmi'
	tree
		icon_state="tree"
		opacity=1
		density=1
	grass
		icon_state="grass"
	rock
		icon_state="rock"
		density=1
	start_spot
		icon_state="spawn"
	wall
		icon_state="wall"
		density=1
	walltop
		icon_state="walltop"
		density=1



world
	mob = /mob/Player  //setting the default mob



client
	view = "15x15"  //setting how far a player can see


/*
  MSG - this is the login message, change it to what ever you want your players to see when they
   login.
*/
var/MSG = {"<b><h3>
Welcome to J_AI created by Johan411. this libary includes a wide varity of AI tools / procedures
and miscellaneous things to create a very good AI system
"}




mob/Player//default mob

	var/ticker=0//a varible to count ticks, when this varible is higher or equal to 20 it will restore hp

	icon = 'icons.dmi'
	icon_state = "player"
	Alignment = "Good"



	New()
		underlays += image('icons.dmi',icon_state="shadow",pixel_y=-3)//add character shadow as a underlay/image
		..()


	Login()
		loc = locate(/turf/start_spot)
		src << MSG
		src << "\n"
		J_showbars(src)
		J_update(src)
		..()


	Logout()
		del(src)
		..()


	Bump(atom/T)
		if(istype(T,/mob/Monster))
			if(bump_attack)
				Attack()
			else step(T,dir)
		else if(isobj(T)) three_steps(T,dir)
		..()


	Move()
		if(moved) return//if mob moved stop code
		moved = 1//setting moved to one to tell the code that mob has moved and cannot move agian until delay has ended
		spawn(move_delay)
			moved = 0
		..()
		if(shopping) shopping=0



	Stat()
		if(attacked) ticker = 0//if your fighting reset the ticker so you cannot gain hp in combat
		else ticker++//add to the ticker varible if not attacking

		if(ticker >= 20)//restoreing hp overtime by counting ticker varible
			hp+=rand(20, 30)//add 20 to 30 health
			ticker = 0
			J_update(src)
		if(hp>hpmax) hp = hpmax

		statpanel("[src.name]")
		src.suffix="<font color=blue>(Level: [lvl])"
		stat(src)
		stat("HP:","[hp]/[hpmax]")
		stat("Attack:","[att] + [att_boost]")
		stat("Strength:","[str] + [str_boost]")
		stat("Defence:","[def] + [def_boost]")
		stat("Experience:","([xp] / [xpmax])")
		stat("")
		stat("Created by Johan411")
		statpanel("J_AI World")
		stat("CPU:","[world.cpu]")
		if(shopping)
			statpanel("Shop")
			stat(shop_list)




	verb
		Attack()//Attack verb for players
			set category = "Combat"//the category is named combat this verb will reside there on the info panel in the interface
			for(var/mob/Monster/M in get_step(src,src.dir))//if mob/Monster is in your direction
				J_Attack(M)//Attack it
				break//break loop


		J_walk()//make monsters walk arround
			set category = "NPC"
			world << "<code><b><center>Making NPC's walk randomly"
			for(var/mob/Monster/M in world)
				M.target = null
				M.active = 0
				M.walk_back = 0


		J_walk_back()//make monsters walk back
			set category = "NPC"
			world << "<code><b><center>Making NPC's walk back"
			for(var/mob/Monster/M in world)
				if(M.active) return
				M.target = null
				M.walk_back = 1
				M.J_WB()


		Summon(mob/M in world)
			set category = "NPC"
			M.loc = usr.loc


		Freeze(mob/M in world)
			set category="NPC"
			if(M.froze)
				M.froze=0
			else
				M.froze=1

		Change_Attack_Effect()
			set category="Effects"
			Attack_Effect=input("Select an effect","Attack Effect")in list("Nothing","flame","freeze")

mob
	Monster
		Deer
			hp=200
			hpmax=200
			icon='icons.dmi'
			icon_state="deer"
			is_coward=1
		Dog
			attack_delay = 15
			xp_give = 15
			icon='icons.dmi'
			icon_state="beast"
		Guard
			attack_delay = 15
			hp=300
			hpmax=300
			str=50
			def=50
			att=20
			xp_give = 500
			icon='icons.dmi'
			icon_state="guard"
			Alignment = "Good"
			Attacks = "Bad"
			Attack_View = 5
			auto_movement = 0
			Protector = 1
		Wolf
			attack_delay = 10
			xp_give = 30
			icon='icons.dmi'
			icon_state="badguy"
			Alignment = "Bad"
			Attacks = "Good"
			Attack_View = 3

		Randomguy
			icon='icons.dmi';icon_state="guy"
			speaks=1
			scripts=list("Leave me alone!","Uhhhg you are an UGLY dude","*Laughs*","*Taunts you*")
			New()
				..()
				name=pick(list("Weird guy","Alan","Gorge","Captian Planet"))

		Shop
			icon='icons.dmi'; icon_state="girl"
			contents=list()//add shop items here
			speaks=1
			is_shop=1
			scripts=list("Welcome to my store!","Hiya adventurer!","Feel free to browse")

obj
	ball
		icon='icons.dmi'
		icon_state="ball_obj"
		density=1


/*
 Disable weird movements.
*/
client
	Northeast()
		return
	Northwest()
		return
	Southeast()
		return
	Southwest()
		return