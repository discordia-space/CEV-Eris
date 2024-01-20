#define SEISMIC_MIN 1
#define SEISMIC_MAX 6
#define CAVE_SIZE 100  // Size of the square cave area
#define CAVE_MARGIN 5  // Margin near the edges of the cave
#define CAVE_CORRIDORS 10  // Number of corridors to guide cave generation
#define CAVE_WALL_PROPORTION 70 // Proportion of wall in random noise generation
#define CAVE_VWEIGHT 10 // Base mineral weight for choice of mineral vein
#define CAVE_COOLDOWN 5 MINUTES
#define CAVE_COLLAPSE 3 MINUTES

// Cave generator statuses
#define CAVE_CLOSED 0
#define CAVE_GENERATING 1
#define CAVE_OPENED 2
#define CAVE_COLLAPSING 3
#define CAVE_CLEANING 4

// Types of turfs in the cave
#define CAVE_FREE 0
#define CAVE_WALL 1
#define CAVE_POI 2
#define CAVE_CARBON 3
#define CAVE_IRON 4
#define CAVE_PLASMA 5
#define CAVE_URANIUM 6
#define CAVE_DIAMOND 7
#define CAVE_SILVER 8
#define CAVE_GOLD 9
#define CAVE_PLATINUM 10

//////////////////////////////
// Generator used to handle underground caves
//////////////////////////////
/obj/cave_generator
	name = "cave generator"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	alpha = 120
	anchored = TRUE
	unacidable = 1
	simulated = FALSE
	invisibility = 0 // 101

	var/status = CAVE_CLOSED  // Status of the cave generator
	var/cave_time = -CAVE_COOLDOWN  // Cooldown timer to avoid spamming cave generation
	var/cave_collapse_time = 0  // Time for cave collapse warning
	var/map // map with 0 (free turf) and 1+ (wall or mineral)
	var/obj/structure/multiz/ladder/cave_hole/ladder_down
	var/obj/structure/multiz/ladder/up/cave/ladder_up
	var/list/datum/map_template/cave_pois/pool_pois = list() // Pool of cave points of interest
	var/list/datum/map_template/cave_pois/pois_placed = list()
	var/list/pois_placed_pos = list()
	var/list/blacklist = list(/mob/observer,
							/obj/machinery/nuclearbomb,
							/obj/item/disk/nuclear)

/obj/cave_generator/Initialize()
	// Initialize and not New to ensure SSmapping.maploader has been created
	// before preloading the templates

	// Get pool of points of interest
	for(var/T in subtypesof(/datum/map_template/cave_pois))
		var/datum/map_template/cave_pois/cave_poi_tmpl = T
		pool_pois += new cave_poi_tmpl

/obj/cave_generator/proc/generate_map(seismic_lvl = 1)
	// Fill the map with random noise
	random_fill_map()

	// Place a few corridors to guide the generation
	generate_corridors()

	// Run the cellular automata to generate the cave system
	for(var/i = 1 to 3)
		run_cellular_automata()

	// Place the points of interest
	generate_pois(seismic_lvl)

	// Generate mineral veins from processed map
	generate_mineral_veins(seismic_lvl)

	// Place the walls, ores and free space
	place_turfs(seismic_lvl)

	// Place the points of interest
	place_pois()

	// Place the golems
	place_golems(seismic_lvl)

/obj/cave_generator/proc/random_fill_map()
	// New, empty map
	map = new/list(CAVE_SIZE, CAVE_SIZE)

	for(var/i = 1 to CAVE_SIZE)
		for(var/j = 1 to CAVE_SIZE)
			// Create a border on the edge of the map
			if(i == 1 || i == CAVE_SIZE || j == 1 || j == CAVE_SIZE)
				map[i][j] = CAVE_WALL
			else if(prob(CAVE_WALL_PROPORTION))
				map[i][j] = CAVE_WALL
			else
				map[i][j] = CAVE_FREE

