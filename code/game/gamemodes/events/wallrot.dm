/*
	Wall rot causes a corrosive fungus to grow on walls,wearing them down until they eventually become
	weak enough to break with bare hands. This can be useful to people trying to get more access around
	the ship, or to break into sensitive areas. Or even to escape maintenance pits

	It is not marked negative due to this possible advantage
*/
/datum/storyevent/wallrot
	id = "wallrot"
	name = "wallrot"


	event_type = /datum/event/wallrot
	event_pools = list(EVENT_LEVEL_MUNDANE = POOL_THRESHOLD_MUNDANE *0.8)
	tags = list(TAG_DESTRUCTIVE)

//----------------------------------------

/datum/event/wallrot/setup()
	announceWhen = rand(0, 300)
	endWhen = announceWhen + 1

/datum/event/wallrot/announce()
	var/new_sound = pick('sound/AI/fungi.ogg', 'sound/AI/funguy.ogg', 'sound/AI/fun_guy.ogg', 'sound/AI/fun_gi.ogg')
	priority_announce("Harmful fungi detected on ship. ship structures may be contaminated.", "Biohazard Alert", new_sound)

/datum/event/wallrot/start()
	set waitfor = FALSE

	var/turf/wall/center = null

	// 100 attempts
	for(var/i = 0; i < 100; i++)
		var/turf/candidate = locate(rand(1, world.maxx), rand(1, world.maxy), pick(GLOB.maps_data.station_levels))
		if(istype(candidate, /turf/wall))
			center = candidate //If necessary we'll settle for any wall
			var/area/A = get_area(center)
			if (!istype(A, /area/eris/maintenance)) //But ideally we want a wall that's not in maintenance, so players are likely to see it
				//We'll keep going til we find a wall that isnt in maint
				break

	if(center)
		// Make sure at least one piece of wall rots!
		center.rot()

		// Have a chance to rot lots of other walls.
		var/rotcount = 0
		var/actual_severity = rand(30, 60)
		for(var/turf/wall/W in RANGE_TURFS(14, center))
			if(prob(25))
				W.rot()
				rotcount++

				// Only rot up to severity walls
				if(rotcount >= actual_severity)
					break

		message_admins("Wallrot has spread from ([jumplink(center)])", 0, 1)


	else
		message_admins("Wallrot failed to find a starting point", 0, 1)



// Wall-rot effect, a nasty fungus that destroys walls.
/turf/wall/proc/rot()
	if(locate(/obj/effect/overlay/wallrot) in src)
		return
	var/number_rots = rand(2,3)
	for(var/i = 0; i < number_rots; i++)
		new/obj/effect/overlay/wallrot(src)


/obj/effect/overlay/wallrot
	name = "wallrot"
	desc = "Ick..."
	icon = 'icons/effects/wallrot.dmi'
	anchored = TRUE
	density = TRUE
	layer = 5
	mouse_opacity = 0

/obj/effect/overlay/wallrot/New()
	..()
	pixel_x += rand(-10, 10)
	pixel_y += rand(-10, 10)
