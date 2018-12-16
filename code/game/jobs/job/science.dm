/datum/job/rd
	title = "Moebius Expedition Overseer"
	flag = MEO
	head_position = 1
	department = "Science"
	department_flag = SCIENCE | COMMAND
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Moebius Corporation"
	selection_color = "#b39aaf"
	req_admin_notify = 1
	economic_modifier = 15
	also_known_languages = list(LANGUAGE_CYRILLIC = 25, LANGUAGE_SERBIAN = 25)

	outfit_type = /decl/hierarchy/outfit/job/science/rd

	access = list(
		access_rd, access_heads, access_tox, access_genetics, access_morgue,
		access_tox_storage, access_teleporter, access_sec_doors,
		access_moebius, access_medical_equip, access_chemistry, access_virology, access_cmo, access_surgery, access_psychiatrist,
		access_robotics, access_xenobiology, access_ai_upload, access_tech_storage, access_eva, access_external_airlocks,
		access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network
	)
	ideal_character_age = 50

	stat_modifers = list(
		STAT_MEC = 30,
		STAT_COG = 40,
		STAT_BIO = 30,
	)

	// TODO: enable after baymed
	software_on_spawn = list(/datum/computer_file/program/comm,
							 ///datum/computer_file/program/aidiag,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/reports)

/obj/landmark/join/start/rd
	name = "Moebius Expedition Overseer"
	icon_state = "player-purple-officer"
	join_tag = /datum/job/rd



/datum/job/scientist
	title = "Moebius Scientist"
	flag = SCIENTIST
	department = "Science"
	department_flag = SCIENCE
	faction = "CEV Eris"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Moebius Expedition Overseer"
	selection_color = "#bdb1bb"
	economic_modifier = 7
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)

	//alt_titles = list("Moebius Xenobiologist")
	outfit_type = /decl/hierarchy/outfit/job/science/scientist

	access = list(
		access_robotics, access_tox, access_tox_storage, access_moebius, access_xenobiology, access_xenoarch,
		access_genetics
	)

	stat_modifers = list(
		STAT_MEC = 20,
		STAT_COG = 30,
		STAT_BIO = 20,
	)


/obj/landmark/join/start/scientist
	name = "Moebius Scientist"
	icon_state = "player-purple"
	join_tag = /datum/job/scientist


/datum/job/roboticist
	title = "Moebius Roboticist"
	flag = ROBOTICIST
	department = "Science"
	department_flag = SCIENCE
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Moebius Expedition Overseer"
	selection_color = "#bdb1bb"
	economic_modifier = 5
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)

	outfit_type = /decl/hierarchy/outfit/job/science/scientist

	access = list(
		access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_moebius
	) //As a job that handles so many corpses, it makes sense for them to have morgue access.

	stat_modifers = list(
		STAT_MEC = 30,
		STAT_COG = 20,
		STAT_BIO = 30,
	)


/obj/landmark/join/start/roboticist
	name = "Moebius Roboticist"
	icon_state = "player-purple"
	join_tag = /datum/job/roboticist
