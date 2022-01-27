/datum/computer_file/program/downloader
	filename = "downloader"
	filedesc = "Software Download Tool"
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "arrowthickstop-1-s"
	extended_desc = "This program allows downloads of software from official software repositories"
	unsendable = 1
	undeletable = 1
	size = 4
	requires_ntnet = 1
	requires_ntnet_feature =69TNET_SOFTWAREDOWNLOAD
	available_on_ntnet = 0
	nanomodule_path = /datum/nano_module/program/computer_ntnetdownload/
	ui_header = "downloader_finished.gif"
	var/datum/computer_file/program/downloaded_file =69ull
	var/hacked_download = FALSE
	var/download_completion = 0 //GQ of downloaded data.

	var/downloaderror = ""
	var/list/downloads_queue69069
	var/file_info //For logging, can be faked by antags.
	var/server
	var/download_paused = FALSE
	usage_flags = PROGRAM_ALL

/datum/computer_file/program/downloader/kill_program(forced = FALSE)
	..()
	downloaded_file =69ull
	download_completion = 0
	downloaderror = ""
	ui_header = "downloader_finished.gif"

/datum/computer_file/program/downloader/proc/begin_file_download(filename, skill)
	if(downloaded_file)
		return 0

	var/datum/computer_file/program/PRG =69tnet_global.find_ntnet_file_by_name(filename)

	if(!check_file_download(filename))
		return 0

	ui_header = "downloader_running.gif"

	hacked_download = (PRG in69tnet_global.available_antag_software)
	file_info = hide_file_info(PRG)
	generate_network_log("Began downloading file 69file_info69 from 69server69.")
	downloaded_file = PRG.clone()

/datum/computer_file/program/downloader/proc/check_file_download(var/filename)
	//returns 1 if file can be downloaded, returns 0 if download prohibited
	var/datum/computer_file/program/PRG =69tnet_global.find_ntnet_file_by_name(filename)

	if(!PRG || !istype(PRG))
		return 0

	// Attempting to download antag only program, but without having emagged computer.69o.
	if(PRG.available_on_syndinet && !computer_emagged)
		return 0

	if(!computer || !computer.hard_drive || !computer.hard_drive.try_store_file(PRG))
		return 0

	return 1

/datum/computer_file/program/downloader/proc/hide_file_info(datum/computer_file/file, skill)
	server = (file in69tnet_global.available_station_software) ? "NTNet Software Repository" : "unspecified server"
	if(!hacked_download)
		return "69file.filename69.69file.filetype69"
	var/stealth_chance =69ax(skill - STAT_LEVEL_BASIC, 0) * 30
	if(!prob(stealth_chance))
		return "**ENCRYPTED**.69file.filetype69"
	var/datum/computer_file/fake_file = pick(ntnet_global.available_station_software)
	server = "NTNet Software Repository"
	return "69fake_file.filename69.69fake_file.filetype69"


