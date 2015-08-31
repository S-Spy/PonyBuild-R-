/mob/living/carbon/pony/Logout()
	..()
	if(species) species.handle_logout_special(src)
	return