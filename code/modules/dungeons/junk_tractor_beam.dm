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

	var/maxx = 100 // hardcoded width of junk_tractor_beam.dmm
	var/maxy = 100 // hardcoded height of junk_tractor_beam.dmm
	var/margin = 9 // margin at the edge of the map
	var/numR = 0 // number of rows (of 3 by 3 cells)
	var/numC = 0 // number of cols (of 3 by 3 cells)
	var/map // map with 0s (free 3 by 3 cells) and 1s (occupied 3 by 3 cells)
	var/grid // grid of 3 by 3 empty cells available in the map (margin excluded)
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

	var/number_asteroids = 10 // Number of asteroids if the junk field has the asteroid belt property
	var/number_21_21 = 2 // Max number of 21 by 21 junk chunks
	var/number_3_3 = 15 // Max number of 3 by 3 junk chunks

	var/list/pool_21_21 = list() // Pool of 21 by 21 junk chunks
	var/list/pool_3_3 = list()  // Pool of 3 by 3 junk chunks


/obj/jtb_generator/New()

	numR = round((maxx - margin) / 3)
	numC = round((maxy - margin) / 3)
	map = new/list(numR,numC,0)
	grid = new/list(numR,numC,0)

	// Get pool of 21 by 21 junk chunks
	for(var/T in subtypesof(/datum/map_template/junk/j21_21))
		var/datum/map_template/junk/j21_21/junk_tmpl = T
		pool_21_21 += new junk_tmpl

	// Get pool of 3 by 3 junk chunks
	for(var/T in subtypesof(/datum/map_template/junk/j3_3))
		var/datum/map_template/junk/j3_3/junk_tmpl = T
		pool_3_3 += new junk_tmpl

	// Populate z level with asteroids and junk chunks
	populate_z_level()

/obj/jtb_generator/proc/populate_z_level()
	while(1)
		if(Master.current_runlevel)
			break
		else
			sleep(250)

	testing("Junk Field build starting at zlevel [loc.z].")
	generate_asteroids()
	compute_occupancy_map()
	compute_occupancy_grid()
	place_21_21_chunks()
	place_portal()
	place_3_3_chunks()
	testing("Junk Field build complete at zlevel [loc.z].")

/obj/jtb_generator/proc/generate_asteroids()
	for(var/i = 1 to number_asteroids)
		var/valid = FALSE
		var/turf/T
		while(!valid)
			T = locate(rand(margin, maxx - margin), rand(margin, maxy - margin), loc.z)
			if(istype(T,/turf/space)) // Avoid spawning new asteroid on top of an existing asteroid
				valid = TRUE
		var/obj/asteroid_spawner/SP = new(T)
		var/datum/rogue/asteroid/AS = generate_asteroid()
		place_asteroid(AS,SP)
		if(delay)
			sleep(delay)
	
	//newmob.faction = "asteroid_belt" //so they won't just kill each other
	
	//var/teleporter = pick(myarea.teleporter_spawns)
	//generate_teleporter(teleporter)

// Check if the turfs associated with cell (x,y) are empty
/obj/jtb_generator/proc/check_occupancy(var/x, var/y)
	for(var/turf/T in block(locate(3 * x, 3 * y, loc.z), locate(3 * (x + 1), 3 * (y + 1), loc.z)))
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

/obj/jtb_generator/proc/get_center_21_21()
	var/target_x = 0  // x coordinates in grid
	var/target_y = 0  // y coordinates in grid
	var/list/listX = list()
	var/list/listY = list()

	// Choose an empty spot for the 21 by 21 chunk
	for(var/i = 1 to numR)
		for(var/j = 1 to numC)
			if(grid[i][j]==7)
				listX += i
				listY += j
	if(listX.len==0)
		return null  // No empty space available to place a 21 by 21 chunk
	else
		var/target = rand(1, listX.len)
		target_x = listX[target]
		target_y = listY[target]

	// Update the occupancy map
	for(var/i = (target_x-7) to target_x)
		for(var/j = (target_y-7) to target_y)
			map[i][j] = 1
	
	// Update the occupancy grid
	compute_occupancy_grid()

	// - 4 to get the center cell of the 7 by 7 empty area then + 1 to get the central turf of the central 3 by 3 cell 
	return locate(3 * (target_x - 4) + 1, 3 * (target_y - 4) + 1, loc.z)

