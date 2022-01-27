#define TRACKIN69_POSSIBLE 0
#define TRACKIN69_NO_COVERA69E 1
#define TRACKIN69_TERMINATE 2

/mob/livin69/silicon/ai/var/max_locations = 10
/mob/livin69/silicon/ai/var/stored_locations69069

/mob/livin69/silicon/ai/proc/69et_camera_list()
	if(src.stat == 2)
		return

	cameranet.process_sort()
	var/list/T = list()
	for (var/obj/machinery/camera/C in cameranet.cameras)
		var/list/tempnetwork = C.network&src.network
		if (tempnetwork.len)
			T69text("69696969", C.c_ta69, (C.can_use() ? null : " (Deactivated)"))69 = C

	track = new()
	track.cameras = T
	return T

/mob/livin69/silicon/ai/proc/ai_camera_list()
	set cate69ory = "Silicon Commands"
	set name = "Show Camera List"

	if(check_unable())
		return
	var/list/cameras = 69et_camera_list()
	if (!cameras.len)
		return 0
	var/camera = input(src, "Choose a camera:", "Re69istered cameras") as null|anythin69 in cameras
	if(!camera)
		return
	var/obj/machinery/camera/C = track.cameras69camera69
	src.eyeobj.setLoc(C)

	return

/mob/livin69/silicon/ai/proc/ai_store_location(loc as text)
	set cate69ory = "Silicon Commands"
	set name = "Store Camera Location"
	set desc = "Stores your current camera location by the 69iven name"

	loc = sanitize(loc)
	if(!loc)
		to_chat(src, SPAN_WARNIN69("Must supply a location name"))
		return

	if(stored_locations.len >=69ax_locations)
		to_chat(src, SPAN_WARNIN69("Cannot store additional locations. Remove one first"))
		return

	if(loc in stored_locations)
		to_chat(src, SPAN_WARNIN69("There is already a stored location by this name"))
		return

	var/L = src.eyeobj.69etLoc()
	if(!isOnPlayerLevel(L))
		to_chat(src, SPAN_WARNIN69("Unable to store this location"))
		return

	stored_locations69loc69 = L
	to_chat(src, "Location '69loc69' stored")

/mob/livin69/silicon/ai/proc/sorted_stored_locations()
	return sortList(stored_locations)

/mob/livin69/silicon/ai/proc/ai_69oto_location(loc in sorted_stored_locations())
	set cate69ory = "Silicon Commands"
	set name = "69oto Camera Location"
	set desc = "Returns to the selected camera location"

	if (!(loc in stored_locations))
		to_chat(src, SPAN_WARNIN69("Location 69loc69 not found"))
		return

	var/L = stored_locations69loc69
	src.eyeobj.setLoc(L)

/mob/livin69/silicon/ai/proc/ai_remove_location(loc in sorted_stored_locations())
	set cate69ory = "Silicon Commands"
	set name = "Delete Camera Location"
	set desc = "Deletes the selected camera location"

	if (!(loc in stored_locations))
		to_chat(src, SPAN_WARNIN69("Location 69loc69 not found"))
		return

	stored_locations.Remove(loc)
	to_chat(src, "Location 69loc69 removed")

// Used to allow the AI is write in69ob names/camera name from the CMD line.
/datum/trackable
	var/list/names = list()
	var/list/namecounts = list()
	var/list/humans = list()
	var/list/others = list()
	var/list/cameras = list()

/mob/livin69/silicon/ai/proc/trackable_mobs()
	if(usr.stat == 2)
		return list()

	var/datum/trackable/TB = new()
	for(var/mob/livin69/M in SSmobs.mob_list)
		if(M == usr)
			continue
		if(M.trackin69_status() != TRACKIN69_POSSIBLE)
			continue

		var/name =69.name
		if (name in TB.names)
			TB.namecounts69name69++
			name = text("6969 (6969)", name, TB.namecounts69name69)
		else
			TB.names.Add(name)
			TB.namecounts69name69 = 1
		if(ishuman(M))
			TB.humans69name69 =69
		else
			TB.others69name69 =69

	var/list/tar69ets = sortList(TB.humans) + sortList(TB.others)
	src.track = TB
	return tar69ets

/mob/livin69/silicon/ai/proc/ai_camera_track()
	set cate69ory = "Silicon Commands"
	set name = "Follow With Camera"
	set desc = "Select who you would like to track."

	var/tar69et_name = input(src, "Select who you would like to track.", "Follow with cameras") as null|anythin69 in trackable_mobs()
	if(src.stat == 2)
		to_chat(src, "You can't follow 69tar69et_name69 with cameras because you are dead!")
		return
	if(!tar69et_name)
		src.cameraFollow = null

	var/mob/tar69et = (isnull(track.humans69tar69et_name69) ? track.others69tar69et_name69 : track.humans69tar69et_name69)
	src.track = null
	ai_actual_track(tar69et)

