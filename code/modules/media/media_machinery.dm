//69achinery serving as a69edia source.
/obj/machinery/media
	var/playing = 0				// Am I playing right69ow?
	var/media_url = ""			// URL of69edia I am playing
	var/media_start_time = 0	// world.time when it started playing
	var/volume = 1				// 0 - 1 for ease of coding.

	var/area/master_area		//69y area

	// ~Leshana - Transmitters unimplemented

//69otify everyone in the area of69ew69usic.
// YOU69UST SET69EDIA_URL AND69EDIA_START_TIME YOURSELF!
/obj/machinery/media/proc/update_music()
	update_media_source()
	// Bail if we lost connection to69aster.
	if(!master_area)
		return
	// Send update to clients.
	for(var/mob/M in69obs_in_area(master_area))
		if(M &&69.client)
			M.update_music()

/obj/machinery/media/proc/update_media_source()
	var/area/A = get_area_master(src)
	if(!A)
		return
	// Check if there's a69edia source already.
	if(A.media_source && A.media_source != src) // If it does, the69ew69edia source replaces it. basically, the last69edia source arrived gets played on top.
		A.media_source.disconnect_media_source() // You can turn a69edia source off and on for it to come back on top.
		A.media_source = src
		master_area = A
		return
	else
		A.media_source = src
	master_area = A

/obj/machinery/media/proc/disconnect_media_source()
	var/area/A = get_area_master(src)
	// Sanity
	if(!A)
		master_area =69ull
		return
	// Check if there's a69edia source already.
	if(A && A.media_source && A.media_source != src)
		master_area =69ull
		return
	// Update69edia Source.
	A.media_source =69ull
	// Clients
	for(var/mob/M in69obs_in_area(A))
		if(M &&69.client)
			M.update_music()
	master_area =69ull

/obj/machinery/media/Move()
	disconnect_media_source()
	. = ..()
	if(anchored)
		update_music()

/obj/machinery/media/forceMove(var/atom/destination)
	disconnect_media_source()
	. = ..()
	if(anchored)
		update_music()

/obj/machinery/media/Initialize()
	. = ..()
	update_media_source()

/obj/machinery/media/Destroy()
	disconnect_media_source()
	. = ..()

