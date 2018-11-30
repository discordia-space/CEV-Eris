/datum/job/ihc
	title = "Ironhammer Commander"
	flag = IHC
	head_position = 1
	department = "Ironhammer"
	department_flag = IRONHAMMER | COMMAND
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#97b0be"
	req_admin_notify = 1
	economic_modifier = 10
	also_known_languages = list(LANGUAGE_CYRILLIC = 60, LANGUAGE_SERBIAN = 60)

	outfit_type = /decl/hierarchy/outfit/job/security/ihc

	access = list(
		access_security, access_eva, access_sec_doors, access_brig, access_armory, access_medspec,
		access_forensics_lockers, access_morgue, access_maint_tunnels, access_all_personal_lockers,
		access_moebius, access_engine, access_mining, access_moebius, access_construction, access_mailsorting,
		access_heads, access_hos, access_RC_announce, access_keycard_auth, access_gateway,
		access_external_airlocks
	)

	stat_modifers = list(
		STAT_ROB = 30,
		STAT_TGH = 20,
	)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/reports)

/obj/landmark/join/start/ihc
	name = "Ironhammer Commander"
	icon_state = "player-blue-officer"
	join_tag = /datum/job/ihc



/datum/job/gunserg
	title = "Ironhammer Gunnery Sergeant"
	flag = GUNSERG
	department = "Ironhammer"
	department_flag = IRONHAMMER
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Ironhammer Commander"
	selection_color = "#a7bbc6"
	economic_modifier = 5
	also_known_languages = list(LANGUAGE_CYRILLIC = 25, LANGUAGE_SERBIAN = 25)

	outfit_type = /decl/hierarchy/outfit/job/security/gunserg

	access = list(
		access_security, access_moebius, access_moebius, access_engine, access_mailsorting,
		access_eva, access_sec_doors, access_brig, access_armory, access_maint_tunnels, access_morgue,
		access_external_airlocks
	)

	stat_modifers = list(
		STAT_ROB = 20,
		STAT_TGH = 20,
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)
	

/obj/landmark/join/start/gunserg
	name = "Ironhammer Gunnery Sergeant"
	icon_state = "player-blue"
	join_tag = /datum/job/gunserg


/datum/job/inspector
	title = "Ironhammer Inspector"
	flag = INSPECTOR
	department = "Ironhammer"
	department_flag = IRONHAMMER
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Ironhammer Commander"
	selection_color = "#a7bbc6"
	economic_modifier = 5
	also_known_languages = list(LANGUAGE_CYRILLIC = 50, LANGUAGE_SERBIAN = 50)
	access = list(
		access_security, access_moebius, access_moebius, access_engine, access_mailsorting,
		access_sec_doors, access_forensics_lockers, access_morgue, access_maint_tunnels,
		access_external_airlocks
	)

	outfit_type = /decl/hierarchy/outfit/job/security/inspector

	stat_modifers = list(
		STAT_BIO = 10,
		STAT_ROB = 10,
		STAT_TGH = 10,
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/obj/landmark/join/start/inspector
	name = "Ironhammer Inspector"
	icon_state = "player-blue"
	join_tag = /datum/job/inspector


/datum/job/medspec
	title = "Ironhammer Medical Specialist"
	flag = MEDSPEC
	department = "Ironhammer"
	department_flag = IRONHAMMER
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Ironhammer Commander"
	selection_color = "#a7bbc6"
	economic_modifier = 5
	also_known_languages = list(LANGUAGE_CYRILLIC = 5)

	outfit_type = /decl/hierarchy/outfit/job/security/medspec
	access = list(
		access_security, access_moebius, access_sec_doors, access_medspec, access_morgue, access_maint_tunnels
	)

	stat_modifers = list(
		STAT_BIO = 20,
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)


/obj/landmark/join/start/medspec
	name = "Ironhammer Medical Specialist"
	icon_state = "player-blue"
	join_tag = /datum/job/medspec


/datum/job/ihoper
	title = "Ironhammer Operative"
	flag = IHOPER
	department = "Ironhammer"
	department_flag = IRONHAMMER
	faction = "CEV Eris"
	total_positions = 6
	spawn_positions = 6
	supervisors = "the Ironhammer Commander"
	//alt_titles = list("Ironhammer Junior Operative")
	selection_color = "#a7bbc6"
	economic_modifier = 4
	also_known_languages = list(LANGUAGE_CYRILLIC = 25, LANGUAGE_SERBIAN = 25)

	outfit_type = /decl/hierarchy/outfit/job/security/ihoper

	access = list(
		access_security, access_moebius, access_moebius, access_engine, access_mailsorting,
		access_eva, access_sec_doors, access_brig, access_maint_tunnels, access_morgue, access_external_airlocks
	)

	stat_modifers = list(
		STAT_ROB = 10,
		STAT_TGH = 20,
	)

	software_on_spawn = list(/datum/computer_file/program/digitalwarrant,
							 /datum/computer_file/program/camera_monitor)

/obj/landmark/join/start/ihoper
	name = "Ironhammer Operative"
	icon_state = "player-blue"
	join_tag = /datum/job/ihoper