// Draw a few straight lines in the initial random noise to guide the generation
/obj/cave_generator/proc/generate_corridors()

	// Draw a vertical corridor from (CAVE_MARGIN, CAVE_SIZE/2) to (CAVE_SIZE/2, CAVE_SIZE/2)
	// then recursively draw corridors that branches out from it
	draw_recursive_corridor(CAVE_MARGIN, CAVE_SIZE/2, CAVE_SIZE/2, CAVE_SIZE/2, CAVE_CORRIDORS/2)
	// Same from (CAVE_SIZE/2, CAVE_SIZE/2) to (CAVE_SIZE - CAVE_MARGIN, CAVE_SIZE/2)
	draw_recursive_corridor(CAVE_SIZE/2, CAVE_SIZE - CAVE_MARGIN, CAVE_SIZE/2, CAVE_SIZE/2, CAVE_CORRIDORS/2)

// Draw a straight line in the random noise, then call itself if necessary
/obj/cave_generator/proc/draw_recursive_corridor(x0, x1, y0, y1, N)

	// Draw a 2-wide corridor
	for(var/i = x0 to x1 + 1)
		for(var/j = y0 to y1 + 1)
			map[i][j] = CAVE_FREE

	// If this is the last corridor
	if(N == 0)
		return

	// Recursively draw another corridor in orthogonal direction
	var/x0_new
	var/x1_new
	var/y0_new
	var/y1_new
	if(x0 == x1)
		x0_new = rand(CAVE_MARGIN, x0)
		x1_new = rand(x0, CAVE_SIZE - CAVE_MARGIN)
		y0_new = rand(y0, y1)
		y1_new = y0_new
	else
		x0_new = rand(x0, x1)
		x1_new = x0_new
		y0_new = rand(CAVE_MARGIN, y0)
		y1_new = rand(y0, CAVE_SIZE - CAVE_MARGIN)
	draw_recursive_corridor(x0_new, x1_new, y0_new, y1_new, N - 1)

// Run one iteration of the cellular automata that processes the initial random noise
/obj/cave_generator/proc/run_cellular_automata()

	for(var/i = 2 to CAVE_SIZE - 1)
		for(var/j = 2 to CAVE_SIZE - 1)
			map[i][j] = place_wall_logic(i, j)

// Wall placement logic for the cellular automata
/obj/cave_generator/proc/place_wall_logic(x0, y0)

	var/num_walls = get_adjacent_walls(x0, y0, 1, 1)
	if(map[x0][y0] == CAVE_WALL)
		if(num_walls >= 4)
			return CAVE_WALL
		else if(num_walls < 2)
			return CAVE_FREE
	else if(num_walls >= 5)
		return CAVE_WALL

	return CAVE_FREE

// Get number of walls in a given range around the target tile
/obj/cave_generator/proc/get_adjacent_walls(x0, y0, scope_x, scope_y)
	var/num_walls = 0
	for(var/i = (x0 - scope_x) to (x0 + scope_x))
		for(var/j = (y0 - scope_y) to (y0 + scope_y))
			if(!(i == x0 && j == y0) && map[i][j] == CAVE_WALL)
				num_walls++
	return num_walls

// Place points of interest on the map
/obj/cave_generator/proc/generate_pois(seismic_lvl)

	// Reset pois lists
	pois_placed = list()
	pois_placed_pos = list()

	// Get pool of points of interest for current seismic level
	var/list/datum/map_template/cave_pois/pool = list()
	for(var/datum/map_template/cave_pois/cave_poi_tmpl in pool_pois)
		if(cave_poi_tmpl.min_seismic_lvl >= seismic_lvl)
			pool += cave_poi_tmpl.type
			pool[cave_poi_tmpl.type] = cave_poi_tmpl.spawn_prob

	// Place a few pois on the map
	var/N_pois = rand(2, 4)
	for(var/i = 1 to N_pois)
		var/poi_path = pickweight_n_take(pool)
		var/datum/map_template/cave_pois/poi = new poi_path()

		// Find a free spot for the poi
		// The free spot will be the middle of the poi
		var/list/res = list(FALSE, 0, 0)
		var/N_trials = 10
		while(!res[1] && N_trials > 0)
			N_trials--
			res = find_free_spot(rand(2, CAVE_SIZE - 2), rand(2, CAVE_SIZE - 2), round(poi.size_x / 2) + 1, round(poi.size_y / 2) + 1)
			if(res[1])
				res[1] = check_poi_overlap(res[2], res[3], poi.size_x, poi.size_y)

		if(!res[1])
			log_world("Failed to find a free spot in the cave to place [poi.name].")
			continue

		// Chunks are spawned from bottom left corner
		var/x_corner_bl = res[2] - round(poi.size_x / 2)
		var/y_corner_bl = res[3] - round(poi.size_x / 2)
		var/x_corner_tr = x_corner_bl + poi.size_x - 1
		var/y_corner_tr = y_corner_bl + poi.size_y - 1
		for(var/j = x_corner_bl to x_corner_tr)
			for(var/k = y_corner_bl to y_corner_tr)
				map[j][k] = CAVE_POI
		pois_placed += poi
		pois_placed_pos += list(list(x_corner_bl, y_corner_bl, x_corner_tr, y_corner_tr))