/obj/jtb_generator/proc/get_center_3_3()
	var/target_x = 0  // x coordinates in grid
	var/target_y = 0  // y coordinates in grid
	var/list/listX = list()
	var/list/listY = list()

	// Choose an empty spot for the 3 by 3 chunk
	for(var/i = 1 to numR)
		for(var/j = 1 to numC)
			if(grid[i][j]>0)
				listX += i
				listY += j
	if(listX.len==0)
		return null  // No empty space available to place a 3 by 3 chunk
	else
		var/target = rand(1, listX.len)
		target_x = listX[target]
		target_y = listY[target]

	// Update the occupancy map
	map[target_x][target_y] = 1
	
	// Update the occupancy grid
	grid[target_x][target_y] = 0 
	// No need to do a compute_occupancy_grid() because we don't care about the exact values to place 3 by 3 chunks

	// + 1 to get the central turf of the central 3 by 3 cell 
	return locate(3 * target_x + 1, 3 * target_y + 1, loc.z)

// Place 21 by 21 junk chunks from the pool of available templates
/obj/jtb_generator/proc/place_21_21_chunks()
	for(var/i = 1 to number_21_21)
		// Pick a ruin
		var/datum/map_template/junk/j21_21/chunk = null
		if(pool_21_21?.len)
			chunk = pick(pool_21_21) // TODO AFFINITY PICK (5 different pools?)
		else
			log_world("Junk loader had no 21 by 21 chunks to pick from.")
			break

		var/turf/T = get_center_21_21() // Location of the central turf of the 21 by 21 chunk
		if(!T)
			log_world("No empty space available to place a 21 by 21 chunk. There was [number_21_21-i+1] remaining chunks to place.")
			break

		log_world("Chunk \"[chunk.name]\" of size 21 by 21 placed at ([T.x], [T.y], [T.z])")
		load_ruin(T, chunk)  // Use ruin loader from planetary exploration

	return

// Place the portal that leads to the ship
/obj/jtb_generator/proc/place_portal()

	return

// Place 3 by 3 junk chunks from the pool of available templates
/obj/jtb_generator/proc/place_3_3_chunks()
	for(var/i = 1 to number_3_3)
		// Pick a ruin
		var/datum/map_template/junk/j3_3/chunk = null
		if(pool_3_3?.len)
			chunk = pick(pool_3_3) // TODO AFFINITY PICK (5 different pools?)
		else
			log_world("Junk loader had no 3 by 3 chunks to pick from.")
			break

		var/turf/T = get_center_3_3() // Location of the central turf of the 21 by 21 chunk
		if(!T)
			log_world("No empty space available to place a 3 by 3 chunk. There was [number_3_3-i+1] remaining chunks to place.")
			break

		testing("Debug width [chunk.width]")
		log_world("Chunk \"[chunk.name]\" of size 21 by 21 placed at ([T.x], [T.y], [T.z])")
		load_chunk(T, chunk)

	return

/obj/jtb_generator/proc/generate_teleporter(var/obj/asteroid_spawner/rogue_teleporter/TP)
	var/TPPREFAB = /datum/rogue/asteroid/predef/teleporter
	var/TPBUILD = new TPPREFAB(null)
	place_asteroid(TPBUILD, TP)

/proc/load_chunk(turf/central_turf, datum/map_template/template)
	if(!template)
		return FALSE
	template.load(central_turf,centered = TRUE)
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

					if(P)
						var/turf/newturf = P.ChangeTurf(T)
						if(newturf)//check here, because sometimes it runtimes and shits in the logs
							newturf.update_icon(1)

				else //Anything not a turf
					new T(spot)
