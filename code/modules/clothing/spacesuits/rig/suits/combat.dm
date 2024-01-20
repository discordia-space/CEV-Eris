/obj/item/clothing/head/space/rig/combat
	light_overlay = "helmet_light_dual_green"
	armorComps = list(
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/plasteel
	)
	spawn_tags = null

/obj/item/clothing/suit/space/rig/combat
	armorComps = list(
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/plasteel
	)

/obj/item/clothing/gloves/space/rig/combat
	armorComps = list(
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/plasteel
	)

/obj/item/clothing/shoes/magboots/rig/combat
	armorComps = list(
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/plasteel
	)

/obj/item/rig/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat."
	icon_state = "security_rig"
	suit_type = "combat hardsuit"
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =200,
		ARMOR_BIO =100,
		ARMOR_RAD =50
	)

	drain = 4
	offline_vision_restriction = 1
	weightReduction = 45000
	rarity_value = 120
	price_tag = 500
	helm_type = /obj/item/clothing/head/space/rig/combat
	chest_type = /obj/item/clothing/suit/space/rig/combat
	glove_type = /obj/item/clothing/gloves/space/rig/combat
	boot_type = /obj/item/clothing/shoes/magboots/rig/combat

/obj/item/rig/combat/equipped
	rarity_value = 200
	initial_modules = list(
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/modular_injector/combat,
		/obj/item/rig_module/storage
		)

//Ironhammer rig suit
/obj/item/clothing/head/space/rig/combat/ironhammer
	light_overlay = "sec_light"
	armorComps = list(
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/plasteel
	)

/obj/item/rig/combat/ironhammer
	name = "ironhammer hardsuit control module"
	desc = "Standard operative suit issued to Ironhammer mercenaries. Provides balanced overall protection against various threats and widely used on planets surface, space stations or in open space."
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =200,
		ARMOR_BIO =100,
		ARMOR_RAD =50
	)
	icon_state = "ihs_rig"
	helm_type = /obj/item/clothing/head/space/rig/combat/ironhammer
	suit_type = "ironhammer hardsuit"
	spawn_blacklisted = TRUE//antag_item_targets

/obj/item/rig/combat/ironhammer/equipped
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/storage
		)

//Hazard Suit
/obj/item/clothing/head/space/rig/hazard
	light_overlay = "helmet_light_dual"
	camera_networks = list(NETWORK_SECURITY)
	rarity_value = 20
	armorComps = list(
		/obj/item/armor_component/plate/plasteel
	)

/obj/item/clothing/suit/space/rig/hazard
	armorComps = list(
		/obj/item/armor_component/plate/plasteel
	)

/obj/item/clothing/gloves/space/rig/hazard
	armorComps = list(
		/obj/item/armor_component/plate/plasteel
	)

/obj/item/clothing/shoes/magboots/rig/hazard
	armorComps = list(
		/obj/item/armor_component/plate/plasteel
	)

/obj/item/rig/hazard
	name = "hazard hardsuit control module"
	suit_type = "hazard hardsuit"
	desc = "A Security hardsuit designed for prolonged EVA in dangerous environments."
	icon_state = "hazard_rig"
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =150,
		ARMOR_BIO =100,
		ARMOR_RAD =100
	)

	drain = 4
	offline_vision_restriction = 1

	helm_type = /obj/item/clothing/head/space/rig/hazard
	chest_type = /obj/item/clothing/suit/space/rig/hazard
	glove_type = /obj/item/clothing/gloves/space/rig/hazard
	boot_type = /obj/item/clothing/shoes/magboots/rig/hazard

	req_access = list()
	req_one_access = list()

/obj/item/rig/hazard/equipped
	rarity_value = 40
	initial_modules = list(
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/taser,
		/obj/item/rig_module/storage
		)
