var/ID_Number = 0
var/Forum_ID_Number = 0
mob/var/tmp/obj/Forums/Forum/Selected_Forum = null
mob/var/switch_language = "ENG"
mob/var/tmp/list/closed_sections = list()
mob/verb/forum()
	src.Display_HTML_Forum()


proc
	save_ID()
		var/filename = "Forum/Forum_IDs.sav"
		var/savefile/F = new(filename)
		var/directory = "/Forum/Forum/"
		F.cd = directory
		F["ID"] << ID_Number
		F["Forum_ID"] << Forum_ID_Number
	load_ID()
		if(length(file2text("Forum/Forum_IDs.sav")))//Если есть файл с сейвами
			var/filename = "Forum/Forum_IDs.sav"//Название файла
			var/savefile/F = new(filename)//
			F.cd = "/Forum/Forum/"
			F["ID"] >> ID_Number
			F["Forum_ID"] >> Forum_ID_Number
			if(ID_Number == null)
				ID_Number = 0
			if(Forum_ID_Number == null)
				Forum_ID_Number = 0

proc/probels(var/n)
	var/text = ""
	for(var/i = 0; i < n; i++)	text = "[text] "
	return text

mob/proc/Display_HTML_Forum()
	if(!Forum_Banned.Find("[key]"))//Отфильтровка забаненных
		var/list/Forum_List = list()
		var/list/sections = list()
		var/HTML = "<html><body bgcolor=#608590>"
		////////////////////////////////////////////////////////
		for(var/obj/Forums/Forum/Fg in world)
			if(Fg.valid2 == 1)
				Forum_List += Fg
				if(Fg.section)
					var/t = 0
					for(var/obj/Forums/Forum/temp_F in sections)
						if(Fg.section == temp_F.section)
							t = 1
							break
					if(t)	continue
					sections += Fg
		////////////////////////////////////////////////////////
		HTML += "<b><a href='?reference=switch_lang'>[switch_language]</a></b>  <a href='?reference=update'>Update</a><hr /><br></html><html>"
		for(var/obj/Forums/Forum/sect in sections)
			if(sect.language != switch_language)	continue
			if(sect.section in closed_sections)
			///////////////////////////////////////////////////////////////
				HTML += "<b><head><style>a {text-decoration: none} </style></head><FONT SIZE=+2><a href='?reference=ViewSection;section=[sect.section]'>+</a></FONT>"
				HTML += " <FONT COLOR=#201040 SIZE=+3>[sanitize_lang(sect.section)]</FONT></b><br>"
			else
				HTML += "<head><style>a {text-decoration: none} </style></head><FONT SIZE=+3><a href='?reference=ViewSection;section=[sect.section]'>-</a></FONT>"
				HTML += " <b><FONT SIZE=+3>[sanitize_lang(sect.section)]</FONT></b><br>"
			////////////////////////////////////////////////////////////////
				for(var/obj/Forums/Forum/Fg in Forum_List)
					if(Fg.language != src.switch_language || Fg.parent || Fg.section != sect.section)	continue
					HTML += "<table><tr><td align = left valign = middle>  <a href='?reference=ViewForum;forum=[Fg.MyForum_ID]'><FONT FACE=Arial COLOR=#404000 SIZE=+1>[sanitize_lang(Fg.name)]</FONT></a><td>"
					if(Fg.time_update)	HTML += "<td align = right valign = middle>[probels(40-lentext(Fg.name))]UPD: <a href='?reference=Thread;messageID=[Fg.last_topic.MyID];forum=[Fg.MyForum_ID]'>[sanitize_lang(Fg.last_topic.name)]</a></td>"
					HTML += "</tr><br><tr>"
					var/p = 0
					for(var/obj/Forums/Forum/child in Forum_List)
						if(child.parent == Fg)
							p += lentext(child.name)+3
							HTML += "<td align = left valign = middle>   <a href='?reference=ViewForum;forum=[child.MyForum_ID]'><FONT SIZE=2>[sanitize_lang(child.name)]</FONT></a></td>"
					if(Fg.time_update)	HTML += "<td align = right valign = middle>[probels(40-p)][time2text(Fg.time_update)] by [Fg.last_author]</td>"
					HTML += "</tr></table><br>"

		src << browse(HTML, "window=forum; size=600x500; botder=1")
	else
		alert(usr, "You are banned from the [world.name] forums.")


