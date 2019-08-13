/obj/item/clothing/head/helmet/space/rig/combat
	light_overlay = "helmet_light_dual_green"

/obj/item/weapon/rig/combat
	name = "combat hardsuit control module"
	desc = "A sleek and dangerous hardsuit for active combat."
	icon_state = "security_rig"
	suit_type = "combat hardsuit"
	armor = list(melee = 70, bullet = 70, energy = 60, bomb = 80, bio = 100, rad = 60)
	slowdown = 1.35 //same as serbs
	offline_slowdown = 3
	offline_vision_restriction = 1

	helm_type = /obj/item/clothing/head/helmet/space/rig/combat



/obj/item/weapon/rig/combat/equipped


	initial_modules = list(
		/obj/item/rig_module/mounted,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat
		)

//Ironhammer rig suit

/obj/item/clothing/head/helmet/space/rig/ihs_combat
	light_overlay = "sec_light"
	light_color = COLOR_LIGHTING_RED_BRIGHT

/obj/item/weapon/rig/ihs_combat
	name = "ironhammer hardsuit control module"
	desc = "Standard operative suit issued to Ironhammer mercenaries. Provides balanced overall protection against various threats and widely used on planets surface, space stations or in open space."
	corporation = /datum/corporation/ironhammer
	icon_state = "ihs_rig"
	helm_type = /obj/item/clothing/head/helmet/space/rig/ihs_combat
	suit_type = "ironhammer hardsuit"
	armor = list(melee = 70, bullet = 65, energy = 55, bomb = 60, bio = 100, rad = 70)
	slowdown = 1.5 //so you must choose between good prot but you're slow as hell and meh prot but you can outrun turtle
	offline_slowdown = 3
	offline_vision_restriction = 0



/obj/item/weapon/rig/ihs_combat/equipped


	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/storage
		)