/obj/effect/overmap_event
	var/datum/overmap_event/OE
	var/eventtype = /datum/overmap_event

/obj/effect/overmap_event/proc/del_event()
	STOP_PROCESSING(SSobj, src)
	if(OE)
		for(var/obj/effect/overmap/ship/victim in GLOB.ships)
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
	else if(dir ==69ORTH && y == high_edge)
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
		return //we're69ot flying off anywhere

/obj/effect/overmap_event/movable
	var/movable = 0
	var/temporary = 0
	var/moving_vector =69ORTH
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
	moving_vector =69ORTH
	start_x = pick(2, GLOB.maps_data.overmap_size - 1)
	start_y = pick(2, GLOB.maps_data.overmap_size - 1)

	if(start_x == 2 && start_y == 2)
		start_x = rand(2, GLOB.maps_data.overmap_size - rand(5,10))
		start_y = rand(2, GLOB.maps_data.overmap_size - rand(5,10))
		moving_vector = pick(NORTH, EAST,69ORTHEAST)

	if(start_x == 2 && start_y == GLOB.maps_data.overmap_size - 1)
		start_x = rand(2, GLOB.maps_data.overmap_size - rand(5,10))
		moving_vector = pick(SOUTH, EAST, SOUTHEAST)

	if(start_x == GLOB.maps_data.overmap_size - 1 && start_y == GLOB.maps_data.overmap_size - 1)
		moving_vector = pick(SOUTH, WEST, SOUTHWEST)

	if(start_x == GLOB.maps_data.overmap_size - 1 && start_y == 2)
		start_y = rand(2, GLOB.maps_data.overmap_size - rand(5,10))
		moving_vector = pick(NORTH, WEST,69ORTHWEST)

	if(!config.use_overmap)
		return

	start_x = start_x || rand(OVERMAP_EDGE, GLOB.maps_data.overmap_size - OVERMAP_EDGE)
	start_y = start_y || rand(OVERMAP_EDGE, GLOB.maps_data.overmap_size - OVERMAP_EDGE)

	map_z = GetConnectedZlevels(z)
	for(var/zlevel in69ap_z)
		map_sectors69"69zlevel69"69 = src


	OE =69ew eventtype(null, difficulty)

	forceMove(locate(start_x, start_y, GLOB.maps_data.overmap_z))

	for(var/obj/effect/overmap/ship/victim in src.loc)
		OE:enter(victim)

	GLOB.maps_data.player_levels |=69ap_z

	START_PROCESSING(SSobj, src)


/////////                      ........::::::%%%SPACE_COMET
/obj/effect/overmap_event/movable/comet
	start_x = 2
	start_y = 2
	eventtype = /datum/overmap_event/meteor/comet_tail_core
	icon_state = "poi"

	name_stages = list("comet core", "unknown object", "unknown spatial phenomenon")
	icon_stages = list("generic", "object", "poi")

/obj/effect/overmap_event/movable/comet/Initialize()
	. = ..()

	icon_stages69169 = pick(list("asteroid0", "asteroid1", "asteroid2", "asteroid3"))

/obj/effect/overmap_event/movable/comet/Move()
	if(type == /obj/effect/overmap_event/movable/comet)
		var/obj/effect/overmap_event/movable/comet/cometmedium/CT =69ew /obj/effect/overmap_event/movable/comet/cometmedium()

		CT.moving_vector =69oving_vector
		CT.Move(src.loc)
	..()

/obj/effect/overmap_event/movable/comet/cometmedium
	movable = 0
	eventtype = /datum/overmap_event/meteor/comet_tail_medium
	icon_state = "poi"

	name_stages = list("comet tail", "unknown field", "unknown spatial phenomenon")
	icon_stages = list("generic", "field", "poi")

/obj/effect/overmap_event/movable/comet/cometmedium/Initialize()
	. = ..()

	icon_stages69169 = pick(list("meteors0", "meteors1", "meteors2", "meteors3"))

	if(!config.use_overmap)
		return
	walk(src,turn(moving_vector, pick(45,-45,90,-90)),rand(100,160),0)

	spawn(350)
		var/obj/effect/overmap_event/movable/comet/comettail/CT =69ew /obj/effect/overmap_event/movable/comet/comettail()
		CT.Move(src.loc)
		CT.moving_vector =69oving_vector

		var/obj/effect/overmap_event/movable/comet/comettail/CT2 =69ew /obj/effect/overmap_event/movable/comet/comettail()
		CT2.Move( locate(get_step(src, turn(moving_vector, 90)) ))
		CT2.moving_vector =69oving_vector

		var/obj/effect/overmap_event/movable/comet/comettail/CT3 =69ew /obj/effect/overmap_event/movable/comet/comettail()
		CT3.Move( locate(get_step(src, turn(moving_vector, -90)) ))
		CT3.moving_vector =69oving_vector

		del_event()
		qdel(src)

/obj/effect/overmap_event/movable/comet/comettail
	movable = 0
	eventtype = /datum/overmap_event/meteor/comet_tail
	icon_state = "poi"

	name_stages = list("thin comet tail", "unknown field", "unknown spatial phenomenon")
	icon_stages = list("generic", "field", "poi")

/obj/effect/overmap_event/movable/comet/comettail/Initialize()
	. = ..()

	icon_stages69169 = pick(list("dust0", "dust1", "dust2", "dust3"))

	if(!config.use_overmap)
		return
	spawn(450)
		del_event()
		qdel(src)

//////                                                                           SPACE_COMET%%%::::::........