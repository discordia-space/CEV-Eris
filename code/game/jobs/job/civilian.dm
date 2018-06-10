//Food
/datum/job/bartender
	title = "Bartender"
	flag = BARTENDER
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 25)
	access = list(access_hydroponics, access_bar, access_kitchen)

	stat_modifers = list(
		STAT_AGI = 10,
	)

	uniform = /obj/item/clothing/under/rank/bartender
	pda = /obj/item/device/pda/bar
	ear = /obj/item/device/radio/headset/headset_service

	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0
		var/obj/item/weapon/storage/box/survival/Barpack = null
		if(H.back)
			Barpack = locate() in H.back
			if(!Barpack)
				Barpack = new(H)
				H.equip_to_slot_or_del(Barpack, slot_in_backpack)

		else //TODO: check both hands
			if(!H.r_hand)
				Barpack = new /obj/item/weapon/storage/box/survival(H)
				H.equip_to_slot_or_del(Barpack, slot_r_hand)
			else if(istype(H.r_hand, /obj/item/weapon/storage/box))
				Barpack = H.r_hand

		if(Barpack)
			new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
			new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
			new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
			new /obj/item/ammo_casing/shotgun/beanbag(Barpack)
		return 1

/obj/landmark/join/start/bartender
	name = "Bartender"
	icon_state = "player-grey"
	join_tag = /datum/job/bartender


/datum/job/chef
	title = "Chef"
	flag = CHEF
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)
	access = list(access_hydroponics, access_bar, access_kitchen)
	idtype = /obj/item/weapon/card/id/ltgrey

	uniform = /obj/item/clothing/under/rank/chef
	shoes = /obj/item/clothing/shoes/black
	pda = /obj/item/device/pda/chef
	hat = /obj/item/clothing/head/chefhat
	suit = /obj/item/clothing/suit/chef
	ear = /obj/item/device/radio/headset/headset_service

/obj/landmark/join/start/chef
	name = "Chef"
	icon_state = "player-grey"
	join_tag = /datum/job/chef



/datum/job/hydro
	title = "Gardener"
	flag = BOTANIST
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)
	access = list(access_hydroponics, access_bar, access_kitchen)
	idtype = /obj/item/weapon/card/id/hydro

	stat_modifers = list(
		STAT_BIO = 10,
	)

	uniform = /obj/item/clothing/under/rank/hydroponics
	pda = /obj/item/device/pda/botanist
	suit = /obj/item/clothing/suit/apron
	gloves = /obj/item/clothing/gloves/botanic_leather
	ear = /obj/item/device/radio/headset/headset_service
	put_in_backpack = list(\
		/obj/item/device/scanner/analyzer/plant_analyzer
		)

/obj/landmark/join/start/hydro
	name = "Gardener"
	icon_state = "player-grey"
	join_tag = /datum/job/hydro


/datum/job/actor
	title = "Actor"
	flag = ACTOR
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)
	access = list(access_maint_tunnels, access_theatre)

	stat_modifers = list(
		STAT_ROB = 10,
		STAT_AGI = 20,
	)

	uniform = /obj/item/clothing/under/rank/clown
	shoes = /obj/item/clothing/shoes/clown_shoes
	pda = /obj/item/device/pda/clown
	mask = /obj/item/clothing/mask/gas/clown_hat
	ear = /obj/item/device/radio/headset/headset_service

	put_in_backpack = list(\
		/obj/item/weapon/bananapeel,\
		/obj/item/weapon/bikehorn,\
		//obj/item/toy/crayon/rainbow,\
		/obj/item/weapon/storage/fancy/crayons,\
		/obj/item/toy/waterflower,\
		/obj/item/weapon/stamp/clown
		)

	backpacks = list(
		/obj/item/weapon/storage/backpack/clown,\
		/obj/item/weapon/storage/backpack/satchel_norm,\
		/obj/item/weapon/storage/backpack/satchel
		)

	equip(var/mob/living/carbon/human/H)
		if(!..())	return 0
		H.mutations.Add(CLUMSY)
		return 1

/obj/landmark/join/start/actor
	name = "Actor"
	icon_state = "player-grey"
	join_tag = /datum/job/actor


/datum/job/janitor
	title = "Janitor"
	flag = JANITOR
	department = "Civilian"
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the First Officer"
	selection_color = "#dddddd"
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)
	access = list(access_janitor, access_maint_tunnels)

	stat_modifers = list(
		STAT_AGI = 10,
	)

	uniform = /obj/item/clothing/under/rank/janitor
	pda = /obj/item/device/pda/janitor
	ear = /obj/item/device/radio/headset/headset_service

/obj/landmark/join/start/janitor
	name = "Janitor"
	icon_state = "player-grey"
	join_tag = /datum/job/janitor
