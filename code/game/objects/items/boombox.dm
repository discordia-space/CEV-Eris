//A lot of code taken from jukebox
//This is not a child object because it's an item

/obj/item/media/boombox
	name = "BL4ST4-TUN3 3000"
	desc = "A snazzy boombox, hefty enough to be carried around your shoulder."
	icon = 'icons/obj/boombox.dmi'
	icon_state = "boombox"
	item_state = "boombox"

	var/loop_mode = JUKEMODE_PLAY_ONCE			// Behavior when finished playing a song
	var/max_queue_len = 3						// How many songs are we allowed to queue up?
	var/datum/track/current_track				// Currently playing song
	var/list/datum/track/queue = list()			// Queued songs
	var/list/datum/track/tracks = list()		// Available tracks

	var/list/current_listeners = list() //People listening to boombox right now

	var/ticks_to_update = 5

	var/obj/item/music_tape/my_tape //boombox tape

	var/sanity_value = 2

/obj/item/media/boombox/New()
	AddComponent(/datum/component/atom_sanity, 0, "")
	START_PROCESSING(SSobj, src)
	..()

/obj/item/media/boombox/Destroy()
	STOP_PROCESSING(SSobj, src)

/obj/item/media/boombox/Process()
	if(ticks_to_update)
		ticks_to_update--
	else
		update_music()
		ticks_to_update = 3
	if(!playing)
		return
	// If the current track isn't finished playing, let it keep going
	if(current_track && world.time < media_start_time + current_track.duration)
		return
	// Otherwise time to pick a new one!
	if(queue.len > 0)
		current_track = queue[1]
		queue.Cut(1, 2)  // Remove the item we just took off the list
	else
		// Oh... nothing in queue? Well then pick next according to our rules
		switch(loop_mode)
			if(JUKEMODE_NEXT)
				var/curTrackIndex = max(1, tracks.Find(current_track))
				var/newTrackIndex = (curTrackIndex % tracks.len) + 1  // Loop back around if past end
				current_track = tracks[newTrackIndex]
			if(JUKEMODE_RANDOM)
				var/previous_track = current_track
				do
					current_track = pick(tracks)
				while(current_track == previous_track && tracks.len > 1)
			if(JUKEMODE_REPEAT_SONG)
				current_track = current_track
			if(JUKEMODE_PLAY_ONCE)
				current_track = null
				playing = 0
				update_icon()
	updateDialog()
	start_stop_song()

// Tells the media manager to start or stop playing based on current settings.
/obj/item/media/boombox/proc/start_stop_song()
	if(current_track && playing)
		media_url = current_track.url
		media_start_time = world.time
		visible_message(SPAN_NOTICE("\The [src] begins to play [current_track.display()]."))
	else
		media_url = ""
		media_start_time = 0
	update_music()

/obj/item/media/boombox/proc/get_people_around()
	var/list/people = list()
	for(var/mob/O in hearers(7, get_turf(src)))
		people += O

	return people

/obj/item/media/boombox/update_music()
	var/list/new_people = get_people_around()
	var/list/leavers = current_listeners - new_people
	for(var/mob/M in leavers)
		if(M && M.client)
			M.force_music("", media_start_time, volume)

	for(var/mob/N in new_people)
		if(N && N.client)
			N.force_music(media_url, media_start_time, volume)

	current_listeners = new_people

/obj/item/media/boombox/attackby(obj/item/W as obj, mob/user as mob)
	src.add_fingerprint(user)

	if(istype(W, /obj/item/music_tape))
		if(my_tape)
			to_chat(user, SPAN_NOTICE("There's already a tape inside [src]."))
		else
			my_tape = W
			user.unEquip(my_tape, src)
			my_tape.forceMove(src)
			to_chat(user, SPAN_NOTICE("You insert the tape inside [src]."))
			update_tape()
	return ..()


/obj/item/media/boombox/proc/update_tape(var/removed)
	if (!removed)
		tracks.Add(get_tape_playlist())
	else
		tracks.Remove(get_tape_playlist())
		StopPlaying()
	updateDialog()

