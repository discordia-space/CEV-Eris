datum/event/wallrot/setup()
	announceWhen = rand(0, 300)
	endWhen = announceWhen + 1

datum/event/wallrot/announce()
	command_announcement.Announce("Harmful fungi detected on station. Station structures may be contaminated.", "Biohazard Alert", new_sound = pick('sound/AI/fungi.ogg', 'sound/AI/funguy.ogg', 'sound/AI/fun_guy.ogg', 'sound/AI/fun_gi.ogg'))

datum/event/wallrot/start()
	set waitfor = FALSE

	var/turf/simulated/wall/center = null

	// 100 attempts
	for(var/i=0, i<100, i++)
		var/turf/candidate = locate(rand(1, world.maxx), rand(1, world.maxy), pick(maps_data.station_levels))
		if(istype(candidate, /turf/simulated/wall))
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
		var/actual_severity = severity * rand(15, 30)
		for(var/turf/simulated/wall/W in trange(14, center))
			if(prob(25))
				W.rot()
				rotcount++

				// Only rot up to severity walls
				if(rotcount >= actual_severity)
					break

		var/area/A = get_area(center)
		var/where = "[A? A.name : "Unknown Location"] | [center.x], [center.y]"
		var/whereLink = "<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[center.x];Y=[center.y];Z=[center.z]'>[where]</a>"
		message_admins("Wallrot has spread from ([whereLink])", 0, 1)


	else
		message_admins("Wallrot failed to find a starting point", 0, 1)