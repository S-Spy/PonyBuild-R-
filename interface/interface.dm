//Please use mob or src (not usr) in these procs. This way they can be called in the same fashion as procs.
/client/verb/wiki()
	set name = "wiki"
	set desc = "Visit the wiki."
	set hidden = 1
	if( config.wikiurl )
		if(alert("This will open the wiki in your browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(config.wikiurl)
	else
		src << "\red The wiki URL is not set in the server configuration."
	return

/client/verb/github()//Не забыть про чейнжлог
	set name = "github"
	set desc = "Visit the our github repository."
	set hidden = 1
	if( config.githuburl )
		if(alert("This will open the github in your browser. Are you sure?",,"Yes","No")=="Yes")
			src << link(config.githuburl)
	else
		src << "\red The github URL is not set in the server configuration."
	return

var/list/bagreports = list()

/client/verb/changes()
	set name = "Changelog"
	set category = "OOC"
	set hidden = 1
	getFiles(
		'html/postcardsmall.jpg',
		'html/somerights20.png',
		'html/88x31.png',
		'html/bug-minus.png',
		'html/cross-circle.png',
		'html/hard-hat-exclamation.png',
		'html/image-minus.png',
		'html/image-plus.png',
		'html/music-minus.png',
		'html/music-plus.png',
		'html/tick-circle.png',
		'html/wrench-screwdriver.png',
		'html/spell-check.png',
		'html/burn-exclamation.png',
		'html/chevron.png',
		'html/chevron-expand.png',
		'html/changelog.css',
		'html/changelog.js',
		'html/changelog.html'
		)
	src << browse('html/changelog.html', "window=changes;size=675x650")
	if(prefs.lastchangelog != changelog_hash)
		prefs.lastchangelog = changelog_hash
		prefs.save_preferences()
		winset(src, "rpane.changelog", "background-color=none;font-style=;")

/client/verb/fast_bug_report()//Не забыть про чейнжлог
	set name = "fast_bug_report"
	set desc = "You can read and write here about actual errors."
	set hidden = 1
	var/dat = "<html><body>"
	for(var/message in bagreports)
		if(message)
			dat += message
			if(check_rights(R_ADMIN, 0) || findtext(message, key))
				dat += " - <a href='?src=\ref[src];bugreport=remove;msg=[bagreports.Find(message)]'> Remove</a>"
			dat += "<br><br>"
	dat += "<a href='?src=\ref[src];bugreport=add'><b>\[Add Report\]</a></b><br>"
	dat += "</body></html>"
	usr << browse(dat, "window=bugreport;size=300x400")

/world/New()
	..()
	var/file = file2text("data/bagreport.txt")
	bagreports = splittext(file, "\n")


/world/Del()
	fdel("data/bagreport.txt")
	for(var/message in bagreports)
		if(message)	text2file("[message]\n","data/bagreport.txt")
	..()

/client/var/language = "eng"
/client/proc/show_motd(var/source = "welcome_[language]")
	var/label_lang 		= (language == "ru") ? "Язык" 			: "Language"
	var/label_home 		= (language == "ru") ? "Главная" 		: "Home"
	var/label_changelog = (language == "ru") ? "Обновления" 	: "Changelog"
	var/label_rules 	= (language == "ru") ? "Правила" 		: "Rules"
	var/label_stories 	= (language == "ru") ? "Истории" 		: "History"
	var/label_wiki 		= (language == "ru") ? "Вики" 			: "Wiki"
	var/label_admin 	= (language == "ru") ? "Администрация" : "Administration"
	var/label_credits 	= (language == "ru") ? "Благодарности" : "Credits"


	var/dat = {"
<html>
<head>
<title>[source]</title>
<meta charset="windows-1251">
<script>
	function page_home() 		{location.href='?_src_=welcome;motd=welcome_[language]';}
	function page_changelog() 	{location.href='?_src_=welcome;motd=changelog_[language]';}
	function page_rules() 		{location.href='?_src_=welcome;motd=rules_[language]';}
	function page_credits() 	{location.href='?_src_=welcome;motd=credits_[language]';}
	function page_stories()		{location.href='?_src_=welcome;motd=stories';}
	function page_wiki() 		{location.href='?_src_=welcome;motd=wiki';}
	function page_admin() 		{location.href='?_src_=welcome;motd=admins;';}

</script>
 </head>


<body>
<table><tr>
<td width = 80><input type="button" value="[label_home]" id="button1_home" onclick="page_home()">				</td>
<td width = 40>																									</td>
<td><input type="button" value="[label_changelog]" 		id="button2_changelog" onclick="page_changelog()">		</td>
<td><input type="button" value="[label_rules]" 			id="button3_rules" onclick="page_rules()">				</td>
<td><input type="button" value="[label_stories]" 		id="button4_stories" onclick="page_stories()">			</td>
<td><input type="button" value="[label_wiki]" 			id="button5_wiki" onclick="page_wiki()">				</td>
<td><input type="button" value="[label_admin]" 			id="button6_admin" onclick="page_admin()">				</td>
<td align="right"><input type="button" value="[label_credits]" id="button7_credits" onclick="page_credits()">	</td>
</tr><tr>
<td>[label_lang]: 															</td>
<td><a href='?_src_=welcome;motd=switch_lang;old=[source]'>[language]</a> 	</td>
</tr><table>

<br>

[file2text("config/info/[source].html")]

</body></html>
	"}
	usr << browse(fix_html(dat), "window=welcome;size=850x400")


/client/Topic(href, href_list[])
	if(href_list["motd"])
		if(href_list["motd"]=="switch_lang")
			language = (language == "ru") ? "eng" : "ru"
			switch(href_list["old"])
				if("welcome_eng")	show_motd("welcome_ru")
				if("welcome_ru")	show_motd("welcome_eng")
				if("changelog_eng")	show_motd("changelog_ru")
				if("changelog_ru")	show_motd("changelog_eng")
				if("rules_eng")		show_motd("rules_ru")
				if("rules_ru")		show_motd("rules_eng")
				if("credits_eng")	show_motd("credits_ru")
				if("credits_ru")	show_motd("credits_eng")
				else	show_motd(href_list["old"])
		else
			show_motd(href_list["motd"])

	..()


/client/verb/welcome()
	set hidden = 1
	show_motd("welcome_[language]")


/client/Topic(href, href_list[])
	switch(href_list["bugreport"])
		if("add")
			var/message = input("Введите описание ошибки.","Сообщение")
			if(message)
				bagreports += "<b>[usr.key]:</b> [replacetext(message, "я", "&#1103;")]"
			fast_bug_report()
		if("remove")
			if(alert("You're sure?", null, "Yes", "No")=="Yes")
				bagreports -= bagreports[text2num(href_list["msg"])]
				fast_bug_report()
		else ..()

/client/verb/forum()
	set name = "forum"
	set desc = "Visit the forum ingame."
	set hidden = 1
	if(mob.Selected_Forum)	mob.Display_HTML_Forum()
	else	mob.Display_HTML_SubForum()

#define BACKSTORY_FILE "config/backstory.html"
/client/verb/backstory()
	set name = "backstory"
	set desc = "Show our backstories."
	set hidden = 1

	src << browse(file(BACKSTORY_FILE), "window=backstory;size=480x320")
	return
#undef BACKSTORY_FILE


#define RULES_FILE "config/rules.html"
/client/verb/rules()
	set name = "Rules"
	set desc = "Show Server Rules."
	set hidden = 1
	src << browse(file(RULES_FILE), "window=rules;size=480x320")
#undef RULES_FILE

/client/verb/hotkeys_help()
	set name = "hotkeys-help"
	set category = "OOC"

	var/hotkey_mode = {"<font color='purple'>
Hotkey-Mode: (hotkey-mode must be on)
\tTAB = toggle hotkey-mode
\ta = left
\ts = down
\td = right
\tw = up
\tq = drop
\te = equip
\tr = throw
\tt = say
\t5 = emote
\tx = swap-hand
\tz = activate held object (or y)
\tj = toggle-aiming-mode
\tf = cycle-intents-left
\tg = cycle-intents-right
\t1 = help-intent
\t2 = disarm-intent
\t3 = grab-intent
\t4 = harm-intent
</font>"}

	var/other = {"<font color='purple'>
Any-Mode: (hotkey doesn't need to be on)
\tCtrl+a = left
\tCtrl+s = down
\tCtrl+d = right
\tCtrl+w = up
\tCtrl+q = drop
\tCtrl+e = equip
\tCtrl+r = throw
\tCtrl+x = swap-hand
\tCtrl+z = activate held object (or Ctrl+y)
\tCtrl+f = cycle-intents-left
\tCtrl+g = cycle-intents-right
\tCtrl+1 = help-intent
\tCtrl+2 = disarm-intent
\tCtrl+3 = grab-intent
\tCtrl+4 = harm-intent
\tF1 = adminhelp
\tF2 = ooc
\tF3 = say
\tF4 = emote
\tDEL = pull
\tINS = cycle-intents-right
\tHOME = drop
\tPGUP = swap-hand
\tPGDN = activate held object
\tEND = throw
</font>"}

	var/admin = {"<font color='purple'>
Admin:
\tF5 = Aghost (admin-ghost)
\tF6 = player-panel-new
\tF7 = admin-pm
\tF8 = Invisimin
</font>"}

	src << hotkey_mode
	src << other
	if(holder)
		src << admin
