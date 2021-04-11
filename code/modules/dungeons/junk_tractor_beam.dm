#define BEAM_IDLE        0
#define BEAM_CAPTURING   1
#define BEAM_STABILIZED  2
#define BEAM_COOLDOWN    3

#define JTB_EDGE 2
#define JTB_MAXX 100
#define JTB_MAXY 100

//////////////////////////////
// Junk Field datum
//////////////////////////////
/datum/junk_field
	var/name // name of the junk field
	var/asteroid_belt_status // if it has an asteroid belt
	var/affinity // affinity of the junk field

/datum/junk_field/New(var/ID)
	name = "Junk Field #[ID]"
	asteroid_belt_status = has_asteroid_belt()
	affinity = get_random_affinity()

/datum/junk_field/proc/has_asteroid_belt()
	if(prob(90))
		return TRUE
	return FALSE

/datum/junk_field/proc/get_random_affinity()
	return pickweight(list(
					"Neutral" = 10,
					"OneStar" = 3,
					"IronHammer" = 3,
					"Serbian" = 3
					))

//////////////////////////////
// Generator used for the junk tractor beam level
//////////////////////////////
/obj/jtb_generator
	name = "junk tractor beam generator"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	alpha = 120
	anchored = TRUE
	unacidable = 1
	simulated = FALSE
	invisibility = 101
	var/delay = 2

	var/max_trials = 3 // Maximum number of trials to build the map
	var/maxx = JTB_MAXX // hardcoded width of junk_tractor_beam.dmm
	var/maxy = JTB_MAXY // hardcoded height of junk_tractor_beam.dmm
	var/margin = 9 // margin at the edge of the map
	var/numR = 0 // number of rows (of 5 by 5 cells)
	var/numC = 0 // number of cols (of 5 by 5 cells)
	var/list/edges // edges turf of the area
	var/map // map with 0s (free 5 by 5 cells) and 1s (occupied 5 by 5 cells)
	var/grid // grid of 5 by 5 empty cells available in the map (margin excluded)
	/* Value at position [i][j] is the size of the biggest empty square with [i][j] at its bottom right corner
	For instance with empty/occupied cells placed like that on the map:
	0  1  1  0  1
	1  1  0  1  0
	0  1  1  1  0
	1  1  1  1  0
	1  1  1  1  1
	0  0  0  0  0
	The resulting occupancy grid would be
	0  1  1  0  1
	1  1  0  1  0
	0  1  1  1  0
	1  1  2  2  0
	1  2  2  3  1
	0  0  0  0  0
	*/

	var/number_asteroids = 6 // Number of asteroids if the junk field has the asteroid belt property
	var/number_25_25 = 3 // Max number of 25 by 25 junk chunks
	var/number_5_5 = 15 // Max number of 5 by 5 junk chunks

	var/list/pool_25_25 = list() // Pool of 25 by 25 junk chunks
	var/list/pool_5_5 = list()  // Pool of 5 by 5 junk chunks

	var/obj/effect/portal/jtb/jtb_portal   // junk field side portal
	var/obj/effect/portal/jtb/ship_portal  // ship side portal
	var/beam_state = BEAM_STABILIZED  // state of the junk tractor beam
	var/datum/junk_field/current_jf  // the current chosen junk field
	var/jf_counter = 1  // counting junk fields to give them a unique number

	var/nb_in_pool = 3  // Number of junk fields in the pool
	var/list/jf_pool = list()  // Pool of junk fields you can choose from

	var/beam_cooldown_time = 10 SECONDS 
	var/beam_capture_time = 10 SECONDS


/obj/jtb_generator/New()
	current_jf = new /datum/junk_field(jf_counter)
	jf_counter++
	generate_junk_field_pool()
	return

/obj/jtb_generator/proc/generate_junk_field_pool()
	if(nb_in_pool > 0)
		for(var/i in 1 to nb_in_pool)
			jf_pool += new /datum/junk_field(jf_counter)
			jf_counter++
	return

