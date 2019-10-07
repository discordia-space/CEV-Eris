//////////////////////////////
// The zonemaster object, spawned to track the zone and
// clean/populate the zone with asteroids and loot
//////////////////////////////

/datum/rogue/zonemaster
	//our area
	var/area/asteroid/rogue/myarea
	var/area/shuttle/belter/myshuttle

	//world.time
	var/prepared_at = 0

	//accepting shuttles
	var/ready = 0

	//completely empty
	var/clean = 1

	//scored or not
	var/scored = 0

	//for scoring
	var/list/mineral_rocks = list()
	var/list/spawned_mobs = list()
	var/original_mobs = 0

	//in-use spawns from the area
	var/obj/asteroid_spawner/list/rockspawns = list()
	var/obj/rogue_mobspawner/list/mobspawns = list()

/datum/rogue/zonemaster/New(var/area/A)
	ASSERT(A)
	myarea = A
	myshuttle = locate(myarea.shuttle_area)
	spawn(10) //This is called from controller New() and freaks out if this calls back too fast.
		rm_controller.mark_clean(src)

///////////////////////////////
///// Utility Procs ///////////
///////////////////////////////

/datum/rogue/zonemaster/proc/is_occupied()
	var/humans = 0
	for(var/mob/living/carbon/human/H in human_mob_list)
		if(H.stat >= DEAD) //Conditions for exclusion here, like if disconnected people start blocking it.
			continue
		var/area/A = get_area(H)
		if((A == myarea) || (A == myshuttle)) //The loc of a turf is the area it is in.
			humans++
	return humans

///////////////////////////////
///// Asteroid Generation /////
///////////////////////////////
/datum/rogue/zonemaster/proc/generate_asteroid(var/core_min = 2, var/core_max = 5)
	//Chance for a predefined structure instead, more common later
	if(prob(rm_controller.diffstep*4))
		rm_controller.dbg("ZM(ga): Fell into prefab asteroid chance.")
		var/prefab = pick(rm_controller.prefabs["tier[rm_controller.diffstep]"])
		rm_controller.dbg("ZM(ga): Picked [prefab] as the prefab.")
		var/prefabinst = new prefab(null)
		return prefabinst

	var/datum/rogue/asteroid/A = new(rand(core_min,core_max))
	rm_controller.dbg("ZM(ga): New asteroid with C:[A.coresize], TW:[A.type_wall].")

	//Add the core to the asteroid's map
	rm_controller.dbg("ZM(ga): Starting core generation for [A.coresize] size core..")
	for(var/x = 1; x <= A.coresize, x++)
		for(var/y = 1; y <= A.coresize, y++)
			rm_controller.dbg("ZM(ga): Doing core-relative [x],[y] at [A.coresize+x],[A.coresize+y], [A.type_wall].")
			A.spot_add(A.coresize+x, A.coresize+y, A.type_wall)

	var/max_armlen = A.coresize - 1 //Can tweak to change appearance.

	//Add the arms to the asteroid's map
	//Vertical arms
	for(var/x = A.coresize+1, x <= A.coresize*2, x++) //Start at leftmost side of core, work towards higher X.
		rm_controller.dbg("ZM(ga): Vert arms. My current column is x:[x].")
		var/B_arm = rand(0,max_armlen)
		var/T_arm = rand(0,max_armlen)
		rm_controller.dbg("ZM(ga): B/T. Going to make B:[B_arm], T:[T_arm] for x:[x].")

		//Bottom arm
		for(var/y = A.coresize, y > A.coresize-B_arm, y--) //Start at bottom edge of the core, work towards lower Y.
			A.spot_add(x,y,A.type_wall)
		//Top arm
		for(var/y = (A.coresize*2)+1, y < ((A.coresize*2)+1)+T_arm, y++) //Start at top edge of the core, work towards higher Y.
			A.spot_add(x,y,A.type_wall)


	//Horizontal arms
	for(var/y = A.coresize+1, y <= A.coresize*2, y++) //Start at lower side of core, work towards higher Y.
		rm_controller.dbg("ZM(ga): Horiz arms. My current row is y:[y].")
		var/R_arm = rand(0,max_armlen)
		var/L_arm = rand(0,max_armlen)
		rm_controller.dbg("ZM(ga): R/L. Going to make R:[R_arm], L:[L_arm] for y:[y].")

		//Right arm
		for(var/x = (A.coresize*2)+1, x <= ((A.coresize*2)+1)+R_arm, x++) //Start at right edge of core, work towards higher X.
			A.spot_add(x,y,A.type_wall)
		//Left arm
		for(var/x = A.coresize, x > A.coresize-L_arm, x--) //Start at left edge of core, work towards lower X.
			A.spot_add(x,y,A.type_wall)


	//Diagonals
	// hao do

	rm_controller.dbg("ZM(ga): Asteroid generation done.")
	return A

