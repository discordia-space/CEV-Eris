//Space stragglers go here
/obj/effect/overmap/sector/temporary
	name = "Deep Space"
	invisibility = 101
	known = 0

/obj/effect/overmap/sector/temporary/New(var/nx, var/ny, var/nz)
	loc = locate(nx, ny, SSmapping.overmap_z)
	x = nx
	y = ny
	map_z += nz
	map_sectors["[nz]"] = src
	testing("Temporary sector at [x],[y] was created, corresponding zlevel is [nz].")

/obj/effect/overmap/sector/temporary/Destroy()
	map_sectors["[map_z]"] = null
	testing("Temporary sector at [x],[y] was deleted.")
	. = ..()

/obj/effect/overmap/sector/temporary/proc/can_die(var/mob/observer)
	testing("Checking if sector at [map_z[1]] can die.")
	for(var/mob/M in GLOB.player_list)
		if(M != observer && (M.z in map_z))
			testing("There are people on it.")
			return 0
	return 1