//Added as a separate proc instead of just reading the var for a future feature
/obj/item/media/boombox/proc/get_tape_playlist()
	return my_tape.tracklist

/obj/item/media/boombox/Topic(href, href_list)
	if(..() || !(Adjacent(usr) || issilicon(usr)))
		return

	if(href_list["change_track"])
		var/datum/track/T = locate(href_list["change_track"]) in tracks
		if(istype(T))
			current_track = T
			StartPlaying()
	else if(href_list["loopmode"])
		var/newval = text2num(href_list["loopmode"])
		loop_mode = sanitize_inlist(newval, list(JUKEMODE_NEXT, JUKEMODE_RANDOM, JUKEMODE_REPEAT_SONG, JUKEMODE_PLAY_ONCE), loop_mode)
	else if(href_list["volume"])
		var/newval = input("Choose Jukebox volume (0-100%)", "Jukebox volume", round(volume * 100.0))
		newval = sanitize_integer(text2num(newval), min = 0, max = 100, default = volume * 100.0)
		volume = newval / 100.0
		update_music() // To broadcast volume change without restarting song
	else if(href_list["stop"])
		StopPlaying()
	else if(href_list["play"])
		if(current_track == null)
			to_chat(usr, "No track selected.")
		else
			StartPlaying()

	return 1

/obj/item/media/boombox/attack_self(mob/user)
	nano_ui_interact(user)

/obj/item/media/boombox/nano_ui_interact(mob/user, ui_key = "jukebox", var/datum/nanoui/ui = null, var/force_open = 1)
	var/title = "Boombox - Space Style"
	var/data[0]

	data["playing"] = playing
	data["max_queue_len"] = max_queue_len
	data["media_start_time"] = media_start_time
	data["loop_mode"] = loop_mode
	data["volume"] = volume
	if(current_track)
		data["current_track_ref"] = "\ref[current_track]"  // Convenient shortcut
		data["current_track"] = current_track.toNanoList()
	data["percent"] = playing ? min(100, round(world.time - media_start_time) / current_track.duration) : 0;

	var/list/nano_tracks = new
	for(var/datum/track/T in tracks)
		nano_tracks[++nano_tracks.len] = T.toNanoList()
	data["tracks"] = nano_tracks

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "jukebox.tmpl", title, 450, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(playing)

/obj/item/media/boombox/attack_ai(mob/user as mob)
	return attack_hand(user)


/obj/item/media/boombox/proc/StopPlaying()
	playing = 0
	var/datum/component/atom_sanity/S = GetComponent(/datum/component/atom_sanity)
	S.affect = 0
	update_icon()
	start_stop_song()

/obj/item/media/boombox/proc/StartPlaying()
	if(!current_track)
		return
	playing = 1
	var/datum/component/atom_sanity/S = GetComponent(/datum/component/atom_sanity)
	S.affect = sanity_value
	update_icon()
	start_stop_song()
	updateDialog()


/obj/item/media/boombox/update_icon()
	if(playing)
		icon_state = "boombox_on"
	else
		icon_state = "boombox"

// Advance to the next track - Don't start playing it unless we were already playing
/obj/item/media/boombox/proc/NextTrack()
	if(!tracks.len) return
	var/curTrackIndex = max(1, tracks.Find(current_track))
	var/newTrackIndex = (curTrackIndex % tracks.len) + 1  // Loop back around if past end
	current_track = tracks[newTrackIndex]
	if(playing)
		start_stop_song()
	updateDialog()

// Un-advance to the previous track - Don't start playing it unless we were already playing
/obj/item/media/boombox/proc/PrevTrack()
	if(!tracks.len) return
	var/curTrackIndex = max(1, tracks.Find(current_track))
	var/newTrackIndex = curTrackIndex == 1 ? tracks.len : curTrackIndex - 1
	current_track = tracks[newTrackIndex]
	if(playing)
		start_stop_song()
	updateDialog()


/obj/item/media/boombox/verb/eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject tape"

	if (usr.stat)
		return

	if(my_tape)
		update_tape(TRUE)
		my_tape.forceMove(get_turf(src))
		my_tape = null
	else
		to_chat(usr, SPAN_NOTICE("There is no tape inside [src]."))
