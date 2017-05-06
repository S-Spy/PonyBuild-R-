/mob/living/carbon/monkey/examine(mob/user)
	..(user)

	var/msg = ""
	if (src.handcuffed)
		msg += "It is \icon[src.handcuffed] handcuffed!\n"
	if (src.wear_mask)
		msg += "It has \icon[src.wear_mask] \a [src.wear_mask] on its head.\n"
	for(var/datum/hand/H in list_hands)
		if(H.item_in_hand)
			msg += "It has \icon[H.item_in_hand] \a [H.item_in_hand] in its [H.name].\n"
	if (src.back)
		msg += "It has \icon[src.back] \a [src.back] on its back.\n"
	if (src.stat == DEAD)
		msg += "<span class='deadsay'>It is limp and unresponsive, with no signs of life.</span>\n"
	else
		msg += "<span class='warning'>"
		if (src.getBruteLoss())
			if (src.getBruteLoss() < 30)
				msg += "It has minor bruising.\n"
			else
				msg += "<B>It has severe bruising!</B>\n"
		if (src.getFireLoss())
			if (src.getFireLoss() < 30)
				msg += "It has minor burns.\n"
			else
				msg += "<B>It has severe burns!</B>\n"
		if (src.stat == UNCONSCIOUS)
			msg += "It isn't responding to anything around it; it seems to be asleep.\n"
		msg += "</span>"

	if (src.digitalcamo)
		msg += "It is repulsively uncanny!\n"

	msg += "*---------*</span>"

	user << msg
	return