#define ADDOS_DELAY 3
#define LEN_SAY_MUTE 10
#define LEN_SAY_KICK 30
#define TIME_MUTE 600

/client/var/list/say_messages = list()
/client/var/list/me_messages = list()
/client/var/list/ooc_messages = list()


/client/proc/message2list(var/message, list/messages)
	if(messages.len > LEN_SAY_KICK)
		var/client/C = usr
		del(C)
		return 0

	if(messages.len > LEN_SAY_MUTE)







/client/proc/check_addos_messages()
	if(messages.len > LEN_SAY_KICK)
		sleep(TIME_KICK)
		return 0

	var/first_message = messages[1]

	if(messages.len > LEN_SAY_MUTE)
		sleep(TIME_MUTE)
		messages = list()
	else
		sleep(ADDOS_DELAY)
		messages.Remove(messages[1])

	return first_message






/*
јлгоритм:
say добавл€ет в список пользовател€ сообщение
auto_say каждые ADDOS_DELAY спавнит новое сообщение от пользовател€

say нужно переназначить вывод в /mob/add_message
auto_say должен быть прив€зан к клиенту и различать OOC и Say

 ак автосей различает OOC и IC?
—лишком сложно
ѕридетс€ поделить на чаты

*/