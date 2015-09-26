/*
Attack effects
-Shows you how to add special effects when a mob attacks.

Theres currently 2,
flame and freeze

flame- chance to burn a mob when you attack them for 25 to 50 damage

freeze - stuns a mob for 1.5 seconds
*/

mob
	var
		Attack_Effect="Nothing"


proc/Attack_Effect(mob/M,mob/target)
	if(M.Attack_Effect=="Nothing") return
	if(prob(20))
		switch(M.Attack_Effect)
			if("flame")
				JFlash(target,'icons.dmi',"Flame")
				view(target)<<"<center>[M]'s attack burns [target]'s insides."
				target.hp-=rand(25,50)
				J_update(target)
			if("freeze")
				target.froze=1
				var/obj/J_Missile2/JM=new(locate(target.x,target.y,target.z))
				JM.icon='icons.dmi';JM.icon_state="Freeze"
				view(target)<<"<center>[M]'s attack makes [target] frozen."
				spawn(15)
					target.froze=0
					del(JM)



obj/J_Missile
	density=0;mouse_opacity=0
	layer=50
	var/duration=2
	New()
		spawn(10) del(src)

obj/J_Missile2
	density=0;mouse_opacity=0
	layer=50


/*
	(JFlash)
		args atom/start, I_icon, I_icon_state

		atom/start - where the created object will go

		I_icon (an icon file)

		I_icon_state (An icon state within the icon file)

(Basically creates and object and flicks it making a spell looking effect)
*/
proc/JFlash(atom/start,I_icon,I_icon_state)
	var/obj/J_Missile/IM=new(start.loc)
	flick(image(I_icon,icon_state=I_icon_state),IM)