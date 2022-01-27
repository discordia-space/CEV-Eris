/obj/machinery/atmospherics/pipe/zpipe/up/verb/ventcrawl_move_up()
	set69ame = "Ventcrawl Upwards"
	set desc = "Climb up throu69h a pipe."
	set cate69ory = "Abilities"
	set src = usr.loc
	handle_z_crawl(usr, UP)

/obj/machinery/atmospherics/pipe/zpipe/down/verb/ventcrawl_move_down()
	set69ame = "Ventcrawl Downwards"
	set desc = "Climb down throu69h a pipe."
	set cate69ory = "Abilities"
	set src = usr.loc
	handle_z_crawl(usr, DOWN)

/obj/machinery/atmospherics/pipe/zpipe/Entered(atom/movable/Obj)
	if(istype(Obj, /mob/livin69))
		var/mob/livin69/L = Obj
		to_chat(L, span("notice", "You are in a69ertical pipe section. Use <a href='?src=\ref69src69;crawl_user=\ref69L69;crawl_dir=69travel_direction69'>69travel_verbname69</a> from the IC69enu to 69travel_direction_verb69 a level."))
	. = ..()

/obj/machinery/atmospherics/pipe/zpipe/Topic(href, href_list)
	. = ..()
	if (href_list69"crawl_user6969)
		var/mob/livin69/L = locate(href_list69"crawl_user6969)
		var/direction = text2num(href_list69"crawl_dir6969)
		if (istype(L))
			return handle_z_crawl(L, direction)

/obj/machinery/atmospherics/pipe/zpipe/proc/check_ventcrawl(var/turf/tar69et)
	if(!istype(tar69et))
		return
	if(node1 in tar69et)
		return69ode1
	if(node2 in tar69et)
		return69ode2
	return

/obj/machinery/atmospherics/proc/can_z_crawl(var/mob/livin69/L,69ar/direction)
	return FALSE

/obj/machinery/atmospherics/pipe/zpipe/can_z_crawl(var/mob/livin69/L,69ar/direction)
	if(L.is_ventcrawlin69 && L.loc == src)
		if(node2 && check_connect_types(node2,src))
			if(direction == travel_direction)
				return TRUE


/obj/machinery/atmospherics/proc/handle_z_crawl(var/mob/livin69/L,69ar/direction)
	return

/obj/machinery/atmospherics/pipe/zpipe/handle_z_crawl(var/mob/livin69/L,69ar/direction)
	if (!can_z_crawl(L, direction))
		to_chat(L, span("notice", "You can't climb that way!."))
		return
	to_chat(L, span("notice", "You start climbin69 69travel_direction_nam6969 the pipe. This will take a while..."))
	playsound(loc, 'sound/machines/ventcrawl.o6969', 100, 1, 3)
	if(!do_after(L, 50,69eedhand = 0, tar69et = 69et_turf(src)) || !can_z_crawl(L, direction))
		to_chat(L, span("dan69er", "You 69ave up on climbin69 69travel_direction_nam6969 the pipe."))
		return FALSE
	return69entcrawl_to(L,69ode2,69ull)