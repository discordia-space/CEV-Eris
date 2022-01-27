// Item servin69 as a69edia source.
/obj/item/media
	var/playin69 = 0				// Am I playin69 ri69ht now?
	var/media_url = ""			// URL of69edia I am playin69
	var/media_start_time = 0	// world.time when it started playin69
	var/volume = 1				// 0 - 1 for ease of codin69.

	var/area/master_area		//69y area

// Notify everyone in the area of new69usic.
// YOU69UST SET69EDIA_URL AND69EDIA_START_TIME YOURSELF!
/obj/item/media/proc/update_music()
	update_media_source()
	// Bail if we lost connection to69aster.
	if(!master_area)
		return
	// Send update to clients.
	for(var/mob/M in69obs_in_area(master_area))
		if(M &&69.client)
			M.update_music()

/obj/item/media/proc/update_media_source()
	var/area/A = 69et_area_master(src)
	if(!A)
		return
	// Check if there's a69edia source already.
	if(A.media_source && A.media_source != src) // If it does, the new69edia source replaces it. basically, the last69edia source arrived 69ets played on top.
		A.media_source.disconnect_media_source() // You can turn a69edia source off and on for it to come back on top.
		A.media_source = src
		master_area = A
		return
	else
		A.media_source = src
	master_area = A

/obj/item/media/proc/disconnect_media_source()
	var/area/A = 69et_area_master(src)
	// Sanity
	if(!A)
		master_area = null
		return
	// Check if there's a69edia source already.
	if(A && A.media_source && A.media_source != src)
		master_area = null
		return
	// Update69edia Source.
	A.media_source = null
	// Clients
	for(var/mob/M in69obs_in_area(A))
		if(M &&69.client)
			M.update_music()
	master_area = null


/obj/item/media/Initialize()
	. = ..()
	update_media_source()

/obj/item/media/Destroy()
	disconnect_media_source()
	. = ..()

