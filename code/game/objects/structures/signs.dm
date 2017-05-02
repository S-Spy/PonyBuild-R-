var/list/stone_text_list = list("(Надпись стерлась под влиянием времени)",
"ЗДЕСЬ ЛЕЖИТ АРВЕЛИС САВЕЛЛИОН, САМЫЙ УЖАСНЫЙ ИЗ УЖАСНЫХ И САМЫЙ ВОИНСТВЕННЫЙ ИЗ ВОИНСТВЕННЫХ.",
"Здесь похоронен лучший друг и просто хороший понь Персик Кусок.",
"Здесь лежит Крис Авеллон, король дискотек.",
"Кристофер Джонс 'Ночное крыло'- повелитель фингалов",
"Кристофер Майкл Холланд, он же 'Крис Холланд', он же 'Крис': Есть две с половиной причины прочесть эту надпись... Наверное, надо было их перечислить.",
"Колин МакКомб: Еще одна бессмысленная жизнь.",
"Дэвид Хэнди: самый громкий среди мертвецов. Да упокоится он с миром и не орет больше.",
"Эрик Демлит. НАСТОЯЩИЙ боец.",
"Фергюс Уркхарт: надорвался на очередном чертовом списке.",
"Джесс Рейнолдс. Любил имбирное печенье. Слишком сильно.",
"Мэтт Нортон. Мог бы кем-то стать. Мог бы стать борцом, а не бездельником, каким был.",
"Роберт Коллиер. Тихий. Смертоносный. Роб.",
"Роберт Хертенштайн 2. Врач пытался сказать ему что-то, но он настаивал: 'С меня хватит информации.'",
"Здесь лежит Скотт Ивертс. Опоздал на работу. На всю жизнь.",
"Томас Френч: умер при попытке справиться с Летающей Гильотиной.",
"Т. Д. Гамильтон: Здесь покоится грязная тварь, которой следовало умереть давным-давно. Гори в аду!",
"Здесь лежит Лестер Мур, в нем четверка дыр, у каждой - сорок четвертый калибр.",
"Ивэн Чантленд: Он не был параноиком, они и в самом деле охотились за ним.",
"Лежит здесь Лось, и холодна его могила. Нашли без головы: наверно, так и было.",
"Стивен Боккс, 25. Ушел во цвете лет, не без помощи камней и стрел жестокой судьбы.",
"Здесь покоится Донни Корнуэлл, хороший и мертвый. В здоровенном гробу, чтобы поместилась его здоровенная голова.",
"Роб Джампа прожил свою жизнь, как имел своих женщин: быстро, дешево и без затей.",
"Песобомб мертв. Да здравствует Пес.",
"Крис Снайдер: слишком любил состязаться.",
"Сделали вы в своей жизни что-нибудь полезное?",
"Почему бы вам не покончить с собой и не избавить кого-то от лишних хлопот?",
"Редж Арнедо: мы до сих пор слышим его голос.",
"Джей Нильсон ''Картофельная нога''. Музыкант. Опочил в возрасте 104 лет, во время соло на барабане.",
"Здесь спит Эзекииль Айкл, 102 года. Лучшие умирают молодыми.",
"Здесь лежит Джонни Ист. Простите, что не встаю.",
"Здесь лежит бедный Джонатан Браз, он хотел нажать тормоз, а вышло на газ.",
"Здесь лежит Батч, он быстро стрелял, но медленно ствол доставал.",
"Сэр Джон Странно. Если в мире был когда-то честный адвокат, то это Странно.",
"Я был кем-то. Кем -- не ваше дело.",
"Я говорил вам, что болен!",
"О путникъ, коль в деньгахъ нужда кому-то - лежитъ здесь Пенни, глубина 4 фута.",
"Она всегда говорила, что ноги ее доконают, но никто ей не верил.",
"В этой могиле лежит сиротливо Джонатан Скрипка, сыгравший фальшиво.",
"Ушел от нас Оуэн Мур, и больше ни мур-мур.",
"В память о Малыше Крисе Гробе. Лежит тут Гроб, положен в гроб, Гроб в гробе, как матрешка. Хоть внешний гроб отменно добр, внутри - дрянной немножко.",
"Под покровом дерна и чертополоха лежит тело несчастного Джона Гороха. Его здесь нет, здесь один лишь стручок: Горох же в раю -- молодец, старичок.",
"Эйлин Ик: после того, как окончила смешанный юридический колледж, сменила фамилию на Иск.",
"Сара Смарт: оратор, автор, профессор, De Amicitia.",
"Тим Винкл: ''Я не выносил никакого лицемерия, кроме своего собственногo''.",
""
)


