/// in order to avoid confusion, we're counting up from 1 and not 0.
/obj/crawler/map_maker
	name = "mapgen"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	alpha = 120
	anchored = TRUE
	unacidable = 1
	simulated = FALSE
	invisibility = 101
	weight = 0
	var/max_x = 8 //if we ever make more than 4x4 dungeon run map, instead of making new procs for generation, we can just edit those vars - edit 16 x 16
	var/max_y = 8
	var/generating = 0
	var/area/crawler/myarea
	var/rooms = list()
	var/list/occupied_rooms = list()
	var/starting_lane = list()
	var/list/start_room_templates = list()
	var/list/room_templates = list()
	var/list/end_room_templates = list()
	var/list/special_rooms = list()
	var/list/above_room_templates = list()
	var/list/horizontal_room_templates = list()
	var/list/under_room_templates = list()
	var/datum/map_template/dungeon_template/room/blocker_temp = null

/obj/crawler/map_maker/New()
	while(1)
		if(Master.current_runlevel)
			break
		else
			sleep(250)
	for(var/item in subtypesof(/datum/map_template/dungeon_template/entrance))
		var/datum/map_template/dungeon_template/entrance/entrance_type = item
		if(!(initial(entrance_type.mappath)))
			continue
		var/datum/map_template/dungeon_template/entrance/S = new entrance_type()

		start_room_templates += S

	for(var/item in subtypesof(/datum/map_template/dungeon_template/exit))
		var/datum/map_template/dungeon_template/exit/exit_type = item
		if(!(initial(exit_type.mappath)))
			continue
		var/datum/map_template/dungeon_template/exit/S = new exit_type()

		end_room_templates += S

	for(var/item in subtypesof(/datum/map_template/dungeon_template/room))
		var/datum/map_template/dungeon_template/room/room_type = item
		if(!(initial(room_type.mappath)))
			continue
		var/datum/map_template/dungeon_template/room/S = new room_type()

		if(S.room_tag == "dead_end")
			special_rooms += S

		else if(S.room_tag == "blocker")
			blocker_temp = S

		else if(S.room_tag == "above_only")
			above_room_templates +=S

		else if(S.room_tag == "under_only")
			under_room_templates +=S

		else if(S.room_tag == "horizontal_only")
			horizontal_room_templates +=S

		else
			room_templates += S


	/*myarea = get_area(loc)
	for(var/obj/crawler/room_controller/RC in myarea.room_controllers)
		rooms += RC
		if(RC.roomnum <= 4)
			lane1 += RC
		else if(RC.roomnum <= 8)
			lane2 += RC
		else if(RC.roomnum <= 12)
			lane3 += RC
		else if(RC.roomnum <= 16)
			lane4 += RC*/

	// Listen to signal to trigger dungeon generation only when needed
	// i.e only when teleporter to dungeon is activated
	RegisterSignal(src, COMSIG_GENERATE_DUNGEON, PROC_REF(trigger_generation))

/obj/crawler/map_maker/proc/trigger_generation(obj/rogue/teleporter/O)
	//SIGNAL_HANDLER
	UnregisterSignal(src, COMSIG_GENERATE_DUNGEON)
	generate_controllers()
	populate_starting_lane()
	sleep(100)
	generate_dungeon()
	// Dungeon has been generated, send signal to teleporter
	SEND_SIGNAL_OLD(O, COMSIG_DUNGEON_GENERATED)

/obj/crawler/map_maker/proc/generate_controllers()
	var/roomnumber = 0
	var/i = max_y
	while(i > 0)
		var/l = max_x
		while(l > 0)
			var/obj/crawler/room_controller/RC = new /obj/crawler/room_controller(locate(x + (13 * (max_x - l)), y - (9 * (max_y - i)), z))
			RC.room_x = (max_x + 1) - l
			RC.room_y = (max_y + 1) - i
			roomnumber++
			RC.roomnum = roomnumber
			rooms += RC
			l--
		i--

