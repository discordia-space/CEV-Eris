/obj/effect/overmap_event
	var/datum/overmap_event/OE
	var/eventtype = /datum/overmap_event

/obj/effect/overmap_event/proc/del_event()
	STOP_PROCESSING(SSobj, src)
	if(OE)
		for(var/obj/effect/overmap/ship/victim in world)
			if(istype(victim, /obj/effect/overmap/ship))
				OE.leave(victim)

/obj/effect/overmap_event/proc/handle_wraparound()
	var/low_edge = 1
	var/high_edge = GLOB.maps_data.overmap_size - 1

	if(dir == WEST && x == low_edge)
		del_event()
		if(istype(src, /obj/effect/overmap_event/movable/comet))
			invisibility = 101
			src:movable = 0
			spawn(rand(30,70))
				new /obj/effect/overmap_event/movable/comet()
				qdel(src)
		else
			qdel(src)
	else if(dir == EAST && x == high_edge)
		del_event()
		if(istype(src, /obj/effect/overmap_event/movable/comet))
			invisibility = 101
			src:movable = 0
			spawn(rand(30,70))
				new /obj/effect/overmap_event/movable/comet()
				qdel(src)
		else
			qdel(src)
	else if(dir == SOUTH  && y == low_edge)
		del_event()
		if(istype(src, /obj/effect/overmap_event/movable/comet))
			invisibility = 101
			src:movable = 0
			spawn(rand(30,70))
				new /obj/effect/overmap_event/movable/comet()
				qdel(src)
		else
			qdel(src)
	else if(dir == NORTH && y == high_edge)
		del_event()
		if(istype(src, /obj/effect/overmap_event/movable/comet))
			invisibility = 101
			src:movable = 0
			spawn(rand(30,70))
				new /obj/effect/overmap_event/movable/comet()
				qdel(src)
		else
			qdel(src)
	else
		return //we're not flying off anywhere

/obj/effect/overmap_event/movable
	var/movable = 0
	var/temporary = 0
	var/moving_vector = NORTH
	var/start_x
	var/start_y
	var/list/map_z = list()

	movable = 1
	var/difficulty = EVENT_LEVEL_MODERATE

/obj/effect/overmap_event/movable/Crossed(obj/effect/overmap/ship/victim)
	..()
	if(OE)
		if(istype(victim, /obj/effect/overmap/ship))
			OE:leave(victim)
			OE:enter(victim)
		if(istype(victim, /obj/effect/overmap/ship/eris))
			if(!scanned)
				name = name_scanned
				icon_state = icon_scanned
				scanned = TRUE

/obj/effect/overmap_event/movable/Uncrossed(obj/effect/overmap/ship/victim)
	..()
	if(OE)
		if(istype(victim, /obj/effect/overmap/ship))
			OE.leave(victim)

/obj/effect/overmap_event/movable/Process()
	if(movable == 1)
		walk(src,moving_vector,170,0)
		handle_wraparound()

