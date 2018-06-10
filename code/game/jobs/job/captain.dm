var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

/datum/job/captain
	title = "Captain"
	flag = CAPTAIN
	department = "Command"
	head_position = 1
	department_flag = ENGSEC
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your heart and wisdom"
	selection_color = "#ccccff"
	idtype = /obj/item/weapon/card/id/gold
	req_admin_notify = 1
	economic_modifier = 25
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)

	ideal_character_age = 70 // Old geezer captains ftw

	stat_modifers = list(
		STAT_PHY = 10,
		STAT_ROB = 10,
	)

	uniform = /obj/item/clothing/under/rank/captain
	shoes = /obj/item/clothing/shoes/color/brown
	pda = /obj/item/device/pda/captain
	hat = /obj/item/clothing/head/caphat
	ear = /obj/item/device/radio/headset/heads/captain
	glasses = /obj/item/clothing/glasses/sunglasses

	backpacks = list(
		/obj/item/weapon/storage/backpack/captain,\
		/obj/item/weapon/storage/backpack/satchel_cap,\
		/obj/item/weapon/storage/backpack/satchel
		)

	put_in_backpack = list(
		/obj/item/weapon/storage/box/ids \
	)

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
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ddddff"
	idtype = /obj/item/weapon/card/id/hop
	req_admin_notify = 1
	economic_modifier = 15
	also_known_languages = list(LANGUAGE_CYRILLIC = 20)
	ideal_character_age = 50

	stat_modifers = list(
		STAT_ROB = 10,
	)

	uniform = /obj/item/clothing/under/rank/first_officer
	shoes = /obj/item/clothing/shoes/reinforced
	suit = /obj/item/clothing/suit/armor/vest
	gloves = /obj/item/clothing/gloves/thick
	pda = /obj/item/device/pda/heads/hop
	ear = /obj/item/device/radio/headset/heads/hop

	put_in_backpack = list(
		/obj/item/weapon/storage/box/ids \
		)

	get_access()
		return get_all_station_access()

/obj/landmark/join/start/hop
	name = "First Officer"
	icon_state = "player-gold"
	join_tag = /datum/job/hop
