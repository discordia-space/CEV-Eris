/datum/job/science
	department = "Science"
	department_flag = MEDSCI
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Moebius Expedition Overseer"
	selection_color = "#ffeeff"


/datum/job/science/rd
	title = JOB_MEO
	flag = MEO
	head_position = 1
	supervisors = "Moebius Corporation"
	selection_color = "#ffddff"
	idtype = /obj/item/weapon/card/id/rd
	req_admin_notify = 1
	economic_modifier = 15
	minimal_access = list(
		access_rd, access_heads, access_tox, access_genetics, access_morgue,
		access_tox_storage, access_teleporter, access_sec_doors,
		access_research, access_robotics, access_xenobiology, access_ai_upload, access_tech_storage,
		access_RC_announce, access_keycard_auth, access_tcomsat, access_gateway, access_xenoarch, access_network
	)
	ideal_character_age = 50

	uniform = /obj/item/clothing/under/rank/expedition_overseer
	pda = /obj/item/device/pda/heads/rd
	ear = /obj/item/device/radio/headset/heads/rd
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/storage/toggle/labcoat
	hand = /obj/item/weapon/clipboard


/datum/job/science/scientist
	title = JOB_SCIENTIST
	flag = SCIENTIST
	total_positions = 5
	spawn_positions = 3
	economic_modifier = 7
	minimal_access = list(access_tox, access_tox_storage, access_research, access_xenoarch, access_genetics)
	additional_access = list(access_robotics, access_xenobiology)
	idtype = /obj/item/weapon/card/id/sci

	uniform = /obj/item/clothing/under/rank/scientist
	pda = /obj/item/device/pda/science
	ear = /obj/item/device/radio/headset/headset_sci
	shoes = /obj/item/clothing/shoes/jackboots
	suit = /obj/item/clothing/suit/storage/toggle/labcoat/science


/datum/job/science/roboticist
	title = JOB_ROBOTICIST
	flag = ROBOTICIST
	total_positions = 2
	spawn_positions = 2
	economic_modifier = 5
	//As a job that handles so many corpses, it makes sense for them to have morgue access.
	minimal_access = list(access_robotics, access_tech_storage, access_morgue, access_research)
	additional_access = list(access_tox, access_tox_storage)
	idtype = /obj/item/weapon/card/id/dkgrey

	uniform = /obj/item/clothing/under/rank/roboticist
	pda = /obj/item/device/pda/roboticist
	gloves = /obj/item/clothing/gloves/thick
	ear = /obj/item/device/radio/headset/headset_sci
	suit = /obj/item/clothing/suit/storage/robotech_jacket
	hand = /obj/item/weapon/storage/toolbox/mechanical
	shoes = /obj/item/clothing/shoes/jackboots
