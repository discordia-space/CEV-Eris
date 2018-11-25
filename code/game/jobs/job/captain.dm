var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

/datum/job/captain
	title = "Captain"
	flag = CAPTAIN
	department = "Command"
	head_position = 1
	department_flag = COMMAND
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your heart and wisdom"
	selection_color = "#ccccff"
	req_admin_notify = 1
	economic_modifier = 25
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)

	ideal_character_age = 70 // Old geezer captains ftw
	outfit_type = /decl/hierarchy/outfit/job/captain

	stat_modifers = list(
		STAT_ROB = 10,
		STAT_TGH = 10,
	)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/card_mod,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/reports)


	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0
		if(H.age>49)
			var/obj/item/clothing/under/U = H.w_uniform
			if(istype(U)) U.accessories += new /obj/item/clothing/accessory/medal/gold/captain(U)
		return 1

	get_access()
		return get_all_station_access()

/obj/landmark/join/start/captain
	name = "Captain"
	icon_state = "player-gold-officer"
	join_tag = /datum/job/captain



/datum/job/hop
	title = "First Officer"
	flag = FIRSTOFFICER
	department = "Civilian"
	head_position = 1
	department_flag = COMMAND
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ddddff"
	req_admin_notify = 1
	economic_modifier = 15
	also_known_languages = list(LANGUAGE_CYRILLIC = 20)
	ideal_character_age = 50

	stat_modifers = list(
		STAT_TGH = 10,
	)

	software_on_spawn = list(/datum/computer_file/program/comm,
							 /datum/computer_file/program/card_mod,
							 /datum/computer_file/program/camera_monitor,
							 /datum/computer_file/program/reports)


	get_access()
		return get_all_station_access()

/obj/landmark/join/start/hop
	name = "First Officer"
	icon_state = "player-gold"
	join_tag = /datum/job/hop
