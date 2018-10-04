/obj/random/tool
	name = "random tool"
	icon_state = "tool-grey"

/obj/random/tool/item_to_spawn()
	return pickweight(list(/obj/item/weapon/tool/screwdriver = 10,\
				/obj/item/weapon/tool/screwdriver/electric = 7,\
				/obj/item/weapon/tool/screwdriver/combi_driver = 5,\
				/obj/item/weapon/tool/wirecutters = 10,\
				/obj/item/weapon/tool/wirecutters/armature = 7,\
				/obj/item/weapon/tool/weldingtool = 10,\
				/obj/item/weapon/tool/omnitool = 3,\
				/obj/item/weapon/tool/crowbar = 10,\
				/obj/item/weapon/tool/crowbar/pneumatic = 7,\
				/obj/item/weapon/tool/wrench = 10,\
				/obj/item/weapon/tool/wrench/big_wrench = 7,\
				/obj/item/weapon/tool/saw = 10,\
				/obj/item/weapon/tool/saw/circular = 7,\
				/obj/item/weapon/tool/saw/advanced_circular = 5,\
				/obj/item/weapon/tool/saw/chain = 5,\
				/obj/item/weapon/tool/shovel = 5,\
				/obj/item/weapon/tool/shovel/spade = 3,\
				/obj/item/weapon/tool/pickaxe = 3,\
				/obj/item/weapon/tool/pickaxe/jackhammer = 5,\
				/obj/item/weapon/tool/pickaxe/drill = 2,\
				/obj/item/weapon/tool/pickaxe/diamonddrill = 1,\
				/obj/item/weapon/tool/pickaxe/excavation = 2,\
				/obj/item/weapon/storage/belt/utility = 5,\
				/obj/item/weapon/storage/belt/utility/full = 5,\
				/obj/item/clothing/gloves/insulated/cheap = 5,\
				/obj/item/clothing/head/welding = 5,\
				/obj/item/weapon/extinguisher = 5,\
				/obj/item/device/t_scanner = 2,\
				/obj/item/device/export_scanner = 2,\
				/obj/item/device/antibody_scanner = 1,\
				/obj/item/device/destTagger = 1,\
				/obj/item/device/scanner/analyzer/plant_analyzer = 1,\
				/obj/item/weapon/autopsy_scanner = 1,\
				/obj/item/device/scanner/healthanalyzer = 3,\
				/obj/item/device/scanner/mass_spectrometer = 1,\
				/obj/item/device/robotanalyzer = 1,\
				/obj/item/device/gps = 3,\
				/obj/item/device/scanner/analyzer = 5,\
				/obj/item/stack/cable_coil = 5,\
				/obj/item/weapon/weldpack/canister = 5,\
				/obj/item/weapon/packageWrap = 5,\
				/obj/item/device/flash = 2,\
				/obj/item/weapon/mop = 2,\
				/obj/item/weapon/inflatable_dispenser = 3,\
				/obj/item/weapon/grenade/chem_grenade/cleaner = 2,\
				/obj/item/device/lighting/toggleable/flashlight = 10))

/obj/random/tool/low_chance
	name = "low chance random tool"
	icon_state = "tool-grey-low"
	spawn_nothing_percentage = 60

/obj/random/toolbox
	name = "random toolbox"
	icon_state = "box-green"

/obj/random/toolbox/item_to_spawn()
	return pickweight(list(/obj/item/weapon/storage/toolbox/mechanical = 3,\
				/obj/item/weapon/storage/toolbox/electrical = 2,\
				/obj/item/weapon/storage/toolbox/emergency = 1))

/obj/random/toolbox/low_chance
	name = "low chance random toolbox"
	icon_state = "box-green-low"
	spawn_nothing_percentage = 60
