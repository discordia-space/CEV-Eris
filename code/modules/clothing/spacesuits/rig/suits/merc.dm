/obj/item/clothing/head/space/rig/merc
	light_overlay = "helmet_light_dual_green"
	camera_networks = list(NETWORK_MERCENARY)
	light_color = COLOR_LIGHTING_GREEN_BRIGHT

/obj/item/rig/merc
	name = "crimson hardsuit control module"
	desc = "A blood-red hardsuit featuring some fairly illegal technology. Advanced armor plating can last through extended firefights."
	icon_state = "merc_rig"
	suit_type = "crimson hardsuit"
	armor = list(
		melee = 8,
		bullet = 10,
		energy = 5,
		bomb = 200,
		bio = 100,
		rad = 50
	)
	ablative_max = 12
	ablation = ABLATION_DURABLE

	drain = 3.5
	offline_vision_restriction = 1

	helm_type = /obj/item/clothing/head/space/rig/merc


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
