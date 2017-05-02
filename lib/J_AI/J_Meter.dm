/*
  Introduces a new type J_Meter
  var
     states  - This is how many icon states are in the icon file starting at 0
*/


J_Meter
	parent_type = /obj
	layer = MOB_LAYER+1
	var/states = 0


/*
  Creating a new meter called health_bar to show how much health a mob has
*/


	health_bar
		icon = 'lifebar.dmi'
		icon_state = "0"
		pixel_y = 5
		pixel_x = -5
		states = 20//this meter has 20 states starting at 0




mob/var/tmp
	list/bars=list(new/J_Meter/health_bar)//a list of a mobs current meters

proc
/*
  Call this to show a mobs meter
*/
	J_showbars(mob/M)
		for(var/J_Meter/meter in M.bars)
			M.overlays-=meter;M.overlays+=meter


/*
  Call J_hidebars() to hide a mobs meters
*/
	J_hidebars(mob/M)
		for(var/J_Meter/meter in M.bars) M.overlays -= meter


/*
  J_updatebar()
   M: the mob with the meter
   meter: a text varible ex: health for /J_Meter/health_bar
   val1: the minimum varible ex: hp
   val2: the maximum varible ex: hpmax
*/
	J_updatebar(mob/M, meter, val1, val2)
		var/J_Meter/met = text2path("/J_Meter/[meter]_bar")
		var/J_Meter/I = locate(met) in M.bars
		if(val1 > val2)
			val1 = val2
		if(I)
			M.overlays -= I
			I.icon_state = "[round((I.states-1)*round(val1)/round(val2),1)+1]"
			M.overlays += I


/*
  J_update(mob)
   * Usage - Updates a mobs meters you can add all of them in here to make things easier.
     Also this shows you how to create more meters and update them correctly.
*/
	J_update(mob/M)
		J_updatebar(M, "health", M.hp, M.hpmax)
