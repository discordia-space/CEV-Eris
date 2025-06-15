// Procs that could be called by on_map_loaded() after .dmm file finished loading
// For any of these procs to be called, a "call_proc_on_load" parameter must be set to proc name in related map's .json config file
// E.g. "call_proc_on_load": "build_pulsar"
// Proc name must be defined under /datum/controller/subsystem/mapping/proc/

/datum/controller/subsystem/mapping/proc/build_pulsar()
	var/pulsar_z = world.maxz
	var/list/turfs = list()
	for(var/square in block(locate(1, 1, pulsar_z), locate(PULSAR_SIZE, PULSAR_SIZE, pulsar_z)))
		// Switch to space turf with green grid overlay
		var/turf/space/T = square
		T.name = "[T.x]-[T.y]"
		T.icon_state = "grid"
		T.update_starlight()
		turfs += T
		CHECK_TICK

	var/area/pulsar/A = new
	A.contents.Add(turfs)

	for(var/i in 1 to PULSAR_SIZE)
		var/turf/beam_loc = locate(i, i, pulsar_z)
		new /obj/effect/pulsar_beam(beam_loc)

		var/turf/beam_right = locate(i + 1, i, pulsar_z)
		new /obj/effect/pulsar_beam/ul(beam_right)

		var/turf/beam_left = locate(i - 1, i, pulsar_z)
		new /obj/effect/pulsar_beam/dr(beam_left)

	var/turf/satellite_loc = locate(round((PULSAR_SIZE)/2 + (PULSAR_SIZE)/4), round((PULSAR_SIZE)/2 - (PULSAR_SIZE)/4), pulsar_z)
	var/turf/shadow_loc = locate(round((PULSAR_SIZE)/2 - (PULSAR_SIZE)/4), round((PULSAR_SIZE)/2 + (PULSAR_SIZE)/4), pulsar_z)

	var/obj/effect/pulsar_ship/ship = new /obj/effect/pulsar_ship(satellite_loc)
	var/newshadow = new /obj/effect/pulsar_ship_shadow(shadow_loc)
	ship.shadow = newshadow

	var/turf/T = locate(round((PULSAR_SIZE - 1)/2), round((PULSAR_SIZE - 1)/2), pulsar_z)
	new /obj/effect/pulsar(T)

	var/event_type = pick(subtypesof(/datum/pulsar_event))
	var/datum/pulsar_event/event = new event_type
	event.on_trigger()


// Magic numbers from original implementation
#define OVERMAP_EVENT_AREAS 640
#define OVERMAP_SIZE 200

/datum/controller/subsystem/mapping/proc/build_overmap()
	testing("Building overmap...")
	SSmapping.overmap_z = world.maxz
	var/list/turfs = list()
	for(var/square in block(locate(1,1,SSmapping.overmap_z), locate(OVERMAP_SIZE, OVERMAP_SIZE, SSmapping.overmap_z)))
		// Switch to space turf with green grid overlay
		var/turf/space/T = square
		T.icon_state = "grid"
		T.update_starlight()
		turfs += T
		CHECK_TICK

	var/area/overmap/A = new
	A.contents.Add(turfs)

    // Spawn star at the center of the overmap
	var/turf/T = locate(round(OVERMAP_SIZE/2),round(OVERMAP_SIZE/2),SSmapping.overmap_z)
	new /obj/effect/star(T)

	testing("Overmap build complete, creating events..")
	testing_variable(t1, world.tick_usage)
	overmap_event_handler.create_events(SSmapping.overmap_z, OVERMAP_SIZE, OVERMAP_EVENT_AREAS)
	testing("Overmap events created in [(world.tick_usage-t1)*0.01*world.tick_lag] seconds")

#undef OVERMAP_EVENT_AREAS
// OVERMAP_SIZE is used elsewhere so it stays defined


// Ideally would not be hardcoded, but since we only have a single static asteroid map it won't matter for the foreseeable future
#define ASTEROID_SIZE 200

/datum/controller/subsystem/mapping/proc/build_asteroid()
	var/asteroid_z = world.maxz
	new /datum/random_map/automata/cave_system(null, 1, 1, asteroid_z, ASTEROID_SIZE, ASTEROID_SIZE)

#undef ASTEROID_SIZE


/datum/controller/subsystem/mapping/proc/build_crawler()
	var/obj/rogue/teleporter/teleporter = locate()
	if(teleporter)
		teleporter.on_destination_map_loaded()