// Check if a potential poi does not overlap with already placed pois
/obj/cave_generator/proc/check_poi_overlap(x_bl, y_bl, size_x, size_y)
	if(!pois_placed.len)
		// No overlap since no poi has been placed yet
		return TRUE

	var/x_tr = x_bl + size_x
	var/y_tr = y_bl + size_y
	for(var/k = 1 to pois_placed.len)
		// If bottom left corner is on the right or above the top right corner of already placed poi, then it's clear
		// If top right corner is on the left or under the bottom left corner of already placed poi, then it's clear
		// Otherwise it means they overlap
		var/list/placed_pos = pois_placed_pos[k]

		if(!(x_bl > placed_pos[3] || y_bl > placed_pos[4] || x_tr < placed_pos[1] || y_tr < placed_pos[2]))
			return FALSE
	// No overlap
	return TRUE

// Generate mineral veins once cave layout has been decided
/obj/cave_generator/proc/generate_mineral_veins(seismic_lvl)
	var/x_vein = 0
	var/y_vein = 0
	var/N_veins = rand(15, 20 * (1 + 0.5 * (seismic_lvl - SEISMIC_MIN) / (SEISMIC_MAX - SEISMIC_MIN)))
	var/N_trials = 50
	while(N_veins > 0 && N_trials > 0)
		N_trials--
		x_vein = rand(CAVE_MARGIN, CAVE_SIZE - CAVE_MARGIN)
		y_vein = rand(CAVE_MARGIN, CAVE_SIZE - CAVE_MARGIN)
		N_veins -= place_mineral_vein(x_vein, y_vein, seismic_lvl)

// Find a free spot in the cave
/obj/cave_generator/proc/find_free_spot(x_start, y_start, x_margin = 0, y_margin = 0)

	var/x0 = x_start - 1
	var/x1 = x_start + 1
	var/y0 = y_start - 1
	var/y1 = y_start + 1
	var/found = FALSE
	var/edge = FALSE
	if(map[x_start][y_start] == CAVE_FREE)
		found = TRUE
	while(!found && !edge)
		found = TRUE
		if(map[x0][y_start] == CAVE_FREE)
			x_start = x0
		else if(map[x1][y_start] == CAVE_FREE)
			x_start = x1
		else if(map[x_start][y0] == CAVE_FREE)
			y_start = y0
		else if(map[x_start][y1] == CAVE_FREE)
			y_start = y1
		else
			found = FALSE

		if(!found)
			x0--
			x1++
			y0--
			y1++
			edge = (x0 <= 1 + x_margin) || (x1 >= CAVE_SIZE - x_margin) || (y0 <= 1 + y_margin) || (y1 >= CAVE_SIZE - y_margin)

	// Hit an edge before finding an available spot
	if(!found)
		return list(FALSE, 0, 0)

	return list(TRUE, x_start, y_start)

// Checks for cave statuses
/obj/cave_generator/proc/is_closed()
	return status == CAVE_CLOSED

/obj/cave_generator/proc/is_generating()
	return status == CAVE_GENERATING

