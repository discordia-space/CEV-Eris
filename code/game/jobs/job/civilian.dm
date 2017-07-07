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
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_bar)
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
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_kitchen)
	idtype = /obj/item/weapon/card/id/ltgrey

	uniform = /obj/item/clothing/under/rank/chef
	shoes = /obj/item/clothing/shoes/black
	pda = /obj/item/device/pda/chef
	hat = /obj/item/clothing/head/chefhat
	suit = /obj/item/clothing/suit/chef
	ear = /obj/item/device/radio/headset/headset_service



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
	access = list(access_hydroponics, access_bar, access_kitchen)
	minimal_access = list(access_hydroponics)
	idtype = /obj/item/weapon/card/id/hydro

	uniform = /obj/item/clothing/under/rank/hydroponics
	pda = /obj/item/device/pda/botanist
	suit = /obj/item/clothing/suit/apron
	gloves = /obj/item/clothing/gloves/botanic_leather
	ear = /obj/item/device/radio/headset/headset_service
	put_in_backpack = list(\
		/obj/item/device/analyzer/plant_analyzer
		)


//Cargo
/datum/job/merchant
	title = "Guild Merchant"
	flag = MERCHANT
	department = "Cargo"
	head_position = 1
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "your greed"
	selection_color = "#dddddd"
	economic_modifier = 10
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_merchant, access_mining, access_heads,
			access_mining_station, access_RC_announce, access_keycard_auth, access_sec_doors, access_eva, access_external_airlocks)
	minimal_access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_merchant, access_mining, access_heads,
			access_mining_station, access_RC_announce, access_keycard_auth, access_sec_doors, access_eva)
	idtype = /obj/item/weapon/card/id/car
	ideal_character_age = 40


	uniform = /obj/item/clothing/under/rank/cargotech
	suit = /obj/item/clothing/suit/storage/qm_coat
	shoes = /obj/item/clothing/shoes/color/brown
	pda = /obj/item/device/pda/quartermaster
	gloves = /obj/item/clothing/gloves/thick
	ear = /obj/item/device/radio/headset/heads/merchant
	hand = /obj/item/weapon/clipboard
	glasses = /obj/item/clothing/glasses/sunglasses



/datum/job/cargo_tech
	title = "Guild Technician"
	flag = GUILDTECH
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = 2
	spawn_positions = 2
	supervisors = "the Guild Merchant"
	selection_color = "#dddddd"
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_merchant, access_mining, access_mining_station)
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)
	idtype = /obj/item/weapon/card/id/car

	uniform = /obj/item/clothing/under/rank/cargotech
	suit = /obj/item/clothing/suit/storage/cargo_jacket
	pda = /obj/item/device/pda/cargo
	ear = /obj/item/device/radio/headset/headset_cargo



/datum/job/mining
	title = "Guild Miner"
	flag = MINER
	department = "Cargo"
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = 3
	spawn_positions = 3
	supervisors = "the Guild Merchant"
	selection_color = "#dddddd"
	economic_modifier = 5
	access = list(access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_merchant, access_mining, access_mining_station)
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)
	idtype = /obj/item/weapon/card/id/car

	uniform = /obj/item/clothing/under/rank/miner
	pda = /obj/item/device/pda/shaftminer
	ear = /obj/item/device/radio/headset/headset_cargo
	survival_gear = /obj/item/weapon/storage/box/engineer

	put_in_backpack = list(\
		/obj/item/weapon/crowbar,\
		/obj/item/weapon/storage/bag/ore
		)



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
	access = list(access_maint_tunnels)
	minimal_access = list(access_maint_tunnels, access_theatre)

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
	access = list(access_janitor, access_maint_tunnels)
	minimal_access = list(access_janitor, access_maint_tunnels)

	uniform = /obj/item/clothing/under/rank/janitor
	pda = /obj/item/device/pda/janitor
	ear = /obj/item/device/radio/headset/headset_service
