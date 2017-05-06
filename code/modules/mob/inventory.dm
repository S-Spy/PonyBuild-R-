//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting l_hand = ...etc
//as they handle all relevant stuff like adding it to the player's screen and updating their overlays.

//Returns the thing in our active hand
/mob/proc/get_active_hand()
	if(issilicon(src))
		if(isrobot(src))
			if(src:module_active)
				return src:module_active
	else
		if(!hand)	return null
		return hand.item_in_hand


//Puts the item into your r_hand if possible and calls all necessary triggers/updates. returns 1 on success.
//Puts the item into our active hand if possible. returns 1 on success.
/mob/proc/put_in_active_hand(var/obj/item/W, var/datum/hand/H)
	if(!H)				H = hand//It's active hand. Else non-active
	if(lying)			return 0
	if(!istype(W))		return 0
	if(!H.item_in_hand)
		W.loc = src
		H.item_in_hand = W
		W.layer = hand.slot.layer+1
		W.screen_loc = hand.slot.screen_loc

		W.equipped(src,slot_r_hand)//Тут все добавляется в интерфейс. Зачем ЭТО?

		if(client)	client.screen |= W
		if(pulling == W) stop_pulling()
		update_inv_hands()
		return 1
	return 0

//Puts the item into our inactive hand if possible. returns 1 on success.
/mob/proc/put_in_free_hand(var/obj/item/W)
	var/datum/hand/free_hand
	for(var/datum/hand/selhand in list_hands)
		if(!selhand.item_in_hand)
			free_hand = selhand
			break
	if(free_hand)
		put_in_active_hand(W, free_hand)
		return 1
	else
		return 0

//Puts the item our active hand if possible. Failing that it tries our inactive hand. Returns 1 on success.
//If both fail it drops it on the floor and returns 0.
//This is probably the main one you need to know :)
/mob/proc/put_in_hands(var/obj/item/W)
	if(!W)		return 0
	if(put_in_active_hand(W))
		update_inv_hands()
		return 1
	else if(put_in_free_hand(W))
		update_inv_hands()
		return 1
	else
		W.loc = get_turf(src)
		W.layer = initial(W.layer)
		W.dropped()
		return 0



/mob/proc/drop_item_v()		//this is dumb.
	if(stat == CONSCIOUS && isturf(loc))
		return drop_active_hand()
	return 0


/mob/proc/drop_from_inventory(var/obj/item/W, var/atom/Target = null)
	if(W)
		if(!Target)
			Target = loc

		if(client)	client.screen -= W
		u_equip(W)
		if(!W) return 1 // self destroying objects (tk, grabs)
		W.layer = initial(W.layer)
		W.loc = Target

		var/turf/T = get_turf(Target)
		if(isturf(T))
			T.Entered(W)

		W.dropped(src)
		update_icons()
		return 1
	return 0




//Drops the item in our active hand.
/mob/proc/drop_active_hand(var/atom/Target, var/datum/hand/H)
	if(!H)	H = hand //for non-active hands
	if(H.item_in_hand)
		if(client)	client.screen -= H.item_in_hand
		H.item_in_hand.layer = initial(H.item_in_hand.layer)

		if(Target)	H.item_in_hand.loc = Target.loc
		else		H.item_in_hand.loc = loc

		var/turf/T = get_turf(loc)
		if(isturf(T))
			T.Entered(H.item_in_hand)

		H.item_in_hand.dropped(src)
		H.item_in_hand = null
		update_inv_hands()
		return 1
	return 0

/mob/proc/drop_all_hands(var/atom/Target)
	if(list_hands.len)
		for(var/datum/hand/H in list_hands)
			drop_active_hand(null, H)
			return 1
	else
		return 0








//TODO: phase out this proc
/mob/proc/before_take_item(var/obj/item/W)	//TODO: what is this?
	W.loc = null
	W.layer = initial(W.layer)
	u_equip(W)
	update_icons()
	return


/mob/proc/u_equip(W as obj)
	for(var/datum/hand/H in list_hands)
		if(H.item_in_hand == W)
			H.item_in_hand = null
			update_inv_hands(0)
			return
	if(W == back)
		back = null
		update_inv_back(0)
	else if(W == wear_mask)
		wear_mask = null
		update_inv_wear_mask(0)
	return

/mob/proc/unEquip(obj/item/I, force = 0) //Force overrides NODROP for things like wizarditis and admin undress.
	if(!I) //If there's nothing to drop, the drop is automatically successful. If(unEquip) should generally be used to check for NODROP.
		return 1

	/*if((I.flags & NODROP) && !force)
		return 0*/

	if(!I.canremove && !force)
		return 0

	for(var/datum/hand/H in list_hands)
		if(H.item_in_hand == I)
			H.item_in_hand = null
			update_inv_hands()
			break

	if(I)
		if(client)
			client.screen -= I
		I.loc = loc
		I.dropped(src)
		if(I)
			I.layer = initial(I.layer)
	return 1