/obj/jtb_generator/proc/field_capture(var/turf/T)
	beam_state = BEAM_CAPTURING
	spawn(beam_capture_time)
		if(src && beam_state == BEAM_CAPTURING)  // Check if jtb_generator has not been destroyed during spawn time and if capture has not been cancelled
			beam_state = BEAM_STABILIZED

			generate_junk_field()  // Generate the junk field

			jf_pool -= current_jf  // Remove generated junk field from pool
			jf_pool += new /datum/junk_field(jf_counter)  // Add a new entry to the pool
			jf_counter++

			create_link_portal(T)
	return

/obj/jtb_generator/proc/create_link_portal(var/turf/T)
	ship_portal = new /obj/effect/portal/jtb(T)  // Spawn portal on ship
	ship_portal.set_target(get_turf(jtb_portal))  // Link the two portals
	jtb_portal.set_target(get_turf(ship_portal))

/obj/jtb_generator/proc/field_cancel()
	if(beam_state == BEAM_CAPTURING)
		beam_state = BEAM_IDLE
	return

/obj/jtb_generator/proc/field_release()

	// TODO TRIGGER CLEANUP
	cleanup_junk_field()
	// TODO CHECK IF HUMAN IN FIELD
	// TODO what to do with corpses?
	qdel(ship_portal)
	beam_state = BEAM_COOLDOWN
	spawn(beam_cooldown_time)
		if(src)  // Check if jtb_generator has not been destroyed during spawn time
			beam_state = BEAM_IDLE
			if(jf_pool.len)
				current_jf = jf_pool[1]  // Select the first available junk field by default
	return

/obj/jtb_generator/proc/get_possible_fields()
	var/list/res = list()
	for(var/datum/junk_field/JF in jf_pool)
		res["[JF.asteroid_belt_status ? "Asteroid Belt - " : ""][JF.affinity] [JF.name]"] = JF
	return res

/obj/jtb_generator/proc/set_field(var/datum/junk_field/JF)
	current_jf = JF
	return

/obj/jtb_generator/proc/cleanup_junk_field()

	testing("Starting junk field cleanup.")
	for(var/i = 1 to maxx)
		for(var/j = 1 to maxy)
			var/turf/T = get_turf(locate(i, j, z))
			for(var/obj/O in T)
				if(!(istype(O, /obj/jtb_generator) || istype(O, /obj/map_data/junk_tractor_beam)))  // JTB related stuff
					qdel(O)
			for(var/mob/M in T)
				if(!ishuman(M))  // Delete all non human mobs
					M.death()  // First we kill them
					qdel(M)
				else  // Humans just win an express ticket to deep space
					go_to_bluespace(M.loc, 0, FALSE, M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)
			if(!T.is_space())
				T.ChangeTurf(/turf/space)

	// Second pass to delete glass shards and stuff like that which is created depending on the qdel order (low wall before window for instance)
	for(var/i = 1 to maxx)
		for(var/j = 1 to maxy)
			var/turf/T = get_turf(locate(i, j, z))
			for(var/obj/O in T)
				if(!(istype(O, /obj/jtb_generator) || istype(O, /obj/map_data/junk_tractor_beam)))  // JTB related stuff
					qdel(O)
	// All mobs and turfs have already been handled so no need to deal with that during second pass

	testing("Junk field cleanup is over.")

/obj/jtb_generator/proc/generate_junk_field()
	testing("Generating Asteroid Belt: [current_jf.asteroid_belt_status] - Affinity: [current_jf.affinity]")

	numR = round((maxx - margin) / 5)
	numC = round((maxy - margin) / 5)
	map = new/list(numR,numC,0)
	grid = new/list(numR,numC,0)

	// Get pool of 25 by 25 junk chunks
	for(var/T in subtypesof(/datum/map_template/junk/j25_25))
		var/datum/map_template/junk/j25_25/junk_tmpl = T
		pool_25_25 += new junk_tmpl

	// Get pool of 5 by 5 junk chunks
	for(var/T in subtypesof(/datum/map_template/junk/j5_5))
		var/datum/map_template/junk/j5_5/junk_tmpl = T
		pool_5_5 += new junk_tmpl

	// Populate z level with asteroids and junk chunks
	var/trial = 0
	while(!populate_z_level() && trial < max_trials)  // Try building until a map complete
		trial++
		testing("Junk Field build failed at zlevel [loc.z]. Trying again.")
	if(trial==max_trials)
		emergency_stop()

