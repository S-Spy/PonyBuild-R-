#define CELLS 4
#define CELLSIZE (32/CELLS)

////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.
	var/filling_color = "#FFFFFF" //Used by sandwiches.
	var/heating = 0
	var/list/center_of_mass = list() // Used for table placement

/obj/item/weapon/reagent_containers/food/New()
	..()
	if (!pixel_x && !pixel_y)
		src.pixel_x = rand(-6.0, 6) //Randomizes postion
		src.pixel_y = rand(-6.0, 6)

/obj/item/weapon/reagent_containers/food/afterattack(atom/A, mob/user, proximity, params)
	if(proximity && params && istype(A, /obj/structure/table) && center_of_mass.len)
		//Places the item on a grid
		var/list/mouse_control = params2list(params)

		var/mouse_x = text2num(mouse_control["icon-x"])
		var/mouse_y = text2num(mouse_control["icon-y"])

		if(!isnum(mouse_x) || !isnum(mouse_y))
			return

		var/cell_x = max(0, min(CELLS-1, round(mouse_x/CELLSIZE)))
		var/cell_y = max(0, min(CELLS-1, round(mouse_y/CELLSIZE)))

		pixel_x = (CELLSIZE * (0.5 + cell_x)) - center_of_mass["x"]
		pixel_y = (CELLSIZE * (0.5 + cell_y)) - center_of_mass["y"]

/obj/item/weapon/reagent_containers/food/proc/heat_food(var/temperature=3)
	if(temperature < 0)	temperature = 0
	if(temperature > 4)	temperature = 4
	if(temperature == 4)
		var/obj/machinery/microwave/M = new/obj/machinery/microwave
		M.Move(locate(x,y,z))
		src = M.fail()
		del M
		return
	else
		var/datum/reagent/R = reagents.reagent_list["Nutriment"]
		var/base_amount = R.volume
		switch(heating)
			if(1)	base_amount *= 0.9
			if(2)	base_amount *= 0.7
			if(3)	base_amount *= 0.5
		heating = temperature
		switch(temperature)
			if(0)	R.volume = base_amount
			if(1)
				R.volume = base_amount / 0.9
				spawn(4000)	if(temperature == heating)	heat_food(temperature - 1)
			if(2)
				R.volume = base_amount / 0.7
				spawn(2000)	if(temperature == heating)	heat_food(temperature - 1)
			if(3)
				R.volume = base_amount / 0.5
				spawn(1000)	if(temperature == heating)	heat_food(temperature - 1)

proc/taste(var/datum/reagents/R, var/byte_size=5)
	var/obj/item/weapon/reagent_containers/glass/beaker/noreact/B = new /obj/item/weapon/reagent_containers/glass/beaker/noreact //temporary holder
	B.volume = 1000
	var/datum/reagents/tmp_R = new R
	var/amount = byte_size
	if(amount > tmp_R.total_volume)	amount = R.total_volume
	tmp_R.trans_to(B, amount)

	var/pungent = 0//острый
	var/sweet = 0//сладкий
	var/salty = 0//соленый
	var/sour = 0//кислый
	var/bitter = 0//√орький
	var/datum/reagents/BR = B.reagents
	for(var/datum/reagent/reagent in BR.reagent_list)
		pungent += reagent.pungent * reagent.volume
		sweet	+= reagent.sweet   * reagent.volume
		salty	+= reagent.salty   * reagent.volume
		sour 	+= reagent.sour    * reagent.volume
		bitter  += reagent.bitter  * reagent.volume

	if(pungent > 1.4)		pungent = 2
	else if(pungent < 0.4)	pungent = 0
	else					pungent = 1
	if(sweet > 1.4)			sweet = 2
	else if(sweet < 0.4)	sweet = 0
	else					sweet = 1
	if(salty > 1.4)			salty = 2
	else if(salty < 0.4)	salty = 0
	else					salty = 1
	if(sour > 0.4)			sour = 1
	else					sour = 0
	if(bitter > 1.4)		bitter = 2
	else if(bitter < 0.4)	bitter = 0
	else		bitter = 1


	var/answer = ""
	if(!pungent && !sweet && !salty && !sour)
		answer = "insipid taste"
		goto End
	if(pungent == 1 && sweet == 1 && salty == 1 && sour == 1)
		answer = "nice mixture of tastes"
		goto End

	if(pungent == 2 && sweet == 2 && salty == 2 && sour == 1)
		answer = "disgusting mixture of tastes"
		goto End
	else if(pungent == 2 && sweet == 2 && salty == 1 && sour == 1)	salty = 0
	else if(pungent == 2 && sweet == 1 && salty == 2 && sour == 1)	sweet = 0
	else if(pungent == 1 && sweet == 2 && salty == 2 && sour == 1)	pungent = 0

	if(pungent == 2 && sweet == 1 && salty == 1 && sour == 1)
		if(rand(1,2) == 1)	salty = 0
		else				sweet = 0
	else if(pungent == 1 && sweet == 2 && salty == 1 && sour == 1)
		if(rand(1,2) == 1)	salty = 0
		else				pungent = 0
	else if(pungent == 1 && sweet == 1 && salty == 2 && sour == 1)
		if(rand(1,2) == 1)	sweet = 0
		else				pungent = 0

	if(pungent == 2)		answer = "pungent "
	else if(pungent == 1)	answer = "spicy "

	if(sweet == 2)			answer = "sweet "
	else if(sweet == 1)		answer = "sweetish"

	if(salty == 2)			answer = "salty "
	else if(pungent == 1)	answer = "brackish "

	if(lentext(answer))
		answer += "tasty"
		if(sour || bitter)	answer += " with "

	if(sour)	answer += "sour"
	if(bitter == 2)
		if(sour)	answer += "-"
		answer += "bitter"
	else if(bitter == 2)
		if(sour)	answer += "-"
		answer += "bitterish"

	if(sour || bitter)	answer += " smack"

	End

	return "It's have [answer]."

#undef CELLS
#undef CELLSIZE