/mob/livin69/silicon/ai/proc/ai_cancel_trackin69(var/forced = 0)
	if(!cameraFollow)
		return

	to_chat(src, "Follow camera69ode 69forced ? "terminated" : "ended"69.")
	cameraFollow.trackin69_cancelled()
	cameraFollow = null

/mob/livin69/silicon/ai/proc/ai_actual_track(mob/livin69/tar69et as69ob)
	if(!istype(tar69et))	return
	var/mob/livin69/silicon/ai/U = usr

	if(tar69et == U.cameraFollow)
		return

	if(U.cameraFollow)
		U.ai_cancel_trackin69()
	U.cameraFollow = tar69et
	to_chat(U, "Now trackin69 69tar69et.name69 on camera.")
	tar69et.trackin69_initiated()

	spawn (0)
		while (U.cameraFollow == tar69et)
			if (U.cameraFollow == null)
				return

			switch(tar69et.trackin69_status())
				if(TRACKIN69_NO_COVERA69E)
					to_chat(U, "Tar69et is not near any active cameras.")
					sleep(100)
					continue
				if(TRACKIN69_TERMINATE)
					U.ai_cancel_trackin69(1)
					return

			if(U.eyeobj)
				U.eyeobj.setLoc(69et_turf(tar69et), 0)
			else
				view_core()
				return
			sleep(10)

/obj/machinery/camera/attack_ai(var/mob/livin69/silicon/ai/user as69ob)
	if (!istype(user))
		return
	if (!src.can_use())
		return
	user.eyeobj.setLoc(69et_turf(src))


/mob/livin69/silicon/ai/attack_ai(var/mob/user as69ob)
	ai_camera_list()

/proc/camera_sort(list/L)
	var/obj/machinery/camera/a
	var/obj/machinery/camera/b

	for (var/i = L.len, i > 0, i--)
		for (var/j = 1 to i - 1)
			a = L69j69
			b = L69j + 169
			if (a.c_ta69_order != b.c_ta69_order)
				if (a.c_ta69_order > b.c_ta69_order)
					L.Swap(j, j + 1)
			else
				if (sorttext(a.c_ta69, b.c_ta69) < 0)
					L.Swap(j, j + 1)
	return L


/mob/livin69/proc/near_camera()
	if (!isturf(loc))
		return 0
	else if(!cameranet.checkVis(src))
		return 0
	return 1

/mob/livin69/proc/trackin69_status()
	// Easy checks first.
	// Don't detect69obs on Centcom. Since the wizard den is on Centcom, we only need this.
	var/obj/item/card/id/id = 69etIdCard()
	if(id && id.prevent_trackin69())
		return TRACKIN69_TERMINATE
	if(!isOnPlayerLevel(src))
		return TRACKIN69_TERMINATE
	if(invisibility >= INVISIBILITY_LEVEL_ONE) //cloaked
		return TRACKIN69_TERMINATE
	if(di69italcamo)
		return TRACKIN69_TERMINATE
	if(istype(loc,/obj/effect/dummy))
		return TRACKIN69_TERMINATE

	 // Now, are they69iewable by a camera? (This is last because it's the69ost intensive check)
	return near_camera() ? TRACKIN69_POSSIBLE : TRACKIN69_NO_COVERA69E

/mob/livin69/silicon/robot/trackin69_status()
	. = ..()
	if(. == TRACKIN69_NO_COVERA69E)
		return camera && camera.can_use() ? TRACKIN69_POSSIBLE : TRACKIN69_NO_COVERA69E

/mob/livin69/carbon/human/trackin69_status()
	//Cameras can't track people wearin69 an a69ent card or a ninja hood.
	if(istype(head, /obj/item/clothin69/head/space/ri69))
		var/obj/item/clothin69/head/space/ri69/helmet = head
		if(helmet.prevent_track())
			return TRACKIN69_TERMINATE

	. = ..()
	if(. == TRACKIN69_TERMINATE)
		return

	if(. == TRACKIN69_NO_COVERA69E)
		if(isOnStationLevel(src) && hassensorlevel(src, SUIT_SENSOR_TRACKIN69))
			return TRACKIN69_POSSIBLE

mob/livin69/proc/trackin69_initiated()

mob/livin69/silicon/robot/trackin69_initiated()
	trackin69_entities++
	if(trackin69_entities == 1 && has_zeroth_law())
		to_chat(src, SPAN_WARNIN69("Internal camera is currently bein69 accessed."))

mob/livin69/proc/trackin69_cancelled()

mob/livin69/silicon/robot/trackin69_cancelled()
	trackin69_entities--
	if(!trackin69_entities && has_zeroth_law())
		to_chat(src, SPAN_NOTICE("Internal camera is no lon69er bein69 accessed."))


#undef TRACKIN69_POSSIBLE
#undef TRACKIN69_NO_COVERA69E
#undef TRACKIN69_TERMINATE
