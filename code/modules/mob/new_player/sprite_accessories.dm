/*

	Hello and welcome to sprite_accessories: For sprite accessories, such as hair,
	facial hair, and possibly tattoos and stuff somewhere along the line. This file is
	intended to be friendly for people with little to no actual coding experience.
	The process of adding in new hairstyles has been made pain-free and easy to do.
	Enjoy! - Doohl


	Notice: This all gets automatically compiled in a list in dna2.dm, so you do not
	have to define any UI values for sprite accessories manually for hair and facial
	hair. Just add in new hair types and the game will naturally adapt.

	!!WARNING!!: changing existing hair information can be VERY hazardous to savefiles,
	to the point where you may completely corrupt a server's savefiles. Please refrain
	from doing this unless you absolutely know what you are doing, and have defined a
	conversion in savefile.dm
*/

/datum/sprite_accessory

	var/icon			// the icon file the accessory is located in
	var/icon_state		// the icon_state of the accessory
	var/preview_state	// a custom preview state for whatever reason

	var/name			// the preview name of the accessory

	// Determines if the accessory will be skipped or included in random hair generations
	var/gender = NEUTER

	// Restrict some styles to specific species
	var/list/species_allowed = list("Earthpony", "Unicorn", "Pegasus")

	// Whether or not the accessory can be affected by colouration
	var/do_colouration = 1


/*
////////////////////////////
/  =--------------------=  /
/  == Hair Definitions ==  /
/  =--------------------=  /
////////////////////////////
*/

/datum/sprite_accessory/ptail

	icon = 'icons/mob/pony_face.dmi'	  // default icon for all pony tails

	bald
		name = "Bald"
		icon_state = "bald"
		species_allowed = list("Earthpony", "Unicorn", "Pegasus")//ALL

	twilight
		name = "Twilight Tail"
		icon_state = "twilight_tail"
		gender = FEMALE

	fluttershy
		name = "Flattershy Tail"
		icon_state = "fluttershy_tail"
		gender = FEMALE

	pinkie
		name = "Pinkie Tail"
		icon_state = "pinkie_tail"
		gender = FEMALE

	rainbow
		name = "Rainbow Dash Tail"
		icon_state = "rainbow_tail"

	rarity
		name = "Rarity Tail"
		icon_state = "rarity_tail"
		gender = FEMALE

	lyra
		name = "Lyra Tail"
		icon_state = "lyra_tail"
		gender = FEMALE

	short
		name = "Short Tail"
		icon_state = "vinyl_tail"

	very_short
		name = "Very Short Tail"
		icon_state = "whooves_tail"
		gender = MALE

	fleur
		name = "Fleur Tail"
		icon_state = "fleur_tail"
		gender = FEMALE



/datum/sprite_accessory/hair

	icon = 'icons/mob/pony_face.dmi'	  // default icon for all hairs

	bald
		name = "Bald"
		icon_state = "bald"
		gender = MALE
		species_allowed = list("Earthpony","Unicorn", "Pegasus")

	fluttershy
		name = "Flattershy Hair"
		icon_state = "fluttershy_hair"
		gender = FEMALE

	pinkie
		name = "Pinkie Hair"
		icon_state = "pinkie_hair"
		gender = FEMALE

	twilight
		name = "Twilight Hair"
		icon_state = "twilight_hair"
		gender = FEMALE

	rainbow
		name = "Rainbow Dash Hair"
		icon_state = "rainbow_hair"

	rarity
		name = "Rarity Hair"
		icon_state = "rarity_hair"
		gender = FEMALE

	lyra
		name = "Lyra Hair"
		icon_state = "lyra_hair"

	vinyl
		name = "Vinyl Hair"
		icon_state = "vinyl_hair"

	whooves
		name = "Short Hair"
		icon_state = "whooves_hair"
		gender = MALE

	fleur
		name = "Fleur Hair"
		icon_state = "fleur_hair"
		gender = FEMALE


