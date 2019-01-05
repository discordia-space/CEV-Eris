//Cargo
/datum/job/merchant
	title = "Guild Merchant"
	flag = MERCHANT
	department = "Guild"
	head_position = 1
	department_flag = GUILD | COMMAND
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your greed"
	selection_color = "#b3a68c"
	economic_modifier = 0
	//The merchant gets no personal salary, but he's free to pay himself as much as he likes from the guild account

	also_known_languages = list(LANGUAGE_CYRILLIC = 100, LANGUAGE_SERBIAN = 100)
	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_merchant, access_mining,
		access_heads, access_mining_station, access_RC_announce, access_keycard_auth, access_sec_doors,
		access_eva, access_external_airlocks
	)
	ideal_character_age = 40

	software_on_spawn = list(///datum/computer_file/program/supply,
							 ///datum/computer_file/program/deck_management,
							 /datum/computer_file/program/scanner,
							 /datum/computer_file/program/wordprocessor,
							 /datum/computer_file/program/reports)

	outfit_type = /decl/hierarchy/outfit/job/cargo/merchant

/obj/landmark/join/start/merchant
	name = "Guild Merchant"
	icon_state = "player-beige-officer"
	join_tag = /datum/job/merchant



/datum/job/cargo_tech
	title = "Guild Technician"
	flag = GUILDTECH
	department = "Guild"
	department_flag = GUILD
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Guild Merchant"
	selection_color = "#c3b9a6"
	also_known_languages = list(LANGUAGE_CYRILLIC = 15, LANGUAGE_SERBIAN = 5)

	outfit_type = /decl/hierarchy/outfit/job/cargo/cargo_tech

	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining,
		access_mining_station
	)

	stat_modifiers = list(
		STAT_ROB = 10,
		STAT_TGH = 10,
	)

	software_on_spawn = list(///datum/computer_file/program/supply,
							 ///datum/computer_file/program/deck_management,
							 /datum/computer_file/program/scanner,
							 /datum/computer_file/program/wordprocessor,
							 /datum/computer_file/program/reports)


/obj/landmark/join/start/cargo_tech
	name = "Guild Technician"
	icon_state = "player-beige"
	join_tag = /datum/job/cargo_tech

/datum/job/mining
	title = "Guild Miner"
	flag = MINER
	department = "Guild"
	department_flag = GUILD
	faction = "CEV Eris"
	total_positions = 4
	spawn_positions = 4
	supervisors = "the Guild Merchant"
	selection_color = "#c3b9a6"
	economic_modifier = 5
	also_known_languages = list(LANGUAGE_CYRILLIC = 15, LANGUAGE_SERBIAN = 5)

	outfit_type = /decl/hierarchy/outfit/job/cargo/mining

	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_mining,
		access_mining_station
	)


	stat_modifiers = list(
		STAT_ROB = 20,
		STAT_TGH = 15,
		STAT_MEC = 15
	)

	software_on_spawn = list(///datum/computer_file/program/supply,
							 ///datum/computer_file/program/deck_management,
							 /datum/computer_file/program/wordprocessor,
							 /datum/computer_file/program/reports)

/obj/landmark/join/start/mining
	name = "Guild Miner"
	icon_state = "player-beige"
	join_tag = /datum/job/mining
