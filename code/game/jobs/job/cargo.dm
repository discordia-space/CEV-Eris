/datum/job/cargo

	department = "Cargo"
	department_flag = CIVILIAN
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Guild Merchant"
	selection_color = "#dddddd"

	idtype = /obj/item/weapon/card/id/car
	ear = /obj/item/device/radio/headset/headset_cargo


//Cargo
/datum/job/cargo/merchant
	title = JOB_MERCHANT
	flag = MERCHANT
	head_position = 1
	supervisors = "your greed"
	economic_modifier = 20
	minimal_access = list(
		access_maint_tunnels, access_mailsorting, access_cargo, access_cargo_bot, access_merchant,
		access_mining, access_heads, access_mining_station, access_RC_announce, access_keycard_auth,
		access_sec_doors, access_eva
	)
	additional_access = list(access_external_airlocks)
	ideal_character_age = 40

	uniform = /obj/item/clothing/under/rank/cargotech
	suit = /obj/item/clothing/suit/storage/qm_coat
	shoes = /obj/item/clothing/shoes/color/brown
	pda = /obj/item/device/pda/quartermaster
	gloves = /obj/item/clothing/gloves/thick
	ear = /obj/item/device/radio/headset/heads/merchant
	hand = /obj/item/weapon/clipboard
	glasses = /obj/item/clothing/glasses/sunglasses


/datum/job/cargo/cargo_tech
	title = JOB_CARGO
	flag = GUILDTECH
	total_positions = 2
	spawn_positions = 2
	minimal_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_mailsorting)
	additional_access = list(access_merchant, access_mining, access_mining_station)

	uniform = /obj/item/clothing/under/rank/cargotech
	suit = /obj/item/clothing/suit/storage/cargo_jacket
	pda = /obj/item/device/pda/cargo


/datum/job/cargo/mining
	title = JOB_MINER
	flag = MINER
	total_positions = 3
	spawn_positions = 3
	economic_modifier = 5
	minimal_access = list(access_mining, access_mining_station, access_mailsorting)
	additional_access = list(access_maint_tunnels, access_cargo, access_cargo_bot, access_merchant)

	uniform = /obj/item/clothing/under/rank/miner
	pda = /obj/item/device/pda/shaftminer
	ear = /obj/item/device/radio/headset/headset_cargo
	survival_gear = /obj/item/weapon/storage/box/engineer

	put_in_backpack = list(
		/obj/item/weapon/crowbar,
		/obj/item/weapon/storage/bag/ore
	)