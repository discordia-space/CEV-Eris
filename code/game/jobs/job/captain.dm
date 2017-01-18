var/datum/announcement/minor/captain_announcement = new(do_newscast = 1)

/datum/job/captain
	title = "Captain"
	flag = CAPTAIN
	department = "Command"
	head_position = 1
	department_flag = ENGSEC
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "company officials and Corporate Regulations"
	selection_color = "#ccccff"
	idtype = /obj/item/weapon/card/id/gold
	req_admin_notify = 1
	access = list() 			//See get_access()
	minimal_access = list() 	//See get_access()
	minimal_player_age = 14
	economic_modifier = 20

	ideal_character_age = 70 // Old geezer captains ftw


	implanted = 1
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



/datum/job/hop
	title = "First Officer"
	flag = HOP
	department = "Civilian"
	head_position = 1
	department_flag = CIVILIAN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the captain"
	selection_color = "#ddddff"
	idtype = /obj/item/weapon/card/id/hop
	req_admin_notify = 1
	minimal_player_age = 10
	economic_modifier = 10
	ideal_character_age = 50

	implanted = 1
	uniform = /obj/item/clothing/under/rank/head_of_personnel
	shoes = /obj/item/clothing/shoes/laceup
	suit = /obj/item/clothing/suit/armor/vest
	gloves = /obj/item/clothing/gloves/thick
	pda = /obj/item/device/pda/heads/hop
	ear = /obj/item/device/radio/headset/heads/hop

	put_in_backpack = list(
		/obj/item/weapon/storage/box/ids \
		)

	get_access()
		return get_all_station_access()