/obj/structure/tombstone
	icon = 'icons/obj/cemetery.dmi'
	icon_state = "0"
	density = 1
	anchored = 1
	opacity = 0
	desc = "It's tombstone."
	var/stone_text

	New()
		icon_state = "tombstone[rand(1,8)]"
		stone_text = stone_text_list[rand(1,stone_text_list.len)]
		if(stone_text != stone_text_list[1])
			stone_text_list -= stone_text
	attack_hand(mob/user as mob)
		user << browse(stone_text, "window=name; size=200x80")
		..()


/obj/structure/sign
	icon = 'icons/obj/decals.dmi'
	anchored = 1
	opacity = 0
	density = 0
	layer = 3.5

/obj/structure/sign/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			del(src)
			return
		if(3.0)
			del(src)
			return
		else
	return

/obj/structure/sign/blob_act()
	del(src)
	return

/obj/structure/sign/attackby(obj/item/tool as obj, mob/user as mob)	//deconstruction
	if(istype(tool, /obj/item/weapon/screwdriver) && !istype(src, /obj/structure/sign/double))
		user << "You unfasten the sign with your [tool]."
		var/obj/item/sign/S = new(src.loc)
		S.name = name
		S.desc = desc
		S.icon_state = icon_state
		//var/icon/I = icon('icons/obj/decals.dmi', icon_state)
		//S.icon = I.Scale(24, 24)
		S.sign_state = icon_state
		del(src)
	else ..()

/obj/item/sign
	name = "sign"
	desc = ""
	icon = 'icons/obj/decals.dmi'
	w_class = 3		//big
	var/sign_state = ""

/obj/item/sign/attackby(obj/item/tool as obj, mob/user as mob)	//construction
	if(istype(tool, /obj/item/weapon/screwdriver) && isturf(user.loc))
		var/direction = input("In which direction?", "Select direction.") in list("North", "East", "South", "West", "Cancel")
		if(direction == "Cancel") return
		var/obj/structure/sign/S = new(user.loc)
		switch(direction)
			if("North")
				S.pixel_y = 32
			if("East")
				S.pixel_x = 32
			if("South")
				S.pixel_y = -32
			if("West")
				S.pixel_x = -32
			else return
		S.name = name
		S.desc = desc
		S.icon_state = sign_state
		user << "You fasten \the [S] with your [tool]."
		del(src)
	else ..()

/obj/structure/sign/double/map
	name = "station map"
	desc = "A framed picture of the station."

/obj/structure/sign/double/map/left
	icon_state = "map-left"

/obj/structure/sign/double/map/right
	icon_state = "map-right"

/obj/structure/sign/securearea
	name = "\improper SECURE AREA"
	desc = "A warning sign which reads 'SECURE AREA'."
	icon_state = "securearea"

/obj/structure/sign/biohazard
	name = "\improper BIOHAZARD"
	desc = "A warning sign which reads 'BIOHAZARD'."
	icon_state = "bio"

/obj/structure/sign/electricshock
	name = "\improper HIGH VOLTAGE"
	desc = "A warning sign which reads 'HIGH VOLTAGE'."
	icon_state = "shock"

/obj/structure/sign/examroom
	name = "\improper EXAM"
	desc = "A guidance sign which reads 'EXAM ROOM'."
	icon_state = "examroom"

