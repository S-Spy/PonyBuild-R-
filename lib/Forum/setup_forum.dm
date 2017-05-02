//Want to see how easy it is to put in-game forums in your game?



 /////////////////////////
//   HTML-Based Forums   //
 /////////////////////////\


proc/sanitize_lang(var/text)//Костыль для сломанных букв
	var/TEXT = ""
	for(var/k = 1, k <= lentext(text), k++)
		if(copytext(text, k, k+1) != "я")	TEXT += copytext(text, k, k+1)
		else	TEXT += "Я"
	return TEXT

proc/html_encode_lang(var/text)	return html_encode(sanitize_lang(text))//sanitize_lang(text))

proc/html_decode_lang(var/text) return html_decode(sanitize_lang(text))//sanitize_lang(text))

world/New()
	Using_HTML_Forums = 1       //Set this variable to 1 to use HTML-Based forums.
	..()


var/obj/Forums/Forum/News = new
var/obj/Forums/Forum/News1 = new
var/obj/Forums/Forum/Develope = new  //<--We first create the forums like this-->
var/obj/Forums/Forum/Develope1 = new
var/obj/Forums/Forum/Develope2 = new
var/obj/Forums/Forum/Develope3 = new
var/obj/Forums/Forum/Bugreport = new
var/obj/Forums/Forum/Reports = new
var/obj/Forums/Forum/Reports1 = new
var/obj/Forums/Forum/Reports2 = new
var/obj/Forums/Forum/Reports3 = new
var/obj/Forums/Forum/Help = new
var/obj/Forums/Forum/Fancontent = new
var/obj/Forums/Forum/Flood = new
var/obj/Forums/Forum/Archive = new
var/obj/Forums/Forum/News_ru = new
var/obj/Forums/Forum/News_ru1 = new
var/obj/Forums/Forum/Develope_ru = new  //<--Сперва здесь нужно обьявить переменную с форумом-->
var/obj/Forums/Forum/Develope_ru1 = new
var/obj/Forums/Forum/Develope_ru2 = new
var/obj/Forums/Forum/Develope_ru3 = new
var/obj/Forums/Forum/Bugreport_ru = new
var/obj/Forums/Forum/Reports_ru = new
var/obj/Forums/Forum/Reports_ru1 = new
var/obj/Forums/Forum/Reports_ru2 = new
var/obj/Forums/Forum/Reports_ru3 = new
var/obj/Forums/Forum/Help_ru = new
var/obj/Forums/Forum/Fancontent_ru = new
var/obj/Forums/Forum/Flood_ru = new
var/obj/Forums/Forum/Archive_ru = new





//mob/Login()
//	..()
//	sleep(1)     //This just ensures that when it first shows you the forum below (since we are doing it in the Login() proc, you wouldn't normally have to make it sleep unless it is within the login proc or a New() proc.), it will show the threads within the forum.
//	src.Selected_Forum = Bug_Reports   //Before calling the next proc, you must ALWAYS make sure this is set, or it will fail.
	//src.Display_HTML_Forum()          //Here is how we display the forum set by src.Selected_Forum.


