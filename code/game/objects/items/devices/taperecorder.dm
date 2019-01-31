/obj/item/device/taperecorder
	name = "universal recorder"
	desc = "A device that can record audio to cassette tapes, and play them. It automatically translates the content in playback."
	icon_state = "taperecorder_idle"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL

	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

	var/emagged = 0
	var/recording = 0
	var/playing = 0
	var/playsleepseconds = 0
	var/obj/item/cassette_tape/mytape
	var/starting_tape_type = /obj/item/cassette_tape/random
	var/canprint = 1
	var/datum/wires/taperecorder/wires = null // Wires datum
	var/open_panel = 0
	flags = CONDUCT
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 4
	throw_range = 20

/obj/item/device/taperecorder/New()
	..()
	add_hearing()
	wires = new(src)
	if(starting_tape_type)
		mytape = new starting_tape_type(src)
	update_icon()

/obj/item/device/taperecorder/Destroy()
	qdel(wires)
	remove_hearing()
	. = ..()

/obj/item/device/taperecorder/fire_act()
	if(mytape)
		mytape.ruin()
	..()

/obj/item/device/taperecorder/examine(mob/user)
	if(..(user, 1) && open_panel)
		usr << "The wire panel is open."

/obj/item/device/taperecorder/attackby(obj/item/I, mob/user, params)
	if(!mytape && istype(I, /obj/item/cassette_tape))
		if(I:ruined)
			user << SPAN_WARNING("The tape is all messed up! You'll need to wind it back in.")
			return
		if(insert_item(I, user))
			mytape = I
			update_icon()
		return

	if(QUALITY_SCREW_DRIVING in I.tool_qualities)
		if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, QUALITY_SCREW_DRIVING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			open_panel = !open_panel
			usr << SPAN_NOTICE("You [open_panel ? "open" : "close"] the wire panel.")

	else if(istool(I))
		wires.Interact(user)
	else
		..()

