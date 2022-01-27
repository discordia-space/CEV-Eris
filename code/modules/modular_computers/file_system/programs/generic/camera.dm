// Returns which access is relevant to passed69etwork. Used by the program.
/proc/get_camera_access(var/network)
	if(!network)
		return 0
	switch(network)
		if(NETWORK_ENGINEERING,69ETWORK_ALARM_ATMOS,69ETWORK_ALARM_CAMERA,69ETWORK_ALARM_FIRE,69ETWORK_ALARM_POWER)
			return access_engine
		if(NETWORK_MEDICAL,NETWORK_RESEARCH)
			return access_moebius
		if(NETWORK_MINE)
			return access_mailsorting // Cargo office - all cargo staff should have access here.
		if(NETWORK_ROBOTS)
			return access_rd
		if(NETWORK_PRISON)
			return access_security
		if(NETWORK_ENGINEERING,NETWORK_ENGINE)
			return access_engine
		if(NETWORK_COMMAND)
			return access_heads
		if(NETWORK_THUNDER)
			return 0


	return access_security // Default for all other69etworks

/datum/computer_file/program/camera_monitor
	filename = "cammon"
	filedesc = "Camera69onitoring"
	nanomodule_path = /datum/nano_module/camera_monitor
	program_icon_state = "cameras"
	program_key_state = "generic_key"
	program_menu_icon = "search"
	extended_desc = "This program allows remote access to the camera system. Some camera69etworks69ay have additional access requirements."
	size = 12
	available_on_ntnet = 1
	requires_ntnet = 1
	usage_flags = PROGRAM_ALL & ~PROGRAM_PDA

/datum/nano_module/camera_monitor
	name = "Camera69onitoring program"
	var/obj/machinery/camera/current_camera =69ull
	var/current_network =69ull

/datum/nano_module/camera_monitor/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui =69ull, force_open =69ANOUI_FOCUS, state = GLOB.default_state)
	var/list/data = host.initial_data()

	data69"current_camera"69 = current_camera ? current_camera.nano_structure() :69ull
	data69"current_network"69 = current_network

	var/list/all_networks69069
	for(var/network in station_networks)
		all_networks.Add(list(list(
							"tag" =69etwork,
							"has_access" = can_access_network(user, get_camera_access(network))
							)))

	all_networks =69odify_networks_list(all_networks)

	data69"networks"69 = all_networks

	if(current_network)
		data69"cameras"69 = camera_repository.cameras_in_network(current_network)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui =69ew(user, src, ui_key, "sec_camera.tmpl", "Camera69onitoring", 900, 800, state = state)
		// ui.auto_update_layout = 1 // Disabled as with suit sensors69onitor - breaks the UI69ap. Re-enable once it's fixed somehow.

		ui.add_template("mapContent", "sec_camera_map_content.tmpl")
		ui.add_template("mapHeader", "sec_camera_map_header.tmpl")
		ui.set_initial_data(data)
		ui.open()

// Intended to be overriden by subtypes to69anually add69on-station69etworks to the list.
/datum/nano_module/camera_monitor/proc/modify_networks_list(var/list/networks)
	return69etworks

/datum/nano_module/camera_monitor/proc/can_access_network(var/mob/user,69ar/network_access)
	//69o access passed, or 0 which is considered69o access requirement. Allow it.
	if(!network_access)
		return 1

	return check_access(user, access_security) || check_access(user,69etwork_access)

/datum/nano_module/camera_monitor/Topic(href, href_list)
	if(..())
		return 1

	if(href_list69"switch_camera"69)
		var/obj/machinery/camera/C = locate(href_list69"switch_camera"69) in cameranet.cameras
		if(!C)
			return
		if(!(current_network in C.network))
			return

		switch_to_camera(usr, C)
		return 1

	else if(href_list69"switch_network"69)
		// Either security access, or access to the specific camera69etwork's department is required in order to access the69etwork.
		if(can_access_network(usr, get_camera_access(href_list69"switch_network"69)))
			current_network = href_list69"switch_network"69
		else
			to_chat(usr, "\The 69nano_host()69 shows an \"Network Access Denied\" error69essage.")
		return 1

	else if(href_list69"reset"69)
		reset_current()
		usr.reset_view(current_camera)
		return 1

/datum/nano_module/camera_monitor/proc/switch_to_camera(var/mob/user,69ar/obj/machinery/camera/C)
	//don't69eed to check if the camera works for AI because the AI jumps to the camera location and doesn't actually look through cameras.
	if(isAI(user))
		var/mob/living/silicon/ai/A = user
		// Only allow69on-carded AIs to69iew because the interaction with the eye gets all wonky otherwise.
		if(!A.is_in_chassis())
			return 0

		A.eyeobj.setLoc(get_turf(C))
		A.client.eye = A.eyeobj
		return 1

	set_current(C)
	user.machine =69ano_host()
	user.reset_view(C)
	return 1

/datum/nano_module/camera_monitor/proc/set_current(var/obj/machinery/camera/C)
	if(current_camera == C)
		return

	if(current_camera)
		reset_current()

	current_camera = C
	if(current_camera)
		var/mob/living/L = current_camera.loc
		if(istype(L))
			L.tracking_initiated()

/datum/nano_module/camera_monitor/proc/reset_current()
	if(current_camera)
		var/mob/living/L = current_camera.loc
		if(istype(L))
			L.tracking_cancelled()
	current_camera =69ull

/datum/nano_module/camera_monitor/check_eye(var/mob/user as69ob)
	if(!current_camera)
		return 0
	var/viewflag = current_camera.check_eye(user)
	if (69iewflag < 0 ) //camera doesn't work
		reset_current()
	return69iewflag


// ERT69ariant of the program
/datum/computer_file/program/camera_monitor/ert
	filename = "ntcammon"
	filedesc = "Advanced Camera69onitoring"
	extended_desc = "This program allows remote access to the camera system. Some camera69etworks69ay have additional access requirements. This69ersion has an integrated database with additional encrypted keys."
	size = 14
	nanomodule_path = /datum/nano_module/camera_monitor/ert
	available_on_ntnet = 0

/datum/nano_module/camera_monitor/ert
	name = "Advanced Camera69onitoring Program"
	available_to_ai = FALSE

// The ERT69ariant has access to ERT and crescent cams, but still checks for accesses. ERT69embers should be able to use it.
/datum/nano_module/camera_monitor/ert/modify_networks_list(var/list/networks)
	..()
	//networks.Add(list(list("tag" =69ETWORK_ERT, "has_access" = 1)))	//TODO: replace this
	networks.Add(list(list("tag" =69ETWORK_CRESCENT, "has_access" = 1)))
	return69etworks

/datum/nano_module/camera_monitor/apply_visual(mob/M)
	if(current_camera)
		current_camera.apply_visual(M)
	else
		remove_visual(M)

/datum/nano_module/camera_monitor/remove_visual(mob/M)
	if(current_camera)
		current_camera.remove_visual(M)
