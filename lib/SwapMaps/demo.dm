world
	view=6
	turf=/turf/ground

	New()
		swapmaps_mode=SWAPMAPS_TEXT
		swapmaps_iconcache=list("blotch"='blotch.dmi')
		..()

turf
	ground/icon='ground.dmi'
	dirt/icon='dirt.dmi'
obj
	gold/icon='gold.dmi'
	fence
		icon='fence.dmi'
		density=1


mob
	icon='mob.dmi'
	Stat()
		stat("Location","[x]/[y]/[z]")
	verb
		Help()
			usr << browse('swapmaps.html')
		Go()
			var/_x=input("x location:","Go: x",x) as num
			var/_y=input("y location:","Go: y",y) as num
			var/_z=input("z location:","Go: z",z) as num
			loc=locate(_x,_y,_z)
		JumpToMap(map as text)
			if(!map) map=input("Map name","Map name") as text
			var/swapmap/M=SwapMaps_Find(map)
			if(!M)
				usr << "Map [map] not found."
				return
			loc=locate(round((M.x1+M.x2)/2),round((M.y1+M.y2)/2),M.z1)
		GetSize(map as text)
			if(!map) map=input("Map name","Map name") as text
			var/list/L=SwapMaps_GetSize(map)
			if(L)
				usr << "Map [map] is [L[1]] x [L[2]] x [L[3]]"
		SaveChunk()
			if(!loc)
				usr << "You must be on the map to save a chunk with this demo."
				return
			var/_x=round(input("x size:","New map: x size",world.maxx) as num,1)
			var/_y=round(input("y size:","New map: y size",world.maxy) as num,1)
			_x=max(1,min(_x,world.maxx-x+1))
			_y=max(1,min(_y,world.maxy-y+1))
			SwapMaps_SaveChunk("chunk",loc,locate(x+_x-1,y+_y-1,z))
		LoadChunk()
			if(!loc)
				usr << "You must be on the map to save a chunk with this demo."
				return
			var/list/L=SwapMaps_GetSize("chunk")
			if(!L)
				usr << "Chunk not found."
				return
			var/_x=max(1,min(x,world.maxx-L[1]+1))
			var/_y=max(1,min(y,world.maxy-L[2]+1))
			var/oldloc=loc
			usr << "Loading chunk at [_x],[_y],[z]"
			SwapMaps_LoadChunk("chunk",locate(_x,_y,z))
			loc=oldloc
		FindMap(map as text)
			if(!map) map=input("Map name","Map name") as text
			var/swapmap/M=SwapMaps_Find(map)
			if(!M) usr << "Map [map] not found."
			else usr << "Map [map] found: ([M.x1]-[M.x2],[M.y1]-[M.y2],[M.z1]-[M.z2])"
		NewMap(map as text)
			if(!map) map=input("Map name","Map name") as text
			var/_x=round(input("x size:","New map: x size",world.maxx) as num,1)
			var/_y=round(input("y size:","New map: y size",world.maxy) as num,1)
			var/_z=round(input("z size:","New map: z size",1) as num,1)
			if(_x<1 || _y<1 || _z<1)
				usr << "[_x],[_y],[_z] is an invalid map size."
				return
			var/swapmap/M=new(map,_x,_y,_z)
			for(var/turf/T in block(locate(M.x1,M.y1,M.z1),locate(M.x2,M.y2,M.z2)))
				for(var/atom/movable/O in T) del(O)
				if(prob(20)) new/turf/dirt(T)
				else new/turf/ground(T)
				if(prob(5)) new/obj/gold(T)
				if(prob(5)) T.icon='blotch.dmi'
			usr << "Map [map] created: ([M.x1]-[M.x2],[M.y1]-[M.y2],[M.z1]-[M.z2])"
		Build()
			var/color=input("Color") as null|text
			var/bgcolor=input("Background") as null|text
			var/t=input("Char","Char"," ") as null|text
			var/d=alert("Dense?","Density","Yes","No")=="Yes"
			var/obj/O=new(loc)
			if(color || bgcolor)
				O.text="<FONT"+(color?" COLOR=[(text2ascii(color) in 48 to 70)?"#":""][color]":"")+(bgcolor?" BGCOLOR=[(text2ascii(bgcolor) in 48 to 70)?"#":""][bgcolor]":"")+">[t]"
			else O.text=t
			O.density=d
		SaveMap(map as text)
			if(!map) map=input("Map name","Map name") as text
			if(!SwapMaps_Save(map))
				usr << "Map [map] not found."
			else
				usr << "Map [map] saved."
		LoadMap(map as text)
			if(!map) map=input("Map name","Map name") as text
			if(!SwapMaps_Load(map))
				usr << "Map [map] not found."
			else
				usr << "Map [map] loaded."
		Template(map as text)
			if(!map) map=input("Template name","Template name") as text
			var/swapmap/M=SwapMaps_CreateFromTemplate(map)
			if(!M)
				usr << "Map template [map] not found."
			else
				usr << "Map [html_encode("\ref[M]")] created."
				usr << "Map is located at [M.x1],[M.y1],[M.z1] - [M.x2],[M.y2],[M.z2]"
		UnloadMap(map as text)
			if(!map) map=input("Map name","Map name") as text
			if(!map)
				for(var/swapmap/M in swapmaps_loaded)
					if(M.Contains(usr))
						usr << "Map [M] unloaded."
						M.Unload()
				return
			if(!SwapMaps_Unload(map))
				usr << "Map [map] not found."
			else
				usr << "Map [map] unloaded."
		ToText(map as text)
			if(!map) map=input("Map name","Map name") as text
			if(!fexists("map_[map].sav"))
				usr << "Map [map] has no file."
				return
			var/savefile/S=new("map_[map].sav")
			fdel("map_[map].txt")
			S.ExportText("/",file("map_[map].txt"))
			usr << "Coverted to text: map_[map].txt"
		Areas()
			if(!z) return
			for(var/i in 1 to 3)
				var/w=rand(1,world.maxx)
				var/h=rand(1,world.maxy)
				var/x2=rand(w,world.maxx)
				var/y2=rand(h,world.maxy)
				var/area/A=new
				A.tag="[i]"
				for(var/turf/T in block(locate(x2-w+1,y2-h+1,z),locate(x2,y2,z)))
					A.contents+=T
		Fence(map as text)
			if(!map) map=input("Map name","Map name") as text
			var/swapmap/M=SwapMaps_Find(map)
			if(!M)
				usr << "Map [map] not found."
				return
			M.BuildRectangle(locate(M.x1,M.y1,M.z1),locate(M.x2,M.y2,M.z2),/obj/fence)


area
	Entered(O)
		O << "Welcome to area [tag]."
	Exited(O)
		O << "Leaving area [tag]."
