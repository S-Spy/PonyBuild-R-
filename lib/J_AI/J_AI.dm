//////////////////////////////////// J_AI ////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////
////////////////////////ANOTHER Libary by Johan411//////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
///////////////////////Enjoy it no credit needed but appreciated//////////////////

world/loop_checks=0


var/CAN_NPC_LEVEL=1//Set to zero to make it so npc's cannot level up

var/Activated_Range = 15 //The distance between player and NPC before its activated


mob/var
	tmp/froze=0 //If set to 1 mob cannot move
	lvl=1
	att=10
	str=5
	def=5
	hp=100
	hpmax=100
	xp=0
	xpmax=50
	xp_give=5 // This is how much xp a mob gives after killed


	bump_attack=1 //Set to zero to turn off bump attacks for players
	auto_movement=1 //Set to zero to make the mob not automatically walk


/*
thought i would add stat boosters for items/equipment spells etc use at your leasure
*/
	att_boost=0//increased by items and effects
	str_boost=0
	def_boost=0

	Alignment="Nuteral"

/*
	Attacks (Varible)
	 Default Value - "None" Set to None so mobs don't auto attack things on sight
	 Good - Auto attack mobs with "Good" Alignment
	 Bad - Auto attack mobs with Bad alignment
*/

	Attacks = "None"
	Attack_View = 5 // If the mob auto attacks this is the range it is able to.
	Protector = 0 //Set to zero if you don't want the mob to protect players


/*
	is_coward
		If set to 1 the mob won't attack people and will run away if attacked
*/
	is_coward=0

/*
Settings varibles for starting location
*/

mob/var/tmp
	start_x
	start_y
	start_z
	start_dir


/*
I would recommend keeping the varibles below temporary
*/

	move_delay=1.6
	moved=0

	attack_delay=5
	attacked=0

/*
(active) toggle varible 1 to 0 if the mob is active doing something
*/
	active=0
/*
(walk_back) toggle varible if the mob is walking back to there starting point
*/
	walk_back=0
/*
(tries) var to see how many times mob has tried to walk to starting point
*/
	tries=0

/*
(dead) a varible to see if that mob is currently dead
*/
	dead=0

/*
(respawns) set to zero if you want that mob to delete when they die
- Comes in good if you have a create mob verb and you dont want them to respawn
*/

	respawns=1

/*
  J_AI()
    * Usage - This activates the mob to make it come after you and cuase the Bump()
      Which allows the mob to attack you.
*/


mob/proc
	J_AI()
		var/mob/Monster/M = src
		if(active)
			return
		active=1
		var/fighter = 1
		spawn()
			while(fighter)
				if(!target)
					active = 0
					fighter = 0
					break

				if(!froze)
					if(is_coward)
						if(target in view(Attack_View, src))
							step_away(src,target,5)
						else
							target=null
							active=0
							fighter=0
							break
					else
						if(target in view(Attack_View, src))
							walk_to(src, target, 1, move_delay)
							if(target in view(1))
								dir = get_dir(src, target)
								step_towards(src, target)
						else
							if(!ishome())
								target=null
								active=0
								fighter=0
								walk_back=1
								M.J_WB()
								break
				else
					walk(src, 0)
				sleep(move_delay)



/*
 After killing a mob J_Level() will be called if you have the proper xp
*/

	J_Level()
		if(!CAN_NPC_LEVEL)
			if(!client) return
		if(xp >= xpmax)
			xp = 0
			xpmax += 100//Increase how much experience is needed to level up agian.
			lvl++
			//Increase varibles by random digits
			hpmax += rand(15, 20)
			str += rand(5, 7)
			def += rand(4, 6)
			att += rand(2, 3)

			hp = hpmax
			src<<"<b>You have been promoted to level [lvl]!"
			J_update(src)
			if(xp >= xpmax) J_Level()//If you can level up agian do it



/*
  J_dienpc()
   * Usage - A special made death proc made for mobs without clients attached.
*/

	J_dienpc()
		if(!respawns)
			del(src)
		else
			loc = locate(0,0,0)
			dead = 1
			spawn(100)
				dead = 0
				walk(src, 0)
				hp = hpmax
				target = null
				active = 0
				walk_back = 0
				loc=locate(start_x ,start_y ,start_z)
				dir=start_dir
				J_update(src)
				world<<"[src.name] has respawned."





/*
  J_Death()
   * Usage - the main procedure for death, this basically kills your player or npc that you killed
     , It also determines weather the mob that died had a client attached and does the appropriate procedure for death.

*/

	J_Death(mob/killer)
		/*Sends a message to view to let people know who and what killed a mob*/
		view()<<"\red <center><code>[src.name] has died by the hands of [killer.name]!!!"
		make_corpse(src)
		src.dead=1