/obj/jtb_generator/proc/emergency_stop()
	admin_notice("Something really wrong happened, junk field generation failed several times in a row")
	log_world("Something really wrong happened, junk field generation failed several times in a row")
	qdel(src)

/obj/jtb_generator/proc/populate_z_level()
	
	testing("Junk Field build starting at zlevel [loc.z].")
	if(current_jf.asteroid_belt_status)  // Generate asteroids only if the junk field has an asteroid belt
		generate_asteroids()
	compute_occupancy_map()
	compute_occupancy_grid()
	place_25_25_chunks()
	if(!place_portal())
		return FALSE // Not being able to place portal, rebuilding map
	place_5_5_chunks()
	tame_mobs()
	generate_edge()
	testing("Junk Field build complete at zlevel [loc.z].")
	return TRUE

/obj/jtb_generator/proc/generate_asteroids()
	for(var/i = 1 to number_asteroids)
		var/valid = FALSE
		var/turf/T
		while(!valid)
			T = get_turf(locate(rand(margin, maxx - margin), rand(margin, maxy - margin), loc.z))
			if(istype(T,/turf/space)) // Avoid spawning new asteroid on top of an existing asteroid
				valid = TRUE
		var/obj/asteroid_spawner/SP = new(T)
		var/datum/rogue/asteroid/AS = generate_asteroid()
		place_asteroid(AS,SP)
		if(delay)
			sleep(delay)
	
	//newmob.faction = "asteroid_belt" //so they won't just kill each other

// Check if the turfs associated with cell (x,y) are empty
/obj/jtb_generator/proc/check_occupancy(var/x, var/y)
	for(var/turf/T in block(locate(5 * x - 4, 5 * y - 4, loc.z), locate(5 * (x + 1) - 4, 5 * (y + 1) - 4, loc.z)))
		if(!istype(T,/turf/space))
			return 1
	return 0

// Compute matrix with 1 if cell is occupied, 0 otherwise 
/obj/jtb_generator/proc/compute_occupancy_map()
	//testing("[numR] and [numC]")
	for(var/i = 1 to numR)
		for(var/j = 1 to numC)
			//testing("[i] [j]")
			map[i][j] = check_occupancy(i, j)

// Compute occupancy grid
/obj/jtb_generator/proc/compute_occupancy_grid()
	//testing("Bis [numR] and [numC]")
	for(var/i = 1 to numR)
		for(var/j = 1 to numC)
			//testing("[i] [j]")
			if(map[i][j]==0)
				if(i==1 || j==1)
					grid[i][j] = 1
				else
					grid[i][j] = min(grid[i][j-1], min(grid[i-1][j], grid[i-1][j-1])) + 1
			else
				grid[i][j] = 0

/obj/jtb_generator/proc/get_corner_25_25()
	var/target_x = 0  // x coordinates in grid
	var/target_y = 0  // y coordinates in grid
	var/list/listX = list()
	var/list/listY = list()

	// Choose an empty spot for the 25 by 25 chunk
	for(var/i = 5 to numR)
		for(var/j = 5 to numC)
			if(grid[i][j]>=3) // We allow the chunk to be partially into an asteroid
				listX += i
				listY += j
	if(listX.len==0)
		return null  // No empty space available to place a 25 by 25 chunk
	else
		var/target = rand(1, listX.len)
		target_x = listX[target]
		target_y = listY[target]

	// Update the occupancy map
	for(var/i = (target_x-4) to target_x)
		for(var/j = (target_y-4) to target_y)
			map[i][j] = 1
	
	// Update the occupancy grid
	compute_occupancy_grid()

	// bottom left corner turf
	return get_turf(locate(5 * (target_x - 4) - 4, 5 * (target_y - 4) - 4, loc.z))

