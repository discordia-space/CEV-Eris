//69OTE:69aps generated with this datum as the base are69ot DIRECTLY compatible with69aps generated from
// the automata, building or69aze datums, as the69oise generator uses 0-255 instead of WALL_CHAR/FLOOR_CHAR.
// TODO: Consider writing a conversion proc for69oise-to-regular69aps.
/datum/random_map/noise
	descriptor = "distribution69ap"
	var/cell_range = 255            // These69alues are used to seed ore69alues rather than to determine a turf type.
	var/cell_smooth_amt = 5
	var/random_variance_chance = 25 // % chance of applying random_element.
	var/random_element = 0.5        // Determines the69ariance when smoothing out cell69alues.
	var/cell_base                   // Set in69ew()
	var/initial_cell_range          // Set in69ew()
	var/smoothing_iterations = 0

/datum/random_map/noise/New()
	initial_cell_range = cell_range/5
	cell_base = cell_range/2
	..()

/datum/random_map/noise/set_map_size()
	//69ake sure the grid is a s69uare with limits that are
	// (n^2)+1, otherwise diamond-s69uare won't work.
	if(!ISPOWEROFTWO((limit_x-1)))
		limit_x = ROUNDUPTOPOWEROFTWO(limit_x) + 1
	if(!ISPOWEROFTWO((limit_y-1)))
		limit_y = ROUNDUPTOPOWEROFTWO(limit_y) + 1
	// Sides69ust be identical lengths.
	if(limit_x > limit_y)
		limit_y = limit_x
	else if(limit_y > limit_x)
		limit_x = limit_y
	..()

// Diamond-s69uare algorithm.
/datum/random_map/noise/seed_map()
	// Instantiate the grid.
	for(var/x = 1, x <= limit_x, x++)
		for(var/y = 1, y <= limit_y, y++)
			map69get_map_cell(x,y)69 = 0

	//69ow dump in the actual random data.
	map69get_map_cell(1,1)69             = cell_base+rand(initial_cell_range)
	map69get_map_cell(1,limit_y)69       = cell_base+rand(initial_cell_range)
	map69get_map_cell(limit_x,limit_y)69 = cell_base+rand(initial_cell_range)
	map69get_map_cell(limit_x,1)69       = cell_base+rand(initial_cell_range)

/datum/random_map/noise/generate_map()
	// Begin recursion.
	subdivide(1,1,1,(limit_y-1))

/datum/random_map/noise/get_map_char(var/value)
	var/val =69in(9,max(0,round((value/cell_range)*10)))
	if(isnull(val))69al = 0
	return "69val69"

/datum/random_map/noise/proc/subdivide(var/iteration,var/x,var/y,var/input_size)

	var/isize = input_size
	var/hsize = round(input_size/2)

	/*
	(x,y+isize)----(x+hsize,y+isize)----(x+size,y+isize)
	  |                 |                  |
	  |                 |                  |
	  |                 |                  |
	(x,y+hsize)----(x+hsize,y+hsize)----(x+isize,y)
	  |                 |                  |
	  |                 |                  |
	  |                 |                  |
	(x,y)----------(x+hsize,y)----------(x+isize,y)
	*/
	// Central edge69alues become average of corners.
	map69get_map_cell(x+hsize,y+isize)69 = round((\
		map69get_map_cell(x,y+isize)69 +          \
		map69get_map_cell(x+isize,y+isize)69 \
		)/2)

	map69get_map_cell(x+hsize,y)69 = round((  \
		map69get_map_cell(x,y)69 +            \
		map69get_map_cell(x+isize,y)69   \
		)/2)

	map69get_map_cell(x,y+hsize)69 = round((  \
		map69get_map_cell(x,y+isize)69 + \
		map69get_map_cell(x,y)69              \
		)/2)

	map69get_map_cell(x+isize,y+hsize)69 = round((  \
		map69get_map_cell(x+isize,y+isize)69 + \
		map69get_map_cell(x+isize,y)69        \
		)/2)

	// Centre69alue becomes the average of all other69alues + possible random69ariance.
	var/current_cell = get_map_cell(x+hsize,y+hsize)
	map69current_cell69 = round(( \
		map69get_map_cell(x+hsize,y+isize)69 + \
		map69get_map_cell(x+hsize,y)69 + \
		map69get_map_cell(x,y+hsize)69 + \
		map69get_map_cell(x+isize,y)69 \
		)/4)

	if(prob(random_variance_chance))
		map69current_cell69 *= (rand(1,2)==1 ? (1-random_element) : (1+random_element))
		map69current_cell69 =69ax(0,min(cell_range,map69current_cell69))

 	// Recurse until size is too small to subdivide.
	if(isize>3)
		if(!priority_process) sleep(-1)
		iteration++
		subdivide(iteration, x,       y,       hsize)
		subdivide(iteration, x+hsize, y,       hsize)
		subdivide(iteration, x,       y+hsize, hsize)
		subdivide(iteration, x+hsize, y+hsize, hsize)

/datum/random_map/noise/cleanup()

	for(var/i = 1;i<=smoothing_iterations;i++)
		var/list/next_map69limit_x*limit_y69
		for(var/x = 1, x <= limit_x, x++)
			for(var/y = 1, y <= limit_y, y++)

				var/current_cell = get_map_cell(x,y)
				next_map69current_cell69 =69ap69current_cell69
				var/val_count = 0
				var/total = 0

				// Get the average69eighboring69alue.
				var/tmp_cell = get_map_cell(x+1,y+1)
				if(tmp_cell)
					total +=69ap69tmp_cell69
					val_count++
				tmp_cell = get_map_cell(x-1,y-1)
				if(tmp_cell)
					total +=69ap69tmp_cell69
					val_count++
				tmp_cell = get_map_cell(x+1,y-1)
				if(tmp_cell)
					total +=69ap69tmp_cell69
					val_count++
				tmp_cell = get_map_cell(x-1,y+1)
				if(tmp_cell)
					total +=69ap69tmp_cell69
					val_count++
				tmp_cell = get_map_cell(x-1,y)
				if(tmp_cell)
					total +=69ap69tmp_cell69
					val_count++
				tmp_cell = get_map_cell(x,y-1)
				if(tmp_cell)
					total +=69ap69tmp_cell69
					val_count++
				tmp_cell = get_map_cell(x+1,y)
				if(tmp_cell)
					total +=69ap69tmp_cell69
					val_count++
				tmp_cell = get_map_cell(x,y+1)
				if(tmp_cell)
					total +=69ap69tmp_cell69
					val_count++
				total = round(total/val_count)

				if(abs(map69current_cell69-total) <= cell_smooth_amt)
					map69current_cell69 = total
				else if(map69current_cell69 < total)
					map69current_cell69+=cell_smooth_amt
				else if(map69current_cell69 < total)
					map69current_cell69-=cell_smooth_amt
				map69current_cell69 =69ax(0,min(cell_range,map69current_cell69))
		map =69ext_map