/obj/effect/overmap_event/movable/Initialize()
	. = ..()
	moving_vector = NORTH
	start_x = pick(2, GLOB.maps_data.overmap_size - 1)
	start_y = pick(2, GLOB.maps_data.overmap_size - 1)

	if(start_x == 2 && start_y == 2)
		start_x = rand(2, GLOB.maps_data.overmap_size - rand(5,10))
		start_y = rand(2, GLOB.maps_data.overmap_size - rand(5,10))
		moving_vector = pick(NORTH, EAST, NORTHEAST)

	if(start_x == 2 && start_y == GLOB.maps_data.overmap_size - 1)
		start_x = rand(2, GLOB.maps_data.overmap_size - rand(5,10))
		moving_vector = pick(SOUTH, EAST, SOUTHEAST)

	if(start_x == GLOB.maps_data.overmap_size - 1 && start_y == GLOB.maps_data.overmap_size - 1)
		moving_vector = pick(SOUTH, WEST, SOUTHWEST)

	if(start_x == GLOB.maps_data.overmap_size - 1 && start_y == 2)
		start_y = rand(2, GLOB.maps_data.overmap_size - rand(5,10))
		moving_vector = pick(NORTH, WEST, NORTHWEST)

	if(!config.use_overmap)
		return

	start_x = start_x || rand(OVERMAP_EDGE, GLOB.maps_data.overmap_size - OVERMAP_EDGE)
	start_y = start_y || rand(OVERMAP_EDGE, GLOB.maps_data.overmap_size - OVERMAP_EDGE)

	map_z = GetConnectedZlevels(z)
	for(var/zlevel in map_z)
		map_sectors["[zlevel]"] = src


	OE = new eventtype(null, difficulty)

	forceMove(locate(start_x, start_y, GLOB.maps_data.overmap_z))

	for(var/obj/effect/overmap/ship/victim in src.loc)
		OE:enter(victim)

	GLOB.maps_data.player_levels |= map_z

	START_PROCESSING(SSobj, src)


/////////                      ........::::::%%%SPACE_COMET
/obj/effect/overmap_event/movable/comet
	start_x = 2
	start_y = 2
	eventtype = /datum/overmap_event/meteor/comet_tail_core

	name_scanned = "moving comet core"
	icon_scanned = "ship_moving"

/obj/effect/overmap_event/movable/comet/Move()
	if(type == /obj/effect/overmap_event/movable/comet)
		var/obj/effect/overmap_event/movable/comet/cometmedium/CT = new /obj/effect/overmap_event/movable/comet/cometmedium()
		if(scanned)
			CT.name = CT.name_scanned
			CT.icon_state = CT.icon_scanned
			CT.scanned = TRUE

		CT.moving_vector = moving_vector
		CT.Move(src.loc)
	..()

/obj/effect/overmap_event/movable/comet/cometmedium
	movable = 0
	eventtype = /datum/overmap_event/meteor/comet_tail_medium

	name_scanned = "dense comet tail"
	icon_scanned = "meteor1"

/obj/effect/overmap_event/movable/comet/cometmedium/Initialize()
	. = ..()

	if(!config.use_overmap)
		return
	walk(src,turn(moving_vector, pick(45,-45,90,-90)),rand(100,160),0)

	spawn(350)
		var/obj/effect/overmap_event/movable/comet/comettail/CT = new /obj/effect/overmap_event/movable/comet/comettail()
		if(scanned)
			CT.name = CT.name_scanned
			CT.icon_state = CT.icon_scanned
			CT.scanned = TRUE
		CT.Move(src.loc)
		CT.moving_vector = moving_vector

		var/obj/effect/overmap_event/movable/comet/comettail/CT2 = new /obj/effect/overmap_event/movable/comet/comettail()
		if(scanned)
			CT2.name = CT2.name_scanned
			CT2.icon_state = CT2.icon_scanned
			CT2.scanned = TRUE
		CT2.Move( locate(get_step(src, turn(moving_vector, 90)) ))
		CT2.moving_vector = moving_vector

		var/obj/effect/overmap_event/movable/comet/comettail/CT3 = new /obj/effect/overmap_event/movable/comet/comettail()
		if(scanned)
			CT3.name = CT3.name_scanned
			CT3.icon_state = CT3.icon_scanned
			CT3.scanned = TRUE
		CT3.Move( locate(get_step(src, turn(moving_vector, -90)) ))
		CT3.moving_vector = moving_vector

		del_event()
		qdel(src)

/obj/effect/overmap_event/movable/comet/comettail
	movable = 0
	eventtype = /datum/overmap_event/meteor/comet_tail

	name_scanned = "thin comet tail"
	icon_scanned = "dust1"

/obj/effect/overmap_event/movable/comet/comettail/Initialize()
	. = ..()

	if(!config.use_overmap)
		return
	spawn(450)
		del_event()
		qdel(src)

//////                                                                           SPACE_COMET%%%::::::........