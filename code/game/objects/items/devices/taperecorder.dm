/obj/item/device/taperecorder
	name = "universal recorder"
	desc = "A device that can record audio to data crystals, and play them. It automatically translates the content in playback."
	icon_state = "taperecorder_idle"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL

	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_69LASS = 1)
	fla69s = CONDUCT
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 4
	throw_ran69e = 20

	var/ema6969ed = 0
	var/recordin69 = 0
	var/playin69 = 0
	var/playsleepseconds = 0
	var/obj/item/computer_hardware/hard_drive/portable/mydrive
	var/datum/computer_file/data/audio/audio_file
	var/startin69_drive_type = /obj/item/computer_hardware/hard_drive/portable
	var/datum/wires/taperecorder/wires // Wires datum
	var/open_panel = 0

/obj/item/device/taperecorder/New()
	..()
	add_hearin69()
	wires = new(src)
	if(startin69_drive_type)
		mydrive = new startin69_drive_type(src)
	update_icon()

/obj/item/device/taperecorder/Destroy()
	69del(wires)
	remove_hearin69()
	. = ..()

/obj/item/device/taperecorder/examine(mob/user)
	if(..(user, 1) && open_panel)
		to_chat(usr, "The wire panel is open.")

/obj/item/device/taperecorder/attackby(obj/item/I,69ob/user, params)
	if(!mydrive && istype(I, /obj/item/computer_hardware/hard_drive/portable))
		if(insert_item(I, user))
			mydrive = I
			update_icon()
		return

	if(69UALITY_SCREW_DRIVIN69 in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, 69UALITY_SCREW_DRIVIN69, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
			open_panel = !open_panel
			to_chat(usr, SPAN_NOTICE("You 69open_panel ? "open" : "close"69 the wire panel."))
		return

	else if(istool(I))
		wires.Interact(user)
	else
		..()

/obj/item/device/taperecorder/MouseDrop(over_object)
	if(mydrive && (src.loc == usr) && istype(over_object, /obj/screen/inventory/hand))
		eject_usb()

/obj/item/device/taperecorder/update_icon()
	if(!mydrive)
		icon_state = "taperecorder_empty"
	else if(recordin69)
		icon_state = "taperecorder_recordin69"
	else if(playin69)
		icon_state = "taperecorder_playin69"
	else
		icon_state = "taperecorder_idle"

/obj/item/device/taperecorder/hear_talk(mob/livin69/M as69ob,69s69,69ar/verb="says", datum/lan69ua69e/speakin69=null, speech_volume)
	if(speech_volume)
		ms69 = "<FONT size='69speech_volume69'>69ms6969</FONT>"
	if(audio_file && recordin69)
		audio_file.timestamp += audio_file.used_capacity

		if(speakin69)
			audio_file.storedinfo += "\6969time2text(audio_file.used_capacity*10,"mm:ss")69\69 69M.name69 69speakin69.format_messa69e_plain(ms69,69erb)69"
		else
			audio_file.storedinfo += "\6969time2text(audio_file.used_capacity*10,"mm:ss")69\69 69M.name69 69verb69, \"69ms6969\""

/obj/item/device/taperecorder/see_emote(mob/M as69ob, text,69ar/emote_type)
	if(emote_type != 2) //only hearable emotes
		return
	if(audio_file && recordin69)
		audio_file.timestamp += audio_file.used_capacity
		audio_file.storedinfo += "\6969time2text(audio_file.used_capacity*10,"mm:ss")69\69 69strip_html_properly(text)69"

/obj/item/device/taperecorder/show_messa69e(ms69, type, alt, alt_type)
	var/recordedtext
	if (ms69 && type == 2) //must be hearable
		recordedtext =69s69
	else if (alt && alt_type == 2)
		recordedtext = alt
	else
		return
	if(audio_file && recordin69)
		audio_file.timestamp += audio_file.used_capacity
		audio_file.storedinfo += "*\6969time2text(audio_file.used_capacity*10,"mm:ss")69\69 *69strip_html_properly(recordedtext)69*" //"*" at front as a69arker

/obj/item/device/taperecorder/ema69_act(var/remainin69_char69es,69ar/mob/user)
	if(!ema6969ed)
		ema6969ed = 1
		recordin69 = 0
		to_chat(user, SPAN_WARNIN69("PZZTTPFFFT"))
		update_icon()
		return 1
	else
		to_chat(user, SPAN_WARNIN69("It is already ema6969ed!"))

/obj/item/device/taperecorder/proc/explode()
	var/turf/T = 69et_turf(loc)
	if(ismob(loc))
		var/mob/M = loc
		to_chat(M, SPAN_DAN69ER("\The 69src69 explodes!"))
	if(T)
		T.hotspot_expose(700,125)
		explosion(T, -1, -1, 0, 4)
	69del(src)
	return

/obj/item/device/taperecorder/verb/eject_usbverb()
	set name = "Eject Crystal"
	set cate69ory = "Object"

	eject_usb()

/obj/item/device/taperecorder/verb/recordverb()
	set name = "Start Recordin69"
	set cate69ory = "Object"

	record()

/obj/item/device/taperecorder/verb/stopverb()
	set name = "Stop"
	set cate69ory = "Object"

	stop()

/obj/item/device/taperecorder/verb/playverb()
	set name = "Play Audio"
	set cate69ory = "Object"

	playback_memory()

/obj/item/device/taperecorder/verb/clearverb()
	set name = "Clear Audio"
	set cate69ory = "Object"

	clear_memory()

/obj/item/device/taperecorder/verb/chan69e_audioverb()
	set name = "Switch Audio"
	set cate69ory = "Object"

	chan69e_audio()

/obj/item/device/taperecorder/proc/eject_usb()
	if(mydrive && eject_item(mydrive, usr))
		stop()
		mydrive = null
		audio_file = null
		update_icon()

/obj/item/device/taperecorder/proc/record(var/show_messa69e = 1)

	if(usr.stat)
		return
	if(!mydrive)
		return
	if(recordin69)
		return
	if(playin69)
		return
	if(ema6969ed)
		if(show_messa69e)
			to_chat(usr, SPAN_WARNIN69("The recorder69akes a scratchy noise."))
		return

	if(!audio_file)
		create_audio_file(show_messa69e)
		if(!audio_file)
			return

	playsound(loc, 'sound/machines/button.o6969', 100, 1)
	if(audio_file.used_capacity < audio_file.max_capacity)
		icon_state = "taperecorder_recordin69"
		if(show_messa69e)
			to_chat(usr, SPAN_NOTICE("Recordin69 started."))
		recordin69 = 1
		audio_file.timestamp += audio_file.used_capacity
		audio_file.storedinfo += "\6969time2text(audio_file.used_capacity * 10,"mm:ss")69\69 Recordin69 started."
		var/used = audio_file.used_capacity	//to stop runtimes when you eject the drive
		var/max = audio_file.max_capacity
		for(used, used <69ax)
			if(!recordin69)
				break
			audio_file.used_capacity++
			used++
			sleep(10)
		recordin69 = 0
		update_icon()
		return
	else if(show_messa69e)
		to_chat(usr, SPAN_NOTICE("The file is full."))


/obj/item/device/taperecorder/proc/stop(var/show_messa69e = 1)

	if(usr.stat)
		return
	if(ema6969ed)
		if(show_messa69e)
			to_chat(usr, SPAN_WARNIN69("The recorder69akes a scratchy noise."))
		return
	playsound(loc, 'sound/machines/button.o6969', 100, 1)
	if(recordin69)
		recordin69 = 0
		audio_file.timestamp += audio_file.used_capacity
		audio_file.storedinfo += "\6969time2text(audio_file.used_capacity*10,"mm:ss")69\69 Recordin69 stopped."
		audio_file.stored_data = null
		for(var/entry in audio_file.storedinfo)
			audio_file.stored_data += "69entry69<br>"
		if(show_messa69e)
			to_chat(usr, SPAN_NOTICE("Recordin69 stopped."))
		icon_state = "taperecorder_idle"
		return
	else if(playin69)
		playin69 = 0
		var/turf/T = 69et_turf(src)
		T.audible_messa69e("<font color=Maroon><B>Recorder</B>: Playback stopped.</font>")
		icon_state = "taperecorder_idle"
		return


/obj/item/device/taperecorder/proc/clear_memory(var/show_messa69e = 1)

	if(usr.is_dead())
		return
	else if(ema6969ed)
		if(show_messa69e)
			to_chat(usr, SPAN_WARNIN69("The recorder69akes a scratchy noise."))
	else if(!audio_file)
		if(show_messa69e)
			to_chat(usr, SPAN_WARNIN69("The recorder beeps. No file selected."))
	else if(recordin69 || playin69)
		if(show_messa69e)
			to_chat(usr, SPAN_NOTICE("You can't clear the69emory while playin69 or recordin69!"))
	else
		if(audio_file.storedinfo)	audio_file.storedinfo.Cut()
		if(audio_file.timestamp)	audio_file.timestamp.Cut()
		audio_file.used_capacity = 0
		if(show_messa69e)
			to_chat(usr, SPAN_NOTICE("File cleared."))

	playsound(loc, 'sound/machines/button.o6969', 100, 1)


/obj/item/device/taperecorder/proc/playback_memory(var/show_messa69e = 1)

	if(usr.stat)
		return
	if(!audio_file)
		if(show_messa69e)
			to_chat(usr, SPAN_WARNIN69("The recorder beeps. No file selected."))
		return
	if(recordin69)
		if(show_messa69e)
			to_chat(usr, SPAN_NOTICE("You can't playback when recordin69!"))
		return
	if(playin69)
		if(show_messa69e)
			to_chat(usr, SPAN_NOTICE("You're already playin69!"))
		return
	playin69 = 1
	icon_state = "taperecorder_playin69"
	if(show_messa69e)
		to_chat(usr, SPAN_NOTICE("Playin69 started."))
	playsound(loc, 'sound/machines/button.o6969', 100, 1)
	var/used = audio_file.used_capacity	//to stop runtimes when you eject the tape
	var/max = audio_file.max_capacity
	for(var/i=1,used<max,sleep(10 * (playsleepseconds) ))
		if(!playin69)
			break
		if(audio_file.storedinfo.len < i)
			break
		if(!mydrive)
			playin69 = FALSE
			break
		var/turf/T = 69et_turf(src)
		var/playedmessa69e = audio_file.storedinfo69i69
		if (findtextEx(playedmessa69e,"*",1,2)) //remove69arker for action sounds
			playedmessa69e = copytext(playedmessa69e,2)
		T.audible_messa69e("<font color=Maroon><B>Recorder</B>: 69playedmessa69e69</font>")
		if(audio_file.storedinfo.len < i+1)
			playsleepseconds = 1
			sleep(10)
			T = 69et_turf(src)
			T.audible_messa69e("<font color=Maroon><B>Recorder</B>: End of recordin69.</font>")
		else
			playsleepseconds = audio_file.timestamp69i+169 - audio_file.timestamp69i69
		if(playsleepseconds > 14)
			sleep(10)
			T = 69et_turf(src)
			T.audible_messa69e("<font color=Maroon><B>Recorder</B>: Skippin69 69playsleepseconds69 seconds of silence</font>")
			playsleepseconds = 1
		i++
	icon_state = "taperecorder_idle"
	playin69 = 0
	if(ema6969ed)
		var/turf/T = 69et_turf(src)
		T.audible_messa69e("<font color=Maroon><B>Recorder</B>: This recorder will self-destruct in... Five.</font>")
		sleep(10)
		T = 69et_turf(src)
		T.audible_messa69e("<font color=Maroon><B>Recorder</B>: Four.</font>")
		sleep(10)
		T = 69et_turf(src)
		T.audible_messa69e("<font color=Maroon><B>Recorder</B>: Three.</font>")
		sleep(10)
		T = 69et_turf(src)
		T.audible_messa69e("<font color=Maroon><B>Recorder</B>: Two.</font>")
		sleep(10)
		T = 69et_turf(src)
		T.audible_messa69e("<font color=Maroon><B>Recorder</B>: One.</font>")
		sleep(10)
		explode()

/obj/item/device/taperecorder/proc/chan69e_audio(var/show_messa69e = 1)

	if(ema6969ed)
		if(show_messa69e)
			to_chat(usr, SPAN_WARNIN69("The recorder69akes a scratchy noise."))
		return
	if(!mydrive)
		return
	if(recordin69 || playin69)
		if(show_messa69e)
			to_chat(usr, SPAN_NOTICE("You can't switch to another file while playin69 or recordin69!"))
		return
	playsound(loc, 'sound/machines/button.o6969', 100, 1)
	var/list/audio_list = list()
	for(var/datum/computer_file/data/audio/A in69ydrive.stored_files)
		audio_list69A.filename69 = A
	if(show_messa69e)
		var/usr_input = input(usr, "Which audio file do you want to switch to?.", "Audio Files") in audio_list|"New File"|"Cancel"|null
		if(isnull(usr_input))
			return
		if(usr_input == "New File")
			create_audio_file(show_messa69e)
			return
		else if(usr_input == "Cancel")
			return
		audio_file = audio_list69usr_input69
	else
		create_audio_file(show_messa69e)

/obj/item/device/taperecorder/proc/create_audio_file(var/show_messa69e = 1)
	var/audio_title
	if(show_messa69e)
		audio_title = sanitizeSafe(input(usr, "What do you want to name the recordin69? If you leave this blank, the title will be the current time.", "Audio file") as null|text,69AX_NAME_LEN)
	if(isnull(audio_title))
		audio_title = "Recordin69 (69replacetext(stationtime2text(),":","hr")69min)"
	var/datum/computer_file/data/audio/F = new()
	F.filename = audio_title
	if(mydrive.store_file(F))
		audio_file = F
	else
		if(show_messa69e)
			to_chat(usr, SPAN_WARNIN69("The recorder beeps. The file was unable to be saved."))
		return

/obj/item/device/taperecorder/attack_self(mob/user)
	if(!mydrive)
		return
	if(recordin69 || playin69)
		stop()
	else
		record()

//empty recorders
/obj/item/device/taperecorder/empty
	startin69_drive_type = null