/*Resets the target and also the target sign*/

		killer.target = null
		if(killer.target_sign) del(killer.target_sign)

		/*Adds xp and calls J_Level() if you have enough xp*/
		killer.xp += xp_give
		killer<<"<small>You have gained [xp_give] experience."
		if(killer.xp >= killer.xpmax) killer.J_Level()

		if(!killer.client)
			var/mob/Monster/M=killer
			M.target=null
			M.active=0
			M.walk_back=1
			M.J_WB()
/*Determines if the mob dieing has a client attached*/
		if(!client)
			src.J_dienpc()//send special procedure for Monster dieing
		else
			//this is where you would add a special procedure for dieing for players
			//I have not created one yet i will get to it in future updates.

			hp = hpmax//reset hp to max

			loc = locate(/turf/start_spot)//send you to your starting location

			J_update(src)//update src's meters

			src.dead=0




/*
  J_Attack()
   * Usage - The procedure called to start an attack.
*/
	J_Attack(mob/M)
		if(attacked)//if mob already attacked then return to stop them from attacking
			return
		flick("[icon_state]_att",src)
		attacked=1

		if(!target) J_Target(src,M)//if src doesnt already have a target asign one

		if(J_getatt(M))//a chance to land a hit calculated by lvl's and att varibles


			var/_dmg = J_getdmg(M)//call J_getdmg(target) to calculate dmg

			if(_dmg>0)//If the calculated damage is higher than zero
				M<<"\red <small>[src.name] has delt [_dmg] to you."
				src<<"\red <small>You have delt [_dmg] to [M.name]."
				M.hp-=_dmg
				Attack_Effect(src,M)

				if(M.hp <= 0)
					M.J_Death(src)
				else
					J_update(M)
					if(M.target != src)
						J_Target(M ,src)
					if(!M.client)
						M.J_AI()
			else
				M<<"[src.name] tried to attack you but missed."
				src<<"You tried to attack [M.name] but you missed."

		else//if J_getatt failed to prob
			M<<"[src.name] tried to attack you but missed."
			src<<"You tried to attack [M.name] but you missed."

		spawn(attack_delay)//a delay for your attack_speed var
			attacked=0//set to zero so you can attack agian




/*
  J_getdmg()
   * Usage - Calculates damage keeping in mind mobs str and str_boost and the mob your attacking
     def and def_boost varible.
     Updated!
        If the mob attacking is behind the target, there will be a damage boost
*/

	J_getdmg(mob/T)
		var/dmg=rand( (3*(str+str_boost)) ,(6*(str+str_boost)) )
		dmg-=round(rand((0.3*(T.def+T.def_boost)),(0.8*(T.def+T.def_boost))))
		if(T.dir == dir) dmg+=rand(10, 20)
		if(dmg<0) dmg=0
		return dmg


/*
  J_getatt()
   * Usage - Calculates a mobs chance to land a hit increased by the att varible also level caps
     Can either lower or higher your chance to land an attack.
*/


	J_getatt(mob/T)
		var/chance=(att + att_boost)
		var/do_it = 0
		if(T.lvl-3 > lvl)
			chance -= 10
		if(lvl > T.lvl+3)
			chance += 10
		if(lvl+5 > T.lvl)
			chance += 50
		if(prob(chance))
			do_it=1
		return do_it



/*
  ishome()
   * Usage - Checks a mobs starting location varibles to see if they match up with the current
     location.
*/


	ishome()
		var/home = 0
		if(x == start_x)
			if(y == start_y)
				if(z == start_z)
					home=1
		return home





mob/Monster//change /mob/Monster to your NPC path
	proc

/*
  set_start()
   * Usage - sets a mobs starting x, y, z and direction
*/

		set_start()
			start_x = x
			start_y = y
			start_z = z
			start_dir = dir



/*
   JAI_walk()
    * Usage - just a little simple walking script i threw together
      You can add more directions in the list/steps() to add more options
      Updated! this loop also checks to see if the mob can auto attack anything arround it.
*/



		JAI_walk()
			spawn()
				while(src)
					var/skip=0
					if(!IS_STARTED) skip = 1
					if(active) skip = 1
					if(walk_back) skip = 1
					if(froze) skip = 1
					if(!skip)
						var/found_target=0
						if(Attacks != "None")
							var/list/L=list()
							for(var/mob/M in view(Attack_View, src))
								if(Attacks == M.Alignment) L += M
							if(Protector)
								for(var/mob/Monster/M in view(Attack_View, src))
									if(!M.is_coward)
										if(M.target)
											if(!M.Protector) L += M
							if(L.len > 0) //Checks to see if anything is in the list
								J_Target(src ,pick(L))// Randomly picks a target
								J_AI()
						if(!found_target)
							if(auto_movement)
								var/list/steps = list(NORTH, SOUTH, EAST, WEST)
								step(src, pick(steps))
					sleep( rand(15,30) )