mob/proc/Display_HTML_SubForum()
	var/obj/Forums/Forum/F = src.Selected_Forum
	src << browse_rsc('Closed Thread.dmi',"TheX")
	src << browse_rsc('New Topic.jpg',"NewTopic")
	if(!Forum_Banned.Find("[key]"))
		var/list/Forum_List = list()
		for(var/obj/Forums/Forum/Fg in world)
			if(Fg.valid2 == 1)
				Forum_List += Fg
		var/HTML = "<html><body bgcolor=#608590><head><style>a {text-decoration: none} </style></head></html><html>"
		HTML += "<b><a href='?reference=switch_lang'>[switch_language]</a></b>  <a href='?reference=update'>Update</a><hr />"
		if(F.section)	HTML += "</center><br><br><center><b><font size = +2><a href='?reference=ViewMain'>[F.section]</a>  /  "
		else	HTML += "</center><br><br><center><b><font size = +2><a href='?reference=ViewMain'>[F.parent.section]</a>  /  <a href='?reference=ViewForum;forum=[F.parent.MyForum_ID]'>[F.parent]</a>  /  "
		HTML += "[F.name]</font></b><br>[F.desc]</center><br><table cellspacing=20 width = 100%  border=0>"
		for(var/obj/Forums/Forum/Fg in Forum_List)//Строим форумы
			if(Fg.parent != F)	continue
			HTML += "<table><tr><td align = left valign = middle>  <a href='?reference=ViewForum;forum=[Fg.MyForum_ID]'><FONT FACE=Arial COLOR=#404000 SIZE=+1>[sanitize_lang(Fg.name)]</FONT></a><td>"
			if(Fg.time_update)	HTML += "<td align = right valign = middle>[probels(40-lentext(Fg.name))]UPD: <a href='?reference=Thread;messageID=[Fg.last_topic.MyID];forum=[Fg.MyForum_ID]'>[sanitize_lang(Fg.last_topic.name)]</a></td>"
			HTML += "</tr><br><tr>"
			if(Fg.time_update)	HTML += "<td align = right valign = middle>[probels(40)][time2text(Fg.time_update)] by [Fg.last_author]</td>"
			HTML += "</tr></table><br>"
		if(Forum_Page[F.name] == 0||Forum_Page[F.name] == null)
			Forum_Page[F.name] = 1
		var/max_pages = F.Forum_Threads.len/10
		var/end = Forum_Page[F.name]*10
		var/start = end-10
		if(start < 0)
			start = 0
		var/list/list_duplicate = new/list()
		for(var/T=length(F.Forum_Threads);T>0;T--)
			if(F.Forum_Threads[T] != null)
				list_duplicate+=F.Forum_Threads[T]
			else
				F.Forum_Threads -= F.Forum_Threads[T]
		if(Administrator_Keys.Find(src.key))
			HTML += "<tr><td  valign=middle><a href='?reference=Admin;forum=[F.MyForum_ID]'><font color = #F50000>Moderator Commands \[*]</font></a></td></tr><tr>"
		if(!F.topic_on)	goto End
		if(Forum_Page[F.name] < max_pages)
			HTML += "<tr><td><a href='?reference=Next;forum=[F.MyForum_ID]'>Next  -></a></td></tr><tr><td> </td></tr>"
		HTML += "</table><table bgcolor=#CCCCFC cellpadding=15 width = 100% border=0><tr><td><a href='?reference=NewThread;forum=[F.MyForum_ID]'><img src=NewTopic></a></td></tr><tr><td> </td></tr>"
		var/w = 0
		var/MyColor = 1
		for(var/obj/Forums/Forum/Thread/O in list_duplicate)
			if(O.MyID > 0)
				if(O.icon != 'Closed Thread.dmi')
					if(w >= start&&w < end)
						if(O.Message != "")
							if(MyColor == 1)
								MyColor = 0
								HTML += "<tr bgcolor=#CCCCF0>"
							else
								MyColor = 1
								HTML += "<tr bgcolor=#CCCCFF>"
							HTML += "<td><a href='?reference=Thread;messageID=[O.MyID];forum=[F.MyForum_ID]'>[O.name]</a><br>[time2text(O.time_update)]"
							//if(F.time_update && text2time(F.time_update) < text2time(O.time_update) || !F.time_update)
							F.time_update = O.time_update
							if(O.Forum_Messages.len == 1)
								HTML += "        [O.Forum_Messages.len] reply"
							else
								HTML += "        [O.Forum_Messages.len] replies"
							w++
							HTML += "</td><td align=right valign=middle><b><font color = #707070>Author:  </font></b><font color = #4040CC>[O.suffix]</font></td></tr>"
						else
							F.Forum_Threads -= O
					else if(w < end&&w < start)
						w++
					else
						if(w > end)
							break
				else
					if(w >= start&&w < end)
						if(O.Message != "")
							if(MyColor == 1)
								MyColor = 0
								HTML += "<tr bgcolor=#CCCCF0>"
							else
								MyColor = 1
								HTML += "<tr bgcolor=#CCCCFF>"
							HTML += "<td valign=middle><img src=TheX><a href='?reference=Thread;messageID=[O.MyID];forum=[F.MyForum_ID]'>[sanitize_lang(O.name)]</a>"
							if(O.Forum_Messages.len == 1)
								HTML += "        [O.Forum_Messages.len] reply"
							else
								HTML += "        [O.Forum_Messages.len] replies"
							w++
							HTML += "</td><td align=right valign=middle><b><font color = #707070>Author:  </font></b><font color = #4040CC>[O.suffix]</font></td></tr>"
						else
							F.Forum_Threads -= O
					else if(w < end&&w < start)
						w++
					else
						if(w > end)
							break
		if(Forum_Page[F.name] > 1)
			HTML += "</table><table cellspacing=20 width = 100%  border=0><tr><td> </td></tr>"
			HTML += "<tr><td><a href='?reference=Prev;forum=[F.MyForum_ID]'><-  Previous</a></td></tr>"
		End
		HTML += "</table></body></html>"
		src << browse(HTML, "window=forum")
	else
		alert(usr, "You are banned from the [world.name] forums.")


