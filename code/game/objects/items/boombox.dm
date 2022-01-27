//A lot of code taken from jukebox
//This is not a child object because it's an item

/obj/item/media/boombox
	name = "BL4ST4-TUN3 3000"
	desc = "A snazzy boombox, hefty enou69h to be carried around your shoulder."
	icon = 'icons/obj/boombox.dmi'
	icon_state = "boombox"
	item_state = "boombox"

	var/loop_mode = JUKEMODE_PLAY_ONCE			// Behavior when finished playin69 a son69
	var/max_69ueue_len = 3						// How69any son69s are we allowed to 69ueue up?
	var/datum/track/current_track				// Currently playin69 son69
	var/list/datum/track/69ueue = list()			// 69ueued son69s
	var/list/datum/track/tracks = list()		// Available tracks

	var/list/current_listeners = list() //People listenin69 to boombox ri69ht now

	var/ticks_to_update = 5

	var/obj/item/music_tape/my_tape //boombox tape

	var/sanity_value = 2

/obj/item/media/boombox/New()
	AddComponent(/datum/component/atom_sanity, 0, "")
	START_PROCESSIN69(SSobj, src)
	..()

/obj/item/media/boombox/Destroy()
	STOP_PROCESSIN69(SSobj, src)

/obj/item/media/boombox/Process()
	if(ticks_to_update)
		ticks_to_update--
	else
		update_music()
		ticks_to_update = 3
	if(!playin69)
		return
	// If the current track isn't finished playin69, let it keep 69oin69
	if(current_track && world.time <69edia_start_time + current_track.duration)
		return
	// Otherwise time to pick a new one!
	if(69ueue.len > 0)
		current_track = 69ueue69169
		69ueue.Cut(1, 2)  // Remove the item we just took off the list
	else
		// Oh... nothin69 in 69ueue? Well then pick next accordin69 to our rules
		switch(loop_mode)
			if(JUKEMODE_NEXT)
				var/curTrackIndex =69ax(1, tracks.Find(current_track))
				var/newTrackIndex = (curTrackIndex % tracks.len) + 1  // Loop back around if past end
				current_track = tracks69newTrackIndex69
			if(JUKEMODE_RANDOM)
				var/previous_track = current_track
				do
					current_track = pick(tracks)
				while(current_track == previous_track && tracks.len > 1)
			if(JUKEMODE_REPEAT_SON69)
				current_track = current_track
			if(JUKEMODE_PLAY_ONCE)
				current_track = null
				playin69 = 0
				update_icon()
	updateDialo69()
	start_stop_son69()

// Tells the69edia69ana69er to start or stop playin69 based on current settin69s.
/obj/item/media/boombox/proc/start_stop_son69()
	if(current_track && playin69)
		media_url = current_track.url
		media_start_time = world.time
		visible_messa69e(SPAN_NOTICE("\The 69src69 be69ins to play 69current_track.display()69."))
	else
		media_url = ""
		media_start_time = 0
	update_music()

/obj/item/media/boombox/proc/69et_people_around()
	var/list/people = list()
	for(var/mob/O in hearers(7, 69et_turf(src)))
		people += O

	return people

/obj/item/media/boombox/update_music()
	var/list/new_people = 69et_people_around()
	var/list/leavers = current_listeners - new_people
	for(var/mob/M in leavers)
		if(M &&69.client)
			M.force_music("",69edia_start_time,69olume)

	for(var/mob/N in new_people)
		if(N && N.client)
			N.force_music(media_url,69edia_start_time,69olume)

	current_listeners = new_people

/obj/item/media/boombox/attackby(obj/item/W as obj,69ob/user as69ob)
	src.add_fin69erprint(user)

	if(istype(W, /obj/item/music_tape))
		if(my_tape)
			to_chat(user, SPAN_NOTICE("There's already a tape inside 69src69."))
		else
			my_tape = W
			user.unE69uip(my_tape, src)
			my_tape.forceMove(src)
			to_chat(user, SPAN_NOTICE("You insert the tape inside 69src69."))
			update_tape()
	return ..()


/obj/item/media/boombox/proc/update_tape(var/removed)
	if (!removed)
		tracks.Add(69et_tape_playlist())
	else
		tracks.Remove(69et_tape_playlist())
		StopPlayin69()
	updateDialo69()

//Added as a separate proc instead of just readin69 the69ar for a future feature
/obj/item/media/boombox/proc/69et_tape_playlist()
	return69y_tape.tracklist

