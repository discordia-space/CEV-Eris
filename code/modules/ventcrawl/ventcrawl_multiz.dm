/obj/machinery/atmospherics/pipe/zpipe/up/verb/ventcrawl_move_up()
	set name = "Ventcrawl Upwards"
	set desc = "Climb up through a pipe."
	set category = "Abilities"
	set src = usr.loc
	handle_z_crawl(usr, UP)

/obj/machinery/atmospherics/pipe/zpipe/down/verb/ventcrawl_move_down()
	set name = "Ventcrawl Downwards"
	set desc = "Climb down through a pipe."
	set category = "Abilities"
	set src = usr.loc
	handle_z_crawl(usr, DOWN)

/obj/machinery/atmospherics/pipe/zpipe/Entered(atom/movable/Obj)
	if(istype(Obj, /mob/living))
		var/mob/living/L = Obj
		to_chat(L, span("notice", "You are in a vertical pipe section. Use <a href='?src=\ref[src];crawl_user=\ref[L];crawl_dir=[travel_direction]'>[travel_verbname]</a> from the IC menu to [travel_direction_verb] a level."))
	. = ..()

/obj/machinery/atmospherics/pipe/zpipe/Topic(href, href_list)
	. = ..()
	if (href_list["crawl_user"])
		var/mob/living/L = locate(href_list["crawl_user"])
		var/direction = text2num(href_list["crawl_dir"])
		if (istype(L))
			return handle_z_crawl(L, direction)

/obj/machinery/atmospherics/pipe/zpipe/proc/check_ventcrawl(var/turf/target)
	if(!istype(target))
		return
	if(node1 in target)
		return node1
	if(node2 in target)
		return node2
	return

/obj/machinery/atmospherics/proc/can_z_crawl(var/mob/living/L, var/direction)
	return FALSE

/obj/machinery/atmospherics/pipe/zpipe/can_z_crawl(var/mob/living/L, var/direction)
	if(L.is_ventcrawling && L.loc == src)
		if(node2 && check_connect_types(node2,src))
			if(direction == travel_direction)
				return TRUE


/obj/machinery/atmospherics/proc/handle_z_crawl(var/mob/living/L, var/direction)
	return

/obj/machinery/atmospherics/pipe/zpipe/handle_z_crawl(var/mob/living/L, var/direction)
	if (!can_z_crawl(L, direction))
		to_chat(L, span("notice", "You can't climb that way!."))
		return
	to_chat(L, span("notice", "You start climbing [travel_direction_name] the pipe. This will take a while..."))
	playsound(loc, 'sound/machines/ventcrawl.ogg', 100, 1, 3)
	if(!do_after(L, 50, needhand = 0, target = get_turf(src)) || !can_z_crawl(L, direction))
		to_chat(L, span("danger", "You gave up on climbing [travel_direction_name] the pipe."))
		return FALSE
	return ventcrawl_to(L, node2, null)