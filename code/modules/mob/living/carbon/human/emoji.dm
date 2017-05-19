/obj/screen/emoji
	name = "emoji"
	layer = 19
	icon = 'icons/mob/emoji.dmi'
	icon_state = "0"

/mob/living/carbon/pony/proc/update_happiness()//Символическое отображение самочувствия персонажа
	if(!client)	return
	var/obj/screen/emoji/emoji_hud = locate(/obj/screen/emoji) in client.screen
	if(!emoji_hud)	return



	var/health_level = 100 * health/maxHealth
	var/nutrition_level = 100 * nutrition/450





	var/happy_level = (health_level + nutrition_level)/2  // 0-100%
	happy_level = round(max(0, min(100, happy_level)))
	/*
	Есть основной режим - счастье. Вычисляется по формуле. Колебания вычисляют процентным рандомом
	И дополнительные режимы, для которых нужны особые условия. Пока без них
	*/

	switch(happy_level)
		if(97 to 100)			emoji_hud.icon_state = pick("3","pride", "0")
		if(90 to 96)			emoji_hud.icon_state = pick("3","2")
		if(80 to 89)			emoji_hud.icon_state = pick("2","1")
		if(60 to 79)			emoji_hud.icon_state = pick("1","0")
		if(41 to 59)			emoji_hud.icon_state = "0"
		if(21 to 40)			emoji_hud.icon_state = pick("-1","0")
		if(16 to 20)			emoji_hud.icon_state = pick("-2","-1")
		if(0 to 10)				emoji_hud.icon_state = pick("-3","angry", "0")


	if(nutrition_level>100)//Тошнота
		emoji_hud.icon_state = pick(prob(nutrition-450);"hush", emoji_hud.icon_state)

	if(stat != CONSCIOUS)
		emoji_hud.icon_state = "sleep"

	return happy_level



/mob/living/carbon/pony/proc/concentration(var/level=1)
		var/health_level = health/maxHealth
		var/starving = nutrition/500
		level = 1/level
		return 100-round((health_level+starving+level)*33)

