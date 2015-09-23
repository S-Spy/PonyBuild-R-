/*
 /--------------------------------------------------------\
|                                                          |
|     Forum Lib by Kunark...  Include it in your games!    |
|                                                          |
 \--------------------------------------------------------/



 /--------------------------------------------------------\
|                                                          |
|              Gritty code...  Don't Touch!                |
|                                                          |
 \--------------------------------------------------------/
*/

var/list/Administrator_Keys = new/list()
var/Forum_Master_Key = ""
var/Using_HTML_Forums = 1

world/New()
	..()
	load_ID()
	for(var/obj/Forums/Forum/F in world)
		if(F.Valid_Forum2 == 1)
			if(F.MyForum_ID <= 0||F.MyForum_ID == null)
				Forum_ID_Number++
				F.MyForum_ID = Forum_ID_Number
	save_ID()


obj/Forums
	Forum
		var/obj/Forums/Forum/Next/Forum_Next
		var/obj/Forums/Forum/Prev/Forum_Prev
		var/obj/Forums/Forum/Back/Forum_Back
		var/obj/Forums/Forum/Reply/Forum_Reply
		var/obj/Forums/Forum/Admin/Forum_Admin
		var/obj/Forums/Forum/Close_Thread/Forum_Close_Thread
		var/obj/Forums/Forum/Delete_Message/Forum_Delete
		var/obj/Forums/Forum/New_Thread/Forum_New_Thread
		var/list/Forum_Threads = list()
		var/Valid_Forum = 0
		var/MyForum_ID = 0
		var/Valid_Forum2 = 1
		New()
			Forum_Next = new
			Forum_New_Thread = new
			Forum_Prev = new
			Forum_Back = new
			Forum_Reply = new
			Forum_Close_Thread = new
			Forum_Delete = new
			Forum_Admin = new
			Valid_Forum = 1
			Forum_Next.Forum_Listing = src
			Forum_Back.Forum_Listing = src
			Forum_Reply.Forum_Listing = src
			Forum_Close_Thread.Forum_Listing = src
			Forum_Prev.Forum_Listing = src
			Forum_Delete.Forum_Listing = src
			Forum_New_Thread.Forum_Listing = src
			..()
			spawn() load_forums()
		Next
			var/obj/Forums/Forum/Forum_Listing
			name = "Next-->>"
			Valid_Forum2 = 0
			New()
				return
			Click()
				if(Forum_Banned.Find("[usr.key]"))
					return
				if(usr.Forum_Posting == 1)
					return
				usr.Forum_Page[Forum_Listing.name]++
				usr.Display_HTML_Forum(src.Forum_Listing)
				return
		Back
			var/obj/Forums/Forum/Forum_Listing
			name = "    ^-Back to Forum"
			Valid_Forum2 = 0
			New()
				return
			Click()
				if(Forum_Banned.Find("[usr.key]"))
					return
				if(usr.Forum_Posting == 1)
					return
				usr.Forum_Thread = null
				return
		Prev
			var/obj/Forums/Forum/Forum_Listing
			name = "<<--Previous"
			Valid_Forum2 = 0
			New()
				return
			Click()
				if(Forum_Banned.Find("[usr.key]"))
					return
				if(usr.Forum_Posting == 1)
					return
				usr.Forum_Page[Forum_Listing.name]--
				if(usr.Forum_Page[Forum_Listing.name] < 1)
					usr.Forum_Page[Forum_Listing.name] = 1
				usr.Display_HTML_Forum(src.Forum_Listing)
				return
		Admin
			name = "Moderator \[*\]"
			Valid_Forum2 = 0
			New()
				return
			Click()
				if(Forum_Banned.Find("[usr.key]"))
					return
				if(Administrator_Keys.Find(usr.key))
					if(usr.Forum_Posting == 1)
						return
					var/list/AdminList = list("Forum-Ban a Key","Forum-Unban a Key")
					if(usr.key == Forum_Master_Key)
						AdminList += "Add Moderator"
						AdminList += "Remove Moderator"
						AdminList += "Change Saved Thread Number"
					AdminList += "Nevermind..."
					switch(input("What do you want to do?","Moderator Commands") in AdminList)
						if("Forum-Ban a Key")
							var/FB = input("Input the key you wish to forum-ban.  This person will not be able to view the forums:","Forum-Ban") as text|null
							if(FB == ""||FB == null)
								return
							if(FB == Forum_Master_Key)
								usr << "You cannot ban the game's creator!"
								return
							if(src != Forum_Master_Key&&Administrator_Keys.Find(FB))
								usr << "You cannot ban another moderator."
								return
							Forum_Banned += FB
						if("Change Saved Thread Number")
							var/FB = input("Input the number of the thread that when the forums are saved, it will only save up to this number.  Minimum is 20:","Save Number",Forum_Saved) as num|null
							if(FB == null)
								return
							if(FB < 20)
								usr << "You cannot set this under 20."
								return
							Forum_Saved = FB
						if("Forum-Unban a Key")
							var/list/L = list()
							for(var/T in Forum_Banned)
								L += T
							L += "Nevermind..."
							var/FUB = input("Input the key you wish to forum-unban:","Forum-Unban") in L
							if(FUB == "Nevermind...")
								return
							Forum_Banned -= FUB
						if("Add Moderator")
							var/FB = input("Input the key you wish to add as a moderator.  This person will be able to use the forum administrative commands:","Add Moderator") as text|null
							if(FB == ""||FB == null)
								return
							Administrator_Keys += FB
						if("Remove Moderator")
							var/list/L = list()
							for(var/T in Administrator_Keys)
								if(T != usr.key)
									L += T
							L += "Nevermind..."
							var/FUB = input("Input the key you wish to remove moderator powers from:","Remove Moderator") in L
							if(FUB == "Nevermind...")
								return
							Administrator_Keys -= FUB
				return
		Close_Thread
			var/obj/Forums/Forum/Forum_Listing
			name = "Close Thread  \[X\]"
			Valid_Forum2 = 0
			New()
				return
			Click()
				if(Forum_Banned.Find("[usr.key]"))
					return
				if(Administrator_Keys.Find(usr.key))
					if(usr.Forum_Posting == 1)
						return
					usr.Forum_Posting = 1
					switch(alert("Are you sure you want to close this thread?","Close Thread","Yes","No"))
						if("Yes")
							usr.Forum_Thread.icon = 'Closed Thread.dmi'
					usr.Forum_Posting = 0
					if(Using_HTML_Forums == 1)
						usr.Forum_Thread.Click()
				return
		Delete_Message
			var/obj/Forums/Forum/Forum_Listing
			name = "Delete Message  \[-\]"
			Valid_Forum2 = 0
			New()
				return
			Click()
				if(Forum_Banned.Find("[usr.key]"))
					return
				if(Administrator_Keys.Find(usr.key))
					if(usr.Forum_Posting == 1)
						return
					usr.Forum_Posting = 1
					usr.Forum_Deleting = 1
					usr.Forum_Delete = null
					usr << "Now, select the message to delete."
					while(usr != null&&usr.Forum_Delete == null)
						sleep(5)
					if(usr == null)
						return
					switch(alert("Are you sure you want to delete this message?","Delete Message","Yes","No"))
						if("Yes")
							usr.Forum_Posting = 0
							usr.Forum_Deleting = 0
							Forum_Threads -= Forum_Delete
							del(usr.Forum_Delete)
						else
							usr.Forum_Posting = 0
							usr.Forum_Deleting = 0
				return
		New_Thread
			var/obj/Forums/Forum/Forum_Listing
			name = "\[New Topic\]"
			Valid_Forum2 = 0
			New()
				return
			Click()
				if(Forum_Banned.Find("[usr.key]"))
					return
				if(usr.Forum_Posting == 1)
					return
				usr.Forum_Posting = 1
				usr.Forum_Title = ""
				usr.Forum_Message = ""
				usr.Forum_Page[Forum_Listing.name] = 1
				var/Message = {"
<html>
<form method=get action='byond://' >
<input type=hidden name=src value='Message'>
<body bgcolor=#608590 text=black>
<B><FONT color = red><center>Title:</FONT></B><br>
<input type='text' name=ForumTitle size='58' maxlength='30'></textarea>
<br>
<br>
<B><FONT color = red><center>Message:</FONT></B><br>
<textarea name=ForumMessage rows=20 cols=50></textarea>
<br>
<input type=submit value='Post'></center>
</body>
</form>
</html>
"}
				usr << browse(Message,"window=Message -- [usr.key];file=null;display=1;clear=0;size=600x500;border=1;can_close=0;can_resize=0;can_minimize=1;titlebar=1")
				while(usr.Forum_Posting == 1&&usr != null)
					sleep(5)
				if(usr == null||src == null)
					return
				var/Filtered_String = usr.Forum_Message
				var/Find1 = findtext(Filtered_String," ")
				while(Find1)
					var/F1 = copytext(Filtered_String,Find1+1)
					var/F2 = copytext(Filtered_String,1,Find1)
					Filtered_String = "[F2][F1]"
					Find1 = findtext(Filtered_String," ")
				if(length(Filtered_String) < 1)
					usr << "A message may not be shorter than 1 character."
					return
				var/obj/Forums/Forum/Thread/FT = new
				if(length(usr.Forum_Title) < 1)
					usr.Forum_Title = "No Topic"
				FT.name = html_encode(usr.Forum_Title)
				FT.Message = html_encode(usr.Forum_Message)
				ID_Number++
				FT.MyID = ID_Number
				save_ID()
				var/SecondName = usr.key
				if(length(usr.name) > 15)
					SecondName = "[copytext(usr.name,1,16)]..."
				if(length(FT.Message) > 5000)
					FT.Message = "[copytext(usr.Forum_Message,1,5000)]... <font color = red>\[ Rest cut out due to long length.\]</font>"
				FT.suffix = SecondName
				Forum_Listing.Forum_Threads += FT
				FT.Forum_Listing = Forum_Listing
				var/FM = FT.Message
				var/FM2 = findtext(FM,"\n")
				while(FM2 != 0)
					var/cutfirst = copytext(FM,1,FM2)
					var/cutlast = copytext(FM,FM2+1)
					FM = "[cutfirst]<br>[cutlast]"
					FM2 = findtext(FM,"\n")
				if(Using_HTML_Forums == 0)
					var/FilterMessage = "<body bgcolor = white color = red><center><table width = 100% cellspacing=0 bgcolor = #000060 cellpadding=5><td rowspan = 4 bgcolor = #000060 width = 1%></td><tr><td align = left valign = middle><font color = #C0C0C0 size = 3>Title:</font><font size = 4 color = #C0C0C0><b>        [FT.name]</b></td><td align = right valign = middle><font color = #C5C5C5 size = 4><b><font color = #C0C0C0 size = 3>Author:</font>      [FT.suffix]</b></td></tr><tr><td align = center colspan = 2><font size = +1 color = #C0C0C0>Message:</td></tr><tr><td bgcolor = #C5C5C5 colspan=2></font></font></center><br>[FM]<br><br></td><td rowspan = 4 bgcolor = #000060 width = 1%></td></tr><tr><td><br></td></td></tr></table></body>"
					usr << browse(FilterMessage)
				else
					usr.Display_HTML_Forum(Forum_Listing)
				Forum_Listing.save_forums()
				return
		Reply
			var/obj/Forums/Forum/Forum_Listing
			name = "    Reply"
			Valid_Forum2 = 0
			New()
				return
			Click()
				if(Forum_Banned.Find("[usr.key]"))
					return
				if(usr.Forum_Posting == 1)
					return
				if(usr.Forum_Thread.icon == 'Closed Thread.dmi')
					alert(usr,"This thread is closed.")
					return
				if(usr.Forum_Thread == null)
					alert(usr,"You aren't within a thread, or the thread you are viewing was deleted.")
					return
				usr.Forum_Posting = 1
				usr.Forum_Title = ""
				usr.Forum_Message = ""
				var/Message = {"
<html>
<form method=get action='byond://' >
<input type=hidden name=src value='Message'>
<body bgcolor=#608590 text=black>
<B><FONT color = red><center>Title:</FONT></B><br>
<input type='text' name=ForumTitle size='58' maxlength='30' value='Re:  [usr.Forum_Thread.name]'></textarea>
<br>
<br>
<B><FONT color = red><center>Message:</FONT></B><br>
<textarea name=ForumMessage rows=20 cols=50></textarea>
<br>
<input type=submit value='Post'></center>
</body>
</form>
</html>
"}
				usr << browse(Message,"window=Message -- [usr.key];file=null;display=1;clear=0;size=600x500;border=1;can_close=0;can_resize=0;can_minimize=1;titlebar=1")
				while(usr.Forum_Posting == 1&&usr != null)
					sleep(5)
				if(usr == null||src == null)
					return
				var/Filtered_String = usr.Forum_Message
				var/Find1 = findtext(Filtered_String," ")
				while(Find1)
					var/F1 = copytext(Filtered_String,Find1+1)
					var/F2 = copytext(Filtered_String,1,Find1)
					Filtered_String = "[F2][F1]"
					Find1 = findtext(Filtered_String," ")
				if(length(Filtered_String) < 1)
					usr << "A message may not be shorter than 1 character."
					return
				var/obj/Forums/Forum/Message/FT = new
				if(length(usr.Forum_Title) < 1)
					usr.Forum_Title = "No Topic"
				usr.Forum_Title = "        [usr.Forum_Title]"
				FT.name = html_encode(usr.Forum_Title)
				FT.Message = html_encode(usr.Forum_Message)
				ID_Number++
				FT.MyID = ID_Number
				save_ID()
				var/SecondName = usr.key
				if(length(usr.name) > 15)
					SecondName = "[copytext(usr.name,1,16)]..."
				if(length(FT.Message) > 5000)
					FT.Message = "[copytext(usr.Forum_Message,1,5000)]... <font color = red>\[ Rest cut out due to long length.\]</font>"
				FT.suffix = SecondName
				usr.Forum_Thread.Forum_Messages += FT
				FT.Forum_Listing = Forum_Listing
				if(Using_HTML_Forums == 0)
					FT.Click()
				else
					usr.Forum_Thread.Click()
				if(usr.Forum_Thread.Forum_Messages.len >= 50&&usr.Forum_Thread.icon == null)
					usr.Forum_Thread.icon = 'Closed Thread.dmi'
				Forum_Listing.save_forums()
				return
		Thread
			var/tmp/Forum_Listing
			name = ""
			var/Message = ""
			var/list/Forum_Messages = new/list()
			var/MyID = 0
			Valid_Forum2 = 0
			New()
				return
			proc
				Delete_Message2()
					if(Forum_Banned.Find("[usr.key]"))
						return
					if(Administrator_Keys.Find(usr.key))
						if(usr.Forum_Posting == 1)
							return
						usr.Forum_Posting = 1
						switch(alert("Are you sure you want to delete this message?","Delete Message","Yes","No"))
							if("Yes")
								usr.Forum_Posting = 0
								Forum_Listing:Forum_Threads -= src
								usr.Display_HTML_Forum(src.Forum_Listing)
								del(src)
							else
								usr.Forum_Posting = 0
					return
			Click()
				if(Forum_Banned.Find("[usr.key]"))
					return
				if(usr.Forum_Deleting == 1&&usr.Forum_Delete == null)
					usr.Forum_Delete = src
				usr.Forum_Thread = src
				var/FM = src.Message
				var/FM2 = findtext(FM,"\n")
				while(FM2 != 0)
					var/cutfirst = copytext(FM,1,FM2)
					var/cutlast = copytext(FM,FM2+1)
					FM = "[cutfirst]<br>[cutlast]"
					FM2 = findtext(FM,"\n")
				if(Using_HTML_Forums == 0)
					var/FilterMessage = "<body bgcolor = #608590 color = red><center><table width = 100% cellspacing=0 bgcolor = #000060 cellpadding=5><td rowspan = 4 bgcolor = #000060 width = 1%></td><tr><td align = left valign = middle><font color = #C0C0C0 size = 3>Title:</font><font size = 4 color = #C0C0C0><b>        [src.name]</b></td><td align = right valign = middle><font color = #C5C5C5 size = 4><b><font color = #C0C0C0 size = 3>Author:</font>      [src.suffix]</b></td></tr><tr><td align = center colspan = 2><font size = +1 color = #C0C0C0>Message:</td></tr><tr><td bgcolor = #C5C5C5 colspan=2></font></font></center><br>[FM]<br><br></td><td rowspan = 4 bgcolor = #000060 width = 1%></td></tr><tr><td><br></td></td></tr></table></body>"
					usr << browse(FilterMessage)
				else
					var/FilterMessage = "<body bgcolor = #608590 color = red><center><a href='?reference=Back;forum=[Forum_Listing:MyForum_ID]'>Back to [Forum_Listing:name]</a><br><br><table width = 100% cellspacing=0 bgcolor = #000060 cellpadding=5><td rowspan = 4 bgcolor = #000060 width = 1%></td><tr><td align = left valign = middle><font color = #C0C0C0 size = 3>Title:</font><font size = 4 color = #C0C0C0><b>        [src.name]</b></td><td align = right valign = middle><font color = #C5C5C5 size = 4><b><font color = #C0C0C0 size = 3>Author:</font>      [src.suffix]</b></td></tr><tr><td align = center colspan = 2><font size = +1 color = #C0C0C0>Message:</td></tr><tr><td bgcolor = #C5C5C5 colspan=2></font></font></center><br>[FM]<br><br></td><td rowspan = 4 bgcolor = #000060 width = 1%></td></tr><tr><td colspan = 2 valign=middle>[usr.ReplyCheckClosed(Forum_Listing)]</td><td valign=middle align=right>[usr.AdminCheckThread2(Forum_Listing,src)]  [usr.AdminCheckThread(Forum_Listing,src)]</td></td></tr></table>"
					for(var/obj/Forums/Forum/Message/M in Forum_Messages)
						var/FMr = M.Message
						var/FMr2 = findtext(FM,"\n")
						while(FMr2 != 0)
							var/cutfirst = copytext(FMr,1,FMr2)
							var/cutlast = copytext(FMr,FMr2+1)
							FMr = "[cutfirst]<br>[cutlast]"
							FMr2 = findtext(FMr,"\n")
						FilterMessage += "<br><center><table width = 100% cellspacing=0 bgcolor = #000060 cellpadding=5><td rowspan = 4 bgcolor = #000060 width = 1%></td><tr><td align = left valign = middle><font color = #C0C0C0 size = 3>Title:</font><font size = 4 color = #C0C0C0><b>        [M.name]</b></td><td align = right valign = middle><font color = #C5C5C5 size = 4><b><font color = #C0C0C0 size = 3>Author:</font>      [M.suffix]</b></td></tr><tr><td align = center colspan = 2><font size = +1 color = #C0C0C0>Message:</td></tr><tr><td bgcolor = #C5C5C5 colspan=2></font></font></center><br>[FMr]<br><br></td><td rowspan = 4 bgcolor = #000060 width = 1%></td></tr><tr><td colspan = 2 valign=middle>[usr.ReplyCheckClosed(Forum_Listing)]</td><td valign=middle align=right>[usr.AdminCheckMessage(Forum_Listing,M)]</p></td></td></tr></table>"
					FilterMessage += "<a href='?reference=Back;forum=[Forum_Listing:MyForum_ID]'>Back to [Forum_Listing:name]</a>"
					FilterMessage += "</center></body>"
					usr << browse(FilterMessage)
				return
		Message
			var/tmp/Forum_Listing
			name = ""
			var/Message = ""
			var/MyID = 0
			Valid_Forum2 = 0
			proc
				Delete_Message2()
					if(Forum_Banned.Find("[usr.key]"))
						return
					if(Administrator_Keys.Find(usr.key))
						if(usr.Forum_Posting == 1)
							return
						usr.Forum_Posting = 1
						switch(alert("Are you sure you want to delete this message?","Delete Message","Yes","No"))
							if("Yes")
								usr.Forum_Posting = 0
								usr.Forum_Thread.Forum_Messages -= src
								usr.Forum_Thread.Click()
								del(src)
							else
								usr.Forum_Posting = 0
					return
			New()
				return
			Click()
				if(Using_HTML_Forums == 1)
					return
				if(Forum_Banned.Find("[usr.key]"))
					return
				if(usr.Forum_Deleting == 1&&usr.Forum_Delete == null)
					usr.Forum_Delete = src
				var/FM = src.Message
				var/FM2 = findtext(FM,"\n")
				while(FM2 != 0)
					var/cutfirst = copytext(FM,1,FM2)
					var/cutlast = copytext(FM,FM2+1)
					FM = "[cutfirst]<br>[cutlast]"
					FM2 = findtext(FM,"\n")
				var/FilterMessage = "<body bgcolor = #608590 color = red><center><table width = 100% cellspacing=0 bgcolor = #000060 cellpadding=5><td rowspan = 4 bgcolor = #000060 width = 1%></td><tr><td align = left valign = middle><font color = #C0C0C0 size = 3>Title:</font><font size = 4 color = #C0C0C0><b>        [src.name]</b></td><td align = right valign = middle><font color = #C5C5C5 size = 4><b><font color = #C0C0C0 size = 3>Author:</font>      [src.suffix]</b></td></tr><tr><td align = center colspan = 2><font size = +1 color = #C0C0C0>Message:</td></tr><tr><td bgcolor = #C5C5C5 colspan=2></font></font></center><br>[FM]<br><br></td><td rowspan = 4 bgcolor = #000060 width = 1%></td></tr><tr><td><br></td></td></tr></table></body>"
				usr << browse(FilterMessage)
				return

mob/var/tmp
	Forum_Title = ""
	Forum_Message = ""
	Forum_Posting = 0
	Forum_Deleting = 0
	list/Forum_Page = list()
	obj/Forums/Forum/Thread/Forum_Thread
	obj/Forum_Delete

client/Topic(href,href_list[])
	if(href_list["src"] == "Message")
		if(href_list["ForumTitle"] != null&&href_list["ForumTitle"] != "")
			usr.Forum_Title = href_list["ForumTitle"]
		if(href_list["ForumMessage"] != null&&href_list["ForumMessage"] != "")
			usr.Forum_Message = href_list["ForumMessage"]
		usr << browse(null,"window=Message -- [usr.key];file=null;display=1;clear=0;size=600x500;border=1;can_close=1;can_resize=0;can_minimize=1;titlebar=1")
		usr.Forum_Posting = 0
	..()

var/list/Forum_Banned = list()
var/Forum_First_Admin = 0

mob/Login()
	..()
	if(Forum_First_Admin == 0)
		var/filename = "Forum/Forum.sav"
		var/savefile/F = new(filename)
		var/directory = "/Forum/Forum/"
		F.cd = directory
		Forum_First_Admin = 1
		Administrator_Keys = list(src.key)
		Forum_Master_Key = src.key
		F["Admin"] << Administrator_Keys
		F["First"] << Forum_First_Admin
		F["Master"] << Forum_Master_Key

world/Del()
	save_forum()
	for(var/obj/Forums/Forum/F in world)
		if(F.Valid_Forum == 1)
			F.save_forums()
	..()

var/list/Saved_List = new/list()
var/Forum_Saved = 100

obj/Forums/Forum/proc
	save_forums()
		var/filename = "Forum/[src.name].sav"
		var/savefile/F = new(filename)
		var/directory = "/Forum/[src.name]/"
		F.cd = directory
		Saved_List = list()
		var/FS = Forum_Saved
		for(var/obj/Forums/Forum/Thread/T in Forum_Threads)
			if(FS > 0)
				FS -= 1
				Saved_List += T
			else
				break
		F["ActualForum"] << Saved_List
	load_forums()
		if(length(file2text("Forum/[src.name].sav")))
			var/filename = "Forum/[src.name].sav"
			var/savefile/F = new(filename)
			F.cd = "/Forum/[src.name]/"
			F["ActualForum"] >> src.Forum_Threads
			if(Forum_Threads == null)
				Forum_Threads = list()
			for(var/obj/Forums/Forum/Thread/TF in src.Forum_Threads)
				TF.Forum_Listing = src
				for(var/obj/Forums/Forum/Message/M in TF.Forum_Messages)
					M.Forum_Listing = src

proc
	save_forum()
		var/filename = "Forum/Forum.sav"
		var/savefile/F = new(filename)
		var/directory = "/Forum/Forum/"
		F.cd = directory
		F["Admin"] << Administrator_Keys
		F["Banned"] << Forum_Banned
		F["Saved"] << Forum_Saved
	load_forum()
		if(length(file2text("Forum/Forum.sav")))
			var/filename = "Forum/Forum.sav"
			var/savefile/F = new(filename)
			F.cd = "/Forum/Forum/"
			F["Admin"] >> Administrator_Keys
			if(Administrator_Keys == null)
				Administrator_Keys = list()
			F["Banned"] >> Forum_Banned
			if(Forum_Banned == null)
				Forum_Banned = list()
			F["First"] >> Forum_First_Admin
			if(Forum_First_Admin == null)
				Forum_First_Admin = 0
			F["Master"] >> Forum_Master_Key
			if(Forum_Master_Key == null)
				Forum_Master_Key = ""
			F["Saved"] >> Forum_Saved
			if(Forum_Saved == null)
				Forum_Saved = 100


mob/proc/Display_Forum(obj/Forums/Forum/F,P)
	if(Using_HTML_Forums == 0)
		if(P == null||P == 0) statpanel(F.name)
		if(!Forum_Banned.Find("[key]"))
			if(Forum_Thread == null)
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
				if(Forum_Page[F.name] < max_pages)
					stat(F.Forum_Next)
					stat("")
				stat(F.Forum_New_Thread)
				stat("")
				if(Administrator_Keys.Find(src.key))
					stat(F.Forum_Admin)
					stat("")
					stat("")
					stat("")
				else
					stat("")
				var/w = 0
				for(var/obj/Forums/Forum/Thread/O in list_duplicate)
					if(w >= start&&w < end)
						if(O.Message != "")
							stat(O)
							if(O.Forum_Messages.len == 1)
								stat("        [O.Forum_Messages.len] reply")
							else
								stat("        [O.Forum_Messages.len] replies")
							stat("")
							w++
						else
							F.Forum_Threads -= O
					else if(w < end&&w < start)
						w++
					else
						if(w > end)
							break
				stat("")
				stat("")
				if(Forum_Page[F.name] > 1) stat(F.Forum_Prev)
			else if(Forum_Thread.Forum_Listing == F)
				stat(F.Forum_Back)
				stat("")
				stat(Forum_Thread)
				stat("")
				stat("")
				if(Forum_Thread.Forum_Messages.len == 0&&Forum_Thread.icon == null)
					stat(F.Forum_Reply)
					stat("")
					stat("")
				for(var/obj/Msg in Forum_Thread.Forum_Messages)
					stat(Msg)
				if(Forum_Thread.Forum_Messages.len >= 50&&Forum_Thread.icon == null)
					Forum_Thread.icon = 'Closed Thread.dmi'
				if(Forum_Thread.icon == null)
					if(Forum_Thread.Forum_Messages.len > 0)
						stat("")
						stat("")
						stat(F.Forum_Reply)
					if(Administrator_Keys.Find(src.key))
						stat("")
						stat("")
						stat(F.Forum_Close_Thread)
				if(Administrator_Keys.Find(src.key))
					stat("")
					stat(F.Forum_Delete)
			else
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
				if(Forum_Page[F.name] < max_pages)
					stat(F.Forum_Next)
					stat("")
				stat(F.Forum_New_Thread)
				stat("")
				if(Administrator_Keys.Find(src.key))
					stat(F.Forum_Admin)
					stat("")
					stat("")
					stat("")
				else
					stat("")
				var/w = 0
				for(var/obj/Forums/Forum/Thread/O in list_duplicate)
					if(w >= start&&w < end)
						if(O.Message != "")
							stat(O)
							if(O.Forum_Messages.len == 1)
								stat("        [O.Forum_Messages.len] reply")
							else
								stat("        [O.Forum_Messages.len] replies")
							stat("")
							w++
						else
							F.Forum_Threads -= O
					else if(w < end&&w < start)
						w++
					else
						if(w > end)
							break
				stat("")
				stat("")
				if(Forum_Page[F.name] > 1) stat(F.Forum_Prev)
		else
			stat("You are banned from the [world.name] forums.")