/datum/rogue/zonemaster/proc/place_asteroid(var/datum/rogue/asteroid/A,var/obj/asteroid_spawner/SP)
	ASSERT(SP && A)

	rm_controller.dbg("ZM(pa): Placing at point [SP.x],[SP.y],[SP.z].")
	SP.myasteroid = A

	//Bottom-left corner of our bounding box
	var/BLx = SP.x - (A.width/2)
	var/BLy = SP.y - (A.width/2)
	rm_controller.dbg("ZM(pa): BLx is [BLx], BLy is [BLy].")

	rm_controller.dbg("ZM(pa): The asteroid has [A.map.len] X-lists.")

	for(var/Ix=1, Ix <= A.map.len, Ix++)
		var/list/curr_x = A.map[Ix]
		rm_controller.dbg("ZM(pa): Now doing X:[Ix] which has [curr_x.len] Y-lists.")

		for(var/Iy=1, Iy <= curr_x.len, Iy++)
			var/list/curr_y = curr_x[Iy]
			rm_controller.dbg("ZM(pa): Now doing Y:[Iy] which has [curr_y.len] items.")

			var/world_x = BLx+Ix
			var/world_y = BLy+Iy
			var/world_z = SP.z

			var/spot = locate(world_x,world_y,world_z)

			for(var/T in curr_y)
				rm_controller.dbg("ZM(pa): Doing entry [T] in Y-list [Iy].")
				if(ispath(T,/turf)) //We're spawning a turf
					rm_controller.dbg("ZM(pa): Turf-generate mode.")

					//Make sure we locate()'d a turf and not something else
					if(!isturf(spot))
						spot = get_turf(spot)
					var/turf/P = spot

					rm_controller.dbg("ZM(pa): Replacing [P.type] with [T].")
					var/turf/newturf = P.ChangeTurf(T)
					switch(newturf.type)
						if(/turf/simulated/mineral)
							place_resources(newturf)

					newturf.update_icon(1)
				else //Anything not a turf
					rm_controller.dbg("ZM(pa): Creating [T].")
					new T(spot)


/datum/rogue/zonemaster/proc/place_resources(var/turf/simulated/mineral/M)
	#define XENOARCH_SPAWN_CHANCE 0.3
	#define DIGSITESIZE_LOWER 4
	#define DIGSITESIZE_UPPER 12
	#define ARTIFACTSPAWNNUM_LOWER 6
	#define ARTIFACTSPAWNNUM_UPPER 12 //Replace with difficulty-based ones.

	if(!M.mineral && prob(rm_controller.diffstep_nums[rm_controller.diffstep]/10)) //Difficulty translates directly into ore chance
		rm_controller.dbg("ZM(par): Adding mineral to [M.x],[M.y].")
		M.make_ore(rm_controller.diffstep >= 3 ? 1 : 0)
		mineral_rocks += M
		//If above difficulty threshold make rare ore instead (M.make_ore(1))
	//Increase with difficulty etc

	if(!M.density)
		return

	if(isnull(M.geologic_data))
		M.geologic_data = new /datum/geosample(M)

	if(!prob(XENOARCH_SPAWN_CHANCE))
		return

	var/farEnough = 1
	for(var/A in SSxenoarch.digsite_spawning_turfs)
		var/turf/T = A
		if(T in range(5, M))
			farEnough = 0
			break
	if(!farEnough)
		return

	SSxenoarch.digsite_spawning_turfs.Add(M)

	var/digsite = get_random_digsite_type()
	var/target_digsite_size = rand(DIGSITESIZE_LOWER, DIGSITESIZE_UPPER)

	var/list/processed_turfs = list()
	var/list/turfs_to_process = list(M)

	var/list/viable_adjacent_turfs = list()
	if(target_digsite_size > 1)
		for(var/turf/simulated/mineral/T in orange(2, M))
			if(!T.density)
				continue
			if(T.finds)
				continue
			if(T in processed_turfs)
				continue
			viable_adjacent_turfs.Add(T)

		target_digsite_size = min(target_digsite_size, viable_adjacent_turfs.len)

	for(var/i = 1 to target_digsite_size)
		turfs_to_process += pick_n_take(viable_adjacent_turfs)

	while(turfs_to_process.len)
		var/turf/simulated/mineral/archeo_turf = pop(turfs_to_process)
		rm_controller.dbg("ZM(par): Adding archeo find to [M.x],[M.y].")
		processed_turfs.Add(archeo_turf)
		if(isnull(archeo_turf.finds))
			archeo_turf.finds = list()
			if(prob(50))
				archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 190)))
			else if(prob(75))
				archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 90)))
				archeo_turf.finds.Add(new /datum/find(digsite, rand(110, 190)))
			else
				archeo_turf.finds.Add(new /datum/find(digsite, rand(10, 50)))
				archeo_turf.finds.Add(new /datum/find(digsite, rand(60, 140)))
				archeo_turf.finds.Add(new /datum/find(digsite, rand(150, 190)))

			//sometimes a find will be close enough to the surface to show
			var/datum/find/F = archeo_turf.finds[1]
			if(F.excavation_required <= F.view_range)
				archeo_turf.archaeo_overlay = "overlay_archaeo[rand(1,3)]"
				archeo_turf.update_icon()

		//have a chance for an artifact to spawn here, but not in animal or plant digsites
		if(isnull(M.artifact_find) && digsite != DIGSITE_GARDEN && digsite != DIGSITE_ANIMAL)
			SSxenoarch.artifact_spawning_turfs.Add(archeo_turf)

	//create artifact machinery
	var/num_artifacts_spawn = rand(ARTIFACTSPAWNNUM_LOWER, ARTIFACTSPAWNNUM_UPPER)
	while(SSxenoarch.artifact_spawning_turfs.len > num_artifacts_spawn)
		pick_n_take(SSxenoarch.artifact_spawning_turfs)

	var/list/artifacts_spawnturf_temp = SSxenoarch.artifact_spawning_turfs.Copy()
	while(artifacts_spawnturf_temp.len > 0)
		var/turf/simulated/mineral/artifact_turf = pop(artifacts_spawnturf_temp)
		artifact_turf.artifact_find = new()

	#undef XENOARCH_SPAWN_CHANCE
	#undef DIGSITESIZE_LOWER
	#undef DIGSITESIZE_UPPER
	#undef ARTIFACTSPAWNNUM_LOWER
	#undef ARTIFACTSPAWNNUM_UPPER //Replace with difficulty-based ones.

