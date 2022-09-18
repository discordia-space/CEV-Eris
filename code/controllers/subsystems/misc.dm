SUBSYSTEM_DEF(misc)
	name = "Misc"
	init_order = INIT_ORDER_LATELOAD
	flags = SS_NO_FIRE
	var/num_exoplanets = 2
	var/list/planet_size  //dimensions of planet zlevel, defaults to world size. Due to how maps are generated, must be (2^n+1) e.g. 17,33,65,129 etc. Map will just round up to those if set to anything other.

/datum/controller/subsystem/misc/Initialize(timeofday)
	if(!LAZYLEN(planet_size))
		planet_size = list(world.maxx - 30 , world.maxy - 30)
	initialize_cursors()
	// build_exoplanets()  // 18/09/2022 Commented till lag gets better overhaul
	build_junk_field()
	return ..()

GLOBAL_LIST_INIT(cursor_icons, list()) //list of icon files, which point to lists of offsets, which point to icons

/proc/initialize_cursors()
	for(var/i = 0 to MAX_ACCURACY_OFFSET)
		make_cursor_icon('icons/obj/gun_cursors/standard/standard.dmi', i)

/datum/controller/subsystem/misc/proc/build_exoplanets()
	if(!config.use_overmap)
		return
	for(var/i = 0, i < num_exoplanets, i++)
		var/exoplanet_type = pick(subtypesof(/obj/effect/overmap/sector/exoplanet))
		var/obj/effect/overmap/sector/exoplanet/new_planet = new exoplanet_type(null, planet_size[1], planet_size[2])
		new_planet.build_level()

/datum/controller/subsystem/misc/proc/build_junk_field()
	var/obj/jtb_generator/jtb_gen = locate(/obj/jtb_generator)
	jtb_gen.generate_junk_field()
