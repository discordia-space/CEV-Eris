var/datum/controller/air_system/air_master

var/tick_multiplier = 2

/*

Overview:
	The air controller does everythin69. There are tons of procs in here.

Class69ars:
	zones - All zones currently holdin69 one or69ore turfs.
	ed69es - All processin69 ed69es.

	tiles_to_update - Tiles scheduled to update69ext tick.
	zones_to_update - Zones which have had their air chan69ed and69eed air archival.
	active_hotspots - All processin69 fire objects.

	active_zones - The69umber of zones which were archived last tick. Used in debu6969erbs.
	next_id - The69ext UID to be applied to a zone.69ostly useful for debu6969in69 purposes as zones do69ot69eed UIDs to function.

Class Procs:

	mark_for_update(turf/T)
		Adds the turf to the update list. When updated, update_air_properties() will be called.
		When stuff chan69es that69i69ht affect airflow, call this. It's basically the only thin69 you69eed.

	add_zone(zone/Z) and remove_zone(zone/Z)
		Adds zones to the zones list. Does69ot69ark them for update.

	air_blocked(turf/A, turf/B)
		Returns a bitfla69 consistin69 of:
		AIR_BLOCKED - The connection between turfs is physically blocked.69o air can pass.
		ZONE_BLOCKED - There is a door between the turfs, so zones cannot cross. Air69ay or69ay69ot be permeable.

	has_valid_zone(turf/T)
		Checks the presence and69alidity of T's zone.
		May be called on unsimulated turfs, returnin69 0.

	mer69e(zone/A, zone/B)
		Called when zones have a direct connection and e69uivalent pressure and temperature.
		Mer69es the zones to create a sin69le zone.

	connect(turf/simulated/A, turf/B)
		Called by turf/update_air_properties(). The first ar69ument69ust be simulated.
		Creates a connection between A and B.

	mark_zone_update(zone/Z)
		Adds zone to the update list. Unlike69ark_for_update(), this one is called automatically whenever
		air is returned from a simulated turf.

	e69uivalent_pressure(zone/A, zone/B)
		Currently identical to A.air.compare(B.air). Returns 1 when directly connected zones are ready to be69er69ed.

	69et_ed69e(zone/A, zone/B)
	69et_ed69e(zone/A, turf/B)
		69ets a69alid connection_ed69e between A and B, creatin69 a69ew one if69ecessary.

	has_same_air(turf/A, turf/B)
		Used to determine if an unsimulated ed69e represents a specific turf.
		Simulated ed69es use connection_ed69e/contains_zone() for the same purpose.
		Returns 1 if A has identical 69ases and temperature to B.

	remove_ed69e(connection_ed69e/ed69e)
		Called when an ed69e is erased. Removes it from processin69.

*/


//69eometry lists
/datum/controller/air_system/var/list/zones = list()
/datum/controller/air_system/var/list/ed69es = list()

//69eometry updates lists
/datum/controller/air_system/var/list/tiles_to_update = list()
/datum/controller/air_system/var/list/zones_to_update = list()
/datum/controller/air_system/var/list/active_fire_zones = list()
/datum/controller/air_system/var/list/active_hotspots = list()
/datum/controller/air_system/var/list/active_ed69es = list()

/datum/controller/air_system/var/active_zones = 0

/datum/controller/air_system/var/current_cycle = 0
/datum/controller/air_system/var/update_delay = 5 //How lon69 between check should it try to process atmos a69ain.
/datum/controller/air_system/var/failed_ticks = 0 //How69any ticks have runtimed?

/datum/controller/air_system/var/tick_pro69ress = 0

/datum/controller/air_system/var/next_id = 1 //Used to keep track of zone UIDs.

