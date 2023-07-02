#define CAVE_SIZE 100  // Size of the square cave area
#define CAVE_MARGIN 5  // Margin near the edges of the cave
#define CAVE_CORRIDORS 10  // Number of corridors to guide cave generation
#define CAVE_WALL_PROPORTION 0.7 // Proportion of wall in random noise generation

// Types of turfs in the cave
#define CAVE_FREE 0
#define CAVE_WALL 1
#define CAVE_IRON 2
#define CAVE_URANIUM 3
#define CAVE_GOLD 4
#define CAVE_SILVER 5
#define CAVE_DIAMOND 6
#define CAVE_PLASMA 7
#define CAVE_OSMIUM 8
#define CAVE_TRITIUM 9
#define CAVE_GLASS 10
#define CAVE_PLASTIC 11

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
	invisibility = 101

    var/map // map with 0 (free turf) and 1+ (wall or mineral)
    var/N_mineral_veins // Number of mineral veins in the cave

/obj/cave_generator/New()

    // Honk
    generate_map()

/obj/cave_generator/proc/generate_map()
    // Fill the map with random noise
    random_fill_map()

    // Place a few corridors to guide the generation
    generate_corridors()

    // Run the cellular automata to generate the cave system
    for(var/i = 1 to 3)
        run_cellular_automata()

    // Generate mineral veins from processed map
    generate_mineral_veins()

    // Finally place the walls, ores and free space
    place_turfs()

/obj/cave_generator/proc/random_fill_map()
    // New, empty map
    map = new/list(CAVE_SIZE, CAVE_SIZE, 0)

    for(var/i = 1 to CAVE_SIZE)
        for(var/j = 1 to CAVE_SIZE)
            // Create a border on the edge of the map
            if(i == 1 || i == CAVE_SIZE || j == 1 || j == CAVE_SIZE)
                map[i][j] = CAVE_WALL
            else if(prob(CAVE_WALL_PROPORTION))
                map[i][j] = CAVE_WALL

/obj/cave_generator/proc/generate_corridors()

    // Draw a vertical corridor from (CAVE_MARGIN, CAVE_SIZE/2) to (CAVE_SIZE/2, CAVE_SIZE/2)
    // then recursively draw corridors that branches out from it
    draw_recursive_corridor(CAVE_MARGIN, CAVE_SIZE/2, CAVE_SIZE/2, CAVE_SIZE/2, CAVE_CORRIDORS/2)
    // Same from (CAVE_SIZE/2, CAVE_SIZE/2) to (CAVE_SIZE - CAVE_MARGIN, CAVE_SIZE/2)
    draw_recursive_corridor(CAVE_SIZE/2, CAVE_SIZE - CAVE_MARGIN, CAVE_SIZE/2, CAVE_SIZE/2, CAVE_CORRIDORS/2)

/obj/cave_generator/proc/draw_recursive_corridor(x0, x1, y0, y1, N)

    // Draw a 2-wide corridor
    for(var/i = x0 to x1 + 1)
        for(var/j = y0 to y1 + 1)
            map[i][j] = CAVE_FREE

    // If this is the last corridor
    if(N == 0)
        return

    // Recursively draw another corridor in orthogonal direction
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

    for(var/i = 1 to CAVE_SIZE)
        for(var/j = 1 to CAVE_SIZE)
            map[i][j] = place_wall_logic(i, j)

// Wall placement logic for the cellular automata
/obj/cave_generator/proc/place_wall_logic(x, y)

    var/num_walls = get_adjacent_walls(x, y, 1, 1)
    if(map[x][y] == CAVE_WALL)
        if(num_walls >= 4)
            return CAVE_WALL
        else if(num_walls < 2)
            return CAVE_FREE
    else if(num_walls >= 5)
        return CAVE_WALL
    else
        return CAVE_FREE

// Get number of walls in a given range around the target tile
/obj/cave_generator/proc/get_adjacent_walls(x, y, scope_x, scope_y)
    var/num_walls = 0
    for(var/i = (x - scope_x) to (x + scope_x))
        for(var/j = (y - scope_y) to (y + scope_y))
            if(!(i == x && j == y) && map[i][j] == CAVE_WALL)
                num_walls++
    return num_walls

// Generate mineral veins once cave layout has been decided
/obj/cave_generator/proc/generate_mineral_veins() 
    var/x_vein = 0
    var/y_vein = 0
    var/N_veins = N_mineral_veins
    var/N_trials = 50
    while(N_veins > 0 && N_trials > 0)
        N_trials--
        x_vein = rand(CAVE_MARGIN, CAVE_SIZE - CAVE_MARGIN)
        y_vein = rand(CAVE_MARGIN, CAVE_SIZE - CAVE_MARGIN)
        N_veins -= place_mineral_vein(x_vein, y_vein)

// Place a mineral vein starting at the designated spot
/obj/cave_generator/proc/generate_mineral_veins(x, y)

    // Find closest available spot (wall tile near a free tile)
    var/search_for = map[x][y] == CAVE_FREE ? CAVE_WALL : CAVE_FREE
    var/x0 = x - 1 
    var/x1 = x + 1
    var/y0 = y - 1
    var/y1 = y + 1
    var/found = FALSE
    var/edge = FALSE
    while(!found && !edge)
        found = TRUE
        if(map[x0, y] == search_for)
            x = x0
        else if(map[x1, y] == search_for)
            x = x1
        else if(map[x, y0] == search_for)
            y = y0
        else if(map[x, y1] == search_for)
            y = y1
        else:
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

    // TODO: Make mineral specific
    var/p_mineral = 0.25
    var/size_min = 5
    var/size_max = 10

    // Place mineral vein at the available spot in a recursive manner
    place_recursive_mineral(x, y, size_min, size_max) 
    return 1

// Place a mineral vein in a recursive manner
/obj/cave_generator/proc/place_recursive_mineral(x, y, p, size, size_min)

    map[x][y] = CAVE_IRON
    // Last turf of the vein
    if(size == 0)
        return

    var/list/xtest = list(x - 1, x + 1, x, x)
    var/list/ytest = list(y, y, y - 1, y + 1)
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
    if(prob(p) || size > size_min)
        place_mineral_turf(xs[i], ys[i], p, size - 1, size_min)

/obj/cave_generator/proc/place_turfs()

    var/turf_type
    for(var/i = 1 to CAVE_SIZE)
        for(var/j = 1 to CAVE_SIZE)
            switch(map[i][j])
                if(CAVE_FREE)
                    turf_type = /turf/simulated/floor/asteroid
                if(CAVE_WALL)
                    turf_type = /turf/unsimulated/mineral
                if(50 to 70)
                    return "health60"
                if(30 to 50)
                    return "health40"
                if(18 to 30)
                    return "health25"
                if(5 to 18)
                    return "health10"
                if(1 to 5)
                    return "health1"
                if(-99 to 0)
                    return "health0"
                else
                    return "health-100"