///////////////////////////////
///// Zone Population /////////
///////////////////////////////

//Overall 'prepare' proc (marks as ready)
/datum/rogue/zonemaster/proc/prepare_zone(var/delay = 0)
	rm_controller.unmark_clean(src)
	rm_controller.dbg("ZM(p): Preparing zone with difficulty level [rm_controller.diffstep].")


	rm_controller.dbg("ZM(p): Randomizing spawns.")
	randomize_spawns()
	rm_controller.dbg("ZM(p): [rockspawns.len] picked.")
	for(var/obj/asteroid_spawner/SP in rockspawns)
		rm_controller.dbg("ZM(p): Creating asteroid for [SP.x],[SP.y],[SP.z].")
		var/datum/rogue/asteroid/A = generate_asteroid()
		rm_controller.dbg("ZM(p): Placing asteroid.")
		place_asteroid(A,SP)
		if(delay)
			sleep(delay)

	for(var/obj/rogue_mobspawner/SP in mobspawns)
		rm_controller.dbg("ZM(p): Spawning mob at [SP.x],[SP.y],[SP.z].")
		//Make sure we can spawn a spacemob here
		if(!istype(get_turf(SP),/turf/space))
			rm_controller.dbg("ZM(p): Turf blocking mob spawn at [SP.x],[SP.y],[SP.z].")
			mobspawns -= SP
			for(var/obj/rogue_mobspawner/NS in myarea.mob_spawns)
				if(NS in mobspawns)
					continue
				if(istype(get_turf(NS),/turf/space))
					SP = NS
					break
		if(SP)
			rm_controller.dbg("ZM(p): Got a mob spawnpoint, so picking a type.")
			var/mobchoice = pick(rm_controller.mobs["tier[rm_controller.diffstep]"])
			rm_controller.dbg("ZM(p): Picked [mobchoice] to spawn.")
			var/mob/living/newmob = new mobchoice(get_turf(SP))
			newmob.faction = "asteroid_belt"
			spawned_mobs += newmob
			if(delay)
				sleep(delay)

	rm_controller.dbg("ZM(p): Zone generation done.")
	world.log << "RM(stats): PREP [myarea] at [world.time] with [spawned_mobs.len] mobs, [mineral_rocks.len] minrocks, total of [rockspawns.len] rockspawns, [mobspawns.len] mobspawns." //DEBUG code for playtest stats gathering.
	prepared_at = world.time
	rm_controller.mark_ready(src)
	return myarea

