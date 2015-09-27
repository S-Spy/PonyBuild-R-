world
	maxx = 70
	maxy = 70
	turf = /turf/wall
	view = 35
	version = 3
	hub = "Jp.jp_DungeonGenerator"

var/jp_DungeonGenerator/generate = new()

mob
	var
		seed=null
	New()
		loc = locate(round(world.maxx/2),round(world.maxy/2),1)

	verb
		simple()
			reset()
			generate.setArea(locate(1,1,1), locate(world.maxx, world.maxy,1))
			generate.setWallType(/turf/wall)
			generate.setFloorType(/turf/ground)
			generate.setAllowedRooms(list(/jp_DungeonRoom/square))
			generate.setNumRooms(10)
			generate.setExtraPaths(0)
			generate.setMinPathLength(0)
			generate.setMaxPathLength(45)
			generate.setMinLongPathLength(0)
			generate.setLongPathChance(0)
			generate.setPathEndChance(100)
			generate.setRoomMinSize(4)
			generate.setRoomMaxSize(4)

			generate.generate()
			display()

		loops()
			reset()
			generate.setArea(locate(1,1,1), locate(world.maxx, world.maxy,1))
			generate.setWallType(/turf/wall)
			generate.setFloorType(/turf/ground)
			generate.setAllowedRooms(list(/jp_DungeonRoom/square))
			generate.setNumRooms(10)
			generate.setExtraPaths(5)
			generate.setMinPathLength(20)
			generate.setMaxPathLength(45)
			generate.setMinLongPathLength(30)
			generate.setLongPathChance(30)
			generate.setPathEndChance(30)
			generate.setRoomMinSize(4)
			generate.setRoomMaxSize(4)

			generate.generate()
			display()

		rooms()
			reset()
			generate.setArea(locate(1,1,1), locate(world.maxx, world.maxy,1))
			generate.setWallType(/turf/wall)
			generate.setFloorType(/turf/ground)
			generate.setAllowedRooms(list(/jp_DungeonRoom/square, /jp_DungeonRoom/circle, /jp_DungeonRoom/cross, /jp_DungeonRoom/deadend))
			generate.setNumRooms(10)
			generate.setExtraPaths(5)
			generate.setMinPathLength(20)
			generate.setMaxPathLength(45)
			generate.setMinLongPathLength(30)
			generate.setLongPathChance(30)
			generate.setPathEndChance(30)
			generate.setRoomMinSize(1)
			generate.setRoomMaxSize(6)

			generate.generate()
			display()

		centred()
			reset()
			generate.setArea(locate(1,1,1), locate(world.maxx, world.maxy,1))
			generate.setWallType(/turf/wall)
			generate.setFloorType(/turf/ground)
			generate.setAllowedRooms(list(/jp_DungeonRoom/square))
			generate.setNumRooms(1)
			generate.setExtraPaths(10)
			generate.setMinPathLength(20)
			generate.setMaxPathLength(45)
			generate.setMinLongPathLength(30)
			generate.setLongPathChance(30)
			generate.setPathEndChance(30)
			generate.setRoomMinSize(10)
			generate.setRoomMaxSize(10)

			generate.generate()
			display()

		cavern()
			reset()
			generate.setArea(locate(1,1,1), locate(world.maxx, world.maxy,1))
			generate.setWallType(/turf/wall)
			generate.setFloorType(/turf/ground)
			generate.setAllowedRooms(list(/jp_DungeonRoom/cavern))
			generate.setNumRooms(3)
			generate.setExtraPaths(1)
			generate.setMinPathLength(3) //3
			generate.setMaxPathLength(45) //45
			generate.setMinLongPathLength(0)
			generate.setLongPathChance(0)
			generate.setPathEndChance(100)
			generate.setRoomMinSize(3)
			generate.setRoomMaxSize(8)

			generate.generate()

			var/const/EROSION_PROB = 30
			var/jp_DungeonRegion/r = generate.out_region
			for(var/turf/t in r.getBorder()) if(prob(EROSION_PROB))	new generate.floortype(t)

			display()

		furnished()
			reset()
			generate.setArea(locate(1,1,1), locate(world.maxx, world.maxy,1))
			generate.setWallType(/turf/wall)
			generate.setFloorType(/turf/ground)
			generate.setAllowedRooms(list(/jp_DungeonRoom/furnished, /jp_DungeonRoom/fountain, /jp_DungeonRoom/hall, /jp_DungeonRoom/deadend))
			generate.setNumRooms(10)
			generate.setExtraPaths(5)
			generate.setMinPathLength(20)
			generate.setMaxPathLength(45)
			generate.setMinLongPathLength(30)
			generate.setLongPathChance(30)
			generate.setPathEndChance(30)
			generate.setRoomMinSize(3)
			generate.setRoomMaxSize(6)

			generate.generate()
			display()

		required()
			reset()
			generate.setArea(locate(1,1,1), locate(world.maxx, world.maxy,1))
			generate.setWallType(/turf/wall)
			generate.setFloorType(/turf/ground)
			generate.setAllowedRooms(list(/jp_DungeonRoom/furnished, /jp_DungeonRoom/fountain, /jp_DungeonRoom/hall, /jp_DungeonRoom/deadend))
			generate.addAllowedRoom(/jp_DungeonRoom/throneroom, 5, 5, 1, 1)
			generate.setNumRooms(10)
			generate.setExtraPaths(5)
			generate.setMinPathLength(20)
			generate.setMaxPathLength(45)
			generate.setMinLongPathLength(30)
			generate.setLongPathChance(30)
			generate.setPathEndChance(30)
			generate.setRoomMinSize(3)
			generate.setRoomMaxSize(6)

			generate.generate()
			display()

		multiborder()
			reset()
			generate.setArea(locate(1,1,1), locate(world.maxx, world.maxy,1))
			generate.setWallType(/turf/wall)
			generate.setFloorType(/turf/ground)
			generate.setAllowedRooms(list(/jp_DungeonRoom/chasm, /jp_DungeonRoom/quads))
			generate.setNumRooms(4)
			generate.setExtraPaths(0)
			generate.setMinPathLength(0)
			generate.setMaxPathLength(45)
			generate.setMinLongPathLength(30)
			generate.setLongPathChance(30)
			generate.setPathEndChance(30)
			generate.setRoomMinSize(3)
			generate.setRoomMaxSize(6)

			generate.generate()
			display()

		preexisting()
			cavern()
			world << "That's the first one done. Let's wait a bit so you can look at it, and then we'll build on it"

			sleep(20)

			world << "Building on it now"
			generate.setArea(locate(1,1,1), locate(world.maxx, world.maxy,1))
			generate.setWallType(/turf/wall)
			generate.setFloorType(/turf/ground)
			generate.setAllowedRooms(list(/jp_DungeonRoom/square))
			generate.setNumRooms(4)
			generate.setExtraPaths(0)
			generate.setMinPathLength(0)
			generate.setMaxPathLength(45)
			generate.setMinLongPathLength(0)
			generate.setLongPathChance(0)
			generate.setPathEndChance(100)
			generate.setRoomMinSize(4)
			generate.setRoomMaxSize(4)
			generate.setUsePreexistingRegions(TRUE)
			generate.setDoAccurateRoomPlacementCheck(TRUE)

			generate.generate()
			display()

		stored_seed()
			reset()
			generate.setArea(locate(1,1,1), locate(world.maxx, world.maxy,1))
			generate.setWallType(/turf/wall)
			generate.setFloorType(/turf/ground)
			generate.setAllowedRooms(list(/jp_DungeonRoom/square))
			generate.setNumRooms(10)
			generate.setExtraPaths(0)
			generate.setMinPathLength(0)
			generate.setMaxPathLength(45)
			generate.setMinLongPathLength(0)
			generate.setLongPathChance(0)
			generate.setPathEndChance(100)
			generate.setRoomMinSize(4)
			generate.setRoomMaxSize(4)

			generate.generate(seed)
			seed = generate.out_seed
			display()
	proc
		reset()
			for(var/turf/t) new /turf/wall(t)
			loc = locate(round(world.maxx/2),round(world.maxy/2),1)

