/obj/structure/undies_wardrobe
	name = "Wardrobe"
	desc = "Holds item of clothing you shouldn't be showing off in the hallways."
	icon = 'icons/obj/closet.dmi'
	icon_state = "cabinet_closed"
	density = 1

/obj/structure/undies_wardrobe/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	/*var/mob/living/carbon/pony/H = user
	if(!ispony(user) || (H.species && !(H.species.flags & HAS_ptail)))
		user << "<span class='warning'>Sadly there's nothing in here for you to wear.</span>"
		return 0

	var/utype = alert("Which section do you want to pick from?",,"Male ptail", "Female ptail", "cutie_marks")
	var/list/selection
	switch(utype)
		if("Male ptail" || "Female ptail")
			selection = ptail
		if("cutie_marks")
			selection = cutie_mark_t
	var/pick = input("Select the style") as null|anything in selection
	if(pick)
		if(get_dist(src,user) > 1)
			return
		if(utype == "cutie_marks")
			H.cutie_mark = cutie_mark_t[pick]
		else
			H.ptail = selection[pick]
		H.update_body(1)

	return 1
	*/