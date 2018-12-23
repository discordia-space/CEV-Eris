/obj/random/rig
	name = "Random Rig suit"

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
	name = "Random damaged Rig suit"
	has_postspawn = TRUE

/obj/random/rig/damaged/post_spawn(var/list/spawns)
	for (var/obj/item/weapon/rig/module in spawns)
		//screw it up a bit
		var/cnd = rand(40,80)
		module.lose_modules(cnd)
		module.misconfigure(cnd)
		module.sabotage_cell()
		module.sabotage_tank()



//Installable modules!

/obj/random/rig_module

/obj/random/rig_module/item_to_spawn()
	return pickweight(list(
	//Storage
	/obj/item/rig_module/storage = 12, //Made much more common

	//Computer
	/obj/item/rig_module/ai_container = 5,
	/obj/item/rig_module/datajack = 3,
	/obj/item/rig_module/electrowarfare_suite = 1,
	/obj/item/rig_module/power_sink = 3,


	//Combat
	/obj/item/rig_module/device/flash = 2,
	/obj/item/rig_module/mounted/taser = 2,
	/obj/item/rig_module/grenade_launcher = 0.5, //Comes preloaded with smoke, flashbang and EMP
	/obj/item/rig_module/mounted = 0.1, //This is mounted lasercannon, dangerous
	/obj/item/rig_module/mounted/egun = 0.2, //Lethal laser
	/obj/item/rig_module/mounted/energy_blade = 0.1,
	/obj/item/rig_module/fabricator = 0.1,
	/obj/item/rig_module/fabricator/energy_net = 0.2,
	/obj/item/rig_module/self_destruct = 1,

	//Stealth
	/obj/item/rig_module/stealth_field = 0.5,
	/obj/item/rig_module/teleporter = 0.5,

	//Utility
	/obj/item/rig_module/device/healthscanner = 4,
	/obj/item/rig_module/device/drill = 1,
	/obj/item/rig_module/device/anomaly_scanner = 2,
	/obj/item/rig_module/device/orescanner = 2,
	/obj/item/rig_module/device/rcd = 0.5,
	/obj/item/rig_module/chem_dispenser = 0.8,
	/obj/item/rig_module/chem_dispenser/ninja = 2, //This version is same as normal but has much less of each chem
	/obj/item/rig_module/chem_dispenser/combat = 0.8,
	/obj/item/rig_module/chem_dispenser/injector = 0.5, //Like normal but can be used on other people as well as yourself
	/obj/item/rig_module/voice = 3,
	/obj/item/rig_module/maneuvering_jets = 8, //Useful but common

	//Vision
	/obj/item/rig_module/vision/multi = 0.2, //Every vision mod in one, very powerful
	/obj/item/rig_module/vision/meson = 2,
	/obj/item/rig_module/vision/thermal = 0.5, //Thermal is very strong
	/obj/item/rig_module/vision/nvg = 2,
	/obj/item/rig_module/vision/sechud = 2,
	/obj/item/rig_module/vision/medhud = 2

	))


//Special variant that has less of the mundane junk and all the really desireable ones
/obj/random/rig_module/rare
	name = "random rare hardsuit module"

/obj/random/rig_module/rare/item_to_spawn()
	return pickweight(list(
	//Storage
	/obj/item/rig_module/storage = 1,

	/obj/item/rig_module/electrowarfare_suite = 1,


	//Combat
	/obj/item/rig_module/grenade_launcher = 1, //Comes preloaded with smoke, flashbang and EMP
	/obj/item/rig_module/mounted = 1, //This is mounted lasercannon, dangerous
	/obj/item/rig_module/mounted/egun = 1, //Lethal laser
	/obj/item/rig_module/mounted/energy_blade = 1,
	/obj/item/rig_module/fabricator = 1,
	/obj/item/rig_module/fabricator/energy_net = 1,
	/obj/item/rig_module/self_destruct = 1,

	//Stealth
	/obj/item/rig_module/stealth_field = 1,
	/obj/item/rig_module/teleporter = 1,

	//Utility
	/obj/item/rig_module/device/drill = 1,
	/obj/item/rig_module/device/rcd = 1,
	/obj/item/rig_module/chem_dispenser/combat = 1,
	/obj/item/rig_module/chem_dispenser/injector = 1, //Like normal but can be used on other people as well as yourself
	/obj/item/rig_module/voice = 1,

	//Vision
	/obj/item/rig_module/vision/multi = 0.5, //Every vision mod in one, very powerful
	/obj/item/rig_module/vision/thermal = 1, //Thermal is very strong
	/obj/item/rig_module/vision/nvg = 1
	))