/datum/job/chief_engineer
	title = "Technomancer Exultant"
	flag = EXULTANT
	head_position = 1
	department = "Engineering"
	department_flag = ENGSEC
	faction = "CEV Eris"
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#ffeeaa"
	idtype = /obj/item/weapon/card/id/ce
	req_admin_notify = 1
	economic_modifier = 10
	also_known_languages = list(LANGUAGE_CYRILLIC = 100)

	ideal_character_age = 50


	access = list(
		access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
		access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
		access_heads, access_construction, access_sec_doors,
		access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload
	)

	stat_modifers = list(
		STAT_PRD = 30,
		STAT_COG = 10,
	)

	uniform = /obj/item/clothing/under/rank/exultant
	suit = /obj/item/clothing/suit/storage/hazardvest
	shoes = /obj/item/clothing/shoes/jackboots
	pda = /obj/item/device/pda/heads/ce
	hat = /obj/item/clothing/head/hardhat/white
	gloves = /obj/item/clothing/gloves/thick
	belt = /obj/item/weapon/storage/belt/utility/full
	ear = /obj/item/device/radio/headset/heads/ce
	survival_gear = /obj/item/weapon/storage/box/engineer

	put_in_backpack = list(\
		/obj/item/device/t_scanner,\
		/obj/item/device/lighting/glowstick/yellow
		)

	backpacks = list(
		/obj/item/weapon/storage/backpack/industrial,\
		/obj/item/weapon/storage/backpack/satchel_eng,\
		/obj/item/weapon/storage/backpack/satchel
		)

/obj/landmark/join/start/chief_engineer
	name = "Technomancer Exultant"
	icon_state = "player-orange-officer"
	join_tag = /datum/job/chief_engineer


/datum/job/technomancer
	title = "Technomancer"
	flag = TECHNOMANCER
	department = "Engineering"
	department_flag = ENGSEC
	faction = "CEV Eris"
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Technomancer Exultant"
	selection_color = "#fff5cc"
	economic_modifier = 5
	also_known_languages = list(LANGUAGE_CYRILLIC = 100)
	access = list(
		access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
		access_external_airlocks, access_construction, access_atmospherics
	)
	idtype = /obj/item/weapon/card/id/engie

	stat_modifers = list(
		STAT_PRD = 20,
		STAT_COG = 10,
	)

	uniform = /obj/item/clothing/under/rank/engineer
	suit = /obj/item/clothing/suit/storage/hazardvest
	shoes = /obj/item/clothing/shoes/jackboots
	pda = /obj/item/device/pda/engineering
	gloves = /obj/item/clothing/gloves/thick
	hat = /obj/item/clothing/head/hardhat
	belt = /obj/item/weapon/storage/belt/utility/full
	ear = /obj/item/device/radio/headset/headset_eng
	survival_gear = /obj/item/weapon/storage/box/engineer

	put_in_backpack = list(\
		/obj/item/device/t_scanner,\
		/obj/item/device/lighting/glowstick/yellow
		)

	backpacks = list(
		/obj/item/weapon/storage/backpack/industrial,\
		/obj/item/weapon/storage/backpack/satchel_eng,\
		/obj/item/weapon/storage/backpack/satchel
		)

/obj/landmark/join/start/technomancer
	name = "Technomancer"
	icon_state = "player-orange"
	join_tag = /datum/job/technomancer