/obj/crawler/map_maker/proc/populate_starting_lane()
	for(var/obj/crawler/room_controller/RC in rooms)
		if(RC.room_y == 1)
			starting_lane += RC

/obj/crawler/map_maker/proc/get_room_by_num(var/num)
	for(var/obj/crawler/room_controller/RC in rooms)
		if(RC.roomnum == num)
			return RC

/obj/crawler/map_maker/proc/get_room_by_coords(var/rx, var/ry)
	for(var/obj/crawler/room_controller/RC in rooms)
		if(RC.room_x == rx && RC.room_y == ry)
			return RC
	return 0

/obj/crawler/map_maker/proc/get_room_number_by_coords(var/rx, var/ry)
	for(var/obj/crawler/room_controller/RC in rooms)
		if(RC.room_x == rx && RC.room_y == ry)
			return RC.roomnum
	return 0

/obj/crawler/map_maker/proc/get_room_x_by_num(var/num)
	for(var/obj/crawler/room_controller/RC in rooms)
		if(RC.roomnum == num)
			return RC.room_x

/obj/crawler/map_maker/proc/get_room_y_by_num(var/num)
	for(var/obj/crawler/room_controller/RC in rooms)
		if(RC.roomnum == num)
			return RC.room_y

/obj/crawler/map_maker/proc/get_room_num_above(var/num)
	if (get_room_y_by_num(num) == 1)
		return 0
	else return get_room_number_by_coords(get_room_x_by_num(num), get_room_y_by_num(num) - 1)

/obj/crawler/map_maker/proc/get_room_num_under(var/num)
	if (get_room_y_by_num(num) == max_y)
		return 0
	else return get_room_number_by_coords(get_room_x_by_num(num), get_room_y_by_num(num) + 1)

/obj/crawler/map_maker/proc/get_room_num_left(var/num)
	if (get_room_x_by_num(num) == 1)
		return 0
	else return get_room_number_by_coords(get_room_x_by_num(num) - 1, get_room_y_by_num(num))

/obj/crawler/map_maker/proc/get_room_num_right(var/num)
	if (get_room_x_by_num(num) == max_x)
		return 0
	else return get_room_number_by_coords(get_room_x_by_num(num) + 1, get_room_y_by_num(num))

/obj/crawler/map_maker/proc/get_lane(var/num)
	var/obj/crawler/room_controller/room
	room = get_room_by_num(num)
	if (room)
		return room.room_y
	else return

/obj/crawler/map_maker/proc/get_adjacent(var/num)
	var/list/neighbors = list()
	if (((num - 1) > 0) && (get_lane(num - 1) == get_lane(num)))
		if(!is_generated(num - 1))
			neighbors += (num - 1)
	if (((num + 1) > 0) && get_lane(num + 1) == get_lane(num))
		if(!is_generated(num + 1))
			neighbors += (num + 1)
	if (neighbors.len)
		return neighbors
	else
		neighbors += 0
		return neighbors


/obj/crawler/map_maker/proc/get_all_neighbors(var/num)
	var/list/neighbors = list()
	neighbors = neighbors + get_adjacent(num)
	neighbors += get_room_num_above(num)
	neighbors += get_room_num_under(num)
	return(neighbors)

/obj/crawler/map_maker/proc/get_all_free_neighbors(var/num)
	var/list/neighbors = list()
	var/list/free_neighbors = list()
	neighbors = neighbors + get_all_neighbors(num)
	for(var/i in neighbors)
		if(is_generated(i))
			continue
		else
			free_neighbors += i
	if (free_neighbors.len)
		return free_neighbors
	else
		return 0


/obj/crawler/map_maker/proc/get_relative(var/num, var/r_direction)
	switch(r_direction)
		if (NORTH)
			return get_room_num_above(num)
		if (SOUTH)
			return get_room_num_under(num)
		if (WEST)
			return get_room_num_left(num)
		if (EAST)
			return get_room_num_right(num)

