/datum/job/chief_engineer
	title = "Technomancer Exultant"
	flag = EXULTANT
	head_position = 1
	department = "Engineering"
	department_flag = ENGINEERING | COMMAND
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#c7b97b"
	req_admin_notify = 1
	economic_modifier = 10
	also_known_languages = list(LANGUAGE_CYRILLIC = 100, LANGUAGE_SERBIAN = 25)

	ideal_character_age = 50

	outfit_type = /decl/hierarchy/outfit/job/engineering/exultant

	access = list(
		access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
		access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
		access_heads, access_construction, access_sec_doors,
		access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload
	)

	stat_modifers = list(
		STAT_MEC = 40,
		STAT_COG = 20,
	)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/ntnetmonitor,
							 /datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shield_control,
							 /datum/computer_file/program/reports)

	description = "You are an exultant, the head of a technomancer clan, nomadic spacefaring engineers. You and your clan have taken up residence on Eris, it is your work, your home, and your pride. \
You are to keep the ship running and constantly improve it as much as you are able. Let none question the efficacy of your labours."

	loyalties = "Your first loyalty is to your pride. The engineering department is your territory, and machinery across the station are your responsibility. Do not tolerate others interfering with them, intruding on your space, or questioning your competence. You don't need inspections, oversight or micromanagement. Outsiders should only enter your spaces by invitation, or out of necessity. Even the captain and other command staff are no exception.\

Your second loyalty is to your clan. Ensure they are paid, fed and safe. Don't risk their lives unnecessarily. If an area is infested with monsters, there's no reason to risk lives trying to repair anything inside there. If one of your people is imprisoned, endangered or accused, you should fight for them. Treat every technomancer like your family"

/obj/landmark/join/start/chief_engineer
	name = "Technomancer Exultant"
	icon_state = "player-orange-officer"
	join_tag = /datum/job/chief_engineer


/datum/job/technomancer
	title = "Technomancer"
	flag = TECHNOMANCER
	department = "Engineering"
	department_flag = ENGINEERING
	faction = "CEV Eris"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Technomancer Exultant"
	selection_color = "#d5c88f"
	economic_modifier = 5
	also_known_languages = list(LANGUAGE_CYRILLIC = 100, LANGUAGE_SERBIAN = 5)

	outfit_type = /decl/hierarchy/outfit/job/engineering/engineer

	access = list(
		access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
		access_external_airlocks, access_construction, access_atmospherics
	)

	stat_modifers = list(
		STAT_MEC = 30,
		STAT_COG = 15,
	)

	software_on_spawn = list(/datum/computer_file/program/power_monitor,
							 /datum/computer_file/program/supermatter_monitor,
							 /datum/computer_file/program/alarm_monitor,
							 /datum/computer_file/program/atmos_control,
							 /datum/computer_file/program/rcon_console,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/shield_control)

/obj/landmark/join/start/technomancer
	name = "Technomancer"
	icon_state = "player-orange"
	join_tag = /datum/job/technomancer
