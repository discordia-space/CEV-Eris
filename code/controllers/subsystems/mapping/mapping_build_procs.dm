/datum/controller/subsystem/mapping/proc/build_pulsar()
	SSmapping.pulsar_z = world.maxz
	var/list/turfs = list()
	for(var/square in block(locate(1, 1, SSmapping.pulsar_z), locate(SSmapping.pulsar_size, SSmapping.pulsar_size, SSmapping.pulsar_z)))
		// Switch to space turf with green grid overlay
		var/turf/space/T = square
		T.name = "[T.x]-[T.y]"
		T.icon_state = "grid"
		T.update_starlight()
		turfs += T
		CHECK_TICK

	var/area/pulsar/A = new
	A.contents.Add(turfs)

	for(var/i in 1 to SSmapping.pulsar_size)
		var/turf/beam_loc = locate(i, i, SSmapping.pulsar_z)
		new /obj/effect/pulsar_beam(beam_loc)

		var/turf/beam_right = locate(i + 1, i, SSmapping.pulsar_z)
		new /obj/effect/pulsar_beam/ul(beam_right)

		var/turf/beam_left = locate(i - 1, i, SSmapping.pulsar_z)
		new /obj/effect/pulsar_beam/dr(beam_left)

	var/turf/satellite_loc = locate(round((SSmapping.pulsar_size)/2 + (SSmapping.pulsar_size)/4), round((SSmapping.pulsar_size)/2 - (SSmapping.pulsar_size)/4), SSmapping.pulsar_z)
	var/turf/shadow_loc = locate(round((SSmapping.pulsar_size)/2 - (SSmapping.pulsar_size)/4), round((SSmapping.pulsar_size)/2 + (SSmapping.pulsar_size)/4), SSmapping.pulsar_z)

	var/obj/effect/pulsar_ship/ship = new /obj/effect/pulsar_ship(satellite_loc)
	var/newshadow = new /obj/effect/pulsar_ship_shadow(shadow_loc)
	ship.shadow = newshadow

	if(!SSmapping.pulsar_star)
		var/turf/T = locate(round((SSmapping.pulsar_size - 1)/2), round((SSmapping.pulsar_size - 1)/2), SSmapping.pulsar_z)
		SSmapping.pulsar_star = new /obj/effect/pulsar(T)

	var/event_type = pick(subtypesof(/datum/pulsar_event))
	var/datum/pulsar_event/event = new event_type
	event.on_trigger()


/datum/controller/subsystem/mapping/proc/build_overmap()
	testing("Building overmap...")
	world.incrementMaxZ()
	SSmapping.overmap_z = world.maxz
	var/list/turfs = list()
	for(var/square in block(locate(1,1,SSmapping.overmap_z), locate(SSmapping.overmap_size, SSmapping.overmap_size, SSmapping.overmap_z)))
		// Switch to space turf with green grid overlay
		var/turf/space/T = square
		T.icon_state = "grid"
		T.update_starlight()
		turfs += T
		CHECK_TICK

	var/area/overmap/A = new
	A.contents.Add(turfs)

    // Spawn star at the center of the overmap
	var/turf/T = locate(round(SSmapping.overmap_size/2),round(SSmapping.overmap_size/2),SSmapping.overmap_z)
	new /obj/effect/star(T)

	testing("Overmap build complete, creating events..")
	testing_variable(t1, world.tick_usage)
	overmap_event_handler.create_events(SSmapping.overmap_z, SSmapping.overmap_size, SSmapping.overmap_event_areas)
	testing("Overmap events created in [(world.tick_usage-t1)*0.01*world.tick_lag] seconds")



/datum/controller/subsystem/mapping/proc/build_asteroid()

	// if(map_data.generate_asteroid)
	// 	new /datum/random_map/automata/cave_system(null, 1, 1,  map_data.z_level, map_data.size, map_data.size)
	// 	new /datum/random_map/noise/ore(null, 1, 1,  map_data.z_level, map_data.size, map_data.size)


/datum/controller/subsystem/mapping/proc/build_crawler()
	var/obj/rogue/teleporter/teleporter = locate()
	if(teleporter)
		teleporter.on_destination_map_loaded()








