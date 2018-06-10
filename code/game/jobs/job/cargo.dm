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
	economic_modifier = 20
	also_known_languages = list(LANGUAGE_CYRILLIC = 25)
	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_merchant, access_mining,
		access_heads, access_mining_station, access_RC_announce, access_keycard_auth, access_sec_doors,
		access_eva, access_external_airlocks
	)
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

/obj/landmark/join/start/merchant
	name = "Guild Merchant"
	icon_state = "player-beige-officer"
	join_tag = /datum/job/merchant



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
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)
	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_merchant, access_mining,
		access_mining_station
	)
	idtype = /obj/item/weapon/card/id/car

	stat_modifers = list(
		STAT_PHY = 10,
		STAT_ROB = 10,
		STAT_AGI = 10,
	)

	uniform = /obj/item/clothing/under/rank/cargotech
	suit = /obj/item/clothing/suit/storage/cargo_jacket
	pda = /obj/item/device/pda/cargo
	ear = /obj/item/device/radio/headset/headset_cargo

/obj/landmark/join/start/cargo_tech
	name = "Guild Technician"
	icon_state = "player-beige"
	join_tag = /datum/job/cargo_tech

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
	also_known_languages = list(LANGUAGE_CYRILLIC = 15)
	access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_merchant, access_mining,
		access_mining_station
	)
	idtype = /obj/item/weapon/card/id/car

	stat_modifers = list(
		STAT_PHY = 20,
		STAT_ROB = 20,
		STAT_AGI = 20,
	)

	uniform = /obj/item/clothing/under/rank/miner
	pda = /obj/item/device/pda/shaftminer
	ear = /obj/item/device/radio/headset/headset_cargo
	survival_gear = /obj/item/weapon/storage/box/engineer

	put_in_backpack = list(\
		/obj/item/weapon/tool/crowbar,\
		/obj/item/weapon/storage/bag/ore
		)

/obj/landmark/join/start/mining
	name = "Guild Miner"
	icon_state = "player-beige"
	join_tag = /datum/job/mining