/obj/cave_generator/proc/is_opened()
	return status == CAVE_OPENED

/obj/cave_generator/proc/is_collapsing()
	return status == CAVE_COLLAPSING

/obj/cave_generator/proc/is_cleaning()
	return status == CAVE_CLEANING

// Check cooldown to avoid spamming cave generation
/obj/cave_generator/proc/check_cooldown()
	return world.time > (cave_time + CAVE_COOLDOWN)

// Return remaining time to open a new cave
/obj/cave_generator/proc/remaining_cooldown()
	return round((cave_time + CAVE_COOLDOWN - world.time) / (1 MINUTES), 0.5)

// Place the up and down ladders and connect them
/obj/cave_generator/proc/place_ladders(drill_x, drill_y, drill_z, seismic_lvl)

	// Lock generator to avoid several iterations running in parallel
	if(status != CAVE_CLOSED)
		return FALSE
	status = CAVE_GENERATING

	spawn(0)
		// Generate the map for the given seismic level
		generate_map(seismic_lvl)

		// Place the up ladder on a free spot in the cave
		var/list/res = list(FALSE, 0, 0)
		var/N_trials = 10
		while(!res[1] && N_trials > 0)
			N_trials--
			res = find_free_spot(rand(2, CAVE_SIZE - 2), rand(2, CAVE_SIZE - 2))
		if(!res[1])
			log_world("Failed to find a free spot in the cave to place a ladder.")
			status = CAVE_CLEANING
			clean_turfs(locate(drill_x, drill_y - 1, drill_z)) // Clean the map for next generation
			cave_time = world.time
			status = CAVE_CLOSED
			return

		// Place the up ladder on free spot
		ladder_up = new /obj/structure/multiz/ladder/up/cave(locate(x + res[2], y + res[3], z))

		// Place the down ladder near the drill
		ladder_down = new /obj/structure/multiz/ladder/cave_hole(locate(drill_x, drill_y - 1, drill_z))

		// Connect ladders
		ladder_down.target = ladder_up
		ladder_up.target = ladder_down

		// Link with cave gen
		ladder_down.cave_gen = src

		status = CAVE_OPENED

	return TRUE

// Initiate the collapse countdown
/obj/cave_generator/proc/initiate_collapse()
	if(status != CAVE_OPENED)
		return

	status = CAVE_COLLAPSING
	cave_collapse_time = world.time + CAVE_COLLAPSE

	// Warn miners so that they have time to get out
	collapse_warning(TRUE)

	// You better be out when this is called
	addtimer(CALLBACK(src, PROC_REF(collapse)), CAVE_COLLAPSE)

// Display a message to everyone in the cave
/obj/cave_generator/proc/collapse_warning(first_warning = FALSE)

	var/minutes_remaining = round((cave_collapse_time - world.time) / (1 MINUTES), 0.5)
	if(first_warning)
		for(var/mob/living/M in SSmobs.mob_living_by_zlevel[z])
			if(ishuman(M) && (M.x > x) && (M.x < x + CAVE_SIZE) && (M.y > y) && (M.y < y + CAVE_SIZE))
				to_chat(M, SPAN_WARNING("WARNING: Cave collapse protocol has been engaged. \
										The cave will collapse in T-[minutes_remaining] minutes. \
										Miners, evacuate as many precious minerals as possible!"))
	else
		for(var/mob/living/M in SSmobs.mob_living_by_zlevel[z])
			if(ishuman(M) && (M.x > x) && (M.x < x + CAVE_SIZE) && (M.y > y) && (M.y < y + CAVE_SIZE))
				to_chat(M, SPAN_WARNING("WARNING: Cave collapse in T-[minutes_remaining] minutes. Remember, the Guild is counting on this haul!"))

	// Call again in 30 seconds
	if(cave_collapse_time - world.time > 45 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(collapse_warning)), 30 SECONDS)

