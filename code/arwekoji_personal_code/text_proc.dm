proc/subnum2textsystem(var/num)
	if(num < 10)	return "[num]"
	else			return "[ascii2text(65-10+num)]"

proc/num_10_to_sys(var/num, var/system=16)
	var/list/log_nums = list()

	while(num > system)
		log_nums = num%system + log_nums
		num = round(num/system)
	log_nums = num%system + log_nums

	var/text = ""
	for(var/n in log_nums)
		text += subnum2textsystem(n)

	return text