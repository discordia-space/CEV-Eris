/obj/item/blueprints
	name = "ship blueprints"
	desc = "Blueprints of the CEV Eris. There is a \"Classified\" stamp and several coffee stains on it."
	icon = 'icons/obj/items.dmi'
	icon_state = "blueprints"
	attack_verb = list("attacked", "bapped", "hit")
	spawn_blacklisted = TRUE//antag_item_targets
	var/const/AREA_ERRNONE = 0
	var/const/AREA_STATION = 1
	var/const/AREA_SPACE =   2
	var/const/AREA_SPECIAL = 3

	var/const/BORDER_ERROR = 0
	var/const/BORDER_NONE = 1
	var/const/BORDER_BETWEEN =   2
	var/const/BORDER_2NDTILE = 3
	var/const/BORDER_SPACE = 4

	var/const/ROOM_ERR_LOLWAT = 0
	var/const/ROOM_ERR_SPACE = -1
	var/const/ROOM_ERR_TOOLARGE = -2

/obj/item/blueprints/attack_self(mob/M as69ob)
	if (!ishuman(M))
		to_chat(M, "This stack of blue paper69eans nothing to you." ) //monkeys cannot into projecting
		return
	interact()
	return

/obj/item/blueprints/Topic(href, href_list)
	..()
	if ((usr.restrained() || usr.stat || usr.get_active_hand() != src))
		return
	if (!href_list69"action"69)
		return
	switch(href_list69"action"69)
		if ("create_area")
			if (get_area_type()!=AREA_SPACE)
				interact()
				return
			create_area()
		if ("edit_area")
			if (get_area_type()!=AREA_STATION)
				interact()
				return
			edit_area()

