/mob/Login()
	..()
	if(ispony(usr)) usr:add_unicorn_verbs()
	world << {"<p style="color:#0000cc"><b>[client.key] entered the game.</b></p>"}



var/list/accept_list = list()

/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying


	spawn(20)
		if(!(key in accept_list))
			client.language = alert("Language: ",,"ru", "eng")
			if(client.language == "eng")
				alert("We have actual rules and strongly recommend you read them before to play. Ignorance of the rules does not exempt from liability.")
			else
				alert("ћы имеем актуальные правила и насто€тельно рекомендуем ¬ам ознакомиться с ними перед началом игры. Ќезнание правил не освобождает от ответственности.")
			accept_list += key
		client.show_motd("welcome_[client.language]")

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	if(length(newplayer_start))
		loc = pick(newplayer_start)
	else
		loc = locate(1,1,1)
	lastarea = loc

	sight |= SEE_TURFS
	player_list |= src

/*
	var/list/watch_locations = list()
	for(var/obj/effect/landmark/landmark in landmarks_list)
		if(landmark.tag == "landmark*new_player")
			watch_locations += landmark.loc

	if(watch_locations.len>0)
		loc = pick(watch_locations)
*/
	new_player_panel()

	spawn(40)
		if(client)
			handle_privacy_poll()
			client.playtitlemusic()
	//AddRep(ckey)
