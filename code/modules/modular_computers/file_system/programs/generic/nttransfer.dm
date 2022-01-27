var/global/nttransfer_uid = 0

/datum/computer_file/program/nttransfer
	filename = "p2p_transfer"
	filedesc = "P2P Transfer Client"
	extended_desc = "This program allows for simple file transfer69ia direct peer to peer connection."
	program_icon_state = "comm_logs"
	program_key_state = "generic_key"
	program_menu_icon = "transferthick-e-w"
	size = 7
	requires_ntnet = TRUE
	requires_ntnet_feature =69TNET_PEERTOPEER
	network_destination = "other device69ia P2P tunnel"
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/computer_nttransfer

	var/error = ""										// Error screen
	var/server_password = ""							// Optional password to download the file.
	var/datum/computer_file/provided_file =69ull		// File which is provided to clients.
	var/datum/computer_file/downloaded_file =69ull		// File which is being downloaded
	var/list/connected_clients = list()					// List of connected clients.
	var/datum/computer_file/program/nttransfer/remote	// Client69ar, specifies who are we downloading from.
	var/download_completion = 0							// Download progress in GQ
	var/actual_netspeed = 0								// Displayed in the UI, this is the actual transfer speed.
	var/unique_token 									// UID of this program
	var/upload_menu = 0									// Whether we show the program list and upload69enu

/datum/computer_file/program/nttransfer/New()
	unique_token =69ttransfer_uid
	nttransfer_uid++
	..()

/datum/computer_file/program/nttransfer/process_tick()
	..()
	// Server69ode
	if(provided_file)
		for(var/datum/computer_file/program/nttransfer/C in connected_clients)
			// Transfer speed is limited by device which uses slower connectivity.
			// We can have69ultiple clients downloading at same time, but let's assume we use some sort of69ulticast transfer
			// so they can all run on same speed.
			C.actual_netspeed =69in(C.ntnet_speed,69tnet_speed)
			C.download_completion += C.actual_netspeed
			if(C.download_completion >= provided_file.size)
				C.finish_download()
	else if(downloaded_file) // Client69ode
		if(!remote)
			crash_download("Connection to remote server lost")

/datum/computer_file/program/nttransfer/kill_program(forced = FALSE)
	if(downloaded_file) // Client69ode, clean up69ariables for69ext use
		finalize_download()

	if(provided_file) // Server69ode, disconnect all clients
		for(var/datum/computer_file/program/nttransfer/P in connected_clients)
			P.crash_download("Connection terminated by remote server")
		downloaded_file =69ull
	..()

// Finishes download and attempts to store the file on HDD
/datum/computer_file/program/nttransfer/proc/finish_download()
	if(!computer || !computer.hard_drive || !computer.hard_drive.store_file(downloaded_file))
		error = "I/O Error:  Unable to save file. Check your hard drive and try again."
	finalize_download()

//  Crashes the download and displays specific error69essage
/datum/computer_file/program/nttransfer/proc/crash_download(var/message)
	error =69essage ?69essage : "An unknown error has occured during download"
	finalize_download()

// Cleans up69ariables for69ext use
/datum/computer_file/program/nttransfer/proc/finalize_download()
	if(remote)
		remote.connected_clients.Remove(src)
	downloaded_file =69ull
	remote =69ull
	download_completion = 0


/datum/nano_module/program/computer_nttransfer
	name = "P2P Transfer Client"

/datum/nano_module/program/computer_nttransfer/ui_interact(mob/user, ui_key = "main",69ar/datum/nanoui/ui =69ull,69ar/force_open =69ANOUI_FOCUS,69ar/datum/topic_state/state = GLOB.default_state)
	if(!program)
		return
	var/datum/computer_file/program/nttransfer/PRG = program
	if(!istype(PRG))
		return

	var/list/data = program.get_header_data()

	if(PRG.error)
		data69"error"69 = PRG.error
	else if(PRG.downloaded_file)
		data69"downloading"69 = 1
		data69"download_size"69 = PRG.downloaded_file.size
		data69"download_progress"69 = PRG.download_completion
		data69"download_netspeed"69 = PRG.actual_netspeed
		data69"download_name"69 = "69PRG.downloaded_file.filename69.69PRG.downloaded_file.filetype69"
	else if (PRG.provided_file)
		data69"uploading"69 = 1
		data69"upload_uid"69 = PRG.unique_token
		data69"upload_clients"69 = PRG.connected_clients.len
		data69"upload_haspassword"69 = PRG.server_password ? 1 : 0
		data69"upload_filename"69 = "69PRG.provided_file.filename69.69PRG.provided_file.filetype69"
	else if (PRG.upload_menu)
		var/list/all_files69069
		for(var/datum/computer_file/F in PRG.computer.hard_drive.stored_files)
			all_files.Add(list(list(
			"uid" = F.uid,
			"filename" = "69F.filename69.69F.filetype69",
			"size" = F.size
			)))
		data69"upload_filelist"69 = all_files
	else
		var/list/all_servers69069
		for(var/datum/computer_file/program/nttransfer/P in69tnet_global.fileservers)
			if(!P.provided_file)
				continue
			all_servers.Add(list(list(
			"uid" = P.unique_token,
			"filename" = "69P.provided_file.filename69.69P.provided_file.filetype69",
			"size" = P.provided_file.size,
			"haspassword" = P.server_password ? 1 : 0
			)))
		data69"servers"69 = all_servers

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "mpc_transfer.tmpl",69ame, 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/computer_file/program/nttransfer/Topic(href, href_list)
	if(..())
		return 1
	if(href_list69"PRG_downloadfile"69)
		for(var/datum/computer_file/program/nttransfer/P in69tnet_global.fileservers)
			if("69P.unique_token69" == href_list69"PRG_downloadfile"69)
				remote = P
				break
		if(!remote || !remote.provided_file)
			return
		if(remote.server_password)
			var/pass = sanitize(input(usr, "Code 401 Unauthorized. Please enter password:", "Password required"))
			if(pass != remote.server_password)
				error = "Incorrect Password"
				return
		downloaded_file = remote.provided_file.clone()
		remote.connected_clients.Add(src)
		return 1
	if(href_list69"PRG_reset"69)
		error = ""
		upload_menu = 0
		finalize_download()
		if(src in69tnet_global.fileservers)
			ntnet_global.fileservers.Remove(src)
		for(var/datum/computer_file/program/nttransfer/T in connected_clients)
			T.crash_download("Remote server has forcibly closed the connection")
		provided_file =69ull
		return 1
	if(href_list69"PRG_setpassword"69)
		var/pass = sanitize(input(usr, "Enter69ew server password. Leave blank to cancel, input 'none' to disable password.", "Server security", "none"))
		if(!pass)
			return
		if(pass == "none")
			server_password = ""
			return
		server_password = pass
		return 1
	if(href_list69"PRG_uploadfile"69)
		for(var/datum/computer_file/F in computer.hard_drive.stored_files)
			if("69F.uid69" == href_list69"PRG_uploadfile"69)
				if(F.unsendable)
					error = "I/O Error: File locked."
					return
				provided_file = F
				ntnet_global.fileservers.Add(src)
				return
		error = "I/O Error: Unable to locate file on hard drive."
		return 1
	if(href_list69"PRG_uploadmenu"69)
		upload_menu = 1
	return 0
