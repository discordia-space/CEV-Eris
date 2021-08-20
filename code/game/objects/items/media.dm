// Item serving as a media source.
/obj/item/media
	var/playing = 0				// Am I playing right now?
	var/media_url = ""			// URL of media I am playing
	var/media_start_time = 0	// world.time when it started playing
	var/volume = 1				// 0 - 1 for ease of coding.

	var/area/master_area		// My area

// Notify everyone in the area of new music.
// YOU MUST SET MEDIA_URL AND MEDIA_START_TIME YOURSELF!
/obj/item/media/proc/update_music()
	update_media_source()
	// Bail if we lost connection to master.
	if(!master_area)
		return
	// Send update to clients.
	for(var/mob/M in mobs_in_area(master_area))
		if(M && M.client)
			M.update_music()

/obj/item/media/proc/update_media_source()
	var/area/A = get_area_master(src)
	if(!A)
		return
	// Check if there's a media source already.
	if(A.media_source && A.media_source != src) // If it does, the new media source replaces it. basically, the last media source arrived gets played on top.
		A.media_source.disconnect_media_source() // You can turn a media source off and on for it to come back on top.
		A.media_source = src
		master_area = A
		return
	else
		A.media_source = src
	master_area = A

/obj/item/media/proc/disconnect_media_source()
	var/area/A = get_area_master(src)
	// Sanity
	if(!A)
		master_area = null
		return
	// Check if there's a media source already.
	if(A && A.media_source && A.media_source != src)
		master_area = null
		return
	// Update Media Source.
	A.media_source = null
	// Clients
	for(var/mob/M in mobs_in_area(A))
		if(M && M.client)
			M.update_music()
	master_area = null


/obj/item/media/Initialize()
	. = ..()
	update_media_source()

/obj/item/media/Destroy()
	disconnect_media_source()
	. = ..()