/*
	Reset()
		This is where you would reset ur mobs stats
*/

		Reset()
			hp=hpmax
			J_update(src)
/*
  J_WB()
   * Usage - a procedure for making a mob without a client attached walk back to there
     starting location, once at there starting location the direction will change to there inital direction.
     This event has to be triggered by setting a mobs walk_back varible to 1 and calling the procedure.

*/

		J_WB()
			var/walked=0
			spawn()
				while(walk_back)//while walk_back is true loop through the following below

                    //If while this code is looping the mob gets a target it will stop the code.
					if(target)
						walk_back = 0
						walk(src, 0)
						break
					if(dead)
						walk_back = 0
						walk(src, 0)
						break

					var/atom/T=locate(start_x,start_y,start_z) //finding the starting location
					var/locto//a holder varible for the starting point
					if(T in view())//checking if the starting point(T) is in view of mob
						locto = T//if its true then set locto(holder) to T

					if(locto)
						if(!walked)
							walked=1
							walk_to(src, locto, 0, move_delay)
							if(ishome())//after moving checking to see if mob is in starting location
								walk_back = 0
								walk(src, 0)
								break
					else//if starting point is not in range of mob
						tries++
						if(tries >= 3)//if tries higher or equal to 3 do the following
							tries = 0
							loc=locate(start_x, start_y, start_z)
							dir = start_dir
							walk_back = 0
							walk(src, 0)
							break
					sleep(10)//delay for walking back can be changed to your needs


/*
  Bump()
   When the mob bumps a object push it or if the mob bumps a mob attack it.
*/
	Bump(atom/O)
		if(isobj(O))//if O is a obj
			three_steps(O,dir)//make O step in mobs direction
		else if(ismob(O))//if not a obj but a mob and mob is active attack
			if(active) J_Attack(O)//if active J_Attack O
		..()

/*
  Move()
   When the mob moves it will check if they are currently walking back
   if they are then it will check if they are at there starting location
*/

	Move()//for when the NPC moves
		..()
		if(walk_back)
			if(ishome())//if mob is in starting location
				dir=start_dir//set direction to starting direction
				walk_back=0//set walk_back so it can be used agian when needed
				walk(src,0)
				Reset()



/*
  On new/mob
   Set there starting location
   Call JAI_walk() to make them move randomly
   show meters then update those new meters.
*/
	New()
		..()
		underlays+=image('icons.dmi',icon_state="shadow",pixel_y=-3)
		set_start()//on mob/new set start point
		JAI_walk()//call walking procedure
		J_showbars(src)//show the health meter
		J_update(src)//update the health meter



/*
  three_steps(atom/O, dir_)
   * Usage - O will step 3 times in dir_
*/
proc/three_steps(atom/O, dir_)
	var/steps=0
	spawn()while(steps<3)
		steps++
		step(O,dir_);if(steps>=3) break
		sleep(3.8)//set a delay to make it look sick!


/*
	make_corpse()
		simple proc to create a object with the mobs dead state
*/


proc
	make_corpse(mob/m)
		var/obj/O= new/obj(locate(m.x,m.y,m.z))
		O.name="[m.name]'s remains"
		O.icon = icon(m.icon,"[m.icon_state]_dead")
		spawn(rand(300,600)) del(O)




/*
  NPC Activational Code - Not sure if this is the efficent way of doing it
   but it seems to work fine
    After a mob with a client moves it checks to see if it can activate any mobs
     Once activated call Start on such mobs
      To watch them and make sure they stay going if playeres are arround
       If no players are found durring this event they will walk back to there starting location
        And stop all actions preventing more CPU usage then needed.
*/


mob
	Move()
		if(froze) return
		..()
		if(client) Activate_Area(src)

mob/var/tmp/IS_STARTED=0

proc/Activate_Area(mob/maker) //the mob thats activating the mobs arround him
	for(var/mob/Monster/M in range(Activated_Range, maker))
		if(!M.IS_STARTED)
			Start(M)

proc/Start(mob/Monster/M)
	if(!M.IS_STARTED)
		M.IS_STARTED=1
		spawn()
			while(M)
				if(!M.IS_STARTED)
					M.walk_back=1
					M.J_WB()
					break
				else
					var/mob/Player/P = locate(/mob/Player) in orange(Activated_Range, M)
					if(!P)
						M.IS_STARTED=0
				sleep(10)
	else
		return