//Attemps to remove an object on a mob.  Will not move it to another area or such, just removes from the mob.
//It does call u_equip() though. So it can drop items to the floor but only if src is pony.
/mob/proc/remove_from_mob(var/obj/O)
	src.u_equip(O)
	if (src.client)
		src.client.screen -= O
	O.layer = initial(O.layer)
	O.screen_loc = null
	return 1


//Outdated but still in use apparently. This should at least be a pony proc.
/mob/proc/get_equipped_items()
	var/list/items = new/list()

	if(hasvar(src,"back")) if(src:back) items += src:back
	if(hasvar(src,"belt")) if(src:belt) items += src:belt
	if(hasvar(src,"l_ear")) if(src:l_ear) items += src:l_ear
	if(hasvar(src,"r_ear")) if(src:r_ear) items += src:r_ear
	if(hasvar(src,"glasses")) if(src:glasses) items += src:glasses
	if(hasvar(src,"gloves")) if(src:gloves) items += src:gloves
	if(hasvar(src,"head")) if(src:head) items += src:head
	if(hasvar(src,"shoes")) if(src:shoes) items += src:shoes
	if(hasvar(src,"wear_id")) if(src:wear_id) items += src:wear_id
	if(hasvar(src,"wear_mask")) if(src:wear_mask) items += src:wear_mask
	if(hasvar(src,"wear_suit")) if(src:wear_suit) items += src:wear_suit
//	if(hasvar(src,"w_radio")) if(src:w_radio) items += src:w_radio  commenting this out since headsets go on your ears now PLEASE DON'T BE MAD KEELIN
	if(hasvar(src,"w_uniform")) if(src:w_uniform) items += src:w_uniform

	//if(hasvar(src,"l_hand")) if(src:l_hand) items += src:l_hand
	//if(hasvar(src,"r_hand")) if(src:r_hand) items += src:r_hand

	return items

/** BS12's proc to get the item in the active hand. Couldn't find the /tg/ equivalent. **/
/mob/proc/equipped()
	return get_active_hand() //TODO: get rid of this proc

/mob/living/carbon/pony/proc/equip_if_possible(obj/item/W, slot, del_on_fail = 1) // since byond doesn't seem to have pointers, this seems like the best way to do this :/
	//warning: icky code
	var/equipped = 0
	if(slot==slot_l_hand || slot==slot_r_hand)
		for(var/datum/hand/H in list_hands)
			if(!H.item_in_hand && H.slot_place==slot)
				H.item_in_hand = W
				equipped = 1
				break

	switch(slot)
		if(slot_back)
			if(!src.back)
				src.back = W
				equipped = 1
		if(slot_wear_mask)
			if(!src.wear_mask)
				src.wear_mask = W
				equipped = 1
		if(slot_handcuffed)
			if(!src.handcuffed)
				src.handcuffed = W
				equipped = 1
		if(slot_belt)
			if(!src.belt && src.w_uniform)
				src.belt = W
				equipped = 1
		if(slot_wear_id)
			if(!src.wear_id && src.w_uniform)
				src.wear_id = W
				equipped = 1
		if(slot_l_ear)
			if(!src.l_ear)
				src.l_ear = W
				equipped = 1
		if(slot_r_ear)
			if(!src.r_ear)
				src.r_ear = W
				equipped = 1
		if(slot_glasses)
			if(!src.glasses)
				src.glasses = W
				equipped = 1
		if(slot_gloves)
			if(!src.gloves)
				src.gloves = W
				equipped = 1
		if(slot_head)
			if(!src.head)
				src.head = W
				equipped = 1
		if(slot_shoes)
			if(!src.shoes)
				src.shoes = W
				equipped = 1
		if(slot_wear_suit)
			if(!src.wear_suit)
				src.wear_suit = W
				equipped = 1
		if(slot_w_uniform)
			if(!src.w_uniform)
				src.w_uniform = W
				equipped = 1
		if(slot_l_store)
			if(!src.l_store && src.w_uniform)
				src.l_store = W
				equipped = 1
		if(slot_r_store)
			if(!src.r_store && src.w_uniform)
				src.r_store = W
				equipped = 1
		if(slot_s_store)
			if(!src.s_store && src.wear_suit)
				src.s_store = W
				equipped = 1
		if(slot_in_backpack)
			if (src.back && istype(src.back, /obj/item/weapon/storage/backpack))
				var/obj/item/weapon/storage/backpack/B = src.back
				if(B.contents.len < B.storage_slots && W.w_class <= B.max_w_class)
					W.loc = B
					equipped = 1

	if(equipped)
		W.layer = 20
		if(src.back && W.loc != src.back)
			W.loc = src
	else
		if (del_on_fail)
			del(W)
	return equipped