world/New()
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	News.name = "News"
	News.desc = ""
	News.section = "Server"

	News1.name = "Events"
	News1.desc = ""
	News1.parent = News
	News1.topic_on = 1

	/////////////////////////////////

	Reports.name = "Reports"
	Reports.desc = ""
	Reports.section = "Server"

	Reports1.name = "Administration"
	Reports1.desc = "Reports to administrators here."
	Reports1.parent = Reports

	Reports2.name = "Unban"
	Reports2.desc = ""
	Reports2.parent = Reports

	Reports3.name = "Ban"
	Reports3.desc = "Ban him!"
	Reports3.parent = Reports

	/////////////////////////////////

	Help.name = "FAQ"
	Help.desc = "If you are a newbie, ask for help here."
	Help.section = "Server"

	///////////////////////////////////////////////////////////

	Develope.name = "Requests"
	Develope.desc = ""
	Develope.section = "Developming"
	Develope.topic_on = 1

	Develope1.name = "Code"
	Develope1.desc = ""
	Develope1.parent = Develope

	/////////////////////////////////

	Bugreport.name = "Bug Reports"
	Bugreport.desc = ""
	Bugreport.section = "Developming"

	///////////////////////////////////////////////////////////

	Fancontent.name = "Fan content"
	Fancontent.desc = ""
	Fancontent.section = "Other"

	/////////////////////////////////

	Flood.name = "Flood"
	Flood.desc = ""
	Flood.section = "Other"

	/////////////////////////////////

	Archive.name = "Archive"
	Archive.desc = ""
	Archive.section = "Other"


	///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


	News_ru.name = "Новости"
	News_ru.desc = ""
	News_ru.section = "Сервер"
	News_ru.language = "RUS"
	News_ru.topic_on = 1

	News_ru1.name = "Ивенты"
	News_ru1.desc = ""
	News_ru1.parent = News_ru

	/////////////////////////////////

	Reports_ru.name = "Жалобы"
	Reports_ru.desc = ""
	Reports_ru.section = "Сервер"
	Reports_ru.language = "RUS"

	Reports_ru1.name = "Администрация"
	Reports_ru1.desc = "Жалобы на действия администрации."
	Reports_ru1.parent = Reports_ru

	Reports_ru2.name = "Разбан"
	Reports_ru2.desc = "Если считаете, что вы получили несправедливый бан, то вам сюда."
	Reports_ru2.parent = Reports_ru

	Reports_ru3.name = "Забанить"
	Reports_ru3.desc = "Кто то нарушил правила и не получил по заслугам? Вам сюда."
	Reports_ru3.parent = Reports_ru

	/////////////////////////////////

	Help_ru.name = "Новичкам"
	Help_ru.desc = "Гайды и общаЯ помощь новичкам."
	Help_ru.section = "Сервер"
	Help_ru.language = "RUS"

	///////////////////////////////////////////////////////////

	Develope_ru.name = "Предложения"
	Develope_ru.desc = "Идеи и предложения любого характера по разработке сервера."
	Develope_ru.section = "Разработка"
	Develope_ru.language = "RUS"
	Develope_ru.topic_on = 1

	Develope_ru1.name = "Код"
	Develope_ru1.desc = "Предложения по модификации кода."
	Develope_ru1.parent = Develope_ru

	Develope_ru2.name = "Мапинг"
	Develope_ru2.desc = "Предложения по модификации основной карты или идеи по новым картам."
	Develope_ru2.parent = Develope_ru

	Develope_ru3.name = "Спрайтинг"
	Develope_ru3.desc = "Предложения по замене, обновлению старых или внедрению новых иконок."
	Develope_ru3.parent = Develope_ru

	/////////////////////////////////

	Bugreport_ru.name = "Багрепорт"
	Bugreport_ru.desc = "Сообщения о багах. Плохих или хороших."
	Bugreport_ru.section = "Разработка"
	Bugreport_ru.language = "RUS"

	/////////////////////////////////////////////////////////

	Fancontent_ru.name = "Творчество"
	Fancontent_ru.desc = "Тут можно найти фан творчество на тему пони или SS13."
	Fancontent_ru.section = "Остальное"
	Fancontent_ru.language = "RUS"

	/////////////////////////////////

	Flood_ru.name = "Флудилка"
	Flood_ru.desc = "Здесь можно поболтать на сторонние темы."
	Flood_ru.section = "Остальное"
	Flood_ru.language = "RUS"

	/////////////////////////////////

	Archive_ru.name = "Архив"
	Archive_ru.desc = "В этом разделе хранятся старые темы."
	Archive_ru.section = "Остальное"
	Archive_ru.language = "RUS"


	///////////////////////////////////////////////////////////////////////////////////////////////////////////
	load_forum()
	..()




//Thats it!  Forum lib does the rest, including managing forum moderators and a banned list!









//For statpanel-to-browser based forums, un-comment the following "/*" (at the beginning) and "*/" (at the end) to view the example.


/*


 //////////////////////////////////
//Statpenl-to-Browser Based Forums//
 //////////////////////////////////




world/New()
	Using_HTML_Forums = 0      //Set this variable to 0 to use Statpanel-to-Browser Based forums.
	..()




var/obj/Forums/Forum/Main_Forum = new  //First, create a forum with the name you want...
var/obj/Forums/Forum/Off_Topic = new  //Let's make another one for the hell of it.




mob/Stat()
	Display_Forum(Main_Forum)  //Then, this is how you display it.

	statpanel("Off Topic")     //Lets make an Off Topic panel...
	stat("Post things not game related here:")
	stat("")  //Make a space between the text above and the forum.
	Display_Forum(Off_Topic,1) //The 1 here in this example is to make it so it doesn't create the forum in the proc.  We did that above instead.  Do that when you want to put extra info or just put it in another statpanel.




world/New()
	Main_Forum.name = "Main Forum"     //Here we need to set their names manually
	Off_Topic.name = "Off Topic"
	load_forum()
	..()


//Thats it!  Forum lib does the rest, including managing forum moderators and a banned list!


*/