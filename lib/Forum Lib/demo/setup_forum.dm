//Want to see how easy it is to put in-game forums in your game?



 /////////////////////////
//   HTML-Based Forums   //
 /////////////////////////




world/New()
	Using_HTML_Forums = 1       //Set this variable to 1 to use HTML-Based forums.
	..()




var/obj/Forums/Forum/Develope = new  //<--We first create the forums like this-->
var/obj/Forums/Forum/Develope1 = new
var/obj/Forums/Forum/Develope2 = new
var/obj/Forums/Forum/Reports = new
var/obj/Forums/Forum/Reports1 = new
var/obj/Forums/Forum/Reports2 = new
var/obj/Forums/Forum/Reports3 = new
var/obj/Forums/Forum/Help = new
var/obj/Forums/Forum/Flood = new
var/obj/Forums/Forum/Develope_ru = new  //<--We first create the forums like this-->
var/obj/Forums/Forum/Develope_ru1 = new
var/obj/Forums/Forum/Develope_ru2 = new
var/obj/Forums/Forum/Reports_ru = new
var/obj/Forums/Forum/Reports_ru1 = new
var/obj/Forums/Forum/Reports_ru2 = new
var/obj/Forums/Forum/Reports_ru3 = new
var/obj/Forums/Forum/Help_ru = new
var/obj/Forums/Forum/Flood_ru = new





//mob/Login()
//	..()
//	sleep(1)     //This just ensures that when it first shows you the forum below (since we are doing it in the Login() proc, you wouldn't normally have to make it sleep unless it is within the login proc or a New() proc.), it will show the threads within the forum.
//	src.Selected_Forum = Bug_Reports   //Before calling the next proc, you must ALWAYS make sure this is set, or it will fail.
	//src.Display_HTML_Forum()          //Here is how we display the forum set by src.Selected_Forum.


world/New()
	///////////////////////////////////////////////////////////////////
	Develope.name = "Developming"  //Here we need to set their names manually.  WIth HTML based forums, you set the desc as well.
	Develope.Parent_Forum = Develope1

	Develope1.name = "Idea's"
	Develope1.desc = ""
	Develope1.Parent_Forum = Develope

	Develope2.name = "Bag Reports"
	Develope2.desc = ""
	Develope2.Parent_Forum = Develope

	///////////////////////////////

	Reports.name = "Reports"
	Reports.Child_Forum = Reports

	Reports1.name = "Administration"
	Reports1.desc = "Reports to administrators here."
	Reports1.Parent_Forum = Reports

	Reports2.name = "Unban"
	Reports2.desc = ""
	Reports2.Parent_Forum = Reports

	Reports3.name = "Ban"
	Reports3.desc = "Ban him!"
	Reports3.Parent_Forum = Reports

	//////////////////////////////

	Help.name = "FAQ"
	Help.desc = "If you are a newbie, ask for help here."

	//////////////////////////////

	Flood.name = "Other"
	Flood.desc = ""


	/////////////////////////////////////////////////////////////


	Develope_ru.name = "Разработка"  //Here we need to set their names manually.  WIth HTML based forums, you set the desc as well.
	Develope_ru.rus = 1
	Develope_ru.Child_Forum = Develope_ru1

	Develope_ru1.name = "Предложения"  //Here we need to set their names manually.  WIth HTML based forums, you set the desc as well.
	Develope_ru1.desc = "Идеи и предложениЯ по развитию билда."
	Develope_ru1.rus = 1
	Develope_ru1.Parent_Forum = Develope_ru

	Develope_ru1.name = "Баги"  //Here we need to set their names manually.  WIth HTML based forums, you set the desc as well.
	Develope_ru2.desc = "Сообщения о багах. Хороших и плохих"
	Develope_ru2.rus = 1
	Develope_ru2.Parent_Forum = Develope_ru

	/////////////////////////////

	Reports_ru.name = "Жалобы"
	Reports_ru.rus = 1
	Reports_ru.Child_Forum = Reports_ru1

	Reports_ru1.name = "Администрация"
	Reports_ru1.desc = "Просьбы на разбан или жалобы на администратора - здесь."
	Reports_ru1.rus = 1
	Reports_ru1.Parent_Forum = Reports_ru

	Reports_ru2.name = "Разбан"
	Reports_ru2.desc = "Просьбы на разбан или жалобы на администратора - здесь."
	Reports_ru2.rus = 1
	Reports_ru2.Parent_Forum = Reports_ru

	Reports_ru3.name = "Забанить"
	Reports_ru3.desc = "Просьбы на разбан или жалобы на администратора - здесь."
	Reports_ru3.rus = 1
	Reports_ru3.Parent_Forum = Reports_ru

	/////////////////////////////

	Help_ru.name = "Новичкам"
	Help_ru.desc = "Гайды и общаЯ помощь новичкам."
	Help_ru.rus = 1

	/////////////////////////////

	Flood_ru.name = "Флудилка"
	Flood_ru.desc = "В этом разделе можно поболтать на сторонние темы."
	Flood_ru.rus = 1
	/////////////////////////////////////////////////////////////////////////
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