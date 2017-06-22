/datum/ckey_reputation
	var/ckey
	var/date_of_start

	var/admin_p_mod = 1
	var/admin_n_mod = 0

	var/warns = 0
	var/jobbans = 0
	var/bans = 0
	var/permabans = 0

	var/peace_kills = 0
	var/antag_kills = 0
	var/peace_rounds = 0
	var/antag_rounds = 0
	var/peace_live_rounds = 0

	var/heal_intents = 0

	var/positive_rep = 1
	var/negative_rep = 0
	var/total_rep = 1

	proc/Calculate()
		//—начала нужно вычислить срок игры на сервере в дн€х
		var/days = world.realtime-date_of_start
		days += (days/7)/4 + (days/31)/2 + (days/150) + (days/365)*4
		days = days * peace_live_rounds/peace_rounds

		var/bans_mod = (warns+jobbans*2+bans*4+permabans*50)/(peace_rounds+antag_rounds)
		if(bans_mod<2)
			bans_mod = -1/bans_mod

		var/kill_mod = (4 / (antag_kills/antag_rounds)) + (3 / (peace_kills/peace_rounds))

		positive_rep = days + admin_p_mod + bans_mod + heal_intents + kill_mod


		bans_mod = warns+jobbans*2+bans*4+permabans*50
		negative_rep = bans_mod + admin_n_mod + peace_kills*8 + antag_kills

		total_rep = negative_rep + positive_rep



/*
var/list/datum/ckey_reputation/players_reputation = list()

/hook/startup/proc/loadReputation()
	LoadReps()
	return 1

/proc/LoadReps()
	var/list/strings = splittext(file2text("data/reputation.txt"), "\n")
	for(var/s in strings)
		var/list/dat = splittext(s, "|")
		var/datum/ckey_reputation/CR = new /datum/ckey_reputation
		CR.ckey 				= dat[1]
		CR.date_of_start		= dat[2]
		CR.admin_p_mod 			= dat[3]
		CR.admin_n_mod 			= dat[4]
		CR.warns 				= dat[5]
		CR.jobbans 				= dat[6]
		CR.bans 				= dat[7]
		CR.permabans 			= dat[8]
		CR.peace_kills 			= dat[9]
		CR.antag_kills			= dat[10]
		CR.peace_rounds			= dat[11]
		CR.antag_rounds			= dat[12]
		CR.peace_live_rounds	= dat[13]
		CR.heal_intents			= dat[14]
		CR.Calculate()

/proc/HasRep(var/ckey)
	for(var/datum/ckey_reputation/CR in players_reputation)
		if(ckey == CR.ckey)
			return 1
	return 0

/proc/AddRep(var/ckey)
	if(!HasRep(ckey))
		var/datum/ckey_reputation/CR = new /datum/ckey_reputation
		CR.ckey	= ckey
		CR.date_of_start = world.realtime
		players_reputation += CR

/proc/save_reputation()
	fdel("data/reputation.txt")
	var/dat = ""
	for(var/datum/ckey_reputation/CR in players_reputation)
		dat += CR.ckey
		for(var/V in CR.vars-CR.ckey-CR.positive_rep-CR.negative_rep-CR.total_rep)
			dat += "-[V]"
		dat += "\n"
	text2file(dat, "data/reputation.txt")

/world/Del()
	save_reputation()
	..()*/