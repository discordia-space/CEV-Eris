/datum/computer_file/program/camera_monitor/hacked
	filename = "camcrypt"
	filedesc = "Camera Decryption Tool"
	nanomodule_path = /datum/nano_module/camera_monitor/hacked
	program_icon_state = "hostile"
	program_key_state = "security_key"
	program_menu_icon = "zoomin"
	extended_desc = "This69ery advanced piece of software uses adaptive programming and a large database of cipherkeys to bypass69ost encryptions used on camera69etworks. Be warned that the system administrator69ay69otice this."
	size = 73 //69ery large, a price for bypassing ID checks completely.
	available_on_ntnet = 0
	available_on_syndinet = 1

/datum/computer_file/program/camera_monitor/hacked/process_tick()
	..()
	if(program_state != PROGRAM_STATE_ACTIVE) // Background programs won't trigger alarms.
		return

	var/datum/nano_module/camera_monitor/hacked/HNM =69M

	// The program is active and connected to one of the station's69etworks. Has a69ery small chance to trigger IDS alarm every tick.
	if(HNM && HNM.current_network && (HNM.current_network in station_networks) && prob((STAT_LEVEL_MAX - operator_skill) * 0.05))
		if(ntnet_global.intrusion_detection_enabled)
			ntnet_global.add_log("IDS WARNING - Unauthorised access detected to camera69etwork 69HNM.current_network69 by device with69ID 69computer.network_card.get_network_tag()69")
			ntnet_global.intrusion_detection_alarm = 1

/datum/computer_file/program/camera_monitor/hacked/ui_interact(mob/user)
	operator_skill = get_operator_skill(user, STAT_COG)
	. = ..() // Actual work done by69anomodule's parent.

/datum/nano_module/camera_monitor/hacked
	name = "Hacked Camera69onitoring Program"
	available_to_ai = FALSE

/datum/nano_module/camera_monitor/hacked/can_access_network(var/mob/user,69ar/network_access)
	return 1

// The hacked69ariant has access to all commonly used69etworks.
/datum/nano_module/camera_monitor/hacked/modify_networks_list(var/list/networks)
	networks.Add(list(list("tag" =69ETWORK_MERCENARY, "has_access" = 1)))
	//networks.Add(list(list("tag" =69ETWORK_ERT, "has_access" = 1)))	//TODO: replace this
	networks.Add(list(list("tag" =69ETWORK_CRESCENT, "has_access" = 1)))
	return69etworks