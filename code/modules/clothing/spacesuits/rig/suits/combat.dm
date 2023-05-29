/obj/item/clothing/head/space/rig/combat
	light_overlay = "helmet_light_dual_green"
	spawn_tags = null

/obj/item/rig/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat."
	icon_state = "security_rig"
	suit_type = "combat hardsuit"
	armor = list(
		melee = 10,
		bullet = 10,
		energy = 10,
		bomb = 200,
		bio = 100,
		rad = 50
	)
	ablative_max = 12

	drain = 4
	offline_vision_restriction = 1
	rarity_value = 20
	price_tag = 500
	helm_type = /obj/item/clothing/head/space/rig/combat

/obj/item/rig/combat/equipped
	rarity_value = 40
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

/obj/item/rig/combat/ironhammer
	name = "ironhammer hardsuit control module"
	desc = "Standard operative suit issued to Ironhammer mercenaries. Provides balanced overall protection against various threats and widely used on planets surface, space stations or in open space."
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

/obj/item/rig/hazard
	name = "hazard hardsuit control module"
	suit_type = "hazard hardsuit"
	desc = "A Security hardsuit designed for prolonged EVA in dangerous environments."
	icon_state = "hazard_rig"
	armor = list(
		melee = 12,
		bullet = 9,
		energy = 9,
		bomb = 150,
		bio = 100,
		rad = 100
	)
	ablative_max = 8
	ablation = ABLATION_DURABLE // Lasts longer than most rigs

	drain = 4
	offline_vision_restriction = 1

	helm_type = /obj/item/clothing/head/space/rig/hazard

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
