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

#undef CELLS
#undef CELLSIZE