/obj/jtb_generator/proc/get_corner_5_5()
	var/target_x = 0  // x coordinates in grid
	var/target_y = 0  // y coordinates in grid
	var/list/listX = list()
	var/list/listY = list()

	// Choose an empty spot for the 5 by 5 chunk
	for(var/i = 1 to numR)
		for(var/j = 1 to numC)
			if(grid[i][j]>0)
				listX += i
				listY += j
	if(listX.len==0)
		return null  // No empty space available to place a 5 by 5 chunk
	else
		var/target = rand(1, listX.len)
		target_x = listX[target]
		target_y = listY[target]

	// Update the occupancy map
	map[target_x][target_y] = 1
	
	// Update the occupancy grid
	grid[target_x][target_y] = 0 
	// No need to do a compute_occupancy_grid() because we don't care about the exact values to place 5 by 5 chunks

	// bottom left corner turf
	return get_turf(locate(5 * target_x - 4, 5 * target_y - 4, loc.z))

// Place 25 by 25 junk chunks from the pool of available templates
/obj/jtb_generator/proc/place_25_25_chunks()
	for(var/i = 1 to number_25_25)
		// Pick a ruin
		var/datum/map_template/junk/j25_25/chunk = null
		if(pool_25_25?.len)
			chunk = pick(pool_25_25) // TODO AFFINITY PICK (5 different pools?)
		else
			log_world("Junk loader had no 25 by 25 chunks to pick from.")
			break

		var/turf/T = get_corner_25_25() // Location of the bottom left corner turf of a 25 by 25 free chunk
		if(!T)
			log_world("No empty space available to place a 25 by 25 chunk. There was [number_25_25-i+1] remaining chunks to place.")
			break

		var/Tx = T.x  // We do that for cleanup because T is going to be replaced during chunk load
		var/Ty = T.y

		log_world("Chunk \"[chunk.name]\" of size 25 by 25 placed at ([T.x], [T.y], [T.z])")
		load_chunk(T, chunk)  // Load chunk with random orientation for variety purpose

		// Cleanup mineral overlays in case chunk got partially merged with an asteroid 
		// This is intended by if(grid[i][j]>=3) in get_corner_25_25 since it can be hard finding a completely clear 25x25 area
		for(var/turf/TM in block(locate(Tx, Ty, z), locate(Tx + 24, Ty + 24, z)))
			for(var/obj/effect/mineral/M in TM)
				if(!istype(get_turf(M), /turf/simulated/mineral))
					qdel(M)
			for(var/obj/structure/lattice/L in TM)  // Fix lattice dir that is not rotated correctly by the loader
				//L.updateOverlays()
				L.dir = 2 // reverse_dir[L.dir]

	return

// Place the portal that leads to the ship
/obj/jtb_generator/proc/place_portal()
	var/turf/T = get_corner_5_5() // Location of the bottom left corner turf of a 5 by 5 free chunk
	if(!T)
		log_world("No empty space available to place a 5 by 5 chunk. Junk field portal cannot be placed.")
		return FALSE
	else
		T = get_turf(locate(T.x + 2, T.y + 2, T.z))  // Portal loading works with center tile
		var/obj/asteroid_spawner/portal/P = new(T)
		var/PPREFAB = /datum/rogue/asteroid/predef/portal
		var/PBUILD = new PPREFAB(null)
		place_asteroid(PBUILD, P)
		log_world("Junk field portal placed at ([T.x], [T.y], [T.z])")
		jtb_portal = locate(/obj/effect/portal/jtb) in T

	return TRUE

