/obj/item/clothing/head/space/rig/merc
	light_overlay = "helmet_light_dual_green"
	camera_networks = list(NETWORK_MERCENARY)
	light_color = COLOR_LIGHTING_GREEN_BRIGHT
	armorComps = list(
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/nt17
	)

/obj/item/clothing/suit/space/rig/merc
	armorComps = list(
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/nt17
	)

/obj/item/clothing/gloves/space/rig/merc
	armorComps = list(
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/nt17
	)

/obj/item/clothing/shoes/magboots/rig/merc
	armorComps = list(
		/obj/item/armor_component/plate/plasteel,
		/obj/item/armor_component/plate/nt17,
		/obj/item/armor_component/plate/nt17
	)

/obj/item/rig/merc
	name = "crimson hardsuit control module"
	desc = "A blood-red hardsuit featuring some fairly illegal technology. Advanced armor plating can last through extended firefights."
	icon_state = "merc_rig"
	suit_type = "crimson hardsuit"
	armor = list(
		ARMOR_BLUNT = 0,
		ARMOR_BULLET = 0,
		ARMOR_ENERGY = 0,
		ARMOR_BOMB =200,
		ARMOR_BIO =100,
		ARMOR_RAD =50
	)

	drain = 2
	offline_vision_restriction = 1

	helm_type = /obj/item/clothing/head/space/rig/merc
	glove_type = /obj/item/clothing/gloves/space/rig/merc
	chest_type = /obj/item/clothing/suit/space/rig/merc
	boot_type = /obj/item/clothing/shoes/magboots/rig/merc
	weightReduction = 65000
	rarity_value = 300

	initial_modules = list(
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/modular_injector/combat,
		/obj/item/rig_module/fabricator/energy_net,
		/obj/item/rig_module/storage
		)

//Has most of the modules removed
/obj/item/rig/merc/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite, // might as well
		/obj/item/rig_module/storage
		)
