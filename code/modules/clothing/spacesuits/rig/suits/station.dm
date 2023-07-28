/obj/item/clothing/head/space/rig/industrial
	camera_networks = list(NETWORK_MINE)

/obj/item/clothing/head/space/rig/ce
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_ENGINEERING)

/obj/item/clothing/head/space/rig/eva
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_ENGINEERING)

/obj/item/clothing/head/space/rig/hazmat
	light_overlay = "hardhat_light"
	camera_networks = list(NETWORK_RESEARCH)

/obj/item/clothing/head/space/rig/medical
	camera_networks = list(NETWORK_MEDICAL)

/obj/item/clothing/head/space/rig/techno
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_ENGINEERING)



/***************************************
	Industrial Suit: For Mining
****************************************/
/obj/item/rig/industrial
	name = "industrial suit control module"
	suit_type = "industrial hardsuit"
	desc = "A heavy, powerful rig used by construction crews and mining corporations. The soft plating can protect the wearer from unexpected hazards, but is not reliable in prolonged combat."
	icon_state = "engineering_rig"
	price_tag = 350
	armor = list(
		melee = 10,
		bullet = 10,
		energy = 0,
		bomb = 100,
		bio = 100,
		rad = 90
	)
	ablative_max = 8
	ablation = ABLATION_SOFT

	drain = 3
	offline_slowdown = HEAVY_SLOWDOWN * 5
	offline_vision_restriction = 2
	emp_protection = -20

	helm_type = /obj/item/clothing/head/space/rig/industrial

	extra_allowed = list(
		/obj/item/device/t_scanner,
		/obj/item/storage/bag/ore,
		/obj/item/tool/pickaxe,
		/obj/item/rcd
	)

	req_access = list()
	req_one_access = list()

/obj/item/rig/industrial/equipped
	rarity_value = 20
	initial_modules = list(
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/storage
		)


/***************************************
	EVA Suit
****************************************/
/obj/item/rig/eva
	name = "EVA suit control module"
	suit_type = "EVA hardsuit"
	desc = "A light rig for repairs and maintenance to the outside of habitats and vessels."
	icon_state = "eva_rig"
	armor = list(
		melee = 9,
		bullet = 3,
		energy = 3,
		bomb = 25,
		bio = 100,
		rad = 100
	)
	slowdown = 0
	offline_slowdown = HEAVY_SLOWDOWN
	offline_vision_restriction = 1

	helm_type = /obj/item/clothing/head/space/rig/eva

	extra_allowed = list(
		/obj/item/storage/toolbox,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/device/t_scanner,
		/obj/item/rcd
	)

	req_access = list()
	req_one_access = list()

/obj/item/rig/eva/equipped
	rarity_value = 20
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/storage
		)


/***************************************
Advanced Voidsuit: Technomancer Exultant
****************************************/
/obj/item/rig/ce
	name = "advanced voidsuit control module"
	suit_type = "advanced voidsuit"
	desc = "An advanced voidsuit that protects against hazardous, low pressure environments. Shines with a high polish."
	icon_state = "ce_rig"
	rarity_value = 20
	armor = list(
		melee = 8,
		bullet = 8,
		energy = 8,
		bomb = 50,
		bio = 100,
		rad = 100
	)
	ablative_max = 10
	ablation = ABLATION_RESILIENT
	drain = 2
	offline_slowdown = 0
	offline_vision_restriction = 0

	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

	helm_type = /obj/item/clothing/head/space/rig/ce
	glove_type = /obj/item/clothing/gloves/rig/ce
	boot_type = /obj/item/clothing/shoes/magboots/rig/ce

	extra_allowed = list(
		/obj/item/storage/toolbox,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/device/t_scanner,
		/obj/item/rcd
	)

	req_access = list(access_ce)
	req_one_access = list()
	spawn_blacklisted = TRUE//antag_item_targets
	slowdown = LIGHT_SLOWDOWN * 1.1


/obj/item/rig/ce/equipped
	rarity_value = 40
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/storage,
		/obj/item/rig_module/cape/te
		)