/obj/item/blueprints/interact()
	var/area/A = get_area(usr)
	var/text = {"<HTML><head><title>69src69</title></head><BODY>
<h2>69station_name()69 blueprints</h2>
<small>Property of 69company_name69. For heads of staff only. Store in high-secure storage.</small><hr>
"}
	switch (get_area_type())
		if (AREA_SPACE)
			text += {"
<p>According the blueprints, you are now in <b>outer space</b>.  Hold your breath.</p>
<p><a href='?src=\ref69src69;action=create_area'>Mark this place as new area.</a></p>
"}
		if (AREA_STATION)
			text += {"
<p>According the blueprints, you are now in <b>\"69A.name69\"</b>.</p>
<p>You69ay <a href='?src=\ref69src69;action=edit_area'>
move an amendment</a> to the drawing.</p>
"}
		if (AREA_SPECIAL)
			text += {"
<p>This place isn't noted on the blueprint.</p>
"}
		else
			return
	text += "</BODY></HTML>"
	usr << browse(text, "window=blueprints")
	onclose(usr, "blueprints")

/obj/item/blueprints/proc/get_area_type(var/area/A = get_area(usr))
	if(istype(A, /area/space))
		return AREA_SPACE
	var/list/SPECIALS = list(
		/area/shuttle,
		/area/admin,
		/area/arrival,
		/area/centcom,
		/area/asteroid,
		/area/wizard_station,
		// /area/derelict //commented out, all hail derelict-rebuilders!
	)
	for (var/type in SPECIALS)
		if ( istype(A,type) )
			return AREA_SPECIAL
	return AREA_STATION

/obj/item/blueprints/proc/create_area()
	//world << "DEBUG: create_area"
	var/res = detect_room(get_turf(usr))
	if(!istype(res,/list))
		switch(res)
			if(ROOM_ERR_SPACE)
				to_chat(usr, SPAN_WARNING("The new area69ust be completely airtight!"))
				return
			if(ROOM_ERR_TOOLARGE)
				to_chat(usr, SPAN_WARNING("The new area too large!"))
				return
			else
				to_chat(usr, SPAN_WARNING("Error! Please notify administration!"))
				return
	var/list/turf/turfs = res
	var/str = sanitizeSafe(input("New area name:","Blueprint Editing", ""),69AX_NAME_LEN)
	if(!str || !length(str)) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, SPAN_WARNING("Name too long."))
		return
	var/area/A = new
	A.name = str
	//var/ma
	//ma = A.master ? "69A.master69" : "(null)"
	//world << "DEBUG: create_area: <br>A.name=69A.name69<br>A.tag=69A.tag69<br>A.master=69ma69"
	A.power_e69uip = 0
	A.power_light = 0
	A.power_environ = 0
	A.always_unpowered = 0
	move_turfs_to_area(turfs, A)

	A.always_unpowered = 0

	spawn(5)
		//ma = A.master ? "69A.master69" : "(null)"
		//world << "DEBUG: create_area(5): <br>A.name=69A.name69<br>A.tag=69A.tag69<br>A.master=69ma69"
		interact()
	return


/obj/item/blueprints/proc/move_turfs_to_area(var/list/turf/turfs,69ar/area/A)
	A.contents.Add(turfs)
		//oldarea.contents.Remove(usr.loc) // not needed
		//T.loc = A //error: cannot change constant69alue


/obj/item/blueprints/proc/edit_area()
	var/area/A = get_area(usr)
	//world << "DEBUG: edit_area"
	var/prevname = "69A.name69"
	var/str = sanitizeSafe(input("New area name:","Blueprint Editing", prevname),69AX_NAME_LEN)
	if(!str || !length(str) || str==prevname) //cancel
		return
	if(length(str) > 50)
		to_chat(usr, SPAN_WARNING("Text too long."))
		return
	set_area_machinery_title(A,str,prevname)
	A.name = str
	to_chat(usr, SPAN_NOTICE("You set the area '69prevname69' title to '69str69'."))
	interact()
	return



/obj/item/blueprints/proc/set_area_machinery_title(var/area/A,var/title,var/oldtitle)
	if (!oldtitle) // or replacetext goes to infinite loop
		return

	for(var/obj/machinery/alarm/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	for(var/obj/machinery/power/apc/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	for(var/obj/machinery/atmospherics/unary/vent_scrubber/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	for(var/obj/machinery/atmospherics/unary/vent_pump/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	for(var/obj/machinery/door/M in A)
		M.name = replacetext(M.name,oldtitle,title)
	//TODO:69uch69uch69ore. Unnamed airlocks, cameras, etc.

/obj/item/blueprints/proc/check_tile_is_border(var/turf/T2,var/dir)
	if (istype(T2, /turf/space))
		return BORDER_SPACE //omg hull breach we all going to die here
	if (istype(T2, /turf/simulated/shuttle))
		return BORDER_SPACE
	if (get_area_type(T2.loc)!=AREA_SPACE)
		return BORDER_BETWEEN
	if (istype(T2, /turf/simulated/wall))
		return BORDER_2NDTILE
	if (!istype(T2, /turf/simulated))
		return BORDER_BETWEEN

	for (var/obj/structure/window/W in T2)
		if(turn(dir,180) == W.dir)
			return BORDER_BETWEEN
		if (W.dir in list(NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST))
			return BORDER_2NDTILE
	for(var/obj/machinery/door/window/D in T2)
		if(turn(dir,180) == D.dir)
			return BORDER_BETWEEN
	if (locate(/obj/machinery/door) in T2)
		return BORDER_2NDTILE

	return BORDER_NONE

/obj/item/blueprints/proc/detect_room(var/turf/first)
	var/list/turf/found = new
	var/list/turf/pending = list(first)
	while(pending.len)
		if (found.len+pending.len > 300)
			return ROOM_ERR_TOOLARGE
		var/turf/T = pending69169 //why byond havent list::pop()?
		pending -= T
		for (var/dir in cardinal)
			var/skip = 0
			for (var/obj/structure/window/W in T)
				if(dir == W.dir || (W.dir in list(NORTHEAST,SOUTHEAST,NORTHWEST,SOUTHWEST)))
					skip = 1; break
			if (skip) continue
			for(var/obj/machinery/door/window/D in T)
				if(dir == D.dir)
					skip = 1; break
			if (skip) continue

			var/turf/NT = get_step(T,dir)
			if (!isturf(NT) || (NT in found) || (NT in pending))
				continue

			switch(check_tile_is_border(NT,dir))
				if(BORDER_NONE)
					pending+=NT
				if(BORDER_BETWEEN)
					//do nothing,69ay be later i'll add 'rejected' list as optimization
				if(BORDER_2NDTILE)
					found+=NT //tile included to new area, but we dont seek69ore
				if(BORDER_SPACE)
					return ROOM_ERR_SPACE
		found+=T
	return found
