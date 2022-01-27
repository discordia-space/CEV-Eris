/datum/computer_file/program/audio
	filename = "audioplyr"
	filedesc = "Audio Player"
	nanomodule_path = /datum/nano_module/program/audio
	extended_desc = "This program69ay be used to play audio files. Features69ocal transcription."
	size = 3
	available_on_ntnet = TRUE
	requires_ntnet = FALSE
	usage_flags = PROGRAM_ALL
	var/datum/computer_file/data/audio/selected_audio
	var/transcribing = FALSE
	var/transcribe_progress = 0
	var/browsing = TRUE
	var/playing
	var/playsleepseconds = 0
	var/error

/datum/computer_file/program/audio/proc/open_audio(var/filename)
	var/datum/computer_file/data/audio/F = get_file(filename)
	if(F)
		selected_audio = F
		return TRUE

/datum/computer_file/program/audio/proc/play_audio()
	var/used = selected_audio.used_capacity
	var/max = selected_audio.max_capacity
	for(var/i=1,used<max,sleep(10 * (playsleepseconds) ))
		if(!playing)
			break
		if(!selected_audio)
			break
		if(selected_audio.storedinfo.len < i)
			break
		var/turf/T = get_turf(computer)
		var/playedmessage = selected_audio.storedinfo69i69
		if (findtextEx(playedmessage,"*",1,2)) //remove69arker for action sounds
			playedmessage = copytext(playedmessage,2)
		T.audible_message("<font color=Maroon><B>Audio Player</B>: 69playedmessage69</font>")
		if(selected_audio.storedinfo.len < i+1)
			playsleepseconds = 1
			sleep(10)
			T = get_turf(computer)
			T.audible_message("<font color=Maroon><B>Audio Player</B>: End of recording.</font>")
			playing = FALSE
		else
			playsleepseconds = selected_audio.timestamp69i+169 - selected_audio.timestamp69i69
		if(playsleepseconds > 14)
			sleep(10)
			T = get_turf(computer)
			T.audible_message("<font color=Maroon><B>Audio Player</B>: Skipping 69playsleepseconds69 seconds of silence</font>")
			playsleepseconds = 1
		i++

/datum/computer_file/program/audio/process_tick()
	..()
	if(!selected_audio)
		transcribing = 0
	if(transcribing)
		transcribe_progress +=69tnet_speed
		if(transcribe_progress >= selected_audio.size)
			transcribe_progress = 0
			transcribing = 0
			selected_audio.transcribed = TRUE
		SSnano.update_uis(NM)

/datum/computer_file/program/audio/kill_program(forced = FALSE)
	..()
	selected_audio =69ull
	browsing = TRUE
	transcribe_progress = 0
	transcribing = FALSE

/datum/computer_file/program/audio/Topic(href, href_list)
	if(..())
		return TRUE

	if(href_list69"PRG_closebrowser"69)
		browsing = FALSE
		return TRUE

	if(href_list69"PRG_backtomenu"69)
		error =69ull
		return TRUE

	if(href_list69"PRG_reset"69)
		transcribing = 0
		transcribe_progress = 0
		return TRUE

	if(href_list69"PRG_toggleaudio"69)
		if(playing)
			playing = FALSE
		else
			if(selected_audio)
				playing = TRUE
				play_audio()
		SSnano.update_uis(NM)
		return TRUE

	if(href_list69"PRG_loadmenu"69)
		browsing = TRUE
		return TRUE

	if(href_list69"PRG_transcribe"69)
		if(selected_audio)
			playing = FALSE
			transcribing = TRUE
		else
			error = "Error:69o file loaded."
		return TRUE

	if(href_list69"PRG_openaudio"69)
		. = TRUE
		playing = FALSE
		browsing = FALSE
		if(!open_audio(href_list69"PRG_openaudio"69))
			error = "I/O error: Unable to open file '69href_list69"PRG_openaudio"6969'."

	if(href_list69"PRG_printfile"69)
		. = TRUE
		if(!selected_audio)
			error = "Error:69o file loaded."
			return TRUE
		if(!computer.printer)
			error = "Missing Hardware: Your computer does69ot have the required hardware to complete this operation."
			return TRUE
		if(!computer.printer.print_text(selected_audio.transcribed ? selected_audio.stored_data : "Please press the \"Transcribe\" button to transcribe the audio file."))
			error = "Hardware error: Printer was unable to print the file. It69ay be out of paper."
			return TRUE

/datum/nano_module/program/audio
	name = "Audio Player"

/datum/nano_module/program/audio/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)

	var/datum/computer_file/program/audio/PRG
	var/list/data = host.initial_data()
	if(program)
		data = program.get_header_data()
		PRG = program
	else
		return
	var/obj/item/computer_hardware/hard_drive/HDD
	var/obj/item/computer_hardware/hard_drive/portable/RHDD

	if(PRG.error)
		data69"error"69 = PRG.error

	if(PRG.browsing)
		data69"browsing"69 = PRG.browsing
		if(!PRG.computer || !PRG.computer.hard_drive)
			data69"error"69 = "I/O ERROR: Unable to access hard drive."
		else
			HDD = PRG.computer.hard_drive
			var/list/files69069
			for(var/datum/computer_file/F in HDD.stored_files)
				if(F.filetype == "AUD")
					files.Add(list(list(
						"name" = F.filename,
						"size" = F.size
					)))
			data69"files"69 = files

			RHDD = PRG.computer.portable_drive
			if(RHDD)
				data69"usbconnected"69 = TRUE
				var/list/usbfiles69069
				for(var/datum/computer_file/F in RHDD.stored_files)
					if(F.filetype == "AUD")
						usbfiles.Add(list(list(
							"name" = F.filename,
							"size" = F.size,
						)))
				data69"usbfiles"69 = usbfiles

	else if(!PRG.transcribing)
		data69"playing"69 = PRG.playing
		if(PRG.selected_audio)
			data69"filename"69 = PRG.selected_audio.filename
			data69"transcript"69 = PRG.selected_audio.transcribed ? PRG.selected_audio.stored_data : "Please press the \"Transcribe\" button to transcribe the audio file."
		else
			data69"filename"69 = "No File"
			data69"transcript"69 = "Please load an audio file."
	else
		data69"transcribe_running"69 = 1
		data69"transcribe_progress"69 = PRG.transcribe_progress
		data69"transcribe_maxprogress"69 = PRG.selected_audio.size
		data69"transcribe_rate"69 = PRG.ntnet_speed


	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "mpc_audio_player.tmpl",69ame, 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
