/obj/random/tool
	name = "random tool"
	icon_state = "tool-grey"

/obj/random/tool/item_to_spawn()
	return pick(/obj/item/weapon/tool/screwdriver,\
				/obj/item/weapon/tool/screwdriver/electric,\
				/obj/item/weapon/tool/screwdriver/combi_driver,\
				/obj/item/weapon/tool/wirecutters,\
				/obj/item/weapon/tool/weldingtool,\
				/obj/item/weapon/tool/crowbar,\
				/obj/item/weapon/tool/wrench,\
				/obj/item/weapon/tool/big_wrench,\
				/obj/item/weapon/tool/saw,\
				/obj/item/weapon/tool/saw/circular,\
				/obj/item/weapon/tool/saw/advanced_circular,\
				/obj/item/device/assembly/igniter,\
				/obj/item/device/assembly/infra,\
				/obj/item/device/assembly/prox_sensor,\
				/obj/item/device/assembly/signaler,\
				/obj/item/device/assembly/timer,\
				/obj/item/device/assembly/voice,\
				/obj/item/weapon/storage/belt/utility,\
				/obj/item/weapon/storage/belt/utility/full,\
				/obj/item/clothing/gloves/insulated/cheap,\
				/obj/item/clothing/head/welding,\
				/obj/item/weapon/extinguisher,\
				/obj/item/stack/cable_coil,\
				/obj/item/weapon/packageWrap,\
				/obj/item/weapon/tool/shovel,\
				/obj/item/weapon/tool/pickaxe,\
				/obj/item/device/flash,\
				/obj/item/weapon/mop,\
				/obj/item/weapon/inflatable_dispenser,\
				/obj/item/weapon/grenade/chem_grenade/cleaner,\
				/obj/item/device/lighting/toggleable/flashlight)

/obj/random/tool/low_chance
	name = "low chance random tool"
	icon_state = "tool-grey-low"
	spawn_nothing_percentage = 60

/obj/random/technology_scanner
	name = "random scanner"
	icon_state = "tech-green"

/obj/random/technology_scanner/item_to_spawn()
	return pick(prob(5);/obj/item/device/t_scanner,\
				prob(2);/obj/item/device/export_scanner,\
				prob(1);/obj/item/device/antibody_scanner,\
				prob(3);/obj/item/device/destTagger,\
				prob(3);/obj/item/device/scanner/analyzer/plant_analyzer,\
				prob(1);/obj/item/weapon/autopsy_scanner,\
				prob(5);/obj/item/device/scanner/healthanalyzer,\
				prob(1);/obj/item/device/scanner/mass_spectrometer,\
				prob(2);/obj/item/device/robotanalyzer,\
				prob(1);/obj/item/device/gps,\
				prob(5);/obj/item/device/scanner/analyzer)

/obj/random/technology_scanner/low_chance
	name = "low chance random scanner"
	icon_state = "tech-green-low"
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
