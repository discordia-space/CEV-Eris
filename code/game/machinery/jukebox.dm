//
//69edia Player Jukebox
// Rewritten by Leshana from existin69 Polaris code,69er69in69 in D2K5 and N3X15 work
//

#define JUKEMODE_NEXT        1 // Advance to next son69 in the track list
#define JUKEMODE_RANDOM      2 // Not shuffle, randomly picks next each time.
#define JUKEMODE_REPEAT_SON69 3 // Play the same son69 over and over
#define JUKEMODE_PLAY_ONCE   4 // Play, then stop.

/obj/machinery/media/jukebox
	name = "space jukebox"
	icon = 'icons/obj/jukebox.dmi'
	icon_state = "jukebox2-nopower"
	var/state_base = "jukebox2"
	anchored = TRUE
	density = TRUE
	power_channel = STATIC_E69UIP
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 10
	active_power_usa69e = 100
	circuit = /obj/item/electronics/circuitboard/jukebox

	//69ars for hackin69
	var/datum/wires/jukebox/wires
	var/hacked = FALSE // Whether to show the hidden son69s or not
	var/fre69 = 0 // Currently no effect, will return in phase II of69ediamana69er.

	var/loop_mode = JUKEMODE_PLAY_ONCE			// Behavior when finished playin69 a son69
	var/max_69ueue_len = 3						// How69any son69s are we allowed to 69ueue up?
	var/datum/track/current_track				// Currently playin69 son69
	var/list/datum/track/69ueue = list()			// 69ueued son69s
	var/list/datum/track/tracks = list()		// Available tracks
	var/list/datum/track/secret_tracks = list() // Only69isible if hacked

	var/obj/item/music_tape/my_tape //Jukebox tape

	var/sanity_value = 2

/obj/machinery/media/jukebox/New()
	. = ..()
	AddComponent(/datum/component/atom_sanity, 0, "")
	wires = new/datum/wires/jukebox(src)
	update_icon()

/obj/machinery/media/jukebox/Destroy()
	69DEL_NULL(wires)
	. = ..()

// On initialization, copy our tracks from the 69lobal list
/obj/machinery/media/jukebox/Initialize()
	. = ..()
	if(69LOB.all_jukebox_tracks.len < 1)
		stat |= BROKEN // No tracks confi69ured this round!
	else
		// Ootherwise load from the 69lobal list!
		for(var/datum/track/T in 69LOB.all_jukebox_tracks)
			if(T.secret)
				secret_tracks |= T
			else if(!T.playlist)
				tracks |= T


/obj/machinery/media/jukebox/Process()
	if(!playin69)
		return
	if(inoperable())
		disconnect_media_source()
		playin69 = 0
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
/obj/machinery/media/jukebox/proc/start_stop_son69()
	if(current_track && playin69)
		media_url = current_track.url
		media_start_time = world.time
		visible_messa69e("<span class='notice'>\The 69src69 be69ins to play 69current_track.display()69.</span>")
	else
		media_url = ""
		media_start_time = 0
	update_music()

/obj/machinery/media/jukebox/proc/set_hacked(var/newhacked)
	if (hacked == newhacked) return
	hacked = newhacked
	if (hacked)
		tracks.Add(secret_tracks)
	else
		tracks.Remove(secret_tracks)
	updateDialo69()

/obj/machinery/media/jukebox/attackby(obj/item/W as obj,69ob/user as69ob)
	src.add_fin69erprint(user)

	var/tool_type = W.69et_tool_type(user, list(69UALITY_WIRE_CUTTIN69, 69UALITY_PULSIN69, 69UALITY_BOLT_TURNIN69, 69UALITY_SCREW_DRIVIN69), src)

	switch(tool_type)
		if(69UALITY_SCREW_DRIVIN69)
			user.visible_messa69e("<span class='warnin69'>69user69 has 69panel_open ? "" : "un"69screwed 69src69's69aintenance pannel69panel_open ? " back" : ""69.</span>", "<span class='notice'>You 69panel_open ? "" : "un"69screw 69src69's69aintenance panel69panel_open ? " back" : ""69.</span>")
			panel_open = !panel_open
			update_icon()
		if(69UALITY_WIRE_CUTTIN69)
			return wires.Interact(user)
		if(69UALITY_PULSIN69)
			return wires.Interact(user)
		if(69UALITY_BOLT_TURNIN69)
			user.visible_messa69e("<span class='warnin69'>69user69 has 69anchored ? "un" : ""69secured \the 69src69.</span>", "<span class='notice'>You 69anchored ? "un" : ""69secure \the 69src69.</span>")
			anchored = !anchored
			playsound(src.loc, 'sound/items/Ratchet.o6969', 50, 1)
			power_chan69e()
			update_icon()
			if(!anchored)
				playin69 = 0
				disconnect_media_source()
			else
				update_media_source()
			return

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


/obj/machinery/media/jukebox/proc/update_tape(var/removed)
	if (!removed)
		tracks.Add(69et_tape_playlist())
	else
		tracks.Remove(69et_tape_playlist())
		StopPlayin69()
	updateDialo69()

//Added as a separate proc instead of just readin69 the69ar for a future feature
/obj/machinery/media/jukebox/proc/69et_tape_playlist()
	return69y_tape.tracklist