// Place 5 by 5 junk chunks from the pool of available templates
/obj/jtb_generator/proc/place_5_5_chunks()
	for(var/i = 1 to number_5_5)
		// Pick a ruin
		var/datum/map_template/junk/j5_5/chunk = null
		if(pool_5_5?.len)
			chunk = pick(pool_5_5) // TODO AFFINITY PICK (5 different pools?)
		else
			log_world("Junk loader had no 5 by 5 chunks to pick from.")
			break

		var/turf/T = get_corner_5_5() // Location of the bottom left corner turf of a 5 by 5 free chunk
		if(!T)
			log_world("No empty space available to place a 5 by 5 chunk. There was [number_5_5-i+1] remaining chunks to place.")
			break

		var/Tx = T.x  // We do that for cleanup because T is going to be replaced during chunk load
		var/Ty = T.y

		testing("Debug width [chunk.width]")
		log_world("Chunk \"[chunk.name]\" of size 5 by 5 placed at ([T.x], [T.y], [T.z])")
		load_chunk(T, chunk)  // Load chunk with random orientation for variety purpose

		// Fix lattice dir that is not rotated correctly by the loader
		for(var/turf/TM in block(locate(Tx, Ty, z), locate(Tx + 4, Ty + 4, z)))
			for(var/obj/structure/lattice/L in TM)
				//L.updateOverlays()
				L.dir = 2 // reverse_dir[L.dir]

	return

// Make all junk field mobs friends with one another
/obj/jtb_generator/proc/tame_mobs()
	for(var/mob/living/M in SSmobs.mob_living_by_zlevel[(get_turf(src)).z])
		M.faction = "junk_field"

// Generate the edge at the border of the map for wrapping effect
/obj/jtb_generator/proc/generate_edge()
	testing("Generating edges of junk field at zlevel [loc.z].")
	
	edges = list()
	edges += block(locate(1, 1, z), locate(1+JTB_EDGE, maxy, z))  // Left border
	edges |= block(locate(maxx-JTB_EDGE, 1, z),locate(maxx, maxy, z))  // Right border
	edges |= block(locate(1, 1, z), locate(maxx, 1+JTB_EDGE, z))  // Bottom border
	edges |= block(locate(1, maxy-JTB_EDGE, z),locate(maxx, maxy, z))  // Top border

	// Cleanup and spawn edge
	for(var/turf/T in edges)
		for(var/obj/O in T)
			if(!(istype(O, /obj/jtb_generator) || istype(O, /obj/map_data/junk_tractor_beam)))  // JTB related stuff
				qdel(O)
		for(var/mob/M in T)
			if(!ishuman(M))  // Delete all non human mobs
				M.death()  // First we kill them
				qdel(M)
			else  // Humans just win an express ticket to deep space
				go_to_bluespace(M.loc, 0, FALSE, M, locate(rand(5, world.maxx - 5), rand(5, world.maxy -5), 3), 0)
		if(T.x <= JTB_EDGE || T.y <= JTB_EDGE || T.x >= maxx-JTB_EDGE+1 || T.y >= maxy-JTB_EDGE+1)  // To let a 1-wide ribbon of clean space
			T.ChangeTurf(/turf/simulated/jtb_edge)

	// Second pass to delete glass shards and stuff like that which is created depending on the qdel order (low wall before window for instance)
	for(var/turf/T in edges)
		for(var/obj/O in T)
			if(!(istype(O, /obj/jtb_generator) || istype(O, /obj/map_data/junk_tractor_beam)))  // JTB related stuff
				qdel(O)

	testing("Edges generation complete.")
	
// Dummy object because place_asteroid needs an /obj/asteroid_spawner
/obj/asteroid_spawner/portal
	name = "portal spawn"
	icon = 'icons/mob/eye.dmi'
	icon_state = "default-eye"
	invisibility = 101
	anchored = TRUE

