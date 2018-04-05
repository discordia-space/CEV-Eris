/obj/random/tool
	name = "random tool"
	icon_state = "tool-grey"

/obj/random/tool/item_to_spawn()
	return pick(prob(10);/obj/item/weapon/tool/screwdriver,\
				prob(7);/obj/item/weapon/tool/screwdriver/electric,\
				prob(5);/obj/item/weapon/tool/screwdriver/combi_driver,\
				prob(10);/obj/item/weapon/tool/wirecutters,\
				prob(7);/obj/item/weapon/tool/wirecutters/armature,\
				prob(10);/obj/item/weapon/tool/weldingtool,\
				prob(3);/obj/item/weapon/tool/omnitool,\
				prob(10);/obj/item/weapon/tool/crowbar,\
				prob(7);/obj/item/weapon/tool/crowbar/pneumatic,\
				prob(10);/obj/item/weapon/tool/wrench,\
				prob(7);/obj/item/weapon/tool/big_wrench,\
				prob(10);/obj/item/weapon/tool/saw,\
				prob(7);/obj/item/weapon/tool/saw/circular,\
				prob(5);/obj/item/weapon/tool/saw/advanced_circular,\
				prob(5);/obj/item/weapon/tool/saw/chain,\
				prob(5);/obj/item/weapon/tool/shovel,\
				prob(3);/obj/item/weapon/tool/shovel/spade,\
				prob(3);/obj/item/weapon/tool/pickaxe,\
				prob(5);/obj/item/weapon/tool/pickaxe/jackhammer,\
				prob(2);/obj/item/weapon/tool/pickaxe/drill,\
				prob(1);/obj/item/weapon/tool/pickaxe/diamonddrill,\
				prob(2);/obj/item/weapon/tool/pickaxe/excavation,\
				prob(5);/obj/item/weapon/storage/belt/utility,\
				prob(5);/obj/item/weapon/storage/belt/utility/full,\
				prob(5);/obj/item/clothing/gloves/insulated/cheap,\
				prob(5);/obj/item/clothing/head/welding,\
				prob(5);/obj/item/weapon/extinguisher,\
				prob(2);/obj/item/device/t_scanner,\
				prob(2);/obj/item/device/export_scanner,\
				prob(1);/obj/item/device/antibody_scanner,\
				prob(1);/obj/item/device/destTagger,\
				prob(1);/obj/item/device/scanner/analyzer/plant_analyzer,\
				prob(1);/obj/item/weapon/autopsy_scanner,\
				prob(3);/obj/item/device/scanner/healthanalyzer,\
				prob(1);/obj/item/device/scanner/mass_spectrometer,\
				prob(1);/obj/item/device/robotanalyzer,\
				prob(3);/obj/item/device/gps,\
				prob(5);/obj/item/device/scanner/analyzer,\
				prob(5);/obj/item/stack/cable_coil,\
				prob(5);/obj/item/weapon/weldpack/canister,\
				prob(5);/obj/item/weapon/packageWrap,\
				prob(2);/obj/item/device/flash,\
				prob(2);/obj/item/weapon/mop,\
				prob(3);/obj/item/weapon/inflatable_dispenser,\
				prob(2);/obj/item/weapon/grenade/chem_grenade/cleaner,\
				prob(3);/obj/item/device/lighting/toggleable/flashlight)

/obj/random/tool/low_chance
	name = "low chance random tool"
	icon_state = "tool-grey-low"
	spawn_nothing_percentage = 60

/obj/random/toolbox
	name = "random toolbox"
	icon_state = "box-green"

/obj/random/toolbox/item_to_spawn()
	return pick(prob(3);/obj/item/weapon/storage/toolbox/mechanical,\
				prob(2);/obj/item/weapon/storage/toolbox/electrical,\
				prob(1);/obj/item/weapon/storage/toolbox/emergency)

/obj/random/toolbox/low_chance
	name = "low chance random toolbox"
	icon_state = "box-green-low"
	spawn_nothing_percentage = 60
