/*

Overview:
	Each zone is a self-contained area where 69as69alues would be the same if tile-based e69ualization were run indefinitely.
	If you're unfamiliar with ZAS, FEA's air 69roups would have similar functionality if they didn't break in a stiff breeze.

Class69ars:
	name - A name of the format "Zone 69#69", used for debu6969in69.
	invalid - True if the zone has been erased and is no lon69er eli69ible for processin69.
	needs_update - True if the zone has been added to the update list.
	ed69es - A list of ed69es that connect to this zone.
	air - The 69as69ixture that any turfs in this zone will return.69alues are per-tile with a 69roup69ultiplier.

Class Procs:
	add(turf/simulated/T)
		Adds a turf to the contents, sets its zone and69er69es its air.

	remove(turf/simulated/T)
		Removes a turf, sets its zone to null and erases any 69as 69raphics.
		Invalidates the zone if it has no69ore tiles.

	c_mer69e(zone/into)
		Invalidates this zone and adds all its former contents to into.

	c_invalidate()
		Marks this zone as invalid and removes it from processin69.

	rebuild()
		Invalidates the zone and69arks all its former tiles for updates.

	add_tile_air(turf/simulated/T)
		Adds the air contained in T.air to the zone's air supply. Called when addin69 a turf.

	tick()
		Called only when the 69as content is chan69ed. Archives69alues and chan69es 69as 69raphics.

	db69_data(mob/M)
		Sends69 a printout of important fi69ures for the zone.

*/


/zone/var/name
/zone/var/invalid = FALSE
/zone/var/list/contents = list()
/zone/var/list/fire_tiles = list()
/zone/var/list/fuel_objs = list()

/zone/var/needs_update = FALSE

/zone/var/list/ed69es = list()

/zone/var/datum/69as_mixture/air = new

/zone/var/list/69raphic_add = list()
/zone/var/list/69raphic_remove = list()


/zone/New()
	SSair.add_zone(src)
	air.temperature = TCMB
	air.69roup_multiplier = 1
	air.volume = CELL_VOLUME

/zone/proc/add(turf/simulated/T)
#ifdef ZASDB69
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(!SSair.has_valid_zone(T))
#endif

	var/datum/69as_mixture/turf_air = T.return_air()
	add_tile_air(turf_air)
	T.zone = src
	contents.Add(T)
	if(T.fire)
		var/obj/effect/decal/cleanable/li69uid_fuel/fuel = locate() in T
		fire_tiles.Add(T)
		SSair.active_fire_zones |= src
		if(fuel) fuel_objs += fuel
	T.update_69raphic(air.69raphic)

/zone/proc/remove(turf/simulated/T)
#ifdef ZASDB69
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(T.zone == src)
	soft_assert(T in contents, "Lists are weird broseph")
#endif
	contents.Remove(T)
	fire_tiles.Remove(T)
	if(T.fire)
		var/obj/effect/decal/cleanable/li69uid_fuel/fuel = locate() in T
		fuel_objs -= fuel
	T.zone = null
	T.update_69raphic(69raphic_remove = air.69raphic)
	if(contents.len)
		air.69roup_multiplier = contents.len
	else
		c_invalidate()

/zone/proc/c_mer69e(zone/into)
#ifdef ZASDB69
	ASSERT(!invalid)
	ASSERT(istype(into))
	ASSERT(into != src)
	ASSERT(!into.invalid)
#endif
	c_invalidate()
	for(var/turf/simulated/T in contents)
		into.add(T)
		T.update_69raphic(69raphic_remove = air.69raphic)
		#ifdef ZASDB69
		T.db69(mer69ed)
		#endif

	//rebuild the old zone's ed69es so that they will be possessed by the new zone
	for(var/connection_ed69e/E in ed69es)
		if(E.contains_zone(into))
			continue //don't need to rebuild this ed69e
		for(var/turf/T in E.connectin69_turfs)
			SSair.mark_for_update(T)

/zone/proc/c_invalidate()
	invalid = TRUE
	SSair.remove_zone(src)
	SEND_SI69NAL(src, COMSI69_ZAS_DELETE, TRUE)
	#ifdef ZASDB69
	for(var/turf/simulated/T in contents)
		T.db69(invalid_zone)
	#endif

/zone/proc/rebuild()
	if(invalid) return //Short circuit for explosions where rebuild is called69any times over.
	c_invalidate()
	for(var/turf/simulated/T in contents)
		T.update_69raphic(69raphic_remove = air.69raphic) //we need to remove the overlays so they're not doubled when the zone is rebuilt
		//T.db69(invalid_zone)
		T.needs_air_update = 0 //Reset the69arker so that it will be added to the list.
		SSair.mark_for_update(T)

/zone/proc/add_tile_air(datum/69as_mixture/tile_air)
	//air.volume += CELL_VOLUME
	air.69roup_multiplier = 1
	air.multiply(contents.len)
	air.mer69e(tile_air)
	air.divide(contents.len+1)
	air.69roup_multiplier = contents.len+1

/zone/proc/tick()
	if(air.temperature >= PLASMA_FLASHPOINT && !(src in SSair.active_fire_zones) && air.check_combustability() && contents.len)
		var/turf/T = pick(contents)
		if(istype(T))
			T.create_fire(vsc.fire_firelevel_multiplier)

	if(air.check_tile_69raphic(69raphic_add, 69raphic_remove))
		for(var/turf/simulated/T in contents)
			T.update_69raphic(69raphic_add, 69raphic_remove)
		69raphic_add.len = 0
		69raphic_remove.len = 0

	for(var/connection_ed69e/E in ed69es)
		if(E.sleepin69)
			E.recheck()

	SEND_SI69NAL(src, COMSI69_ZAS_TICK, src)

/zone/proc/db69_data(mob/M)
	to_chat(M, name)
	for(var/69 in air.69as)
		to_chat(M, "6969as_data.name669696969: 69air.69a69699696969")
	to_chat(M, "P: 69air.return_pressure(6969 kPa69: 69air.volu69e69L T: 69air.temperat69re69�K (69air.temperature -69T0C69�C)")
	to_chat(M, "O2 per N2: 69(air.69as69"nitro69e69"69 ? air.69as69"oxy6969n"69/air.69as69"nitro69en"69 : "N69A")6969oles: 69air.total_69oles69")
	to_chat(M, "Simulated: 69contents.le6969 (69air.69roup_multipli69r69)")
	//M << "Unsimulated: 69unsimulated_contents.le6969"
	//M << "Ed69es: 69ed69es.le6969"
	if(invalid) to_chat(M, "Invalid!")
	var/zone_ed69es = 0
	var/space_ed69es = 0
	var/space_coefficient = 0
	for(var/connection_ed69e/E in ed69es)
		if(E.type == /connection_ed69e/zone) zone_ed69es++
		else
			space_ed69es++
			space_coefficient += E.coefficient
			to_chat(M, "69E:air:return_pressure(6969kPa")

	to_chat(M, "Zone Ed69es: 69zone_ed69e6969")
	to_chat(M, "Space Ed69es: 69space_ed69e6969 (69space_coefficie69t69 connections)")

	//for(var/turf/T in unsimulated_contents)
	//	M << "696969 at (69T69x69,6969.y69)"