// Template of portal chunk
/datum/rogue/asteroid/predef/portal
	width = 5
	type_wall	= /turf/simulated/wall/r_wall
	type_under	= /turf/simulated/floor/asteroid

	New()
		..()  // The joy of not being able to use a for in the declaration
		for(var/i = 2 to 4)
			for(var/j = 2 to 4)
				spot_add(i,j,type_under)
				if(i==3 && j==3)
					spot_add(3,3,/obj/effect/portal/jtb)

/proc/load_chunk(turf/corner_turf, datum/map_template/template)
	if(!template)
		return FALSE
	var/ori = pick(cardinal)
	testing(ori)
	if(ori == WEST || ori == EAST)  
		// For west and east the x and y coordinates are switched by template.load so we need to switch them ourself to spawn at correct location
		corner_turf = get_turf(locate(corner_turf.y, corner_turf.x, corner_turf.z))
	template.load(corner_turf, centered=FALSE, orientation=ori)
	return TRUE

// Copy of /obj/asteroid_generator/proc/generate_asteroid
/obj/jtb_generator/proc/generate_asteroid(var/core_min = 2, var/core_max = 5)
	var/datum/rogue/asteroid/A = new(rand(core_min,core_max))

	for(var/x = 1; x <= A.coresize, x++)
		for(var/y = 1; y <= A.coresize, y++)
			A.spot_add(A.coresize+x, A.coresize+y, A.type_wall)


	var/max_armlen = A.coresize - 1 //Can tweak to change appearance.

	//Add the arms to the asteroid's map
	//Vertical arms
	for(var/x = A.coresize+1, x <= A.coresize*2, x++) //Start at leftmost side of core, work towards higher X.
		var/B_arm = rand(0,max_armlen)
		var/T_arm = rand(0,max_armlen)

		//Bottom arm
		for(var/y = A.coresize, y > A.coresize-B_arm, y--) //Start at bottom edge of the core, work towards lower Y.
			A.spot_add(x,y,A.type_wall)
		//Top arm
		for(var/y = (A.coresize*2)+1, y < ((A.coresize*2)+1)+T_arm, y++) //Start at top edge of the core, work towards higher Y.
			A.spot_add(x,y,A.type_wall)


	//Horizontal arms
	for(var/y = A.coresize+1, y <= A.coresize*2, y++) //Start at lower side of core, work towards higher Y.
		var/R_arm = rand(0,max_armlen)
		var/L_arm = rand(0,max_armlen)

		//Right arm
		for(var/x = (A.coresize*2)+1, x <= ((A.coresize*2)+1)+R_arm, x++) //Start at right edge of core, work towards higher X.
			A.spot_add(x,y,A.type_wall)
		//Left arm
		for(var/x = A.coresize, x > A.coresize-L_arm, x--) //Start at left edge of core, work towards lower X.
			A.spot_add(x,y,A.type_wall)

	return A

// Copy of /obj/asteroid_generator/proc/place_asteroid
/obj/jtb_generator/proc/place_asteroid(var/datum/rogue/asteroid/A,var/obj/asteroid_spawner/SP)
	ASSERT(SP && A)

	SP.myasteroid = A

	//Bottom-left corner of our bounding box
	var/BLx = SP.x - (A.width/2)
	var/BLy = SP.y - (A.width/2)


	for(var/Ix=1, Ix <= A.map.len, Ix++)
		var/list/curr_x = A.map[Ix]

		for(var/Iy=1, Iy <= curr_x.len, Iy++)
			var/list/curr_y = curr_x[Iy]

			var/world_x = BLx+Ix
			var/world_y = BLy+Iy
			var/world_z = SP.z

			var/spot = locate(world_x,world_y,world_z)

			for(var/T in curr_y)
				if(ispath(T,/turf)) //We're spawning a turf

					//Make sure we locate()'d a turf and not something else
					if(!isturf(spot))
						spot = get_turf(spot)
					var/turf/P = spot

					if(P.is_space())  // Only spawn on space turf to avoid mixing with junk chunks
						var/turf/newturf = P.ChangeTurf(T)
						if(newturf)//check here, because sometimes it runtimes and shits in the logs
							newturf.update_icon(1)

				else //Anything not a turf
					new T(spot)


