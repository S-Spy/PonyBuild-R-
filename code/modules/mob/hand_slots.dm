#define MOUTH_ICON  1
#define HOOF_ICON   2
#define TELE_ICON   3

#define INV_HEAD_DEF_ICON 	'icons/mob/head.dmi'
#define INV_L_HAND_DEF_ICON 'icons/mob/items/lefthand.dmi'
#define INV_R_HAND_DEF_ICON 'icons/mob/items/righthand.dmi'

/mob/var/list/datum/hand/list_hands = list()

/datum/hand
	var/name
	var/obj/content = null
	var/obj/screen/inventory/hand/slot
	var/list/datum/organ/connect_organs = list()
	var/list/connect_organ_names = list()
	var/mob/mymob
	var/screen_loc
	var/obj/item/item_in_hand
	var/item_type = HOOF_ICON
	var/slot_place = slot_r_hand

	hoofkinesis										//1. Ключевые точки для взаимодействия
		name = "hoofkinesis"
		connect_organ_names = list("r_hand", "l_hand", "r_arm", "l_arm")
		screen_loc = ui_hand1

	telekinesis
		name = "telekinesis"
		connect_organ_names = list("horn")
		screen_loc = ui_hand2
		item_type = TELE_ICON

	mouth
		connect_organ_names = list("head")
		name = "mouth"
		screen_loc = ui_hand3
		item_type = MOUTH_ICON
		slot_place = slot_l_hand

	New(var/mob/M)
		mymob = M
		//Настройка связанного слота
		slot = new/obj/screen/inventory/hand()
		slot.name = name
		slot.icon_state = name
		slot.screen_loc = screen_loc
		slot.parent = src

		if(iscarbon(mymob))	for(var/n in connect_organ_names)		//2. Проверка на наличие подходящего органа перед добавлением в список использования
			if(mymob.organs_by_name[n])
				if(!connect_organs.len)   	mymob.list_hands += src
				connect_organs |=   mymob.organs_by_name[n]
			else	if(mymob:internal_organs_by_name[n])
				if(!connect_organs.len)	   	mymob.list_hands += src
				connect_organs |= 	mymob.internal_organs_by_name[n]
		if(!connect_organs.len)
			del slot
			del src


/mob/proc/make_hand_list()
	list_hands = list()
	for(var/path in typesof(/datum/hand)-/datum/hand)
		var/datum/hand/H = new path(src)
		if(!hand)	hand = H


/mob/proc/item_in_hands(var/obj/item/I, var/datum/hand/hand_list = list_hands)
	for(var/datum/hand/H in hand_list)
		if(H.item_in_hand == I)		return H//return slot with this item
	return 0

/mob/proc/type_in_hands(var/path, var/datum/hand/hand_list = list_hands)
	for(var/datum/hand/H in hand_list)
		if(istype(H.item_in_hand, path))		return H
	return 0

/mob/proc/free_hand( var/datum/hand/hand_list = list_hands)
	for(var/datum/hand/H in hand_list)
		if(!H.item_in_hand)		return H
	return 0

/mob/proc/list_items_in_hands(var/datum/hand/hand_list = list_hands)
	var/list/obj/ilist = list()
	for(var/datum/hand/H in hand_list)
		ilist += H.item_in_hand
	return ilist



//Принцип такой, что для управления рукой используется датум. И из него все референсы

/mob/proc/swap_hand(var/obj/screen/inventory/hand/H)
	if(H && H.parent.item_in_hand) //this segment checks if the item in your hand is twohanded.
		if(istype(H.parent.item_in_hand,/obj/item/weapon/twohanded))
			if(H.parent.item_in_hand:wielded == 1)
				usr << "<span class='warning'>Your other hand is too busy holding the [H.parent.item_in_hand.name]</span>"
				return

	if(!H)
		if(list_hands.len==0)	return
		var/datum/hand/dathand
		var/has_active
		for(var/ih=1, ih<= list_hands.len, ih++)//Перебор по порядку
			var/datum/hand/selhand = list_hands[ih]
			if(has_active)
				dathand = selhand
				break
			else if(selhand == hand)
				has_active = 1
		if(!H)	dathand = list_hands[1]
		H = dathand.slot

	hand = H.parent

	for(var/datum/hand/selhand in list_hands)
		selhand.slot.icon_state = "[selhand.name]"//Если тут добавить проверку, то число действий будет 2N. Так же получается только N+1
	H.icon_state = "[H.name]_active"
	return