///room number
///1 - 2 - 3 - 4
///5 - 6 - 7 - 8
///9 - 10 - 11 - 12
///13 -14 - 15 - 16
/obj/crawler/map_maker
	name = "mapgen"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x3"
	alpha = 120
	anchored = 1
	unacidable = 1
	simulated = 0
	invisibility = 101
	var/generated = 0
	var/area/crawler/myarea
	var/rooms = list()
	var/occupied_rooms = list()
	var/lane1 = list()
	var/lane2 = list()
	var/lane3 = list()
	var/lane4 = list()

/obj/crawler/map_maker/New()
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

	generate_the_dungeon()

/obj/crawler/map_maker/proc/get_room_by_num(var/num)
	for(var/obj/crawler/room_controller/RC in rooms)
		if(RC.roomnum == num)
			return RC

/obj/crawler/map_maker/proc/get_room_num_under(var/num)
	if(num > 12)
		return 0
	else return (num+4)


/obj/crawler/map_maker/proc/generate_the_dungeon()
	while(1)
		if(Master.current_runlevel)
			break
		else
			sleep(250)
	var/path_to_end = list()
	var/obj/crawler/room_controller/starting_room = pick(lane1)//picking starting room
	var/obj/crawler/room_controller/exit_room = pick(lane4)//picking exit room
	path_to_end += starting_room
	occupied_rooms += starting_room
	while(!generated)
		generate_the_fucking_dungeon_please()

