//Want to see how easy it is to put in-game forums in your game?



 /////////////////////////
//   HTML-Based Forums   //
 /////////////////////////




world/New()
	Using_HTML_Forums = 1       //Set this variable to 1 to use HTML-Based forums.
	..()




var/obj/Forums/Forum/Bug_Reports = new  //<--We first create the forums like this-->
var/obj/Forums/Forum/Game_Q = new
var/obj/Forums/Forum/BYOND_Chat = new
var/obj/Forums/Forum/Newbie_Help = new





mob/Login()
	..()
	sleep(1)     //This just ensures that when it first shows you the forum below (since we are doing it in the Login() proc, you wouldn't normally have to make it sleep unless it is within the login proc or a New() proc.), it will show the threads within the forum.
	src.Selected_Forum = Bug_Reports   //Before calling the next proc, you must ALWAYS make sure this is set, or it will fail.
	src.Display_HTML_Forum()          //Here is how we display the forum set by src.Selected_Forum.


world/New()
	Bug_Reports.name = "Bug Reports"  //Here we need to set their names manually.  WIth HTML based forums, you set the desc as well.
	Bug_Reports.desc = "Post reports about bugs you find in the game here."
	Game_Q.name = "Game Q & A"
	Game_Q.desc = "Ask questions about the game here."
	BYOND_Chat.name = "BYOND Chat"
	BYOND_Chat.desc = "Talk about BYOND here."
	Newbie_Help.name = "Newbie Help"
	Newbie_Help.desc = "If you are a newbie, ask for help here."
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