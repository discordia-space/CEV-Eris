/datum/job/engineering
	department = "Engineering"
	department_flag = ENGSEC
	faction = "CEV Eris"

	suit = /obj/item/clothing/suit/storage/hazardvest
	shoes = /obj/item/clothing/shoes/jackboots
	gloves = /obj/item/clothing/gloves/thick
	belt = /obj/item/weapon/storage/belt/utility/full
	survival_gear = /obj/item/weapon/storage/box/engineer

	put_in_backpack = list(
		/obj/item/device/t_scanner,
		/obj/item/device/lighting/glowstick/yellow
		)
	backpacks = list(
		/obj/item/weapon/storage/backpack/industrial,
		/obj/item/weapon/storage/backpack/satchel_eng,
		/obj/item/weapon/storage/backpack/satchel
	)


/datum/job/engineering/chief_engineer
	title = JOB_EXULTANT
	flag = EXULTANT
	head_position = 1
	total_positions = 1
	spawn_positions = 1
	supervisors = "the Captain"
	selection_color = "#ffeeaa"
	idtype = /obj/item/weapon/card/id/ce
	req_admin_notify = 1
	economic_modifier = 10

	ideal_character_age = 50


	minimal_access = list(
		access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
		access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
		access_heads, access_construction, access_sec_doors,
		access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload
	)

	uniform = /obj/item/clothing/under/rank/exultant
	pda = /obj/item/device/pda/heads/ce
	hat = /obj/item/clothing/head/hardhat/white
	ear = /obj/item/device/radio/headset/heads/ce


/datum/job/engineering/technomancer
	title = TECHNOMANCER
	flag = TECHNOMANCER
	total_positions = 5
	spawn_positions = 5
	supervisors = "the Technomancer Exultant"
	selection_color = "#fff5cc"
	economic_modifier = 5
	minimal_access = list(
		access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
		access_external_airlocks, access_construction, access_atmospherics
	)
	idtype = /obj/item/weapon/card/id/engie

	uniform = /obj/item/clothing/under/rank/engineer
	pda = /obj/item/device/pda/engineering
	hat = /obj/item/clothing/head/hardhat
	ear = /obj/item/device/radio/headset/headset_eng

