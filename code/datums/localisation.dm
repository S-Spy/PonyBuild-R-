//¬ начале имеем несколько массивов на каждый €зык по одному.  аждый массив имеет 2 столбца и безграничную высоту

var/list/localisation_languages = list("eng", "ru")

var/list/localisation_lists = list()//тут держатс€ массивы





datum/localisation_global
	var/lang
	var/list/ids = list() //"" = ""

	New(var/n)	// 1 - ¬ этом хранилище есть им€, равное его €зыку и список фраз "Ќа английском" = "Ќа локали"
		lang = n

		LoadIDFromData() // 2 - —начала записываютс€ фразы из файла этой локализации

	proc/LoadIDFromData()
		var/text = file2text("data/localisation/[lang].txt")

		//ƒальше нужно поделить на части
		while(findtext(text, "\"") && findtext(text, "="))
			var/first_pos = findtext(text, "\"")+1

			var/l1 = copytext(text, first_pos, findtext(text, "\"", first_pos))//»справить начальную позицию

			text = copytext(text, findtext(text, "=")+1)

			first_pos = findtext(text, "\"")+1
			var/l2 = copytext(text, first_pos, findtext(text, "\"", first_pos))

			ids[l1] = l2

			text = copytext(text, findtext(text, "\"", 2) + min(2, lentext(text)-findtext(text, "\"", 2)) )



	proc/LocalIDCompareWith(var/datum/localisation_global/LG2)//¬ случае большого числа €зыков использовать сравнение, дл€ добавлени€ недостающих позиций
		for(var/label in LG2.ids)
			if(!(label in ids))
				LocalAddLabel(label)//ѕуста€ позици€ добавитс€ в следующем раунды

	proc/LocalAddLabel(var/label)//ќбновление базы данных или по простому - добавление новой записи в файл локализации, чтобы еЄ перевели
		var/text = file2text("data/localisation/[lang].txt")
		var/add_text = "\"[label]\"=\"\""
		if(!findtext(text, add_text))
			text2file("[add_text]", "data/localisation/[lang].txt")





/world/New()
	..()
	for(var/lang in localisation_languages-"eng")	// 0 - ѕри создании мира создаетс€ хранилище массивов переведенных фраз
		var/datum/localisation_global/LG = new(lang)
		localisation_lists += list(lang = LG)

	for(var/datum/localisation_global/LG1 in localisation_lists)
		for(var/datum/localisation_global/LG2 in localisation_lists-LG1)
			LG1.LocalIDCompareWith(LG2)


proc/local(var/id_text, var/language, var/base_language)
	if(!language) //–асчет на то, что не придетс€ каждый раз указывать второй аргумент
		language = usr.client.language
	if(!language)
		language = "eng"

	if(language=="eng")//ƒаже если у игрока английский €зык - модуль локализации все равно обновл€ет базу данных
		for(var/L in localisation_lists)
			var/datum/localisation_global/LG1 = localisation_lists[L]
			if(!(id_text in LG1.ids))
				LG1.LocalAddLabel(id_text)
		return id_text

	var/datum/localisation_global/LG// ќпредел€ем массив дл€ данного €зыка
	for(var/lang in localisation_lists)
		var/datum/localisation_global/LG1 = localisation_lists[lang]
		if(LG1.lang==language)
			LG=LG1
			break

	if(id_text in LG.ids)
		if(!LG.ids[id_text] || LG.ids[id_text]=="")//≈сли запись пуста, то возвращаем английское значение
			return id_text
		else
			return LG.ids[id_text]//»наче локализацию
	else
		for(var/L in localisation_lists)
			var/datum/localisation_global/LG1 = localisation_lists[L]
			if(!(id_text in LG1.ids))
				LG1.LocalAddLabel(id_text)//≈сли запись вообще не существует, то база данных обновл€етс€
		return id_text