/obj/item/device/taperecorder/MouseDrop(over_object)
	if(mytape && (src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(mytape, usr))
		stop()
		mytape = null
		update_icon()

/obj/item/device/taperecorder/update_icon()
	if(!mytape)
		icon_state = "taperecorder_empty"
	else if(recording)
		icon_state = "taperecorder_recording"
	else if(playing)
		icon_state = "taperecorder_playing"
	else
		icon_state = "taperecorder_idle"

/obj/item/device/taperecorder/hear_talk(mob/living/M as mob, msg, var/verb="says", datum/language/speaking=null)
	if(mytape && recording)
		mytape.timestamp += mytape.used_capacity

		if(speaking)
			mytape.storedinfo += "\[[time2text(mytape.used_capacity*10,"mm:ss")]\] [M.name] [speaking.format_message_plain(msg, verb)]"
		else
			mytape.storedinfo += "\[[time2text(mytape.used_capacity*10,"mm:ss")]\] [M.name] [verb], \"[msg]\""

/obj/item/device/taperecorder/see_emote(mob/M as mob, text, var/emote_type)
	if(emote_type != 2) //only hearable emotes
		return
	if(recording)
		mytape.timestamp += mytape.used_capacity
		mytape.storedinfo += "\[[time2text(mytape.used_capacity*10,"mm:ss")]\] [strip_html_properly(text)]"

/obj/item/device/taperecorder/show_message(msg, type, alt, alt_type)
	var/recordedtext
	if (msg && type == 2) //must be hearable
		recordedtext = msg
	else if (alt && alt_type == 2)
		recordedtext = alt
	else
		return
	if(recording)
		mytape.timestamp += mytape.used_capacity
		mytape.storedinfo += "*\[[time2text(mytape.used_capacity*10,"mm:ss")]\] *[strip_html_properly(recordedtext)]*" //"*" at front as a marker

/obj/item/device/taperecorder/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		emagged = 1
		recording = 0
		user << SPAN_WARNING("PZZTTPFFFT")
		update_icon()
		return 1
	else
		user << SPAN_WARNING("It is already emagged!")

/obj/item/device/taperecorder/proc/explode()
	var/turf/T = get_turf(loc)
	if(ismob(loc))
		var/mob/M = loc
		M << SPAN_DANGER("\The [src] explodes!")
	if(T)
		T.hotspot_expose(700,125)
		explosion(T, -1, -1, 0, 4)
	qdel(src)
	return

/obj/item/device/taperecorder/verb/record(var/show_message = 1 as num)
	set name = "Start Recording"
	set category = "Object"

	if(usr.stat)
		return
	if(!mytape || mytape.ruined)
		return
	if(recording)
		return
	if(playing)
		return
	if(emagged)
		if(show_message)
			usr << SPAN_WARNING("The tape recorder makes a scratchy noise.")
		return

	icon_state = "taperecorder_recording"
	if(mytape.used_capacity < mytape.max_capacity)
		if(show_message)
			usr << SPAN_NOTICE("Recording started.")
		recording = 1
		mytape.timestamp += mytape.used_capacity
		mytape.storedinfo += "\[[time2text(mytape.used_capacity * 10,"mm:ss")]\] Recording started."
		var/used = mytape.used_capacity	//to stop runtimes when you eject the tape
		var/max = mytape.max_capacity
		for(used, used < max)
			if(!recording)
				break
			mytape.used_capacity++
			used++
			sleep(10)
		recording = 0
		update_icon()
		return
	else if(show_message)
		usr << SPAN_NOTICE("The tape is full.")


/obj/item/device/taperecorder/verb/stop(var/show_message = 1 as num)
	set name = "Stop"
	set category = "Object"

	if(usr.stat)
		return
	if(emagged)
		if(show_message)
			usr << SPAN_WARNING("The tape recorder makes a scratchy noise.")
		return
	if(recording)
		recording = 0
		mytape.timestamp += mytape.used_capacity
		mytape.storedinfo += "\[[time2text(mytape.used_capacity*10,"mm:ss")]\] Recording stopped."
		if(show_message)
			usr << SPAN_NOTICE("Recording stopped.")
		icon_state = "taperecorder_idle"
		return
	else if(playing)
		playing = 0
		var/turf/T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Playback stopped.</font>")
		icon_state = "taperecorder_idle"
		return


/obj/item/device/taperecorder/verb/clear_memory(var/show_message = 1 as num)
	set name = "Clear Tape"
	set category = "Object"

	if(usr.stat)
		return
	if(emagged)
		if(show_message)
			usr << SPAN_WARNING("The tape recorder makes a scratchy noise.")
		return
	if(!mytape || mytape.ruined)
		return
	if(recording || playing)
		if(show_message)
			usr << SPAN_NOTICE("You can't clear the memory while playing or recording!")
		return
	else
		if(mytape.storedinfo)	mytape.storedinfo.Cut()
		if(mytape.timestamp)	mytape.timestamp.Cut()
		mytape.used_capacity = 0
		if(show_message)
			usr << SPAN_NOTICE("Tape cleared.")
		return


/obj/item/device/taperecorder/verb/playback_memory(var/show_message = 1 as num)
	set name = "Play Tape"
	set category = "Object"

	if(usr.stat)
		return
	if(!mytape || mytape.ruined)
		return
	if(recording)
		if(show_message)
			usr << SPAN_NOTICE("You can't playback when recording!")
		return
	if(playing)
		if(show_message)
			usr << SPAN_NOTICE("You're already playing!")
		return
	playing = 1
	icon_state = "taperecorder_playing"
	if(show_message)
		usr << SPAN_NOTICE("Playing started.")
	var/used = mytape.used_capacity	//to stop runtimes when you eject the tape
	var/max = mytape.max_capacity
	for(var/i=1,used<max,sleep(10 * (playsleepseconds) ))
		if(!playing)
			break
		if(mytape.storedinfo.len < i)
			break
		var/turf/T = get_turf(src)
		var/playedmessage = mytape.storedinfo[i]
		if (findtextEx(playedmessage,"*",1,2)) //remove marker for action sounds
			playedmessage = copytext(playedmessage,2)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: [playedmessage]</font>")
		if(mytape.storedinfo.len < i+1)
			playsleepseconds = 1
			sleep(10)
			T = get_turf(src)
			T.audible_message("<font color=Maroon><B>Tape Recorder</B>: End of recording.</font>")
		else
			playsleepseconds = mytape.timestamp[i+1] - mytape.timestamp[i]
		if(playsleepseconds > 14)
			sleep(10)
			T = get_turf(src)
			T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Skipping [playsleepseconds] seconds of silence</font>")
			playsleepseconds = 1
		i++
	icon_state = "taperecorder_idle"
	playing = 0
	if(emagged)
		var/turf/T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: This tape recorder will self-destruct in... Five.</font>")
		sleep(10)
		T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Four.</font>")
		sleep(10)
		T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Three.</font>")
		sleep(10)
		T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: Two.</font>")
		sleep(10)
		T = get_turf(src)
		T.audible_message("<font color=Maroon><B>Tape Recorder</B>: One.</font>")
		sleep(10)
		explode()


/obj/item/device/taperecorder/verb/print_transcript(var/show_message = 1 as num)
	set name = "Print Transcript"
	set category = "Object"

	if(usr.stat)
		return
	if(emagged)
		if(show_message)
			usr << SPAN_WARNING("The tape recorder makes a scratchy noise.")
		return
	if(!mytape || mytape.ruined)
		return
	if(!canprint)
		if(show_message)
			usr << SPAN_NOTICE("The recorder can't print that fast!")
		return
	if(recording || playing)
		if(show_message)
			usr << SPAN_NOTICE("You can't print the transcript while playing or recording!")
		return
	usr << SPAN_NOTICE("Transcript printed.")
	var/obj/item/weapon/paper/P = new /obj/item/weapon/paper(get_turf(src))
	var/t1 = "<B>Transcript:</B><BR><BR>"
	for(var/i=1,mytape.storedinfo.len >= i,i++)
		var/printedmessage = mytape.storedinfo[i]
		if (findtextEx(printedmessage,"*",1,2)) //replace action sounds
			printedmessage = "\[[time2text(mytape.timestamp[i]*10,"mm:ss")]\] (Unrecognized sound)"
		t1 += "[printedmessage]<BR>"
	P.info = t1
	P.name = "Transcript"
	canprint = 0
	sleep(300)
	canprint = 1


/obj/item/device/taperecorder/attack_self(mob/user)
	if(!mytape || mytape.ruined)
		return
	if(recording || playing)
		stop()
	else
		record()

//empty tape recorders
/obj/item/device/taperecorder/empty
	starting_tape_type = null

/obj/item/cassette_tape
	name = "cassette tape"
	desc = "A magnetic tape that can hold up to twenty minutes of content."
	icon_state = "tape_white"
	icon = 'icons/obj/device.dmi'
	item_state = "analyzer"
	w_class = ITEM_SIZE_TINY
	matter = list(MATERIAL_PLASTIC = 1, MATERIAL_GLASS = 0.5)
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 4
	throw_range = 20
	var/max_capacity = 1200
	var/used_capacity = 0
	var/list/storedinfo = list()
	var/list/timestamp = list()
	var/ruined = 0

/obj/item/cassette_tape/fire_act(exposed_temperature, exposed_volume)
	ruin()
	..()

/obj/item/cassette_tape/attack_self(mob/user)
	if(!ruined)
		to_chat(user, "<span class='notice'>You pull out all the tape!</span>")
		ruin()


/obj/item/cassette_tape/proc/ruin()
	//Lets not add infinite amounts of overlays when our fireact is called
	//repeatedly
	if(!ruined)
		overlays += "ribbonoverlay"
	ruined = 1


/obj/item/cassette_tape/proc/fix()
	overlays.Cut()
	ruined = 0


/obj/item/cassette_tape/attackby(obj/item/I, mob/user, params)
	if(ruined && (QUALITY_SCREW_DRIVING in I.tool_qualities))
		user << SPAN_NOTICE("You start winding the tape back in...")
		if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_SCREW_DRIVING, FAILCHANCE_EASY, required_stat = STAT_MEC))
			user << SPAN_NOTICE("You wound the tape back in.")
			fix()

//Random colour tapes
/obj/item/cassette_tape/random
	icon_state = "random_tape"

/obj/item/cassette_tape/random/New()
	icon_state = "tape_[pick("white", "blue", "red", "yellow", "purple")]"
	..()