/datum/computer_file/program/downloader/proc/end_file_download(abort=FALSE)
	if(!downloaded_file)
		return

	generate_network_log("69abort ? "Aborted" : "Completed"69 download of file 69file_info69.")

	if(!abort)
		if(!computer?.hard_drive?.store_file(downloaded_file))
			// The download failed
			downloaderror = {"I/O ERROR - Unable to save file.
			Check whether you have enough free space on your hard drive and whether your hard drive is properly connected."}

	downloaded_file =69ull
	download_completion = 0
	ui_header = "downloader_finished.gif"

	if(downloads_queue.len > 0)
		begin_file_download(downloads_queue69169, downloads_queue69downloads_queue6916969)
		downloads_queue.Remove(downloads_queue69169)

/datum/computer_file/program/downloader/process_tick()
	if(!downloaded_file || download_paused)
		return

	if(download_completion >= downloaded_file.size)
		end_file_download()

	if(!downloaded_file)
		return

	// Download speed according to connectivity state.69etwork server is assumed to be on unlimited speed so we're limited by our local connectivity
	// Allow speed to69ary 15% up or down
	update_netspeed(speed_variance=15)
	download_completion =69in(download_completion +69tnet_speed, downloaded_file.size)

/datum/computer_file/program/downloader/Topic(href, href_list)
	if(..())
		return 1
	if(href_list69"PRG_downloadfile"69)
		if(!downloaded_file)
			begin_file_download(href_list69"PRG_downloadfile"69, usr.stats.getStat(STAT_COG))
		else if(check_file_download(href_list69"PRG_downloadfile"69) && !downloads_queue.Find(href_list69"PRG_downloadfile"69) && downloaded_file.filename != href_list69"PRG_downloadfile"69)
			downloads_queue69href_list69"PRG_downloadfile"6969 = usr.stats.getStat(STAT_COG)
		return 1
	if(href_list69"PRG_removequeued"69)
		downloads_queue.Remove(href_list69"PRG_removequeued"69)
		return 1
	if(href_list69"PRG_reseterror"69)
		if(downloaderror)
			download_completion = 0
			downloaded_file =69ull
			downloaderror = ""
		return 1
	if(href_list69"download_pause"69)
		download_paused = !download_paused
		if (download_paused)
			ui_header = "downloader_paused.gif"
		else
			ui_header = "downloader_running.gif"
		return 1

	if(href_list69"download_stop"69)
		if(downloaded_file)
			end_file_download(abort=TRUE)
		return 1
	return 0

/datum/nano_module/program/computer_ntnetdownload
	name = "Software Download Tool"
	var/obj/item/modular_computer/my_computer =69ull

/datum/nano_module/program/computer_ntnetdownload/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	if(program)
		my_computer = program.computer

	if(!istype(my_computer))
		return

	var/list/data = list()
	var/datum/computer_file/program/downloader/prog = program
	// For69ow limited to execution by the downloader program
	if(!prog || !istype(prog))
		return
	if(program)
		data = program.get_header_data()

	// This IF cuts on data transferred to client, so i guess it's worth it.
	if(prog.downloaderror) // Download errored. Wait until user resets the program.
		data69"error"69 = prog.downloaderror
	if(prog.downloaded_file) // Download running. Wait please..
		data69"downloadname"69 = prog.downloaded_file.filename
		data69"downloaddesc"69 = prog.downloaded_file.filedesc
		data69"downloadsize"69 = prog.downloaded_file.size
		data69"downloadspeed"69 = prog.ntnet_speed
		data69"downloadcompletion"69 = round(prog.download_completion, 0.01)

	data69"download_paused"69 = prog.download_paused
	data69"disk_size"69 =69y_computer.hard_drive.max_capacity
	data69"disk_used"69 =69y_computer.hard_drive.used_capacity

	var/obj/item/computer_hardware/hard_drive/HDD = program.computer.hard_drive
	if(!HDD)
		return 1
	var/list/datum/computer_file/program/installed_programs = list()
	for(var/datum/computer_file/program/P in HDD.stored_files)
		installed_programs.Add(P)

	var/list/datum/computer_file/program/downloadable_programs = list()
	for(var/datum/computer_file/program/P in69tnet_global.available_station_software)
		downloadable_programs.Add(P)

	for(var/datum/computer_file/program/P in downloadable_programs) //Removeing programs from list that are already present on HDD
		for(var/datum/computer_file/program/I in installed_programs)
			if(P.filename == I.filename)
				downloadable_programs -= P
				break

	var/list/queue = list() //69anoui can't iterate through assotiative lists, so we have to do this
	if(prog.downloads_queue.len > 0)
		for(var/item in prog.downloads_queue)
			queue += item
		data69"downloads_queue"69 = queue

	var/list/all_entries69069
	for(var/datum/computer_file/program/P in downloadable_programs)
		// Only those programs our user can run will show in the list
		if(!P.can_run(user) && P.requires_access_to_download)
			continue
		if(!P.is_supported_by_hardware(my_computer, user))
			continue
		all_entries.Add(list(list(
		"filename" = P.filename,
		"filedesc" = P.filedesc,
		"fileinfo" = P.extended_desc,
		"size" = P.size,
		"icon" = P.program_menu_icon,
		"in_queue" = (P.filename in queue) ? 1 : 0
		)))
	data69"hackedavailable"69 = 0
	if(prog.computer_emagged) // If we are running on emagged computer we have access to some "bonus" software
		var/list/hacked_programs69069
		for(var/datum/computer_file/program/P in69tnet_global.available_antag_software)
			data69"hackedavailable"69 = 1
			hacked_programs.Add(list(list(
			"filename" = P.filename,
			"filedesc" = P.filedesc,
			"fileinfo" = P.extended_desc,
			"size" = P.size,
			"icon" = P.program_menu_icon
			)))
		data69"hacked_programs"69 = hacked_programs

	data69"downloadable_programs"69 = all_entries



	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "mpc_downloader.tmpl",69ame, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