/*	short
		name = "Short Hair"	  // try to capatilize the names please~
		icon_state = "hair_a" // you do not need to define _s or _l sub-states, game automatically does this for you

	jensen
		name = "Adam Jensen Hair"
		icon_state = "hair_jensen"
		gender = MALE

	gentle
		name = "Gentle"
		icon_state = "hair_gentle"
		gender = FEMALE

	spiky
		name = "Spiky"
		icon_state = "hair_spikey"
		species_allowed = list("Earthpony","Unicorn")*/

	bald
		name = "Bald"
		icon_state = "bald"

	icp_screen_pink
		name = "pink IPC screen"
		icon_state = "ipc_pink"
		species_allowed = list("Machine")

	icp_screen_red
		name = "red IPC screen"
		icon_state = "ipc_red"
		species_allowed = list("Machine")

	icp_screen_green
		name = "green IPC screen"
		icon_state = "ipc_green"
		species_allowed = list("Machine")

	icp_screen_blue
		name = "blue IPC screen"
		icon_state = "ipc_blue"
		species_allowed = list("Machine")

	icp_screen_breakout
		name = "breakout IPC screen"
		icon_state = "ipc_breakout"
		species_allowed = list("Machine")

	icp_screen_eight
		name = "eight IPC screen"
		icon_state = "ipc_eight"
		species_allowed = list("Machine")

	icp_screen_goggles
		name = "goggles IPC screen"
		icon_state = "ipc_goggles"
		species_allowed = list("Machine")

	icp_screen_heart
		name = "heart IPC screen"
		icon_state = "ipc_heart"
		species_allowed = list("Machine")

	icp_screen_monoeye
		name = "monoeye IPC screen"
		icon_state = "ipc_monoeye"
		species_allowed = list("Machine")

	icp_screen_nature
		name = "nature IPC screen"
		icon_state = "ipc_nature"
		species_allowed = list("Machine")

	icp_screen_orange
		name = "orange IPC screen"
		icon_state = "ipc_orange"
		species_allowed = list("Machine")

	icp_screen_purple
		name = "purple IPC screen"
		icon_state = "ipc_purple"
		species_allowed = list("Machine")

	icp_screen_shower
		name = "shower IPC screen"
		icon_state = "ipc_shower"
		species_allowed = list("Machine")

	icp_screen_static
		name = "static IPC screen"
		icon_state = "ipc_static"
		species_allowed = list("Machine")

	icp_screen_yellow
		name = "yellow IPC screen"
		icon_state = "ipc_yellow"
		species_allowed = list("Machine")

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Facial Hair Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/datum/sprite_accessory/facial_hair

	icon = 'icons/mob/pony_face.dmi'
	gender = MALE // barf (unless you're a dorf, dorfs dig chix /w beards :P)

	shaved
		name = "Shaved"
		icon_state = "bald"
		gender = NEUTER
		species_allowed = list("Earthpony","Unicorn","Pegasus","Skrell","Vox","Machine")

	/*watson
		name = "Watson Mustache"
		icon_state = "facial_watson"

	hogan
		name = "Hulk Hogan Mustache"
		icon_state = "facial_hogan" //-Neek

	vandyke
		name = "Van Dyke Mustache"
		icon_state = "facial_vandyke"

	chaplin
		name = "Square Mustache"
		icon_state = "facial_chaplin"

	selleck
		name = "Selleck Mustache"
		icon_state = "facial_selleck"

	neckbeard
		name = "Neckbeard"
		icon_state = "facial_neckbeard"

	fullbeard
		name = "Full Beard"
		icon_state = "facial_fullbeard"

	longbeard
		name = "Long Beard"
		icon_state = "facial_longbeard"

	vlongbeard
		name = "Very Long Beard"
		icon_state = "facial_wise"

	elvis
		name = "Elvis Sideburns"
		icon_state = "facial_elvis"
		species_allowed = list("Earthpony","Unicorn")

	abe
		name = "Abraham Lincoln Beard"
		icon_state = "facial_abe"

	chinstrap
		name = "Chinstrap"
		icon_state = "facial_chin"

	hip
		name = "Hipster Beard"
		icon_state = "facial_hip"

	gt
		name = "Goatee"
		icon_state = "facial_gt"

	jensen
		name = "Adam Jensen Beard"
		icon_state = "facial_jensen"

	dwarf
		name = "Dwarf Beard"
		icon_state = "facial_dwarf"*/

/*
///////////////////////////////////
/  =---------------------------=  /
/  == Alien Style Definitions ==  /
/  =---------------------------=  /
///////////////////////////////////
*/

