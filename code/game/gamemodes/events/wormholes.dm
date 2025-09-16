/*
	Wormholes is an uncommon moderate event which spawns several connected pairs of wormholes around the
	ship.These wormholes are semi-stable and will last for a significant quantity of time. Anywhere from
	a few minutes to several hours, effectively permanantly connecting areas.

	This may require engineering to wall them off, or ironhammer to guard them, to prevent unauthorised access
	If conveniently placed,they may also offer new, rapid transit routes around the ship
*/
/datum/storyevent/wormholes
	id = "wormholes"
	name = "wormholes"

	weight = 0.4
	event_type = /datum/event/wormholes
	event_pools = list(EVENT_LEVEL_MODERATE = POOL_THRESHOLD_MODERATE)
	tags = list(TAG_POSITIVE, TAG_COMMUNAL)

////////////////////////////////////////////////////////
/datum/event/wormholes
	//The duration ranges from fairly long, to basically forever
	var/min_duration = 5 MINUTES
	var/max_duration = 3 HOURS

	var/number_of_wormholes

	var/list/wormhole_tiles = list()

/datum/event/wormholes/setup()
	number_of_wormholes = rand(2,8)
	for (var/i = 1; i <= number_of_wormholes*2; i++)
		var/area/A
		if (prob(15))
			//15% chance to allow maintenance areas in the search
			A = random_ship_area(TRUE, FALSE)
		else
			A = random_ship_area(TRUE, TRUE)
		var/turf/T = A.random_space()
		if(!T)
			//We somehow failed to find a turf, decrement i so we get another go
			i--
			continue
		wormhole_tiles.Add(T)

/datum/event/wormholes/announce()
	priority_announce("Space-time anomalies detected on the ship. There is no additional data.", "Anomaly Alert", sound = 'sound/AI/spanomalies.ogg')


/datum/event/wormholes/start()
	for (var/i = 1; i <= number_of_wormholes; i++)
		var/turf/enter = pick_n_take(wormhole_tiles)
		var/turf/exit = pick_n_take(wormhole_tiles)
		new /obj/effect/portal/wormhole(enter, rand(min_duration, max_duration),exit)