// Collapse the cave system and clean it
/obj/cave_generator/proc/collapse()
	if(status != CAVE_COLLAPSING)
		return

	// Cave is being cleaned
	status = CAVE_CLEANING

	// Dump blacklisted content on this turf
	var/turf/dump = get_turf(ladder_down)

	// Disconnect and remove the ladders
	remove_ladders()

	// Clean the map
	spawn(0)
		clean_turfs(dump)

		// The cave is ready for the next generation
		cave_time = world.time
		status = CAVE_CLOSED

// Disconnect and remove the ladders
/obj/cave_generator/proc/remove_ladders()
	// Checks in case one of the ladders got qdeled for some reason (like shuttle landing on it)
	if(ladder_down)
		ladder_down.target = null
		QDEL_NULL(ladder_down)
	if(ladder_up)
		ladder_up.target = null
		QDEL_NULL(ladder_up)

// Place a mineral vein starting at the designated spot
/obj/cave_generator/proc/place_mineral_vein(x_start, y_start, seismic_lvl)

	// Find closest available spot (wall tile near a free tile)
	var/search_for = map[x_start][y_start] == CAVE_FREE ? CAVE_WALL : CAVE_FREE
	var/x0 = x_start - 1
	var/x1 = x_start + 1
	var/y0 = y_start - 1
	var/y1 = y_start + 1
	var/found = FALSE
	var/edge = FALSE
	while(!found && !edge)
		found = TRUE
		if(map[x0][y_start] == search_for)
			if(search_for == CAVE_FREE)
				x0++
			x_start = x0
		else if(map[x1][y_start] == search_for)
			if(search_for == CAVE_FREE)
				x1--
			x_start = x1
		else if(map[x_start][y0] == search_for)
			if(search_for == CAVE_FREE)
				y0++
			y_start = y0
		else if(map[x_start][y1] == search_for)
			if(search_for == CAVE_FREE)
				y1--
			y_start = y1
		else
			found = FALSE

		if(!found)
			x0--
			x1++
			y0--
			y1++
			edge = (x0 == 1) || (x1 == CAVE_SIZE) || (y0 == 1) || (y1 == CAVE_SIZE)

	// Hit an edge before finding an available spot
	if(!found)
		return 0

	// Choose which kind of mineral should the vein be made of
	// Multiplier scale from 0 to 1
	// Carbon and iron always have same probability
	// Plasma, silver, gold scale up until medium seismic level
	// Uranium, diamond and platinum scale up until max seismic level
	var/seismic_mult = (seismic_lvl - SEISMIC_MIN) / (SEISMIC_MAX - SEISMIC_MIN)
	var/list/datum/cave_vein/cave_veins = list(/datum/cave_vein/carbon = CAVE_VWEIGHT,
											/datum/cave_vein/iron = CAVE_VWEIGHT,
											/datum/cave_vein/plasma = CAVE_VWEIGHT * min(1, 2 * seismic_mult),
											/datum/cave_vein/silver = CAVE_VWEIGHT * min(1, 2 * seismic_mult),
											/datum/cave_vein/gold = CAVE_VWEIGHT * min(1, 2 * seismic_mult),
											/datum/cave_vein/uranium = CAVE_VWEIGHT * seismic_mult,
											/datum/cave_vein/diamond = CAVE_VWEIGHT * seismic_mult,
											/datum/cave_vein/platinum = CAVE_VWEIGHT * seismic_mult)
	var/vein_path = pickweight(cave_veins)
	var/datum/cave_vein/CV = new vein_path()

	// Place mineral vein at the available spot in a recursive manner
	place_recursive_mineral(x_start, y_start, CV.p_spread, CV.size_max, CV.size_min, CV.mineral)
	return 1

// Place a mineral vein in a recursive manner
/obj/cave_generator/proc/place_recursive_mineral(x0, y0, p, size, size_min, mineral)

	map[x0][y0] = mineral

	// Last turf of the vein
	if(size == 0)
		return

	var/list/xtest = list(x0 - 1, x0 + 1, x0, x0)
	var/list/ytest = list(y0, y0, y0 - 1, y0 + 1)
	var/list/xs = list()
	var/list/ys = list()
	for(var/i = 1 to 4)
		// Check if inside map bounds
		if((xtest[i] > 1) && (xtest[i] < CAVE_SIZE) && (ytest[i] > 1) && (ytest[i] < CAVE_SIZE))
			if(map[xtest[i]][ytest[i]] == CAVE_WALL)
				xs += xtest[i]
				ys += ytest[i]

	if(!LAZYLEN(xs))
		return

	var/j = rand(1, LAZYLEN(xs))
	if(prob(p) || (size > size_min))
		place_recursive_mineral(xs[j], ys[j], p, size - 1, size_min, mineral)