client/Topic(href,href_list[])
	switch(href_list["reference"])
		if("update")//Обновление страницы
			if(mob.Selected_Forum)	mob.Display_HTML_SubForum()
			else					mob.Display_HTML_Forum()
		if("switch_lang")//Переклюение форумов по языку
			switch(mob.switch_language)
				if("ENG")	mob.switch_language = "RUS"
				if("RUS")	mob.switch_language = "ENG"
			mob.Selected_Forum = null
			mob.Display_HTML_Forum()
		if("ViewMain")//Возвращение в главное меню
			mob.Selected_Forum = null
			mob.Display_HTML_Forum()
		if("ViewSection")//+- Отображения разделов форумов на главной странице
			if(href_list["section"] in mob.closed_sections)	mob.closed_sections -= href_list["section"]
			else	mob.closed_sections += href_list["section"]
			mob.Display_HTML_Forum()
		if("ViewForum")//Переход к содержимому форумов и подфорумов
			for(var/obj/Forums/Forum/FF in world)
				if(text2num(href_list["forum"]) == FF.MyForum_ID)
					mob.Selected_Forum = FF
					break
			if(mob.Selected_Forum)	mob.Display_HTML_SubForum()
		if("Admin")
			var/obj/Forums/Forum/F
			for(var/obj/Forums/Forum/FF in world)
				if(text2num(href_list["forum"]) == FF.MyForum_ID)
					F = FF
					break
			if(F != null)
				F.Forum_Admin.Click()
		if("Next")
			var/obj/Forums/Forum/F
			for(var/obj/Forums/Forum/FF in world)
				if(text2num(href_list["forum"]) == FF.MyForum_ID)
					F = FF
					break
			if(F != null)
				F.Forum_Next.Click()
		if("Prev")
			var/obj/Forums/Forum/F
			for(var/obj/Forums/Forum/FF in world)
				if(text2num(href_list["forum"]) == FF.MyForum_ID)
					F = FF
					break
			if(F != null)
				F.Forum_Prev.Click()
		if("Reply")
			var/obj/Forums/Forum/F
			for(var/obj/Forums/Forum/FF in world)
				if(text2num(href_list["forum"]) == FF.MyForum_ID)
					F = FF
					break
			if(F != null)
				F.Forum_Reply.Click()
		if("NewThread")
			var/obj/Forums/Forum/F
			for(var/obj/Forums/Forum/FF in world)
				if(text2num(href_list["forum"]) == FF.MyForum_ID)
					F = FF
					break
			if(F != null)
				F.Forum_New_Thread.Click()
		if("Back")
			if(mob.Selected_Forum)	mob.Display_HTML_SubForum()
			else	mob.Display_HTML_Forum()
		if("Thread")//Переход в тему по нажатию на ее название
			var/obj/Forums/Forum/F
			for(var/obj/Forums/Forum/FF in world)
				if(text2num(href_list["forum"]) == FF.MyForum_ID)
					F = FF
					break
			if(F != null)
				var/obj/Forums/Forum/FFF
				for(var/obj/Forums/Forum/Thread/FFFF in world)
					if(text2num(href_list["messageID"]) == FFFF.MyID)
						FFF = FFFF
						break
				if(FFF != null)
					FFF.Click()
		if("DeleteThread")
			var/obj/Forums/Forum/F
			for(var/obj/Forums/Forum/FF in world)
				if(text2num(href_list["forum"]) == FF.MyForum_ID)
					F = FF
					break
			if(F != null)
				var/obj/Forums/Forum/Thread/FFF
				for(var/obj/Forums/Forum/Thread/FFFF in world)
					if(text2num(href_list["messageID"]) == FFFF.MyID)
						FFF = FFFF
						break
				if(FFF != null)
					FFF.Delete_Message2()
		if("DeleteMessage")
			var/obj/Forums/Forum/F
			for(var/obj/Forums/Forum/FF in world)
				if(text2num(href_list["forum"]) == FF.MyForum_ID)
					F = FF
					break
			if(F != null)
				var/obj/Forums/Forum/Message/FFF
				for(var/obj/Forums/Forum/Message/FFFF in world)
					if(text2num(href_list["messageID"]) == FFFF.MyID)
						FFF = FFFF
						break
				if(FFF != null)
					FFF.Delete_Message2()
		if("CloseThread")
			var/obj/Forums/Forum/F
			for(var/obj/Forums/Forum/FF in world)
				if(text2num(href_list["forum"]) == FF.MyForum_ID)
					F = FF
					break
			if(F != null)
				F.Forum_Close_Thread.Click()
	..()







