/datum/job/rd
	title = "Moebius Expedition Overseer"
	flag = MEO
	head_position = 1
	department = "Science"
	department_flag = MEDSCI
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "Moebius Corporation"
	selection_color = "#ffddff"
	idtype = /obj/item/weapon/card/id/rd
	req_admin_notify = 1
	economic_modifier = 15
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)
	access = list(
		access_rd, access_heads, access_tox, access_genetics, access_morgue,
		access_tox_storage, access_teleporter, access_sec_doors,
		access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
		access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network
	)
	ideal_character_age = 50

	stat_modifers = list(
		STAT_PRD = 20,
		STAT_COG = 30,
		STAT_BIO = 20,
	)

	uniform = /obj/item/clothing/under/rank/expedition_overseer
	pda = /obj/item/device/pda/heads/rd
	ear = /obj/item/device/radio/headset/heads/rd
	shoes = /obj/item/clothing/shoes/reinforced
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	hand = /obj/item/weapon/clipboard

	backpacks = list(
		/obj/item/weapon/storage/backpack,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)

/obj/landmark/join/start/rd
	name = "Moebius Expedition Overseer"
	icon_state = "player-purple-officer"
	join_tag = /datum/job/rd



/datum/job/scientist
	title = "Moebius Scientist"
	flag = SCIENTIST
	department = "Science"
	department_flag = MEDSCI
	faction = "CEV Eris"
	total_positions = 5
	spawn_positions = 3
	supervisors = "the Moebius Expedition Overseer"
	selection_color = "#ffeeff"
	economic_modifier = 7
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)
	access = list(
		access_robotics, access_tox, access_tox_storage, access_research, access_xenobiology, access_xenoarch,
		access_genetics
	)
	idtype = /obj/item/weapon/card/id/sci

	stat_modifers = list(
		STAT_PRD = 10,
		STAT_COG = 20,
		STAT_BIO = 10,
	)

	uniform = /obj/item/clothing/under/rank/scientist
	pda = /obj/item/device/pda/science
	ear = /obj/item/device/radio/headset/headset_sci
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science

	backpacks = list(
		/obj/item/weapon/storage/backpack,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)

/obj/landmark/join/start/scientist
	name = "Moebius Scientist"
	icon_state = "player-purple"
	join_tag = /datum/job/scientist


/datum/job/roboticist
	title = "Moebius Roboticist"
	flag = ROBOTICIST
	department = "Science"
	department_flag = MEDSCI
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Moebius Expedition Overseer"
	selection_color = "#ffeeff"
	economic_modifier = 5
	also_known_languages = list(LANGUAGE_CYRILLIC = 10)
	access = list(
		access_robotics, access_tox, access_tox_storage, access_tech_storage, access_morgue, access_research
	) //As a job that handles so many corpses, it makes sense for them to have morgue access.
	idtype = /obj/item/weapon/card/id/dkgrey

	stat_modifers = list(
		STAT_PRD = 20,
		STAT_COG = 10,
		STAT_BIO = 20,
	)

	uniform = /obj/item/clothing/under/rank/roboticist
	pda = /obj/item/device/pda/roboticist
	gloves = /obj/item/clothing/gloves/thick
	ear = /obj/item/device/radio/headset/headset_sci
	suit = /obj/item/clothing/suit/storage/robotech_jacket
	hand = /obj/item/weapon/storage/toolbox/mechanical
	shoes = /obj/item/clothing/shoes/jackboots

/obj/landmark/join/start/roboticist
	name = "Moebius Roboticist"
	icon_state = "player-purple"
	join_tag = /datum/job/roboticist