// Remove everything from all tiles except the turfs themselves
/obj/cave_generator/proc/clean_turfs(turf/dump)

	for(var/mob/living/M in SSmobs.mob_living_by_zlevel[z])
		if((M.x > x) && (M.x < x + CAVE_SIZE) && (M.y > y) && (M.y < y + CAVE_SIZE))
			if(ishuman(M))
				log_and_message_admins("[key_name(M)] got killed in cave collapse.")
			M.death(FALSE)
			M.ghostize()

	var/list/cave_content = get_area_contents(/area/asteroid/cave)
	for (var/atom/movable/A in cave_content)
		if(isturf(A) || istype(A, /obj/cave_generator || istype(A, /atom/movable/lighting_overlay)))
			continue
		else if(!(A.type in blacklist))
			qdel(A)
		else
			A.forceMove(dump)
			if(!isobserver(A))
				log_and_message_admins("[A] has been moved to [admin_jump_link(dump, src)] to avoid deletion in cave collapse.")

	// Clean up shards and rods created when girders and windows are deleted at previous step
	cave_content = get_area_contents(/area/asteroid/cave)
	for (var/atom/movable/A in cave_content)
		if(isturf(A) || istype(A, /obj/cave_generator || istype(A, /atom/movable/lighting_overlay)))
			continue
		else if(!(A.type in blacklist))
			qdel(A)
		// No need to do forceMove since everything relevant is already displaced


/obj/cave_generator/proc/place_turfs(seismic_lvl)

	var/turf_type
	for(var/i = 1 to CAVE_SIZE)
		for(var/j = 1 to CAVE_SIZE)
			switch(map[i][j])
				if(CAVE_FREE)
					turf_type = /turf/simulated/floor/asteroid/cave
				if(CAVE_WALL)
					turf_type = /turf/simulated/impassable_rock
				if(CAVE_POI)
					turf_type = /turf/space
				if(CAVE_CARBON)
					turf_type = /turf/simulated/cave_mineral/carbon
				if(CAVE_IRON)
					turf_type = /turf/simulated/cave_mineral/iron
				if(CAVE_PLASMA)
					turf_type = /turf/simulated/cave_mineral/plasma
				if(CAVE_URANIUM)
					turf_type = /turf/simulated/cave_mineral/uranium
				if(CAVE_DIAMOND)
					turf_type = /turf/simulated/cave_mineral/diamond
				if(CAVE_SILVER)
					turf_type = /turf/simulated/cave_mineral/silver
				if(CAVE_GOLD)
					turf_type = /turf/simulated/cave_mineral/gold
				if(CAVE_PLATINUM)
					turf_type = /turf/simulated/cave_mineral/platinum
				else
					turf_type = /turf/simulated/floor/asteroid/cave

			var/turf/T = get_turf(locate(x + i, y + j, z))
			if(!istype(T, turf_type))
				T.ChangeTurf(turf_type)
			if(istype(T, /turf/simulated/cave_mineral))
				var/turf/simulated/cave_mineral/CM = T
				CM.seismic_multiplier = seismic_lvl

// Spawn points of interest at their respective position
/obj/cave_generator/proc/place_pois()
	if(!LAZYLEN(pois_placed))
		return

	for(var/k = 1 to LAZYLEN(pois_placed))
		var/turf/corner_turf = get_turf(locate(x + pois_placed_pos[k][1], y + pois_placed_pos[k][2], z))
		pois_placed[k].load(corner_turf)

