/obj/random/tool
	name = "random tool"
	icon_state = "tool-grey"
	spawn_nothing_percentage = 15
	has_postspawn = TRUE

/obj/random/tool/item_to_spawn()
	return pickweight(list(/obj/random/pack/rare = 2,
				/obj/item/weapon/tool/omnitool = 0.5,
				/obj/item/weapon/tool/screwdriver = 8,
				/obj/item/weapon/tool/screwdriver/electric = 2,
				/obj/item/weapon/tool/screwdriver/combi_driver = 1,
				/obj/item/weapon/tool/wirecutters = 4,
				/obj/item/weapon/tool/wirecutters/pliers = 4,
				/obj/item/weapon/tool/wirecutters/armature = 2,
				/obj/item/weapon/tool/weldingtool = 8,
				/obj/item/weapon/tool/weldingtool/advanced = 2,
				/obj/item/weapon/tool/crowbar = 12,
				/obj/item/weapon/tool/crowbar/pneumatic = 2,
				/obj/item/weapon/tool/wrench = 8,
				/obj/item/weapon/tool/wrench/big_wrench = 2,
				/obj/item/weapon/tool/multitool = 4,
				/obj/item/weapon/tool/saw = 8,
				/obj/item/weapon/tool/saw/circular = 2,
				/obj/item/weapon/tool/saw/circular/advanced = 1,
				/obj/item/weapon/tool/saw/chain = 0.5,
				/obj/item/weapon/tool/saw/hyper = 0.5,
				/obj/item/weapon/tool/shovel = 5,
				/obj/item/weapon/tool/shovel/spade = 2.5,
				/obj/item/weapon/tool/shovel/power = 1,
				/obj/item/weapon/tool/pickaxe = 2,
				/obj/item/weapon/tool/pickaxe/jackhammer = 1,
				/obj/item/weapon/tool/pickaxe/drill = 1,
				/obj/item/weapon/tool/pickaxe/diamonddrill = 0.5,
				/obj/item/weapon/tool/pickaxe/excavation = 1,
				/obj/item/weapon/tool/tape_roll = 12,
				/obj/item/weapon/tool/tape_roll/fiber = 2,
				/obj/item/weapon/storage/belt/utility = 5,
				/obj/item/weapon/storage/belt/utility/full = 1,
				/obj/item/clothing/gloves/insulated/cheap = 5,
				/obj/item/clothing/gloves/insulated = 2,
				/obj/item/clothing/head/welding = 5,
				/obj/item/weapon/extinguisher = 5,
				/obj/item/device/t_scanner = 2,
				/obj/item/device/scanner/price = 2,
				/obj/item/device/antibody_scanner = 1,
				/obj/item/device/destTagger = 1,
				/obj/item/device/scanner/plant = 1,
				/obj/item/weapon/autopsy_scanner = 1,
				/obj/item/device/scanner/health = 3,
				/obj/item/device/scanner/mass_spectrometer = 1,
				/obj/item/device/robotanalyzer = 1,
				/obj/item/device/gps = 3,
				/obj/item/device/scanner/gas = 2,
				/obj/item/stack/cable_coil = 5,
				/obj/item/weapon/weldpack/canister = 2,
				/obj/item/weapon/packageWrap = 1,
				/obj/item/device/flash = 2,
				/obj/item/weapon/mop = 5,
				/obj/item/weapon/inflatable_dispenser = 3,
				/obj/item/weapon/grenade/chem_grenade/cleaner = 2,
				/obj/item/device/lighting/toggleable/flashlight = 10,
				/obj/item/weapon/tank/jetpack/carbondioxide = 1.5,
				/obj/item/weapon/tank/jetpack/oxygen = 1,
				/obj/item/weapon/storage/makeshift_grinder = 2,
				/obj/item/device/makeshift_electrolyser = 1,
				/obj/item/device/makeshift_centrifuge = 1,
				/obj/item/robot_parts/robot_component/jetpack = 0.75,))


//Randomly spawned tools will often be in imperfect condition if they've been left lying out
/obj/random/tool/post_spawn(var/list/spawns)
	if (isturf(loc))
		for (var/obj/O in spawns)
			if (!istype(O, /obj/random) && prob(20))
				O.make_old()


/obj/random/tool/low_chance
	name = "low chance random tool"
	icon_state = "tool-grey-low"
	spawn_nothing_percentage = 60




/obj/random/tool/advanced
	name = "random advanced tool"
	icon_state = "tool-orange"

/obj/random/tool/advanced/item_to_spawn()
	return pickweight(list(
				/obj/item/weapon/tool/screwdriver/combi_driver = 3,
				/obj/item/weapon/tool/wirecutters/armature = 3,
				/obj/item/weapon/tool/omnitool = 2,
				/obj/item/weapon/tool/crowbar/pneumatic = 3,
				/obj/item/weapon/tool/wrench/big_wrench = 3,
				/obj/item/weapon/tool/weldingtool/advanced = 3,
				/obj/item/weapon/tool/saw/circular/advanced = 2,
				/obj/item/weapon/tool/saw/chain = 1,
				/obj/item/weapon/tool/saw/hyper = 1,
				/obj/item/weapon/tool/pickaxe/diamonddrill = 2,
				/obj/item/weapon/tool/tape_roll/fiber = 2,
				/obj/item/weapon/tool/fireaxe = 1))

/obj/random/tool/advanced/low_chance
	name = "low chance advanced tool"
	icon_state = "tool-orange-low"
	spawn_nothing_percentage = 60




/obj/random/toolbox
	name = "random toolbox"
	icon_state = "box-green"

/obj/random/toolbox/item_to_spawn()
	return pickweight(list(/obj/item/weapon/storage/toolbox/mechanical = 3,
				/obj/item/weapon/storage/toolbox/electrical = 2,
				/obj/item/weapon/storage/toolbox/emergency = 1))

/obj/random/toolbox/low_chance
	name = "low chance random toolbox"
	icon_state = "box-green-low"
	spawn_nothing_percentage = 60


/obj/random/tool/advanced/onestar
	name = "random onestar tool"


/obj/random/tool/advanced/onestar/item_to_spawn()
	return pickweight(list(/obj/item/weapon/tool/crowbar/onestar = 1,
						/obj/item/weapon/tool/medmultitool = 1,
						/obj/item/weapon/tool/pickaxe/onestar = 1,
						/obj/item/weapon/tool/pickaxe/jackhammer/onestar = 1,
						/obj/item/weapon/tool/pickaxe/drill/onestar = 1,
						/obj/item/weapon/tool/screwdriver/combi_driver/onestar = 1,
						/obj/item/weapon/tool/weldingtool/onestar = 1))

/obj/random/tool/advanced/onestar/low_chance
	icon_state = "tool-orange-low"
	spawn_nothing_percentage = 60