mob/living/carbon/verb/give(var/mob/living/carbon/target in view(1)-usr)
	set category = "IC"
	set name = "Give"
	if(!istype(target) || target.stat == 2 || usr.stat == 2|| target.client == null)
		return
	var/obj/item/I
	if(!usr.hand.item_in_hand)
		usr << "<span class='warning'>You don't have anything in your right hand to give to [target.name]</span>"
		return
	I = usr.hand.item_in_hand
	if(!I)
		return
	if(target.free_hand())
		switch(alert(target,"[usr] wants to give you \a [I]?",,"Yes","No"))
			if("Yes")
				if(!I)
					return
				if(!Adjacent(usr))
					usr << "<span class='warning'>You need to stay in reaching distance while giving an object.</span>"
					target << "<span class='warning'>[usr.name] moved too far away.</span>"
					return
				if(usr.hand.item_in_hand && usr.hand.item_in_hand != I)
					usr << "<span class='warning'>You need to keep the item in your active hand.</span>"
					target << "<span class='warning'>[usr.name] seem to have given up on giving \the [I.name] to you.</span>"
					return
				if(!target.free_hand())
					target << "<span class='warning'>Your hands are full.</span>"
					usr << "<span class='warning'>Their hands are full.</span>"
					return
				else
					usr.drop_active_hand()
					var/datum/hand/H = target.free_hand()
					H.item_in_hand = I
				I.loc = target
				I.layer = 20
				I.add_fingerprint(target)
				target.update_inv_hands()
				target.update_inv_hands()
				usr.update_inv_hands()
				usr.update_inv_hands()
				target.visible_message("<span class='notice'>[usr.name] handed \the [I.name] to [target.name].</span>")
			if("No")
				target.visible_message("<span class='warning'>[usr.name] tried to hand [I.name] to [target.name] but [target.name] didn't want it.</span>")
	else
		usr << "<span class='warning'>[target.name]'s hands are full.</span>"
