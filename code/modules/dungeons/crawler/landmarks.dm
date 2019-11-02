/obj/crawler/crawler_wallmaker
	name = "wallmaker"
	icon = 'icons/mob/radial/menu.dmi'
	icon_state = "x2"
	invisibility = 101
	var/wall_dir = NORTH
	var/spawnwall = TRUE

/obj/crawler/crawler_wallmaker/New()
	sleep(350)
	var/turf/T = get_step(loc, wall_dir)
	for(var/obj/crawler/crawler_wallmaker/found in T.contents)
		if(found)
			spawnwall = FALSE
			break
	if(spawnwall)
		new /turf/simulated/wall(src.loc)

/obj/crawler/crawler_wallmaker/west
	icon_state = "radial_left"
	wall_dir = WEST

/obj/crawler/crawler_wallmaker/east
	icon_state = "radial_right"
	wall_dir = EAST

/obj/crawler/crawler_wallmaker/north
	icon_state = "radial_up"
	wall_dir = NORTH

/obj/crawler/crawler_wallmaker/south
	icon_state = "radial_down"
	wall_dir = SOUTH

/obj/crawler/crawler_wallbreaker
	name = "wallbreaker"
	icon = 'icons/mob/radial/menu.dmi'
	icon_state = "x2"
	invisibility = 101
	var/breakhorizontal = 1
	var/walls_to_break = list()

/obj/crawler/crawler_wallbreaker/proc/breakwalls()
	var/turf/T = get_turf(src)
	walls_to_break += T
	if(breakhorizontal)
		walls_to_break += get_step(T, WEST)
		walls_to_break += get_step(T, EAST)
	else
		walls_to_break += get_step(T, NORTH)
		walls_to_break += get_step(T, SOUTH)
	for(var/turf/W in walls_to_break)
		var/turf/simulated/floor/tiled/derelict/red_white_edges/newfloor = new /turf/simulated/floor/tiled/derelict/red_white_edges(W)
		spawn(20)
			newfloor.lighting_build_overlay()




/obj/crawler/crawler_wallbreaker/vertical
	name = "wallbreaker"
	icon = 'icons/mob/radial/menu.dmi'
	icon_state = "x2"
	invisibility = 101
	breakhorizontal = 0

/obj/crawler/crawler_chanceblock
	name = "chance"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	invisibility = 101

/obj/crawler/crawler_chanceblock_danger
	name = "danger"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	invisibility = 101

/obj/crawler/room_controller
	name = "room"
	icon = 'icons/mob/eye.dmi'
	icon_state = "default-eye"
	invisibility = 101
	var/roomnum = 1
	var/room_x = 1
	var/room_y = 1
	var/under = 0
	var/above = 0
	var/datum/map_template/dungeon_template/template = null
	var/end_room = FALSE

/obj/crawler/room_controller/New()
	if(loc && istype(loc.loc,/area/crawler))
		var/area/crawler/A = loc.loc
		A.room_controllers += src

/obj/crawler/room_controller/proc/connect(var/obj/crawler/room_controller/neighbor)
	var/rc_dir = get_dir(src, neighbor)
	var/turf/T1
	var/turf/T2
	switch(rc_dir)
		if(NORTH)
			T1 = locate(x, y + 4, z)
			T2 = locate(x, y + 5, z)
		if (SOUTH)
			T1 = locate(x, y - 4, z)
			T2 = locate(x, y - 5, z)
		if (WEST)
			T1 = locate(x - 6, y, z)
			T2 = locate(x - 7, y, z)
		if (EAST)
			T1 = locate(x + 6, y, z)
			T2 = locate(x + 7, y, z)

	for (var/obj/crawler/crawler_wallbreaker/WB1 in T1)
		WB1.breakwalls()

	for (var/obj/crawler/crawler_wallbreaker/WB2 in T2)
		WB2.breakwalls()

	for (var/obj/crawler/crawler_wallbreaker/vertical/WB3 in T1)
		WB3.breakwalls()

	for (var/obj/crawler/crawler_wallbreaker/vertical/WB4 in T2)
		WB4.breakwalls()


/obj/crawler/spawnpoint
	name = "spawnpoint"
	icon = 'icons/mob/radial/menu.dmi'
	icon_state = "x2"
	invisibility = 101


/obj/crawler/teleport_marker
	name = "spawnpoint"
	icon = 'icons/mob/radial/menu.dmi'
	icon_state = "x2"
	invisibility = 101