/obj/random/rig
	name = "Random Rig module"

/obj/random/rig/item_to_spawn()
	return pickweight(list(
	//Uncommon/civilian ones. These should make up most of the rig spawns
	/obj/item/weapon/rig/eva = 16,
	/obj/item/weapon/rig/eva/equipped = 4,
	/obj/item/weapon/rig/medical = 10,
	/obj/item/weapon/rig/medical/equipped = 2,
	/obj/item/weapon/rig/light = 20,
	/obj/item/weapon/rig/industrial = 10,
	/obj/item/weapon/rig/industrial/equipped = 2,

	//Head of staff
	/obj/item/weapon/rig/ce = 1,
	/obj/item/weapon/rig/ce/equipped = 0.2,
	/obj/item/weapon/rig/hazmat = 1,
	/obj/item/weapon/rig/hazmat/equipped = 1,

	//Heavy armor
	/obj/item/weapon/rig/combat = 1,
	/obj/item/weapon/rig/ihs_combat = 1,
	/obj/item/weapon/rig/hazard = 1,

	//The ones below here come with built in weapons
	/obj/item/weapon/rig/combat/equipped = 0.2,
	/obj/item/weapon/rig/ihs_combat/equipped = 0.2,
	/obj/item/weapon/rig/hazard/equipped = 0.2,
	))


/obj/random/rig/damaged
	name = "Random damaged Rig module"
	has_postspawn = TRUE

/obj/random/rig/damaged/post_spawn(var/list/spawns)
	for (var/obj/item/weapon/rig/module in spawns)
		//screw it up a bit
		var/cnd = rand(40,80)
		module.lose_modules(cnd)
		module.misconfigure(cnd)
		module.sabotage_cell()
		module.sabotage_tank()