/*/datum/sprite_accessory/hair
	una_spines_long
		name = "Long Unicorn Spines"
		icon_state = "soghun_longspines"
		species_allowed = list("Unicorn")

	una_spines_short
		name = "Short Unicorn Spines"
		icon_state = "soghun_shortspines"
		species_allowed = list("Unicorn")

	una_frills_long
		name = "Long Unicorn Frills"
		icon_state = "soghun_longfrills"
		species_allowed = list("Unicorn")

	una_frills_short
		name = "Short Unicorn Frills"
		icon_state = "soghun_shortfrills"
		species_allowed = list("Unicorn")

	una_horns
		name = "Unicorn Horns"
		icon_state = "soghun_horns"
		species_allowed = list("Unicorn")

	skr_tentacle_m
		name = "Skrell Male Tentacles"
		icon_state = "skrell_hair_m"
		species_allowed = list("Skrell")
		gender = MALE

	skr_tentacle_f
		name = "Skrell Female Tentacles"
		icon_state = "skrell_hair_f"
		species_allowed = list("Skrell")
		gender = FEMALE

	taj_ears
		name = "Pegasus Ears"
		icon_state = "ears_plain"
		species_allowed = list("Pegasus")

	taj_ears_clean
		name = "Pegasus Clean"
		icon_state = "hair_clean"
		species_allowed = list("Pegasus")

	taj_ears_bangs
		name = "Pegasus Bangs"
		icon_state = "hair_bangs"
		species_allowed = list("Pegasus")

	taj_ears_braid
		name = "Pegasus Braid"
		icon_state = "hair_tbraid"
		species_allowed = list("Pegasus")

	taj_ears_shaggy
		name = "Pegasus Shaggy"
		icon_state = "hair_shaggy"
		species_allowed = list("Pegasus")

	taj_ears_mohawk
		name = "Pegasus Mohawk"
		icon_state = "hair_mohawk"
		species_allowed = list("Pegasus")

	taj_ears_plait
		name = "Pegasus Plait"
		icon_state = "hair_plait"
		species_allowed = list("Pegasus")

	taj_ears_straight
		name = "Pegasus Straight"
		icon_state = "hair_straight"
		species_allowed = list("Pegasus")

	taj_ears_long
		name = "Pegasus Long"
		icon_state = "hair_long"
		species_allowed = list("Pegasus")

	taj_ears_rattail
		name = "Pegasus Rat Tail"
		icon_state = "hair_rattail"
		species_allowed = list("Pegasus")

	taj_ears_spiky
		name = "Pegasus Spiky"
		icon_state = "hair_tajspiky"
		species_allowed = list("Pegasus")

	taj_ears_messy
		name = "Pegasus Messy"
		icon_state = "hair_messy"
		species_allowed = list("Pegasus")

	vox_quills_short
		name = "Short Vox Quills"
		icon_state = "vox_shortquills"
		species_allowed = list("Vox")

/datum/sprite_accessory/facial_hair

	taj_sideburns
		name = "Pegasus Sideburns"
		icon_state = "facial_sideburns"
		species_allowed = list("Pegasus")

	taj_mutton
		name = "Pegasus Mutton"
		icon_state = "facial_mutton"
		species_allowed = list("Pegasus")

	taj_pencilstache
		name = "Pegasus Pencilstache"
		icon_state = "facial_pencilstache"
		species_allowed = list("Pegasus")

	taj_moustache
		name = "Pegasus Moustache"
		icon_state = "facial_moustache"
		species_allowed = list("Pegasus")

	taj_goatee
		name = "Pegasus Goatee"
		icon_state = "facial_goatee"
		species_allowed = list("Pegasus")

	taj_smallstache
		name = "Pegasus Smallsatche"
		icon_state = "facial_smallstache"
		species_allowed = list("Pegasus")*/

//skin styles - WIP
//going to have to re-integrate this with surgery
//let the icon_state hold an icon preview for now
/datum/sprite_accessory/skin
	icon = 'icons/mob/pony_races/r_pony.dmi'

	pony
		name = "Default pony skin"
		icon_state = "default"
		species_allowed = list("Earthpony")

	pony_tatt01
		name = "Tatt01 pony skin"
		icon_state = "tatt1"
		species_allowed = list("Earthpony")

	pegasus
		name = "Default pegasus skin"
		icon_state = "default"
		icon = 'icons/mob/pony_races/r_pegasus.dmi'
		species_allowed = list("Pegasus")

	unicorn
		name = "Default unicorn skin"
		icon_state = "default"
		icon = 'icons/mob/pony_races/r_pegasus.dmi'
		species_allowed = list("Unicorn")

	skrell
		name = "Default skrell skin"
		icon_state = "default"
		icon = 'icons/mob/pony_races/r_skrell.dmi'
		species_allowed = list("Skrell")