/obj/structure/sign/vacuum
	name = "\improper HARD VACUUM AHEAD"
	desc = "A warning sign which reads 'HARD VACUUM AHEAD'."
	icon_state = "space"

/obj/structure/sign/deathsposal
	name = "\improper DISPOSAL LEADS TO SPACE"
	desc = "A warning sign which reads 'DISPOSAL LEADS TO SPACE'."
	icon_state = "deathsposal"

/obj/structure/sign/pods
	name = "\improper ESCAPE PODS"
	desc = "A warning sign which reads 'ESCAPE PODS'."
	icon_state = "pods"

/obj/structure/sign/fire
	name = "\improper DANGER: FIRE"
	desc = "A warning sign which reads 'DANGER: FIRE'."
	icon_state = "fire"

/obj/structure/sign/nosmoking_1
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking"

/obj/structure/sign/nosmoking_2
	name = "\improper NO SMOKING"
	desc = "A warning sign which reads 'NO SMOKING'."
	icon_state = "nosmoking2"

/obj/structure/sign/redcross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "redcross"

/obj/structure/sign/greencross
	name = "medbay"
	desc = "The Intergalactic symbol of Medical institutions. You'll probably get help here."
	icon_state = "greencross"

/obj/structure/sign/goldenplaque
	name = "The Most Robust Men Award for Robustness"
	desc = "To be Robust is not an action or a way of life, but a mental state. Only those with the force of Will strong enough to act during a crisis, saving friend from foe, are truly Robust. Stay Robust my friends."
	icon_state = "goldenplaque"

/obj/structure/sign/kiddieplaque
	name = "\improper AI developers plaque"
	desc = "Next to the extremely long list of names and job titles, there is a drawing of a little child. The child appears to be retarded. Beneath the image, someone has scratched the word \"PACKETS\""
	icon_state = "kiddieplaque"

/obj/structure/sign/atmosplaque
	name = "\improper FEA atmospherics division plaque"
	desc = "This plaque commemorates the fall of the Atmos FEA division. For all the charred, dizzy, and brittle men who have died in its hands."
	icon_state = "atmosplaque"

/obj/structure/sign/double/maltesefalcon	//The sign is 64x32, so it needs two tiles. ;3
	name = "The Maltese Falcon"
	desc = "The Maltese Falcon, Space Bar and Grill."

/obj/structure/sign/double/maltesefalcon/left
	icon_state = "maltesefalcon-left"

/obj/structure/sign/double/maltesefalcon/right
	icon_state = "maltesefalcon-right"

/obj/structure/sign/science			//These 3 have multiple types, just var-edit the icon_state to whatever one you want on the map
	name = "\improper SCIENCE!"
	desc = "A warning sign which reads 'SCIENCE!'."
	icon_state = "science1"

/obj/structure/sign/chemistry
	name = "\improper CHEMISTRY"
	desc = "A warning sign which reads 'CHEMISTRY'."
	icon_state = "chemistry1"

/obj/structure/sign/botany
	name = "\improper HYDROPONICS"
	desc = "A warning sign which reads 'HYDROPONICS'."
	icon_state = "hydro1"

/obj/structure/sign/directions/science
	name = "\improper Science department"
	desc = "A direction sign, pointing out which way the Science department is."
	icon_state = "direction_sci"

/obj/structure/sign/directions/engineering
	name = "\improper Engineering department"
	desc = "A direction sign, pointing out which way the Engineering department is."
	icon_state = "direction_eng"

/obj/structure/sign/directions/security
	name = "\improper Security department"
	desc = "A direction sign, pointing out which way the Security department is."
	icon_state = "direction_sec"

/obj/structure/sign/directions/medical
	name = "\improper Medical Bay"
	desc = "A direction sign, pointing out which way the Medical Bay is."
	icon_state = "direction_med"

/obj/structure/sign/directions/evac
	name = "\improper Escape Arm"
	desc = "A direction sign, pointing out which way the escape shuttle dock is."
	icon_state = "direction_evac"
