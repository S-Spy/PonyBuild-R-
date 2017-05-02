
/*
  A clicked based target system or manual target by calling J_Target(mob, target)
*/


mob/var/tmp//Varibles for target
	old_target

	target_sign

	target

mob/Click()//on click call J_target
	..()
	J_Target(usr, src)//Make usr target src


/*////////////////////////////////
   J_Target() - procedure to set target and display client based images

 Usage:
  mob/U is your mob
  mob/M is the mob to be targeted
*/

proc
	J_Target(mob/U, mob/M) // mob/M is the mob to be targeted
		U.target = M
		if(!U.client) return//if U does not have a client attached end code

		if(U.old_target == U.target)//if your old_target is your new target
			U.old_target = null//untarget
			U.target = null//resetting varibles
			if(U.target_sign) del U.target_sign//and removing image

		else
			U.old_target=M//setup old_target
			if(U.target_sign) del U.target_sign//if you have a client image delete it
			var/image/I=image('icons.dmi',M,icon_state="target",pixel_y=-4)
			I.mouse_opacity = 0
			I.layer=M.layer-1
			U.target_sign=I//set your target sign to the image
			U<<I//send the image to your client making it only visible to you
		return