/obj/item/media/boombox/Topic(href, href_list)
	if(..() || !(Adjacent(usr) || issilicon(usr)))
		return

	if(href_list69"chan69e_track"69)
		var/datum/track/T = locate(href_list69"chan69e_track"69) in tracks
		if(istype(T))
			current_track = T
			StartPlayin69()
	else if(href_list69"loopmode"69)
		var/newval = text2num(href_list69"loopmode"69)
		loop_mode = sanitize_inlist(newval, list(JUKEMODE_NEXT, JUKEMODE_RANDOM, JUKEMODE_REPEAT_SON69, JUKEMODE_PLAY_ONCE), loop_mode)
	else if(href_list69"volume"69)
		var/newval = input("Choose Jukebox69olume (0-100%)", "Jukebox69olume", round(volume * 100.0))
		newval = sanitize_inte69er(text2num(newval),69in = 0,69ax = 100, default =69olume * 100.0)
		volume = newval / 100.0
		update_music() // To broadcast69olume chan69e without restartin69 son69
	else if(href_list69"stop"69)
		StopPlayin69()
	else if(href_list69"play"69)
		if(current_track == null)
			to_chat(usr, "No track selected.")
		else
			StartPlayin69()

	return 1

/obj/item/media/boombox/attack_self(mob/user)
	ui_interact(user)

/obj/item/media/boombox/ui_interact(mob/user, ui_key = "jukebox",69ar/datum/nanoui/ui = null,69ar/force_open = 1)
	var/title = "Boombox - Space Style"
	var/data69069

	data69"playin69"69 = playin69
	data69"max_69ueue_len"69 =69ax_69ueue_len
	data69"media_start_time"69 =69edia_start_time
	data69"loop_mode"69 = loop_mode
	data69"volume"69 =69olume
	if(current_track)
		data69"current_track_ref"69 = "\ref69current_track69"  // Convenient shortcut
		data69"current_track"69 = current_track.toNanoList()
	data69"percent"69 = playin69 ?69in(100, round(world.time -69edia_start_time) / current_track.duration) : 0;

	var/list/nano_tracks = new
	for(var/datum/track/T in tracks)
		nano_tracks69++nano_tracks.len69 = T.toNanoList()
	data69"tracks"69 = nano_tracks

	// update the ui if it exists, returns null if no ui is passed/found
	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "jukebox.tmpl", title, 450, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(playin69)

/obj/item/media/boombox/attack_ai(mob/user as69ob)
	return attack_hand(user)


/obj/item/media/boombox/proc/StopPlayin69()
	playin69 = 0
	var/datum/component/atom_sanity/S = 69etComponent(/datum/component/atom_sanity)
	S.affect = 0
	update_icon()
	start_stop_son69()

/obj/item/media/boombox/proc/StartPlayin69()
	if(!current_track)
		return
	playin69 = 1
	var/datum/component/atom_sanity/S = 69etComponent(/datum/component/atom_sanity)
	S.affect = sanity_value
	update_icon()
	start_stop_son69()
	updateDialo69()


/obj/item/media/boombox/update_icon()
	if(playin69)
		icon_state = "boombox_on"
	else
		icon_state = "boombox"

// Advance to the next track - Don't start playin69 it unless we were already playin69
/obj/item/media/boombox/proc/NextTrack()
	if(!tracks.len) return
	var/curTrackIndex =69ax(1, tracks.Find(current_track))
	var/newTrackIndex = (curTrackIndex % tracks.len) + 1  // Loop back around if past end
	current_track = tracks69newTrackIndex69
	if(playin69)
		start_stop_son69()
	updateDialo69()

// Un-advance to the previous track - Don't start playin69 it unless we were already playin69
/obj/item/media/boombox/proc/PrevTrack()
	if(!tracks.len) return
	var/curTrackIndex =69ax(1, tracks.Find(current_track))
	var/newTrackIndex = curTrackIndex == 1 ? tracks.len : curTrackIndex - 1
	current_track = tracks69newTrackIndex69
	if(playin69)
		start_stop_son69()
	updateDialo69()


/obj/item/media/boombox/verb/eject()
	set src in oview(1)
	set cate69ory = "Object"
	set name = "Eject tape"

	if (usr.stat)
		return

	if(my_tape)
		update_tape(TRUE)
		my_tape.forceMove(69et_turf(src))
		my_tape = null
	else
		to_chat(usr, SPAN_NOTICE("There is no tape inside 69src69."))