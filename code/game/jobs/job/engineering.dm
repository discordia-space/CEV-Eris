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

	ideal_character_age = 50


	access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)
	minimal_access = list(access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels,
			            access_teleporter, access_external_airlocks, access_atmospherics, access_emergency_storage, access_eva,
			            access_heads, access_construction, access_sec_doors,
			            access_ce, access_RC_announce, access_keycard_auth, access_tcomsat, access_ai_upload)
	minimal_player_age = 7

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
		/obj/item/device/flashlight/glowstick/yellow
		)

	backpacks = list(
		/obj/item/weapon/storage/backpack/industrial,\
		/obj/item/weapon/storage/backpack/satchel_eng,\
		/obj/item/weapon/storage/backpack/satchel
		)


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
	access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics)
	minimal_access = list(access_eva, access_engine, access_engine_equip, access_tech_storage, access_maint_tunnels, access_external_airlocks, access_construction, access_atmospherics)
	idtype = /obj/item/weapon/card/id/engie

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
		/obj/item/device/flashlight/glowstick/yellow
		)

	backpacks = list(
		/obj/item/weapon/storage/backpack/industrial,\
		/obj/item/weapon/storage/backpack/satchel_eng,\
		/obj/item/weapon/storage/backpack/satchel
		)
