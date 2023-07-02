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

    // Fill the map with random noise
    random_fill_map()

    // Place a few corridors to guide the generation
    place_corridors()

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

/obj/cave_generator/proc/place_corridors()

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