/obj/item/clothing/gloves/rig/ce
	name = "insulated gloves"
	siemens_coefficient = 0

/obj/item/clothing/shoes/magboots/rig/ce
	name = "advanced magboots"
	desc = "Advanced magnetic boots that have a lighter magnetic pull, placing less burden on the wearer."
	mag_slow = 1

/***************************************
Technomancer RIG
***************************************/
/obj/item/rig/techno
	name = "technomancer suit control module"
	suit_type = "technomancer RIG suit"
	desc = "An advanced RIG suit that protects against hazardous, low pressure and high temperature environments."
	icon_state = "techno_rig"
	rarity_value = 20
	armor = list(
		melee = 8,
		bullet = 8,
		energy = 8,
		bomb = 50,
		bio = 100,
		rad = 100
	)
	ablative_max = 10
	ablation = ABLATION_DURABLE
	drain = 3
	offline_vision_restriction = 0

	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

	helm_type = /obj/item/clothing/head/space/rig/techno
	glove_type = /obj/item/clothing/gloves/rig/techno
	boot_type = /obj/item/clothing/shoes/magboots/rig/techno

	extra_allowed = list(
		/obj/item/storage/toolbox,
		/obj/item/storage/briefcase/inflatable,
		/obj/item/device/t_scanner,
		/obj/item/rcd
	)

	spawn_blacklisted = TRUE
	slowdown = LIGHT_SLOWDOWN

/obj/item/rig/techno/equipped
	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/storage
		)

/obj/item/clothing/gloves/rig/techno
	name = "insulated gloves"
	siemens_coefficient = 0


/obj/item/clothing/shoes/magboots/rig/techno
	name = "advanced magboots"
	desc = "Advanced magnetic boots that have a lighter magnetic pull, placing less burden on the wearer."
	mag_slow = 1



/***************************************
	Hazmat: Moebius Overseer
****************************************/
/obj/item/rig/hazmat
	name = "AMI control module"
	suit_type = "hazmat hardsuit"
	desc = "An Anomalous Material Interaction hardsuit that protects against the strangest energies the universe can throw at it."
	icon_state = "science_rig"
	spawn_tags = SPAWN_TAG_RIG_HAZMAT
	rarity_value = 25
	price_tag = 350
	armor = list(
		melee = 0,
		bullet = 0,
		energy = 8,
		bomb = 350,
		bio = 100,
		rad = 100
	)
	ablative_max = 12
	ablation = ABLATION_EVERLASTING
	drain = 3
	offline_vision_restriction = 1

	helm_type = /obj/item/clothing/head/space/rig/hazmat

	extra_allowed = list(
		/obj/item/stack/flag,
		/obj/item/tool,
		/obj/item/device/scanner/health,
		/obj/item/device/measuring_tape,
		/obj/item/device/gps,
		/obj/item/device/radio/beacon,
	)

	req_access = list()
	req_one_access = list()
	slowdown = MEDIUM_SLOWDOWN

/obj/item/rig/hazmat/equipped
	req_access = list(access_rd)
	rarity_value = 40

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/storage
		)



/***************************************
	Medical
****************************************/
/obj/item/rig/medical
	name = "rescue suit control module"
	suit_type = "rescue hardsuit"
	desc = "A relatively lightweight ceramic RIG suit designed for medical rescue in hazardous locations."
	icon_state = "medical_rig"
	armor = list(
		melee = 4,
		bullet = 4,
		energy = 0,
		bomb = 50,
		bio = 100,
		rad = 100
	)
	ablative_max = 10
	ablation = ABLATION_CERAMIC
	offline_vision_restriction = 1

	helm_type = /obj/item/clothing/head/space/rig/medical

	extra_allowed = list(
		/obj/item/storage/firstaid,
		/obj/item/device/scanner/health,
		/obj/item/stack/medical,
		/obj/item/roller
	)
	slowdown = LIGHT_SLOWDOWN * 1.1

/obj/item/rig/medical/equipped
	req_access = list()
	req_one_access = list()
	rarity_value = 20
	initial_modules = list(
		/obj/item/rig_module/modular_injector/medical,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/storage
		)