mob/proc/AdminCheckThread(var/obj/Forums/Forum/Foo,var/obj/Forums/Forum/Thread/ohm)
	src << browse_rsc('Delete Thread.jpg',"DeleteThreader")
	var/HTML = "<a href='?reference=DeleteThread;forum=[Foo.MyForum_ID];messageID=[ohm.MyID]'><img src=DeleteThreader align=middle></a>"
	if(Administrator_Keys.Find(src.key))
		return HTML
	else
		return "<br>"

mob/proc/AdminCheckThread2(var/obj/Forums/Forum/Fooo,var/obj/Forums/Forum/Thread/ohm2)
	src << browse_rsc('closethread.jpg',"CloseThreader")
	var/HTML = "<a href='?reference=CloseThread;forum=[Fooo.MyForum_ID];messageID=[ohm2.MyID]'><img src=CloseThreader align=middle></a>"
	if(Administrator_Keys.Find(src.key)&&ohm2.icon != 'Closed Thread.dmi')
		return HTML
	else
		return ""

mob/proc/AdminCheckMessage(var/obj/Forums/Forum/Foooo,var/obj/Forums/Forum/Message/ohm3)
	src << browse_rsc('Delete Message.jpg',"DeleteMessager")
	var/HTML = "<a href='?reference=DeleteMessage;forum=[Foooo.MyForum_ID];messageID=[ohm3.MyID]'><img src=DeleteMessager align=middle></a>"
	if(Administrator_Keys.Find(src.key))
		return HTML
	else
		return "<br>"

mob/proc/ReplyCheckClosed(var/obj/Forums/Forum/Fooooo)
	src << browse_rsc('Reply.jpg',"Replyer")
	var/HTML = "<a href='?reference=Reply;forum=[Fooooo.MyForum_ID]'><img src=Replyer align=middle></a>"
	if(src.Forum_Thread.icon != 'Closed Thread.dmi')
		return HTML
	else
		return "<br>"








