/**********************
 * AWW SHIT IT'S TIME FOR RADIO
 *
 * Concept stolen from D2K5
 * Rewritten by693X15 for69gstation
 * Adapted by Leshana for69OREStation
 * Stolen for Eris by69estor
 ***********************/

// Uncomment to test the69ediaplayer
// #define DEBUG_MEDIAPLAYER

#ifdef DEBUG_MEDIAPLAYER
#define69P_DEBUG(x) to_chat(owner,x)
#warn Please comment out #define DEBUG_MEDIAPLAYER before committing.
#else
#define69P_DEBUG(x)
#endif

// Set up player on login.
/client/New()
	. = ..()
	media =69ew /datum/media_manager(src)
	media.open()
	media.update_music()

// Stop69edia when the round ends. I guess so it doesn't play forever or something (for some reason?)
/hook/roundend/proc/stop_all_media()
	log_debug("Stopping all playing69edia...")
	// Stop all69usic.
	for(var/mob/M in SSmobs.mob_list)
		if(M &&69.client)
			M.stop_all_music()
	//  SHITTY HACK TO AVOID RACE CONDITION WITH SERVER REBOOT.
	sleep(10)  // TODO - Leshana - see if this is69eeded

// Update when69oving between areas.
// TODO - While this direct override69ight technically be faster, probably better code to use observer or hooks ~Leshana
/area/Entered(A)
	//69ote, we cannot call ..() first, because it would update lastarea.
	if(!isliving(A))
		return ..()
	var/mob/living/M = A
	// Optimization,69o69eed to call update_music() if both are69ull (or same instance, strange as that would be)
	if(M.lastarea != src && src.media_source)
		if(M.lastarea?.media_source == src.media_source)
			return ..()
	if(M.client &&69.client.media && !M.client.media.forced)
		M.update_music()
	return ..()

//
// ###69edia69ariable on /client ###
/client
	// Set on Login
	var/datum/media_manager/media =69ull

/client/verb/change_volume()
	set69ame = "Set69olume"
	set category = "OOC"
	set desc = "Set jukebox69olume"
	set_new_volume(usr)

/client/proc/set_new_volume(var/mob/user)
	if(!69DELETED(src.media) || !istype(src.media))
		to_chat(user, "<span class='warning'>You have69o69edia datum to change, if you're69ot in the lobby tell an admin.</span>")
		return
	var/value = input("Choose your Jukebox69olume.", "Jukebox69olume",69edia.volume)
	value = round(max(0,69in(100,69alue)))
	media.update_volume(value)

//
// ###69edia procs on69obs ###
// These are all convenience functions, simple delegations to the69edia datum on69ob.
// But their presense and69ull checks69ake other coder's life69uch easier.
//

/mob/proc/update_music()
	if (client && client.media && !client.media.forced)
		client.media.update_music()

/mob/proc/stop_all_music()
	if (client && client.media)
		client.media.stop_music()

/mob/proc/force_music(var/url,69ar/start,69ar/volume=1)
	if (client && client.media)
		if(url == "")
			client.media.forced = 0
			client.media.update_music()
		else
			client.media.forced = 1
			client.media.push_music(url, start,69olume)
	return

//
// ### Define69edia source to areas ###
// Each area69ay have at69ost one69edia source that plays songs into that area.
// We keep track of that source so any69ob entering the area can lookup what to play.
//
/area
	// For69ow, only one69edia source per area allowed
	// Possible Future: turn into a list, then only play the first one that's playing.
	var/obj/machinery/media/media_source =69ull

//
// ###69edia69anager Datum
//

/datum/media_manager
	var/url = ""				// URL of currently playing69edia
	var/start_time = 0			// world.time when it started playing *in the source* (Not when started playing for us)
	var/source_volume = 1		//69olume as set by source. Actual69olume = "volume * source_volume"
	var/rate = 1				// Playback speed.  For Fun(tm)
	var/volume = 50				// Client's69olume69odifier. Actual69olume = "volume * source_volume"
	var/client/owner			// Client this is actually running in
	var/forced=0				// If true, current url overrides area69edia sources
	var/playerstyle				// Choice of which player plugin to use
	var/const/WINDOW_ID = "rpane.mediapanel"	// Which elem in skin.dmf to use

/datum/media_manager/New(var/client/C)
	ASSERT(istype(C))
	src.owner = C

// Actually pop open the player in the background.
/datum/media_manager/proc/open()
	if(!owner.prefs)
		return
	if(isnum(owner.prefs.media_volume))
		volume = owner.prefs.media_volume
	switch(owner.prefs.media_player)
		if(0)
			playerstyle = PLAYER_VLC_HTML
		if(1)
			playerstyle = PLAYER_WMP_HTML
		if(2)
			playerstyle = PLAYER_HTML5_HTML
	owner << browse(null, "window=69WINDOW_ID69")
	owner << browse(playerstyle, "window=69WINDOW_ID69")
	send_update()

// Tell the player to play something69ia JS.
/datum/media_manager/proc/send_update()
	if(!(owner.prefs))
		return
	if(owner.get_preference_value(/datum/client_preference/play_jukebox) == GLOB.PREF_NO && url != "")
		return // Don't send anything other than a cancel to people with SOUND_STREAMING pref disabled
	MP_DEBUG("<span class='good'>Sending update to69ediapanel (69url69, 69(world.time - start_time) / 1069, 69volume * source_volume69)...</span>")
	owner << output(list2params(list(url, (world.time - start_time) / 10,69olume * source_volume)), "69WINDOW_ID69:SetMusic")

/datum/media_manager/proc/push_music(var/targetURL,69ar/targetStartTime,69ar/targetVolume)
	if (url != targetURL || abs(targetStartTime - start_time) > 1 || abs(targetVolume - source_volume) > 0.1 /* 10% */)
		url = targetURL
		start_time = targetStartTime
		source_volume = CLAMP(targetVolume, 0, 1)
		send_update()

/datum/media_manager/proc/stop_music()
	push_music("", 0, 1)

/datum/media_manager/proc/update_volume(var/value)
	volume =69alue
	send_update()

// Scan for69edia sources and use them.
/datum/media_manager/proc/update_music()
	var/targetURL = ""
	var/targetStartTime = 0
	var/targetVolume = 0

	if (forced || !owner || !owner.mob)
		return

	var/area/A = get_area_master(owner.mob)
	if(!A)
		MP_DEBUG("client=69owner69,69ob=69owner.mob6969ot in an area! loc=69owner.mob.loc69.  Aborting.")
		stop_music()
		return
	var/obj/machinery/media/M = A.media_source
	if(M &&69.playing)
		targetURL =69.media_url
		targetStartTime =69.media_start_time
		targetVolume =69.volume
		//MP_DEBUG("Found audio source: 69M.media_url69 @ 69(world.time - start_time) / 1069s.")
	push_music(targetURL, targetStartTime, targetVolume)
