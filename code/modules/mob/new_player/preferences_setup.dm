/mob/var/icon/cutiemark_paint_west//≈сли стоит галочка, то эта переменна€ заполнитс€ и будет использоватьс€ заместо
/mob/var/icon/cutiemark_paint_east


/datum/preferences
	proc/CustomCutiemarkPaint(mob/user)
		if(!brush_color)	brush_color = rgb(rand(0, 255), rand(0, 255), rand(0, 255))
		update_custom_cutiemark(user)

		var/dat = {"
<html>
<body>
<b>Brush color:<b> <table><tr><td bgcolor='[brush_color]'><font face='fixedsys' size='3' color='[brush_color]'><a href='?_src_=prefs;cutie_paint=1;' style='color: [brush_color]'>__</a></font></td></tr></table>
<table border=0 cellspacing=0>"}

		for(var/iy=4, iy>=1, iy--)
			dat += "<tr>"
			for(var/ix=1, ix<=4, ix++)
				if(!colors4x4[ix][iy] || colors4x4[ix][iy]=="#00000000")
					if(!( (ix==1 && (iy==4||iy==3)) || (ix==2 && iy==4) ))
						colors4x4[ix][iy] = rgb(150, 150, 150)

				dat += "<td bgcolor='[colors4x4[ix][iy]]'>"
				dat += "<font face='fixedsys' size='3' color='[colors4x4[ix][iy]]'><a href='?_src_=prefs;cutie_paint=2;x=[ix];y=[iy]' style='color: [colors4x4[ix][iy]]'>__</a></font>"
				dat += "</td>"
			dat += "</tr>"

		dat += {"</table>
<img src=cutiemark_paint.png height=128 width=128>
<img src=cutiemark_paint2.png height=128 width=128>
<br>
<a href='?_src_=prefs;cutie_paint=3'>\[Done\]</a>
</body>
</html>
"}
		user << browse(dat, "window=cutie_paint;size=150x200")

	//The mob should have a gender you want before running this proc. Will run fine without H
	proc/check_color()
		var/r_dif = abs(r_hair-r_skin)
		var/g_dif = abs(g_hair-g_skin)
		var/b_dif = abs(b_hair-b_skin)
		if(r_dif+g_dif+b_dif < 60)		//ѕроверка одинаковости
			return 0

		if(r_hair>150 || g_hair>150 || b_hair>150)
			if(r_skin<150 && g_skin<150 && b_skin<150)
				return 0
		return 1

	proc/randomize_appearance_for(var/mob/living/carbon/pony/H)
		gender = pick(MALE, FEMALE)
		if(H)
			if(H.gender == MALE)	gender = MALE
			else					gender = FEMALE
		s_tone = random_skin_tone()
		h_style = random_style(gender, species)
		f_style = random_style(gender, species, facial_hair_styles_list)
		pony_tail_style = random_style(gender, species, pony_tail_styles_list)
		randomize_hair_color()
		randomize_eyes_color()

		var/i=1//„тобы игра не зависла с бесконечными проверками
		do
			i++
			randomize_skin_color()
		while(i<10 && !check_color())

		randomize_aura_color()
		cutie_mark = random_cutiemark()
		backbag = 2
		age = rand(AGE_MIN,AGE_MAX)
		if(H)
			copy_to(H,1)


	proc/randomize_hair_color(var/target)
		if(prob (75) && target == "facial") // Chance to inherit hair color
			r_facial = r_hair
			g_facial = g_hair
			b_facial = b_hair
			return

		var/red = 0
		var/green = 0
		var/blue = 0

		var/col = pick ("color")//, "wheat", "black", "blonde", "chestnut", "copper", "brown", "old", "punk")
		switch(col)
			if("blonde")
				red = 255
				green = 255
				blue = 0
			if("black")
				red = 0
				green = 0
				blue = 0
			if("chestnut")
				red = 153
				green = 102
				blue = 51
			if("copper")
				red = 255
				green = 153
				blue = 0
			if("brown")
				red = 102
				green = 51
				blue = 0
			if("wheat")
				red = 255
				green = 255
				blue = 153
			if("old")
				red = rand (100, 255)
				green = red
				blue = red
			if("color")
				red = rand (0, 255)
				green = rand (0, 255)
				blue = rand (0, 255)

		red = max(min(red + rand (-25, 25), 255), 0)
		green = max(min(green + rand (-25, 25), 255), 0)
		blue = max(min(blue + rand (-25, 25), 255), 0)

		switch(target)
			if("hair")
				r_hair = red
				g_hair = green
				b_hair = blue
			if("facial")
				r_facial = red
				g_facial = green
				b_facial = blue
			if("tail")
				r_tail = red
				g_tail = green
				b_tail = blue
			else
				r_hair = red
				g_hair = green
				b_hair = blue
				r_facial = red
				g_facial = green
				b_facial = blue
				r_tail = red
				g_tail = green
				b_tail = blue

	proc/randomize_eyes_color()
		var/red
		var/green
		var/blue

		var/col = pick ("black", "grey", "brown", "chestnut", "blue", "lightblue", "green", "albino")
		switch(col)
			if("black")
				red = 0
				green = 0
				blue = 0
			if("grey")
				red = rand (100, 200)
				green = red
				blue = red
			if("brown")
				red = 102
				green = 51
				blue = 0
			if("chestnut")
				red = 153
				green = 102
				blue = 0
			if("blue")
				red = 51
				green = 102
				blue = 204
			if("lightblue")
				red = 102
				green = 204
				blue = 255
			if("green")
				red = 0
				green = 102
				blue = 0
			if("albino")
				red = rand (200, 255)
				green = rand (0, 150)
				blue = rand (0, 150)

		red = max(min(red + rand (-25, 25), 255), 0)
		green = max(min(green + rand (-25, 25), 255), 0)
		blue = max(min(blue + rand (-25, 25), 255), 0)

		r_eyes = red
		g_eyes = green
		b_eyes = blue

	proc/randomize_aura_color()
		r_aura = rand(0, 255)
		g_aura = rand(0, 255)
		b_aura = rand(0, 255)
		var/pr = rand(0, 100)
		if(pr<34)		r_aura = rand(230, 255)
		else if(pr<67)	g_aura = rand(230, 255)
		else			b_aura = rand(230, 255)


	proc/randomize_skin_color()
		var/red
		var/green
		var/blue

		var/col = pick ("color")//, "black", "grey", "albino", "brown", "chestnut", "blue", "lightblue", "green")
		switch(col)
			if("black")
				red = 0
				green = 0
				blue = 0
			if("grey")
				red = rand (100, 200)
				green = red
				blue = red
			if("brown")
				red = 102
				green = 51
				blue = 0
			if("chestnut")
				red = 153
				green = 102
				blue = 0
			if("blue")
				red = 51
				green = 102
				blue = 204
			if("lightblue")
				red = 102
				green = 204
				blue = 255
			if("green")
				red = 0
				green = 102
				blue = 0
			if("albino")
				red = rand (200, 255)
				green = rand (0, 150)
				blue = rand (0, 150)
			if("color")
				red = rand (0, 255)
				green = rand (0, 255)
				blue = rand (0, 255)

		red = max(min(red + rand (-25, 25), 255), 0)
		green = max(min(green + rand (-25, 25), 255), 0)
		blue = max(min(blue + rand (-25, 25), 255), 0)

		r_skin = red
		g_skin = green
		b_skin = blue

	proc/mf_under(T as text)
		if(gender == FEMALE)	T+="_f"
		return T

	proc/update_preview_icon()		//seriously. This is horrendous.
		del(preview_icon_front)
		del(preview_icon_side)
		del(preview_icon)

		var/g = "m"
		if(gender == FEMALE)	g = "f"

		var/icon/icobase
		var/datum/species/current_species = all_species[species]

		if(current_species)
			icobase = current_species.icobase
		else
			icobase = 'icons/mob/pony_races/r_pony.dmi'

		preview_icon = new /icon(icobase, "torso_[g]")
		preview_icon.Blend(new /icon(icobase, "groin_[g]"), ICON_OVERLAY)
		preview_icon.Blend(new /icon(icobase, "head_[g]"), ICON_OVERLAY)

		for(var/name in list("r_leg","r_foot","l_leg","l_foot","r_arm","r_hand","l_arm","l_hand"))
			if(organ_data[name] == "amputated") continue

			var/icon/temp = new /icon(icobase, "[name]")
			if(organ_data[name] == "cyborg")
				temp.MapColors(rgb(77,77,77), rgb(150,150,150), rgb(28,28,28), rgb(0,0,0))

			preview_icon.Blend(temp, ICON_OVERLAY)


		//Magic horn
		if(current_species && current_species.flags & HAS_HORN)
			var/icon/I = new/icon(current_species.icobase, "horn")
			preview_icon.Blend(I, ICON_OVERLAY)



		// Skin color
		if(current_species && (current_species.flags & HAS_SKIN_COLOR))
			preview_icon.Blend(rgb(r_skin, g_skin, b_skin))

		if(cutie_mark && !(cutiemark_paint_east && custom_cutiemark))
			var/icon/cutie_mark_s = new/icon('icons/mob/cutiemarks.dmi', "icon_state" = cutie_mark)
			preview_icon.Blend(cutie_mark_s, ICON_OVERLAY)

		//Wings of pegasus
		if(current_species && (current_species.flags & HAS_WINGS))
			var/icon/I = new/icon(current_species.icobase, "wings")
			I.Blend(rgb(r_skin, g_skin, b_skin))
			preview_icon.Blend(I, ICON_OVERLAY)

		//Magic aura
		if(current_species && current_species.flags & HAS_HORN)
			var/icon/I = new/icon('icons/mob/pony.dmi', "icon_state" = "horn_light")
			I.Blend(rgb(r_aura, g_aura, b_aura), ICON_ADD)
			preview_icon.Blend(I, ICON_OVERLAY)


		var/icon/eyes_s = new/icon("icon" = 'icons/mob/pony_face.dmi', "icon_state" = current_species ? current_species.eyes : "eyes_s")
		if ((current_species && (current_species.flags & HAS_EYE_COLOR)))
			eyes_s.Blend(rgb(r_eyes, g_eyes, b_eyes), ICON_ADD)

		if(gender == FEMALE)	preview_icon.Blend(new /icon('icons/mob/pony.dmi', "f1"), ICON_OVERLAY)
		else					preview_icon.Blend(new /icon('icons/mob/pony.dmi', "m"), ICON_OVERLAY)

		var/datum/sprite_accessory/hair_style = hair_styles_list[h_style]
		if(hair_style)
			var/un = (current_species.flags & HAS_HORN) ? "_un" : ""
			var/icon/hair_s = new/icon("icon" = hair_style.icon, "icon_state" = "[hair_style.icon_state][un]_s")
			hair_s.Blend(rgb(r_hair, g_hair, b_hair), ICON_ADD)
			eyes_s.Blend(hair_s, ICON_OVERLAY)

		var/datum/sprite_accessory/facial_hair_style = facial_hair_styles_list[f_style]
		if(facial_hair_style)
			var/icon/facial_s = new/icon("icon" = facial_hair_style.icon, "icon_state" = "[facial_hair_style.icon_state]_s")
			facial_s.Blend(rgb(r_facial, g_facial, b_facial), ICON_ADD)
			eyes_s.Blend(facial_s, ICON_OVERLAY)

		var/icon/pony_tail_s
		var/datum/sprite_accessory/pony_tailstyle = pony_tail_styles_list[pony_tail_style]
		if(current_species.flags && pony_tailstyle)
			pony_tail_s = new/icon(pony_tailstyle.icon, "icon_state" = "[pony_tailstyle.icon_state]_s")
			pony_tail_s.Blend(rgb(r_tail, g_tail, b_tail), ICON_ADD)



		var/icon/clothes_s = null
		if(job_civilian_low & ASSISTANT)//This gives the preview icon clothes depending on which job(if any) is set to 'high'
			clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("grey_s"))
			clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
			if(backbag == 2)
				clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
			else if(backbag == 3 || backbag == 4)
				clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

		else if(job_civilian_high)//I hate how this looks, but there's no reason to go through this switch if it's empty
			switch(job_civilian_high)
				if(HOP)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("hop_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "ianshirt"), ICON_OVERLAY)
					switch(backbag)
						if(2)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(BARTENDER)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("ba_suit_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "tophat"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(BOTANIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("hydroponics_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "ggloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "apron"), ICON_OVERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "nymph"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-hyd"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CHEF)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("chef_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "chefhat"), ICON_OVERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "apronchef"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(JANITOR)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("janitor_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "bio_janitor"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(LIBRARIAN)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("red_suit_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "hairflower"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(QUARTERMASTER)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("qm_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "poncho"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CARGOTECH)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("cargotech_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "flat_cap"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(MINER)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("miner_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "bearpelt"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(LAWYER)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("internalaffairs_s"))
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon(INV_R_HAND_DEF_ICON, "briefcase"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "suitjacket_blue"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CHAPLAIN)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("chapblack_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "imperium_monk"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CLOWN)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("clown_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "clown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/mask.dmi', "clown"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/back.dmi', "clownpack"), ICON_OVERLAY)
				if(MIME)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("mime_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "lgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/mask.dmi', "mime"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "beret"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "suspenders"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

		else if(job_medsci_high)
			switch(job_medsci_high)
				if(RD)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("director_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "petehat"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-tox"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(SCIENTIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("sciencewhite_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_tox_open"), ICON_OVERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "metroid"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-tox"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(XENOBIOLOGIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("sciencewhite_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_tox_open"), ICON_OVERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "metroid"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-tox"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CHEMIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("chemistrywhite_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labgreen"), ICON_OVERLAY)
					else
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_chem_open"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-chem"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CMO)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("cmo_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "bio_cmo"), ICON_OVERLAY)
					else
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_cmo_open"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "medicalpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-med"), ICON_OVERLAY)
						if(4)
							clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(DOCTOR)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("medical_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "surgeon"), ICON_OVERLAY)
					else
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "medicalpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-med"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(GENETICIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("geneticswhite_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "monkeysuit"), ICON_OVERLAY)
					else
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_gen_open"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-gen"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(VIROLOGIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("virologywhite_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "white"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/mask.dmi', "sterile"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_vir_open"), ICON_OVERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "plaguedoctor"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "medicalpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-vir"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(ROBOTICIST)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("robotics_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "labcoat_open"), ICON_OVERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon(INV_R_HAND_DEF_ICON, "toolbox_blue"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

		else if(job_engsec_high)
			switch(job_engsec_high)
				if(CAPTAIN)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("captain_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "centcomcaptain"), ICON_OVERLAY)
					else
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "captain"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-cap"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(HOS)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("hosred_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "hosberet"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "securitypack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-sec"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(WARDEN)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("warden_s"))
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/feet.dmi', "slippers_worn"), ICON_OVERLAY)
					else
						clothes_s.Blend(new /icon('icons/mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "securitypack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-sec"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(DETECTIVE)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("detective_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/mask.dmi', "cigaron"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "detective"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "detective"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(OFFICER)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("secred_s"))
					clothes_s.Blend(new /icon('icons/mob/feet.dmi', "jackboots"), ICON_UNDERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/head.dmi', "officerberet"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "securitypack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-sec"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CHIEF)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("chief_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "brown"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/belt.dmi', "utility"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "hardhat0_white"), ICON_OVERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon(INV_R_HAND_DEF_ICON, "blueprints"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "engiepack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(ENGINEER)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("engine_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "orange"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/belt.dmi', "utility"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "hardhat0_yellow"), ICON_OVERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "hazard"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "engiepack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-eng"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(ATMOSTECH)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("atmos_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/hands.dmi', "bgloves"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/belt.dmi', "utility"), ICON_OVERLAY)
					if(prob(1))
						clothes_s.Blend(new /icon('icons/mob/suit.dmi', "firesuit"), ICON_OVERLAY)
					switch(backbag)
						if(2)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
						if(3)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel-norm"), ICON_OVERLAY)
						if(4)	clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

				if(AI)//Gives AI and borgs assistant-wear, so they can still customize their character
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("grey_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "straight_jacket"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "cardborg_h"), ICON_OVERLAY)
					if(backbag == 2)
						clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
					else if(backbag == 3 || backbag == 4)
						clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)
				if(CYBORG)
					clothes_s = new /icon('icons/mob/uniform.dmi', mf_under("grey_s"))
					//clothes_s.Blend(new /icon('icons/mob/feet.dmi', "black"), ICON_UNDERLAY)
					clothes_s.Blend(new /icon('icons/mob/suit.dmi', "cardborg"), ICON_OVERLAY)
					clothes_s.Blend(new /icon('icons/mob/head.dmi', "cardborg_h"), ICON_OVERLAY)
					if(backbag == 2)
						clothes_s.Blend(new /icon('icons/mob/back.dmi', "backpack"), ICON_OVERLAY)
					else if(backbag == 3 || backbag == 4)
						clothes_s.Blend(new /icon('icons/mob/back.dmi', "satchel"), ICON_OVERLAY)

		if(disabilities & NEARSIGHTED)
			preview_icon.Blend(new /icon('icons/mob/eyes.dmi', "glasses"), ICON_OVERLAY)

		preview_icon.Blend(eyes_s, ICON_OVERLAY)
		if(pony_tail_s)
			preview_icon.Blend(pony_tail_s, ICON_OVERLAY)
		if(clothes_s)
			preview_icon.Blend(clothes_s, ICON_OVERLAY)
		preview_icon_front = new(preview_icon, dir = SOUTH)
		preview_icon_side = new(preview_icon, dir = WEST)

		if(cutiemark_paint_west && custom_cutiemark)
			preview_icon_side.Blend(cutiemark_paint_west, ICON_OVERLAY)

		del(eyes_s)
		del(pony_tail_s)
		del(clothes_s)



