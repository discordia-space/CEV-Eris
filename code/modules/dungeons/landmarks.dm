//////////////////////////////
// Landmarks for asteroid positioning
// Just69akes the placement69ore safe/sane
//////////////////////////////

/obj/asteroid_spawner
	name = "asteroid spawn"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x2"
	invisibility = 101
	anchored = TRUE
	var/datum/rogue/asteroid/myasteroid

/obj/asteroid_spawner/New()
	if(loc && istype(loc,/turf/space) && istype(loc.loc,/area/asteroid/rogue))
		var/area/asteroid/rogue/A = loc.loc
		A.asteroid_spawns += src

/obj/rogue_mobspawner
	name = "mob spawn"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	invisibility = 101
	anchored = TRUE
	var/mob/mymob

/obj/rogue_mobspawner/New()
	if(loc && istype(loc,/turf/space) && istype(loc.loc,/area/asteroid/rogue))
		var/area/asteroid/rogue/A = loc.loc
		A.mob_spawns += src

/obj/asteroid_spawner/rogue_teleporter
	name = "teleporter spawn"
	icon = 'icons/mob/eye.dmi'
	icon_state = "default-eye"
	invisibility = 101
	anchored = TRUE

/obj/asteroid_spawner/rogue_teleporter/New()
	if(loc && istype(loc,/turf/space) && istype(loc.loc,/area/asteroid/rogue))
		var/area/asteroid/rogue/A = loc.loc
		A.teleporter_spawns += src