proc
	display()
		var/ret="<strong>Results:</strong><br/>"

		ret+="Number of rooms generated: [generate.out_numRooms]<br/>"
		ret+="Number of paths generated: [generate.out_numPaths]<br/>"
		ret+="Number of long paths generated: [generate.out_numLongPaths]<br/>"
		ret+="Error string: [generate.errString(generate.out_error)]<br/>"
		ret+="Time taken: [generate.out_time/10] seconds<br/>"
		ret+="Random seed used: [generate.out_seed]<br/>"

		var/list/l = list()
		for(var/jp_DungeonRoom/r in generate.out_rooms) l[r.type]++
		ret+="Rooms generated:<br/>"
		for(var/k in l)	ret+="\t[k]: [l[k]]<br/>"

		world << browse(ret)

turf
	icon='turfs.dmi'
	Click()
		world << "Turf is at [x], [y]"
	ground
		icon_state = "ground"
	wall
		icon_state = "wall"
	door
		icon_state = "door"
	pillar
		icon_state = "pillar"
	fountain
		icon_state = "fountain"
	chasm
		icon_state = "chasm"
	throne
		icon_state = "throne"

jp_DungeonRoom
	deadend
		place()
			centre=new gen.floortype(centre)
			turfs+=centre
			border+=pick(gen.getAdjacent(centre))

	cavern
		place()
			var/list/all = range(centre,size)
			var/list/poss = gen.getAdjacent(centre)
			turfs += new gen.floortype(centre)

			var/count = round(size**2)
			while(count>0 && poss.len)
				var/turf/t = pick(poss)
				poss-=t
				for(var/turf/k in gen.getAdjacent(t))
					if(gen.isWall(k))
						if(k in all)
							if(!(k in poss))
								poss+=k
				turfs += new gen.floortype(t)
				count--

			for(var/turf/t in turfs) for(var/turf/t2 in gen.getAdjacent(t)) if(gen.isWall(t2) && !(t2 in border)) border+=t2

	furnished
		place()
			centre = new gen.floortype(centre)
			turfs+=centre
			for(var/turf/t in range(centre, size)) turfs += new gen.floortype(t)
			for(var/turf/t in turfs) for(var/turf/t2 in gen.getAdjacent(t)) if(gen.isWall(t2) && !(t2 in border)) border+=t2

		finalise()
			for(var/turf/t in (range(centre, size+1)-range(centre,size)))
				if(t.type == gen.floortype)
					new /turf/door(t)

	fountain
		ok()
			if(size<1) return FALSE
			return TRUE

		place()
			centre = new gen.floortype(centre)
			turfs+=centre
			for(var/turf/t in range(centre, size)) turfs += new gen.floortype(t)
			for(var/turf/t in turfs) for(var/turf/t2 in gen.getAdjacent(t)) if(gen.isWall(t2) && !(t2 in border)) border+=t2

		finalise()
			new /turf/fountain(centre)

	hall
		ok()
			if(size<3) return FALSE
			return TRUE

		place()
			centre = new gen.floortype(centre)
			turfs+=centre
			for(var/turf/t in range(centre, size)) turfs += new gen.floortype(t)
			for(var/turf/t in turfs) for(var/turf/t2 in gen.getAdjacent(t)) if(gen.isWall(t2) && !(t2 in border)) border+=t2

		finalise()
			var/turf/t = get_step(centre, NORTHEAST)
			new /turf/pillar(t)
			t = get_step(centre, NORTHWEST)
			new /turf/pillar(t)
			t = get_step(centre, SOUTHEAST)
			new /turf/pillar(t)
			t = get_step(centre, SOUTHWEST)
			new /turf/pillar(t)

	quads
		finalise()
			for(var/turf/t in range(centre, size))
				if(t.y==getY() || t.x==getX())
					if(t==centre) centre = new /turf/chasm(centre)
					else new /turf/chasm(t)

		place()
			for(var/turf/t in range(centre, size))
				if(t.y!=getY() && t.x!=getX()) turfs+=new gen.floortype(t)
				else turfs+=t

			var/list/l1 = list()
			var/list/l2 = list()
			var/list/l3 = list()
			var/list/l4 = list()

			for(var/turf/t in turfs)
				if(gen.isWall(t)) continue
				for(var/turf/t2 in gen.getAdjacent(t))
					if(gen.isWall(t2) && !(t2 in turfs))
						if(t2.y<getY())
							if(t2.x<getX())	l1+=t2
							else l2+=t2
						else
							if(t2.x<getX()) l3+=t2
							else l4+=t2

			multiborder = list(l1, l2, l3, l4)
			border.Add(l1)
			border.Add(l2)
			border.Add(l3)
			border.Add(l4)

		doesMultiborder()
			return TRUE

	chasm
		finalise()
			for(var/turf/t in range(centre, size))
				if(t.y==getY())
					if(t==centre) centre = new /turf/chasm(centre)
					else new /turf/chasm(t)

		place()
			for(var/turf/t in range(centre, size))
				if(t.y!=getY()) turfs+=new gen.floortype(t)
				else turfs+=t

			var/list/l1 = list()
			var/list/l2 = list()

			for(var/turf/t in turfs)
				if(gen.isWall(t)) continue
				for(var/turf/t2 in gen.getAdjacent(t))
					if(gen.isWall(t2) && !(t2 in turfs))
						if(t2.y<getY()) l1+=t2
						else l2+=t2

			multiborder = list(l1, l2)
			border.Add(l1)
			border.Add(l2)

		doesMultiborder()
			return TRUE


	throneroom
		ok()
			if(size<1) return FALSE
			return TRUE

		place()
			centre = new gen.floortype(centre)
			turfs+=centre
			for(var/turf/t in range(centre, size)) turfs += new gen.floortype(t)
			for(var/turf/t in turfs) for(var/turf/t2 in gen.getAdjacent(t)) if(gen.isWall(t2) && !(t2 in border)) border+=t2

		finalise()
			new /turf/throne(centre)