/datum/job/cmo
	title = "Moebius Biolab Officer"
	flag = MBO
	head_position = 1
	department = "Medical"
	department_flag = MEDICAL | COMMAND
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Moebius Expedition Overseer"
	selection_color = "#94a87f"
	req_admin_notify = 1
	economic_modifier = 10
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)

	outfit_type = /decl/hierarchy/outfit/job/medical/cmo

	access = list(
		access_moebius, access_medical_equip, access_morgue, access_genetics, access_heads,
		access_chemistry, access_virology, access_cmo, access_surgery, access_RC_announce,
		access_keycard_auth, access_sec_doors, access_psychiatrist, access_eva, access_external_airlocks
	)

	ideal_character_age = 50

	stat_modifers = list(
		STAT_BIO = 40,
	)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/reports)

/obj/landmark/join/start/cmo
	name = "Moebius Biolab Officer"
	icon_state = "player-green-officer"
	join_tag = /datum/job/cmo


/datum/job/doctor
	title = "Moebius Doctor"
	flag = DOCTOR
	department = "Medical"
	department_flag = MEDICAL
	faction = "CEV Eris"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#a8b69a"
	economic_modifier = 7
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)

	outfit_type = /decl/hierarchy/outfit/job/medical/doctor

	access = list(
		access_moebius, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology,
		access_genetics
	)

	stat_modifers = list(
		STAT_BIO = 30,
	)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)


/obj/landmark/join/start/doctor
	name = "Moebius Doctor"
	icon_state = "player-green"
	join_tag = /datum/job/doctor



/datum/job/chemist
	title = "Moebius Chemist"
	flag = CHEMIST
	department = "Medical"
	department_flag = MEDICAL
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#a8b69a"
	economic_modifier = 5
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)

	outfit_type = /decl/hierarchy/outfit/job/medical/chemist

	access = list(
		access_moebius, access_medical_equip, access_morgue, access_surgery, access_chemistry, access_virology
	)

	stat_modifers = list(
		STAT_COG = 10,
		STAT_BIO = 30,
	)

	software_on_spawn = list(/datum/computer_file/program/scanner)

/obj/landmark/join/start/chemist
	name = "Moebius Chemist"
	icon_state = "player-green"
	join_tag = /datum/job/chemist


/datum/job/psychiatrist
	title = "Moebius Psychiatrist"
	flag = PSYCHIATRIST
	department = "Medical"
	department_flag = MEDICAL
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	economic_modifier = 5
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#a8b69a"
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)

	outfit_type = /decl/hierarchy/outfit/job/medical/psychiatrist

	access = list(
		access_moebius, access_medical_equip, access_morgue, access_psychiatrist
	)

	stat_modifers = list(
		STAT_BIO = 15,
	)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)


/obj/landmark/join/start/psychiatrist
	name = "Moebius Psychiatrist"
	icon_state = "player-green"
	join_tag = /datum/job/psychiatrist


/datum/job/paramedic
	title = "Moebius Paramedic"
	flag = PARAMEDIC
	department = "Medical"
	department_flag = MEDICAL
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Moebius Biolab Officer"
	selection_color = "#a8b69a"
	economic_modifier = 4
	also_known_languages = list(LANGUAGE_CYRILLIC = 20)

	outfit_type = /decl/hierarchy/outfit/job/medical/paramedic

	access = list(
		access_moebius, access_medical_equip, access_morgue, access_surgery,
		access_eva, access_maint_tunnels, access_external_airlocks, access_psychiatrist
	)

	stat_modifers = list(
		STAT_BIO = 20,
		STAT_ROB = 10,
		STAT_TGH = 10,
	)

	software_on_spawn = list(/datum/computer_file/program/suit_sensors,
							 /datum/computer_file/program/camera_monitor)

/obj/landmark/join/start/paramedic
	name = "Moebius Paramedic"
	icon_state = "player-green"
	join_tag = /datum/job/paramedic

