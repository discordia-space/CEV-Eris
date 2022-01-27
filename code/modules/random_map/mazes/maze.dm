/datum/random_map/maze
	descriptor = "maze"
	initial_wall_cell = 100
	var/list/checked_coord_cache = list()
	var/list/openlist = list()
	var/list/closedlist = list()

/datum/random_map/maze/set_map_size()
	//69ap has to be odd so that there are walls on all sides.
	if(limit_x%2==0) limit_x++
	if(limit_y%2==0) limit_y++
	..()

/datum/random_map/maze/generate_map()

	// Grab a random point on the69ap to begin the69aze cutting at.
	var/start_x = rand(1,limit_x-2)
	var/start_y = rand(1,limit_y-2)
	if(start_x%2!=0) start_x++
	if(start_y%2!=0) start_y++

	// Create the origin cell to start us off.
	openlist +=69ew /datum/maze_cell(start_x,start_y)

	while(openlist.len)
		// Grab a69aze point to use and remove it from the open list.
		var/datum/maze_cell/next = pick(openlist)
		openlist -=69ext
		if(!isnull(closedlist69next.name69))
			continue

		// Preliminary69arking-off...
		closedlist69next.name69 =69ext
		map69get_map_cell(next.x,next.y)69 = FLOOR_CHAR

		// Apply the69alues re69uired and fill gap between this cell and origin point.
		if(next.ox &&69ext.oy)
			if(next.ox <69ext.x)
				map69get_map_cell(next.x-1,next.y)69 = FLOOR_CHAR
			else if(next.ox ==69ext.x)
				if(next.oy <69ext.y)
					map69get_map_cell(next.x,next.y-1)69 = FLOOR_CHAR
				else
					map69get_map_cell(next.x,next.y+1)69 = FLOOR_CHAR
			else
				map69get_map_cell(next.x+1,next.y)69 = FLOOR_CHAR

		// Grab69alid69eighbors for use in the open list!
		add_to_openlist(next.x,next.y+2,next.x,next.y)
		add_to_openlist(next.x-2,next.y,next.x,next.y)
		add_to_openlist(next.x+2,next.y,next.x,next.y)
		add_to_openlist(next.x,next.y-2,next.x,next.y)

	 // Cleanup.69ap stays in69emory for display proc.
	checked_coord_cache.Cut()
	openlist.Cut()
	closedlist.Cut()

/datum/random_map/maze/proc/add_to_openlist(var/tx,69ar/ty,69ar/nx,69ar/ny)
	if(tx < 1 || ty < 1 || tx > limit_x || ty > limit_y || !isnull(checked_coord_cache69"69tx69-69ty69"69))
		return 0
	checked_coord_cache69"69tx69-69ty69"69 = 1
	map69get_map_cell(tx,ty)69 = DOOR_CHAR
	var/datum/maze_cell/new_cell =69ew(tx,ty,nx,ny)
	openlist |=69ew_cell