//////////////////////////////
// Console to use junk tractor beam
//////////////////////////////

/obj/machinery/computer/jtb_console
	name = "junk tractor beam control console"
	icon_state = "computer"
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	light_color = COLOR_LIGHTING_CYAN_MACHINERY
	circuit = /obj/item/weapon/electronics/circuitboard/jtb
	var/obj/jtb_generator/jtb_gen  // jtb generator

/obj/machinery/computer/jtb_console/Initialize()
	. = ..()
	
	jtb_gen = locate(/obj/jtb_generator)  // Find junk field generator object
	if(!jtb_gen)
		admin_notice("Could not find junk tractor beam generator.")
		log_world("Could not find junk tractor beam generator.")
	else
		jtb_gen.create_link_portal(get_turf(locate(x+2, y, z)))

/obj/machinery/computer/jtb_console/attack_hand(mob/user)
	if(..())
		return
	if(!jtb_gen)
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		src.audible_message("<span class='warning'>The junk tractor beam console beeps: 'NOTICE: Critical error. No tractor beam detected.'</span>")
		return
	ui_interact(user)

/obj/machinery/computer/jtb_console/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS)
	if(!jtb_gen)
		playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
		src.audible_message("<span class='warning'>The junk tractor beam console beeps: 'NOTICE: Critical error. No tractor beam detected.'</span>")
		return
	
	var/data[0]
	data = list(
		"beam_state" = get_beam_state(),
		"asteroid_belt" = get_asteroid_belt_status(),
		"affinity" = get_junk_field_affinity(),
		"junk_field_name" = get_junk_field_name(),
		"can_capture" = can_capture(),
		"can_cancel" = can_cancel(),
		"can_release" = can_release()
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "jtb_console.tmpl", "Junk Tractor Beam Control", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/jtb_console/Topic(href, href_list, state)
	if(..())
		return 1

	if(href_list["capture"])
		field_capture()

	if(href_list["cancel"])
		field_cancel()

	if(href_list["release"])
		field_release()
	
	if(href_list["pick"])
		var/list/possible_fields = get_possible_fields()
		var/datum/junk_field/JF
		if(possible_fields.len)
			JF = input("Choose Junk Field", "Junk Field") as null|anything in possible_fields
		else
			playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
			src.audible_message("<span class='warning'>The junk tractor beam console beeps: 'NOTICE: No junk field in range.'</span>")
		possible_fields = get_possible_fields()
		if(CanInteract(usr,GLOB.default_state) && (JF in possible_fields))
			set_field(possible_fields[JF])
	
	updateUsrDialog()

/obj/machinery/computer/jtb_console/proc/get_beam_state()
	return jtb_gen.beam_state

/obj/machinery/computer/jtb_console/proc/get_asteroid_belt_status()
	return jtb_gen.current_jf ? jtb_gen.current_jf.asteroid_belt_status : FALSE

/obj/machinery/computer/jtb_console/proc/get_junk_field_affinity()
	return jtb_gen.current_jf ? jtb_gen.current_jf.affinity : "None"

/obj/machinery/computer/jtb_console/proc/get_junk_field_name()
	return jtb_gen.current_jf ? jtb_gen.current_jf.name : "None"

/obj/machinery/computer/jtb_console/proc/can_capture()
	return jtb_gen.beam_state == BEAM_IDLE

/obj/machinery/computer/jtb_console/proc/can_cancel()
	return jtb_gen.beam_state == BEAM_CAPTURING

/obj/machinery/computer/jtb_console/proc/can_release()
	return jtb_gen.beam_state == BEAM_STABILIZED

/obj/machinery/computer/jtb_console/proc/field_capture()
	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
	src.audible_message("<span class='warning'>The junk tractor beam console beeps: 'NOTICE: Starting capture of targeted junk field.'</span>")
	jtb_gen.field_capture(get_turf(locate(x+2, y, z))) 
	return

/obj/machinery/computer/jtb_console/proc/field_cancel()
	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
	src.audible_message("<span class='warning'>The junk tractor beam console beeps: 'NOTICE: Canceling capture of junk field.'</span>")
	jtb_gen.field_cancel()
	return

/obj/machinery/computer/jtb_console/proc/field_release()
	playsound(src.loc, 'sound/machines/twobeep.ogg', 50, 1)
	if(check_biosignature())
		src.audible_message("<span class='warning'>The junk tractor beam console beeps: 'NOTICE: Sentient signature detected in junk field. Release blocked by security protocols.'</span>")
	else
		src.audible_message("<span class='warning'>The junk tractor beam console beeps: 'NOTICE: Releasing captured junk field.'</span>")
		jtb_gen.field_release()
	return

/obj/machinery/computer/jtb_console/proc/check_biosignature()
	var/list/candidates = SSticker.minds.Copy()
	while(candidates.len)
		var/datum/mind/candidate_mind = candidates[1]
		candidates -= candidate_mind

		var/mob/M = candidate_mind.current
		if((ishuman(M) || issilicon(M)) && (M.stat != DEAD && M.z == jtb_gen.z))  // Check if there is an alive human/silicon in the junk field
			return TRUE
	return FALSE

/obj/machinery/computer/jtb_console/proc/get_possible_fields()
	return jtb_gen.get_possible_fields()

/obj/machinery/computer/jtb_console/proc/set_field(var/datum/junk_field/JF)
	jtb_gen.set_field(JF)
	return 

//////////////////////////////
// Wrapping at the edge of junk field
// Mainly a copy paste of /turf/simulated/planet_edge
//////////////////////////////

/turf/simulated/jtb_edge
	name = "junk field edge"
	desc = "A blue wall of energy that stabilizes the junk field."
	density = FALSE
	blocks_air = TRUE
	dynamic_lighting = FALSE
	icon = 'icons/obj/machines/shielding.dmi'
	icon_state = "shield_normal"
	var/list/victims

/turf/simulated/jtb_edge/proc/MineralSpread()
	return

/turf/simulated/jtb_edge/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/turf/simulated/jtb_edge/Exited(atom/movable/AM)
	. = ..()
	LAZYREMOVE(victims, weakref(AM))
	
/turf/simulated/jtb_edge/Entered(atom/movable/AM)
	..()
	LAZYADD(victims, weakref(AM))
	START_PROCESSING(SSobj, src)

/turf/simulated/jtb_edge/Process()
	. = ..()

	for(var/weakref/W in victims)
		var/atom/movable/AM = W.resolve()
		if (AM == null || get_turf(AM) != src )
			victims -= W
			continue

		var/new_x = AM.x
		var/new_y = AM.y
		if(x <= 1+JTB_EDGE)
			new_x = JTB_MAXX - JTB_EDGE - 1
		else if (x >= (JTB_MAXX - JTB_EDGE))
			new_x = JTB_EDGE + 2
		else if (y <= 1+JTB_EDGE)
			new_y = JTB_MAXY - JTB_EDGE - 1
		else if (y >= (JTB_MAXY - JTB_EDGE))
			new_y = JTB_EDGE + 2

		var/turf/T = get_turf(locate(new_x, new_y, AM.z))
		if(T && !T.density)
			AM.forceMove(T)
			if(isliving(AM))
				var/mob/living/L = AM
				if(L.pulling)
					var/atom/movable/AMP = L.pulling
					AMP.forceMove(T)
			victims -= W  // Victim has been teleported

	if(!LAZYLEN(victims))
		return PROCESS_KILL

#undef BEAM_IDLE
#undef BEAM_CAPTURING
#undef BEAM_STABILIZED
#undef JTB_EDGE
#undef JTB_MAXX
#undef JTB_MAXY