//Randomize the landmarks that are enabled
/datum/rogue/zonemaster/proc/randomize_spawns(var/chance = 50)
	rm_controller.dbg("ZM(rs): Previously [rockspawns.len] rockspawns.")
	rockspawns.Cut()
	rm_controller.dbg("ZM(rs): Now [rockspawns.len] rockspawns.")
	for(var/obj/asteroid_spawner/SP in myarea.asteroid_spawns)
		if(prob(chance))
			rockspawns += SP
	rm_controller.dbg("ZM(rs): Picked [rockspawns.len] new rockspawns with [chance]% chance.")

	rm_controller.dbg("ZM(rs): Previously [mobspawns.len] mobspawns.")
	mobspawns.Cut()
	rm_controller.dbg("ZM(rs): Now [mobspawns.len] mobspawns.")
	for(var/obj/rogue_mobspawner/SP in myarea.mob_spawns)
		if(prob(rm_controller.diffstep_nums[rm_controller.diffstep]/10))
			mobspawns += SP
			original_mobs++
	rm_controller.dbg("ZM(rs): Picked [mobspawns.len] new mobspawns with [chance]% chance.")
	return myarea

///////////////////////////////
///// Zone Cleaning ///////////
///////////////////////////////
/datum/rogue/zonemaster/proc/score_zone(var/bonus = 10)
	rm_controller.dbg("ZM(sz): Scoring zone with area [myarea].")
	scored = 1
	var/tally = bonus

	//Ore-bearing rocks that were mined
	for(var/turf/T in mineral_rocks)
		var/has_minerals = 0
		for(var/atom/I in T.contents)
			if(istype(I,/obj/effect/mineral))
				has_minerals++
				break
		if(has_minerals == 0)
			tally += RM_DIFF_VALUE_ORE

	mineral_rocks.Cut() //For good measure, to prevent rescoring.

	for(var/I = 1, I <= spawned_mobs.len, I++)
		if(isnull(spawned_mobs[I]))
			tally += RM_DIFF_VALUE_MOB //Mobs so annihilated they were deleted
			rm_controller.dbg("ZM(sz): Scoring one mob annihilated.")
		if(istype(spawned_mobs[I],/mob))
			var/mob/M = spawned_mobs[I]
			if(M.stat > 0) //Knocked out or dead or anything other than normal
				tally += RM_DIFF_VALUE_MOB
				rm_controller.dbg("ZM(sz): Scoring one mob dead.")

	spawned_mobs.Cut()
	original_mobs = 0

	rm_controller.adjust_difficulty(tally)
	rm_controller.dbg("ZM(sz): Finished scoring and adjusted by [tally].")
	world.log << "RM(stats): SCORE [myarea] for [tally]." //DEBUG code for playtest stats gathering.
	return tally

//Overall 'destroy' proc (marks as unready)
/datum/rogue/zonemaster/proc/clean_zone(var/delay = 1)
	rm_controller.dbg("ZM(cz): Cleaning zone with area [myarea].")
	world.log << "RM(stats): CLEAN start [myarea] at [world.time] prepared at [prepared_at]." //DEBUG code for playtest stats gathering.
	rm_controller.unmark_ready(src)

	//Cut these lists so qdel can dereference the things properly
	mineral_rocks.Cut()
	spawned_mobs.Cut()
	rockspawns.Cut()
	mobspawns.Cut()

	var/ignored = list(
	/obj/asteroid_spawner,
	/obj/rogue_mobspawner,
	/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/onleft,
	/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/onright,
	/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/ontop,
	/obj/effect/step_trigger/teleporter/random/rogue/fourbyfour/onbottom)

	for(var/atom/I in myarea.contents)
		if(I.type == /turf/space)
			I.overlays.Cut()
			continue
		else if(I.type in ignored)
			continue
		qdel(I)
		sleep(delay)

	//A deletion so nice that I give it twice
	for(var/atom/I in myarea.contents)
		if(I.type in ignored)
			continue
		qdel(I)
		sleep(delay)

	//Clean up vars
	scored = 0
	original_mobs = 0
	prepared_at = 0

	world.log << "RM(stats): CLEAN done [myarea] at [world.time]." //DEBUG code for playtest stats gathering.

	rm_controller.dbg("ZM(cz): Finished cleaning up zone area [myarea].")
	rm_controller.mark_clean(src)
	return myarea

///////////////////////////////
///// Mysterious Mystery //////
///////////////////////////////

//Throw a meteor at a player in the zone
