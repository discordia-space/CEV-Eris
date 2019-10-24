///room number, in order to avoid confusion, we're counting up from 1 and not 0.
///1 - 2 - 3 - 4
///5 - 6 - 7 - 8
///9 - 10 - 11 - 12
///13 -14 - 15 - 16 - I really should've gone with X and Y coordinate system - done, and it also counts from 1 instead of 0
/obj/crawler/map_maker
	name = "mapgen"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	alpha = 120
	anchored = 1
	unacidable = 1
	simulated = 0
	invisibility = 101
	var/max_x = 4 //if we ever make more than 4x4 dungeon run map, instead of making new procs for generation, we can just edit those vars
	var/max_y = 4
	var/generating = 0
	var/area/crawler/myarea
	var/rooms = list()
	var/occupied_rooms = list()
	var/lane1 = list()
	var/lane2 = list()
	var/lane3 = list()
	var/lane4 = list()
	var/list/start_room_templates = list()
	var/list/room_templates = list()
	var/list/end_room_templates = list()

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

		room_templates += S


	myarea = get_area(loc)
	for(var/obj/crawler/room_controller/RC in myarea.room_controllers)
		rooms += RC
		if(RC.roomnum <= 4)
			lane1 += RC
		else if(RC.roomnum <= 8)
			lane2 += RC
		else if(RC.roomnum <= 12)
			lane3 += RC
		else if(RC.roomnum <= 16)
			lane4 += RC
	sleep(100)
	generate_dungeon()


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
	var/obj/crawler/room_controller/starting_room = pick(lane1)//picking starting room
	occupied_rooms += starting_room
	generating = 1
	var/room_generating = starting_room.roomnum
	generate_room(starting_room.roomnum, "start")
	while(generating)
		if(is_generated(room_generating))
			var/next = pick(get_adjacent(room_generating))
			if(prob(70) && next)//so it doesn't alway hit the side and only then go down
				room_generating = next
				continue
			var/under = get_room_num_under(room_generating)
			if(under)
				testing("under room number is:")
				room_generating = under
				testing(room_generating)
				continue
			else
				generating = 0
				if(next)
					room_generating = next
		if(generating)
			occupied_rooms += get_room_by_num(room_generating)
			generate_room(room_generating, "normal")
			testing("Generated the mundane room with number:")
			testing(room_generating)
		else
			generate_room(room_generating, "end")
			occupied_rooms += get_room_by_num(room_generating)
			testing("end room number is:")
			testing(room_generating)
			testing("Created the end")
			break

/*if(is_generated(room_generating))
			//picking the next room
			var/next = pick(get_adjacent(room_generating))
			if(prob(70))//so it doesn't alway hit the side and only then go down
				if(next)
					room_generating = next
				else
					room_generating = get_room_num_under(room_generating) //if there is no available rooms on the sides, go down
			if (get_room_num_under(room_generating) && !next)
				room_generating = get_room_num_under(room_generating)
			else
				generating = 0
				generate_room(room_generating, "end")
				break
		else
			occupied_rooms += get_room_by_num(room_generating)
			generate_room(room_generating, "normal")*/


	sleep(200)
	var/obj/crawler/room_controller/previous_room = starting_room
	for(var/obj/crawler/room_controller/c_room in occupied_rooms)
		testing(c_room.roomnum)
		if(c_room == previous_room)
			continue
		else
			previous_room.connect(c_room)
		previous_room = c_room
	sleep(1)
	for(var/turf/simulated/wall/W in block(locate(1, 1, z), locate(54, 38, z)))
		W.update_connections(1)



/obj/crawler/map_maker/proc/generate_room(var/roomnumber, var/roomtype)
	var/datum/map_template/r_template = null
	var/turf/T = get_turf(get_room_by_num(roomnumber))
	T = get_step(T, NORTHWEST)
	T = get_step(T, NORTHWEST)
	switch(roomtype)
		if("start")
			testing("Generated the start")
			r_template = pick(start_room_templates)
			r_template.load(T, centered = TRUE, orientation = SOUTH)
		if("end")
			r_template = pick(end_room_templates)
			r_template.load(T, centered = TRUE, orientation = SOUTH)
		if("normal")
			r_template = pick(room_templates)
			r_template.load(T, centered = TRUE, orientation = SOUTH)