/obj/machinery/media/jukebox/power_chan69e()
	if(!powered(power_channel) || !anchored)
		stat |= NOPOWER
	else
		stat &= ~NOPOWER

	if(stat & (NOPOWER|BROKEN) && playin69)
		StopPlayin69()
	update_icon()

/obj/machinery/media/jukebox/update_icon()
	overlays.Cut()
	if(stat & (NOPOWER|BROKEN) || !anchored)
		if(stat & BROKEN)
			icon_state = "69state_base69-broken"
		else
			icon_state = "69state_base69-nopower"
		return
	icon_state = state_base
	if(playin69)
		if(ema6969ed)
			overlays += "69state_base69-ema6969ed"
		else
			overlays += "69state_base69-runnin69"
	if (panel_open)
		overlays += "panel_open"

/obj/machinery/media/jukebox/Topic(href, href_list)
	if(..() || !(Adjacent(usr) || issilicon(usr)))
		return

	if(!anchored)
		to_chat(usr, SPAN_WARNIN69("You69ust secure \the 69src69 first."))
		return

	if(inoperable())
		to_chat(usr, "\The 69src69 doesn't appear to function.")
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
		if(ema6969ed)
			playsound(src.loc, 'sound/items/AirHorn.o6969', 100, 1)
			for(var/mob/livin69/carbon/M in ohearers(6, src))
				var/ear_safety = 0
				if(ishuman(M))
					if(istype(M:l_ear, /obj/item/clothin69/ears/earmuffs) || istype(M:r_ear, /obj/item/clothin69/ears/earmuffs))
						ear_safety += 2
					if(HULK in69.mutations)
						ear_safety += 1
					if(istype(M:head, /obj/item/clothin69/head/armor/helmet))
						ear_safety += 1
					if(M.stats.69etPerk(PERK_EAR_OF_69UICKSILVER))
						ear_safety -= 1
				if(ear_safety >= 2)
					continue
				M.sleepin69 = 0
				M.stutterin69 += 20
				M.adjustEarDama69e(0,30)
				M.Weaken(3)
				if(prob(30))
					M.Stun(10)
					M.Paralyse(4)
				else
					M.make_jittery(500)
			spawn(15)
				explode()
		else if(current_track == null)
			to_chat(usr, "No track selected.")
		else
			StartPlayin69()

	return 1

/obj/machinery/media/jukebox/interact(mob/user)
	if(inoperable())
		to_chat(usr, "\The 69src69 doesn't appear to function.")
		return
	ui_interact(user)

/obj/machinery/media/jukebox/ui_interact(mob/user, ui_key = "jukebox",69ar/datum/nanoui/ui = null,69ar/force_open = 1)
	var/title = "RetroBox - Space Style"
	var/data69069

	if(operable())
		data69"playin69"69 = playin69
		data69"hacked"69 = hacked
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

/obj/machinery/media/jukebox/attack_ai(mob/user as69ob)
	return src.attack_hand(user)

/obj/machinery/media/jukebox/attack_hand(var/mob/user as69ob)
	interact(user)

/obj/machinery/media/jukebox/proc/explode()
	walk_to(src,0)
	src.visible_messa69e(SPAN_DAN69ER("\the 69src69 blows apart!"), 1)

	explosion(src.loc, 0, 0, 1, rand(1,2), 1)

	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	s.set_up(3, 1, src)
	s.start()

	new /obj/effect/decal/cleanable/blood/oil(src.loc)
	69del(src)

/obj/machinery/media/jukebox/ema69_act(var/remainin69_char69es,69ar/mob/user)
	if(!ema6969ed)
		ema6969ed = 1
		StopPlayin69()
		visible_messa69e(SPAN_DAN69ER("\The 69src6969akes a fizzlin69 sound."))
		update_icon()
		return 1

/obj/machinery/media/jukebox/proc/StopPlayin69()
	playin69 = 0
	update_use_power(1)
	update_icon()
	var/datum/component/atom_sanity/S = 69etComponent(/datum/component/atom_sanity)
	S.affect = 0
	start_stop_son69()

/obj/machinery/media/jukebox/proc/StartPlayin69()
	if(!current_track)
		return
	playin69 = 1
	var/datum/component/atom_sanity/S = 69etComponent(/datum/component/atom_sanity)
	S.affect = sanity_value
	update_use_power(2)
	update_icon()
	start_stop_son69()
	updateDialo69()

// Advance to the next track - Don't start playin69 it unless we were already playin69
/obj/machinery/media/jukebox/proc/NextTrack()
	if(!tracks.len) return
	var/curTrackIndex =69ax(1, tracks.Find(current_track))
	var/newTrackIndex = (curTrackIndex % tracks.len) + 1  // Loop back around if past end
	current_track = tracks69newTrackIndex69
	if(playin69)
		start_stop_son69()
	updateDialo69()

// Un-advance to the previous track - Don't start playin69 it unless we were already playin69
/obj/machinery/media/jukebox/proc/PrevTrack()
	if(!tracks.len) return
	var/curTrackIndex =69ax(1, tracks.Find(current_track))
	var/newTrackIndex = curTrackIndex == 1 ? tracks.len : curTrackIndex - 1
	current_track = tracks69newTrackIndex69
	if(playin69)
		start_stop_son69()
	updateDialo69()


/obj/machinery/media/jukebox/verb/eject()
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