/obj/crawler/map_maker/proc/is_generated(var/num)
	for (var/obj/crawler/room_controller/room in occupied_rooms)
		if (room.roomnum == num)
			return 1
	return 0

/obj/crawler/map_maker/proc/generate_dungeon()
	var/obj/crawler/room_controller/starting_room = pick(starting_lane)//picking starting room
	occupied_rooms += starting_room
	generating = 1
	var/room_generating = starting_room.roomnum
	generate_room(starting_room.roomnum, "start")
	while(generating)
		if(is_generated(room_generating))
			var/next = pick(get_adjacent(room_generating))
			if(prob(85) && next)//so it doesn't alway hit the side and only then go down
				room_generating = next
				continue
			var/under = get_room_num_under(room_generating)
			if(under)
				//testing("under room number is:")
				var/obj/crawler/room_controller/c_room = get_room_by_num(room_generating)
				c_room.above = 1
				room_generating = under
				c_room = get_room_by_num(room_generating)
				c_room.under = 1 //so rooms with dead ends on top and bottom don't generate on top of each other, blocking the path. Hacky, but I found no workaround
				//testing(room_generating)
				continue
			else
				generating = 0
				if(next)
					room_generating = next
		if(generating)
			occupied_rooms += get_room_by_num(room_generating)
			//testing("Scheduled the mundane room with number:")
			//testing(room_generating)
		else
			var/obj/crawler/room_controller/endroom = get_room_by_num(room_generating)
			endroom.end_room = TRUE
			occupied_rooms += endroom
			//testing("end room number is:")
			//testing(room_generating)
			//testing("Scheduledx the end")
			break


	var/obj/crawler/room_controller/previous_room = starting_room
	for(var/obj/crawler/room_controller/c_room in occupied_rooms)
		if(c_room == previous_room)
			continue
		else if(c_room.end_room)
			generate_room(c_room.roomnum, "end")
		else
			generate_room(c_room.roomnum, "normal", previous_room.roomnum)
		previous_room = c_room



	sleep(200)
	previous_room = starting_room
	for(var/obj/crawler/room_controller/c_room in occupied_rooms)
		//testing(c_room.roomnum)
		if(c_room == previous_room)
			continue
		else
			previous_room.connect(c_room)
		previous_room = c_room

	var/secret_rooms = rand(15, occupied_rooms.len * 2)
	while(secret_rooms > 0)
		var/obj/crawler/room_controller/occupied_room = pick(occupied_rooms)
		var/list/neighbors = get_all_free_neighbors(occupied_room.roomnum)
		if(neighbors.len)
			var/r_num = pick(neighbors)
			if(r_num)
				var/obj/crawler/room_controller/neighbor = get_room_by_num(r_num)
				if(generate_room(r_num, "dead_end", occupied_room.roomnum))
					occupied_rooms += neighbor
					spawn(250)
						occupied_room.connect(neighbor)
		else
			secret_rooms++
		secret_rooms--

	for(var/obj/crawler/room_controller/c_room in rooms)
		if(c_room in occupied_rooms)
			continue
		else
			generate_room(c_room.roomnum, "blocker")
	testing("beginning dungeon initialization!")
	var/datum/map_template/dungeon_template/init_template = starting_room.template
	var/list/bounds = list(1.#INF, 1.#INF, 1.#INF, -1.#INF, -1.#INF, -1.#INF)
	bounds[MAP_MINX] = 1
	bounds[MAP_MINY] = 146
	bounds[MAP_MINZ] = z
	bounds[MAP_MAXX] = 210
	bounds[MAP_MAXY] = 1
	bounds[MAP_MAXZ] = z
	init_template.initTemplateBounds(bounds)
	testing("finished dungeon initialization!")

	sleep(1)
	for(var/turf/simulated/wall/W in block(locate(1, 1, z), locate(210, 146, z)))
		W.update_connections(1)


/obj/crawler/map_maker/proc/can_generate(var/roomnumber, var/datum/map_template/dungeon_template/r_template)
	var/list/disallowed_dirs = list()
	var/obj/crawler/room_controller/c_room = get_room_by_num(roomnumber)
	if(c_room.above)
		disallowed_dirs += SOUTH
	if(c_room.under)
		disallowed_dirs += NORTH
	for(var/i in disallowed_dirs)
		if(i in  r_template.directional_flags)
			//testing("Couldn't generate!")
			return 0
	//testing("CAN GENERATE!")
	return 1

/obj/crawler/map_maker/proc/can_connect(var/roomnumber, var/prevnum, var/datum/map_template/dungeon_template/r_template)
	var/rc_dir = get_dir(get_room_by_num(roomnumber), get_room_by_num(prevnum))
	var/cr_dir = get_dir(get_room_by_num(prevnum), get_room_by_num(roomnumber))
	//testing(roomnumber)
	//testing(prevnum)
	//testing(dir2text(rc_dir))
	//testing(dir2text(cr_dir))
	var/can_connect = 0
	var/obj/crawler/room_controller/pr_r = get_room_by_num(prevnum)
	var/datum/map_template/dungeon_template/prev_template = pr_r.template
	for(var/t_dir in r_template.directional_flags)
		if (t_dir == dir2text(rc_dir))
			can_connect = can_connect + 1
			//testing("can connect - 1")
	for(var/t_dir in prev_template.directional_flags)
		if (t_dir == dir2text(cr_dir))
			can_connect = can_connect + 1
			//testing("can connect - 2")
	if(can_connect == 2)
		//testing("CONNECTED = 1")
		return 1
	else
		return 0

/obj/crawler/map_maker/proc/generate_room(var/roomnumber, var/roomtype, var/prevnum)
	var/datum/map_template/r_template = null
	var/obj/crawler/room_controller/c_room = get_room_by_num(roomnumber)
	var/turf/T = get_turf(c_room)
	var/disallowed = 1
	T = get_step(T, NORTHWEST)
	T = get_step(T, NORTHWEST)
	switch(roomtype)
		if("blocker")
			r_template = blocker_temp
			r_template.load(T, centered = TRUE, orientation = SOUTH, post_init = 1)
		if("start")
			//testing("Generated the start")
			r_template = pick(start_room_templates)
			r_template.load(T, centered = TRUE, orientation = SOUTH, post_init = 1)
		if("end")
			r_template = pick(end_room_templates)
			r_template.load(T, centered = TRUE, orientation = SOUTH, post_init = 1)
		if("normal")
			r_template = pick(room_templates)
			while(disallowed)
				r_template = pick(room_templates)
				sleep(2)
				if(c_room.above)
					if(prob(60))
						r_template = pick(above_room_templates)
			/*	if(c_room.under)
					if(prob(60))
						r_template = pick(under_room_templates)**/
				else if (!c_room.above)
					if(prob(40))
						r_template = pick(horizontal_room_templates)
				//testing("Repeating - [get_room_by_num(prevnum).template.name] - [r_template.name]")
				if(can_generate(roomnumber, r_template))
					if(can_connect(roomnumber, prevnum, r_template))
						//testing("yote")
						disallowed = 0
			r_template.load(T, centered = TRUE, orientation = SOUTH, post_init = 1)

		if("dead_end")
			var/tries = 7
			r_template = pick(special_rooms)
			while(tries)
				tries--
				r_template = pick(special_rooms)
				sleep(2)
				//testing("DEAD END REPEAT - [get_room_by_num(prevnum).template.name] - [r_template.name]")
				if(can_generate(roomnumber, r_template))
					if(can_connect(roomnumber, prevnum, r_template))
						//testing("yote")
						tries = 0
						disallowed = 0
			if(!disallowed)
				r_template.load(T, centered = TRUE, orientation = SOUTH, post_init = 1)
	c_room.template = r_template
	if(!disallowed)
		return 1