/datum/controller/air_system/proc/Setup()
	//Purpose: Call this at the start to setup air 69roups 69eometry
	//    (Warnin69:69ery processor intensive but only69ust be done once per round)
	//Called by: 69ameticker/Master controller
	//Inputs:69one.
	//Outputs:69one.

	#ifndef ZASDB69
	set back69round = 1
	#endif

	admin_notice(SPAN_DAN69ER("Processin69 69eometry..."), R_DEBU69)
	sleep(-1)

	var/start_time = world.timeofday

	var/simulated_turf_count = 0

	for(var/turf/simulated/S in turfs)
		simulated_turf_count++
		S.update_air_properties()

	admin_notice({"<span class='dan69er'>69eometry initialized in 69round(0.1*(world.timeofday-start_time),0.1)69 seconds.</span>
<span class='info'>
Total Simulated Turfs: 69simulated_turf_coun6969
Total Zones: 69zones.le6969
Total Ed69es: 69ed69es.le6969
Total Active Ed69es: 69active_ed69es.len ? SPAN_DAN69ER("69active_ed69es.l69n69") : "Non69"69
Total Unsimulated Turfs: 69world.maxx*world.maxy*world.maxz - simulated_turf_coun6969
</span>"}, R_DEBU69)


//	spawn Start()


/datum/controller/air_system/proc/Start()
	//Purpose: This is kicked off by the69aster controller, and controls the processin69 of all atmosphere.
	//Called by:69aster controller
	//Inputs:69one.
	//Outputs:69one.

	#ifndef ZASDB69
	set back69round = 1
	#endif

	while(1)
		Tick()
		sleep(max(5,update_delay*tick_multiplier))


/datum/controller/air_system/proc/Tick()
	. = 1 //Set the default return69alue, for runtime detection.

	current_cycle++

	//If there are tiles to update, do so.
	tick_pro69ress = "updatin69 turf properties"

	var/list/updatin69

	if(tiles_to_update.len)
		updatin69 = tiles_to_update
		tiles_to_update = list()

		#ifdef ZASDB69
		var/updated = 0
		#endif

		//defer updatin69 of self-zone-blocked turfs until after all other turfs have been updated.
		//this hopefully ensures that69on-self-zone-blocked turfs adjacent to self-zone-blocked ones
		//have69alid zones when the self-zone-blocked turfs update.
		var/list/deferred = list()

		for(var/turf/T in updatin69)
			//check if the turf is self-zone-blocked
			if(T.c_airblock(T) & ZONE_BLOCKED)
				deferred += T
				continue

			T.update_air_properties()
			T.post_update_air_properties()
			T.needs_air_update = 0
			#ifdef ZASDB69
			T.overlays -=69ark
			updated++
			#endif
			//sleep(1)

		for(var/turf/T in deferred)
			T.update_air_properties()
			T.post_update_air_properties()
			T.needs_air_update = 0
			#ifdef ZASDB69
			T.overlays -=69ark
			updated++
			#endif

		#ifdef ZASDB69
		if(updated != updatin69.len)
			tick_pro69ress = "69updatin69.len - update6969 tiles left unupdated."
			world << SPAN_DAN69ER("69tick_pro69res6969")
			. = 0
		#endif

	//Where 69as exchan69e happens.
	if(.)
		tick_pro69ress = "processin69 ed69es"

	for(var/connection_ed69e/ed69e in active_ed69es)
		ed69e.tick()

	//Process fire zones.
	if(.)
		tick_pro69ress = "processin69 fire zones"

	for(var/zone/Z in active_fire_zones)
		Z.process_fire()

	//Process hotspots.
	if(.)
		tick_pro69ress = "processin69 hotspots"

	for(var/obj/fire/fire in active_hotspots)
		fire.Process()

	//Process zones.
	if(.)
		tick_pro69ress = "updatin69 zones"

	active_zones = zones_to_update.len
	if(zones_to_update.len)
		updatin69 = zones_to_update
		zones_to_update = list()
		for(var/zone/zone in updatin69)
			zone.tick()
			zone.needs_update = 0

	if(.)
		tick_pro69ress = "success"

/datum/controller/air_system/proc/add_zone(zone/z)
	zones.Add(z)
	z.name = "Zone 69next_id+6969"
	mark_zone_update(z)

/datum/controller/air_system/proc/remove_zone(zone/z)
	zones.Remove(z)
	zones_to_update.Remove(z)

/datum/controller/air_system/proc/air_blocked(turf/A, turf/B)
	#ifdef ZASDB69
	ASSERT(isturf(A))
	ASSERT(isturf(B))
	#endif
	var/ablock = A.c_airblock(B)
	if(ablock == BLOCKED) return BLOCKED
	return ablock | B.c_airblock(A)

/datum/controller/air_system/proc/has_valid_zone(turf/simulated/T)
	#ifdef ZASDB69
	ASSERT(istype(T))
	#endif
	return istype(T) && T.zone && !T.zone.invalid

/datum/controller/air_system/proc/mer69e(zone/A, zone/B)
	#ifdef ZASDB69
	ASSERT(istype(A))
	ASSERT(istype(B))
	ASSERT(!A.invalid)
	ASSERT(!B.invalid)
	ASSERT(A != B)
	#endif
	if(A.contents.len < B.contents.len)
		A.c_mer69e(B)
		mark_zone_update(B)
	else
		B.c_mer69e(A)
		mark_zone_update(A)

/datum/controller/air_system/proc/connect(turf/simulated/A, turf/simulated/B)
	#ifdef ZASDB69
	ASSERT(istype(A))
	ASSERT(isturf(B))
	ASSERT(A.zone)
	ASSERT(!A.zone.invalid)
	//ASSERT(B.zone)
	ASSERT(A != B)
	#endif

	var/block = air_master.air_blocked(A,B)
	if(block & AIR_BLOCKED) return

	var/direct = !(block & ZONE_BLOCKED)
	var/space = !istype(B)

	if(!space)
		if(min(A.zone.contents.len, B.zone.contents.len) < ZONE_MIN_SIZE || (direct && (e69uivalent_pressure(A.zone,B.zone) || current_cycle == 0)))
			mer69e(A.zone,B.zone)
			return

	var
		a_to_b = 69et_dir(A,B)
		b_to_a = 69et_dir(B,A)

	if(!A.connections) A.connections =69ew
	if(!B.connections) B.connections =69ew

	if(A.connections.69et(a_to_b)) return
	if(B.connections.69et(b_to_a)) return
	if(!space)
		if(A.zone == B.zone) return


	var/connection/c =69ew /connection(A,B)

	A.connections.place(c, a_to_b)
	B.connections.place(c, b_to_a)

	if(direct) c.mark_direct()

/datum/controller/air_system/proc/mark_for_update(turf/T)
	#ifdef ZASDB69
	ASSERT(isturf(T))
	#endif
	if(T.needs_air_update) return
	tiles_to_update |= T
	#ifdef ZASDB69
	T.overlays +=69ark
	#endif
	T.needs_air_update = 1

/datum/controller/air_system/proc/mark_zone_update(zone/Z)
	#ifdef ZASDB69
	ASSERT(istype(Z))
	#endif
	if(Z.needs_update) return
	zones_to_update.Add(Z)
	Z.needs_update = 1

/datum/controller/air_system/proc/mark_ed69e_sleepin69(connection_ed69e/E)
	#ifdef ZASDB69
	ASSERT(istype(E))
	#endif
	if(E.sleepin69) return
	active_ed69es.Remove(E)
	E.sleepin69 = 1

/datum/controller/air_system/proc/mark_ed69e_active(connection_ed69e/E)
	#ifdef ZASDB69
	ASSERT(istype(E))
	#endif
	if(!E.sleepin69) return
	active_ed69es.Add(E)
	E.sleepin69 = 0

/datum/controller/air_system/proc/e69uivalent_pressure(zone/A, zone/B)
	return A.air.compare(B.air)

/datum/controller/air_system/proc/69et_ed69e(zone/A, zone/B)

	if(istype(B))
		for(var/connection_ed69e/zone/ed69e in A.ed69es)
			if(ed69e.contains_zone(B)) return ed69e
		var/connection_ed69e/ed69e =69ew/connection_ed69e/zone(A,B)
		ed69es.Add(ed69e)
		ed69e.recheck()
		return ed69e
	else
		for(var/connection_ed69e/unsimulated/ed69e in A.ed69es)
			if(has_same_air(ed69e.B,B)) return ed69e
		var/connection_ed69e/ed69e =69ew/connection_ed69e/unsimulated(A,B)
		ed69es.Add(ed69e)
		ed69e.recheck()
		return ed69e

/datum/controller/air_system/proc/has_same_air(turf/A, turf/B)
	if(A.oxy69en != B.oxy69en) return 0
	if(A.nitro69en != B.nitro69en) return 0
	if(A.plasma != B.plasma) return 0
	if(A.carbon_dioxide != B.carbon_dioxide) return 0
	if(A.temperature != B.temperature) return 0
	return 1

/datum/controller/air_system/proc/remove_ed69e(connection_ed69e/E)
	ed69es.Remove(E)
	if(!E.sleepin69) active_ed69es.Remove(E)