// Spawn golems on free turfs depending on seismic level
/obj/cave_generator/proc/place_golems(seismic_lvl)

	var/golem_type
	for(var/i = 1 to CAVE_SIZE)
		for(var/j = 1 to CAVE_SIZE)
			if(map[i][j] == CAVE_FREE && prob(2 + seismic_lvl))
				if(prob(4 * seismic_lvl)) // Probability of special golem
					golem_type = pick(GLOB.golems_special)
				else
					golem_type = pick(GLOB.golems_normal)
				// Spawn golem at free location
				new golem_type(get_turf(locate(x + i, y + j, z)), drill=null, parent=null)

//////////////////////////////
// Mineral veins for the cave generator
//////////////////////////////
/datum/cave_vein
	var/name  // Name of the vein
	var/mineral  // Type of ore of this vein
	var/size_min  // Minimal size of this vein
	var/size_max  // Maximal size of this vein
	var/p_spread = 50  // Probability of spread past minimal size

/datum/cave_vein/carbon
	name = "carbon vein"
	mineral = CAVE_CARBON
	size_min = 6
	size_max = 12

/datum/cave_vein/iron
	name = "iron vein"
	mineral = CAVE_IRON
	size_min = 6
	size_max = 12

/datum/cave_vein/plasma
	name = "plasma vein"
	mineral = CAVE_PLASMA
	size_min = 5
	size_max = 10

/datum/cave_vein/uranium
	name = "uranium vein"
	mineral = CAVE_URANIUM
	size_min = 3
	size_max = 6

/datum/cave_vein/diamond
	name = "diamond vein"
	mineral = CAVE_DIAMOND
	size_min = 3
	size_max = 6

/datum/cave_vein/silver
	name = "silver vein"
	mineral = CAVE_SILVER
	size_min = 4
	size_max = 8

/datum/cave_vein/gold
	name = "gold vein"
	mineral = CAVE_GOLD
	size_min = 4
	size_max = 8

/datum/cave_vein/platinum
	name = "platinum vein"
	mineral = CAVE_PLATINUM
	size_min = 4
	size_max = 8

//////////////////////////////
// Ladders to enter and exit the cave
//////////////////////////////
/obj/structure/multiz/ladder/cave_hole
	name = "cave network entrance"
	desc = "A hole in the ground leading to an extensive cavern network."
	icon = 'icons/obj/burrows.dmi'
	icon_state = "maint_hole"
	var/obj/cave_generator/cave_gen

/obj/structure/multiz/ladder/cave_hole/Destroy()
	if(cave_gen)
		cave_gen = null
	. = ..()

/obj/structure/multiz/ladder/cave_hole/attackby(obj/item/I, mob/user)
	if(!cave_gen || !((cave_gen.status == CAVE_OPENED) || (cave_gen.status == CAVE_COLLAPSING)))
		to_chat(user, SPAN_NOTICE("The cave system is not opened yet."))
		return
	. = ..()

/obj/structure/multiz/ladder/cave_hole/attack_hand(var/mob/M)
	if(!cave_gen || !((cave_gen.status == CAVE_OPENED) || (cave_gen.status == CAVE_COLLAPSING)))
		to_chat(M, SPAN_NOTICE("The cave system is not opened yet."))
		return
	. = ..()

/obj/structure/multiz/ladder/up/cave
	name = "cave network exit"

// Undefine cave constants
#undef CAVE_SIZE
#undef CAVE_MARGIN
#undef CAVE_CORRIDORS
#undef CAVE_WALL_PROPORTION
#undef CAVE_VWEIGHT
#undef CAVE_COOLDOWN
#undef CAVE_COLLAPSE

// Undefine statuses
#undef CAVE_CLOSED
#undef CAVE_GENERATING
#undef CAVE_OPENED
#undef CAVE_COLLAPSING
#undef CAVE_CLEANING

// Undefine cave tiles
#undef CAVE_FREE
#undef CAVE_WALL
#undef CAVE_POI
#undef CAVE_CARBON
#undef CAVE_IRON
#undef CAVE_PLASMA
#undef CAVE_URANIUM
#undef CAVE_DIAMOND
#undef CAVE_SILVER
#undef CAVE_GOLD
#undef CAVE_PLATINUM
