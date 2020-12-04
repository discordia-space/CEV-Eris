/obj/item/weapon/computer_hardware/hard_drive/portable/design
	name = "design disk"
	desc = "Data disk used to store autolathe designs."
	icon_state = "yellow"
	max_capacity = 1024	// Up to 255 designs, automatically reduced to the nearest power of 2
	origin_tech = list(TECH_DATA = 3) // Most design disks end up being 64 to 128 GQ
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 2, MATERIAL_GOLD = 0.5)
	license = -1
	spawn_tags = SPAWN_TAG_DESING
	rarity_value = 25
	var/list/designs = list()


/obj/item/weapon/computer_hardware/hard_drive/portable/design/install_default_files()
	..()
	// Add design files to the disk
	for(var/design_typepath in designs)
		var/datum/computer_file/binary/design/D = new
		D.set_design_type(design_typepath)
		if(license > 0)
			D.set_point_cost(designs[design_typepath])

		store_file(D)

	// Shave off the extra space so a disk with two designs doesn't show up as 1024 GQ
	while(max_capacity > 16 && max_capacity / 2 > used_capacity)
		max_capacity /= 2

	// Prevent people from breaking DRM by copying files across protected disks.
	// Stops people from screwing around with unprotected disks too.
	read_only = TRUE
	return TRUE

// Disks formated as /designpath = pointcost , if no point cost is specified it defaults to 1.

// Asters
/obj/item/weapon/computer_hardware/hard_drive/portable/design/tools
	disk_name = "Asters Basic Tool Pack"
	icon_state = "guild"
	rarity_value = 5.5
	spawn_tags = SPAWN_TAG_DESING_COMMON
	license = -1
	designs = list(
		/datum/design/autolathe/tool/hatchet,
		/datum/design/autolathe/tool/minihoe,
		/datum/design/autolathe/tool/ducttape,
		/datum/design/autolathe/tool/knife,
		/datum/design/autolathe/misc/heavyflashlight,
		/datum/design/autolathe/tool/crowbar,
		/datum/design/autolathe/tool/screwdriver,
		/datum/design/autolathe/tool/wirecutters,
		/datum/design/autolathe/tool/pliers,
		/datum/design/autolathe/tool/wrench,
		/datum/design/autolathe/tool/hammer,
		/datum/design/autolathe/tool/saw,
		/datum/design/autolathe/tool/multitool,
		/datum/design/autolathe/tool/pickaxe,
		/datum/design/autolathe/tool/shovel,
		/datum/design/autolathe/tool/spade,
		/datum/design/autolathe/device/t_scanner,
		/datum/design/autolathe/tool/rcd_ammo,
		/datum/design/autolathe/tool/weldertool,
		/datum/design/autolathe/tool/weldinggoggles,
		/datum/design/autolathe/tool/weldermask,
		/datum/design/autolathe/device/flamethrower
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/misc
	disk_name = "Asters Miscellaneous Pack"
	icon_state = "guild"
	rarity_value = 3.5
	spawn_tags = SPAWN_TAG_DESING_COMMON
	license = -1
	designs = list(
		/datum/design/autolathe/misc/flashlight,
		/datum/design/autolathe/tool/ducttape,
		/datum/design/autolathe/misc/extinguisher,
		/datum/design/autolathe/misc/radio_headset,
		/datum/design/autolathe/misc/radio_bounced,
		/datum/design/autolathe/misc/ashtray,
		/datum/design/autolathe/container/drinkingglass,
		/datum/design/autolathe/container/carafe,
		/datum/design/autolathe/container/insulated_pitcher,
		/datum/design/autolathe/container/bucket,
		/datum/design/autolathe/container/jar,
		/datum/design/autolathe/container/syringe,
		/datum/design/autolathe/container/vial,
		/datum/design/autolathe/container/beaker,
		/datum/design/autolathe/container/beaker_large,
		/datum/design/autolathe/container/mixingbowl,
		/datum/design/autolathe/container/pill_bottle,
		/datum/design/autolathe/container/spray,
		/datum/design/autolathe/container/freezer,
		/datum/design/autolathe/misc/cane,
		/datum/design/autolathe/misc/floor_light,
		/datum/design/autolathe/misc/tube,
		/datum/design/autolathe/misc/bulb,
		/datum/design/autolathe/device/floorpainter,
		/datum/design/autolathe/device/mechpainter
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/devices
	disk_name = "Asters Devices and Instruments"
	icon_state = "guild"
	rarity_value = 3
	spawn_tags = SPAWN_TAG_DESING_COMMON
	license = 10
	designs = list(
		/datum/design/autolathe/misc/flashlight,
		/datum/design/autolathe/device/analyzer,
		/datum/design/autolathe/device/plant_analyzer,
		/datum/design/autolathe/device/healthanalyzer,
		/datum/design/research/item/medical/mass_spectrometer,
		/datum/design/research/item/medical/reagent_scanner,
		/datum/design/research/item/medical/robot_scanner,
		/datum/design/autolathe/device/slime_scanner,
		/datum/design/autolathe/device/antibody_scanner,
		/datum/design/autolathe/device/megaphone,
		/datum/design/autolathe/device/t_scanner,
		/datum/design/autolathe/device/gps,
		/datum/design/autolathe/device/destTagger,
		/datum/design/autolathe/device/export_scanner,
		/datum/design/autolathe/device/implanter,
		/datum/design/autolathe/device/hand_labeler,
		/datum/design/research/item/light_replacer,
		/datum/design/autolathe/sec/hailer,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/robustcells
	disk_name = "Asters Robustcells"
	icon_state = "guild"
	rarity_value = 3
	spawn_tags = SPAWN_TAG_DESING_COMMON
	license = 10
	designs = list(
		/datum/design/autolathe/cell/large,
		/datum/design/autolathe/cell/large/high = 2,
		/datum/design/autolathe/cell/medium,
		/datum/design/autolathe/cell/medium/high = 2,
		/datum/design/autolathe/cell/small,
		/datum/design/autolathe/cell/small/high = 2,
	)


// Technomancers
/obj/item/weapon/computer_hardware/hard_drive/portable/design/components
	disk_name = "Technomancers ARK-034 Components"
	icon_state = "technomancers"
	rarity_value = 4
	spawn_tags = SPAWN_TAG_DESING_COMMON
	license = 20
	designs = list(
		/datum/design/autolathe/part/consolescreen,
		/datum/design/research/item/part/smes_coil,
		/datum/design/research/item/part/basic_capacitor,
		/datum/design/research/item/part/basic_sensor,
		/datum/design/research/item/part/micro_mani,
		/datum/design/research/item/part/basic_micro_laser,
		/datum/design/research/item/part/basic_matter_bin,
		/datum/design/autolathe/part/igniter,
		/datum/design/autolathe/part/signaler,
		/datum/design/autolathe/part/sensor_infra,
		/datum/design/autolathe/part/timer,
		/datum/design/autolathe/part/voice_analyzer,
		/datum/design/autolathe/part/sensor_prox,
		/datum/design/autolathe/part/camera_assembly,
		/datum/design/autolathe/part/laserguide,
		/datum/design/research/item/ducts
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/adv_tools
	disk_name = "Technomancers IJIRO-451 Advanced Tools"
	icon_state = "technomancers"
	rarity_value = 11
	spawn_tags = SPAWN_TAG_DESING_ADVANCED_COMMON
	license = 10
	designs = list(
		/datum/design/autolathe/tool/big_wrench,
		/datum/design/autolathe/tool/pneumatic_crowbar,
		/datum/design/research/item/weapon/mining/jackhammer,
		/datum/design/research/item/weapon/mining/drill,
		/datum/design/research/item/weapon/mining/drill_diamond,
		/datum/design/autolathe/tool/pickaxe_excavation,
		/datum/design/autolathe/tool/shovel/power,
		/datum/design/autolathe/tool/circularsaw,
		/datum/design/autolathe/tool/powered_hammer,
		/datum/design/autolathe/tool/chainsaw,
		/datum/design/autolathe/tool/hypersaw,
		/datum/design/autolathe/tool/rcd,
		/datum/design/autolathe/tool/electric_screwdriver,
		/datum/design/autolathe/tool/combi_driver,
		/datum/design/autolathe/tool/armature_cutter,
		/datum/design/autolathe/tool/weldertool_adv,
		/datum/design/autolathe/part/diamondblade,
		/datum/design/autolathe/tool/rpd,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/circuits
	disk_name = "Technomancers ESPO-830 Circuits"
	icon_state = "technomancers"
	spawn_tags = SPAWN_TAG_DESING_COMMON
	rarity_value = 5.5
	license = 10
	designs = list(
		/datum/design/autolathe/circuit/airlockmodule = 0,
		/datum/design/autolathe/circuit/airlockmodule/secure,
		/datum/design/autolathe/circuit/airalarm = 0,
		/datum/design/autolathe/circuit/firealarm = 0,
		/datum/design/autolathe/circuit/powermodule = 0,
		/datum/design/autolathe/circuit/recharger,
		/datum/design/research/circuit/autolathe,
		/datum/design/autolathe/circuit/autolathe_disk_cloner = 3,
		/datum/design/autolathe/circuit/vending,
		/datum/design/research/circuit/arcade_battle,
		/datum/design/research/circuit/arcade_orion_trail,
		/datum/design/research/circuit/teleconsole,
		/datum/design/research/circuit/operating,
		/datum/design/autolathe/circuit/helm,
		/datum/design/autolathe/circuit/nav,
		/datum/design/autolathe/circuit/centrifuge,
		/datum/design/autolathe/circuit/electrolyzer,
		/datum/design/autolathe/circuit/reagentgrinder,
		/datum/design/autolathe/circuit/industrialgrinder = 2,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/conveyors
	disk_name = "Technomancers LAT-018 Logistics"
	icon_state = "technomancers"
	rarity_value = 4
	spawn_tags = SPAWN_TAG_DESING_COMMON
	license = 10
	designs = list(
		/datum/design/autolathe/conveyor = 0,
		/datum/design/autolathe/conveyor_switch = 0,
		/datum/design/autolathe/circuit/smelter = 4,
		/datum/design/autolathe/circuit/sorter = 2
	)


// Moebius
/obj/item/weapon/computer_hardware/hard_drive/portable/design/medical
	disk_name = "Moebius Medical Designs"
	icon_state = "moebius"
	rarity_value = 4.5
	spawn_tags = SPAWN_TAG_DESING_COMMON
	license = 20
	designs = list(
		/datum/design/autolathe/gun/syringe_gun,
		/datum/design/autolathe/misc/penflashlight,
		/datum/design/autolathe/tool/scalpel,
		/datum/design/autolathe/tool/circularsaw,
		/datum/design/autolathe/tool/surgicaldrill,
		/datum/design/autolathe/tool/retractor,
		/datum/design/autolathe/tool/cautery,
		/datum/design/autolathe/tool/hemostat,
		/datum/design/autolathe/tool/bonesetter,
		/datum/design/autolathe/container/syringe,
		/datum/design/autolathe/container/vial,
		/datum/design/autolathe/container/beaker,
		/datum/design/autolathe/container/beaker_large,
		/datum/design/autolathe/container/pill_bottle,
		/datum/design/autolathe/container/spray,
		/datum/design/autolathe/container/freezer_medical,
		/datum/design/autolathe/device/implanter,
		/datum/design/autolathe/container/syringegun_ammo,
		/datum/design/autolathe/container/syringe/large,

	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/surgery
	disk_name = "Back Alley Organs"
	icon_state = "moebius"
	license = 5
	designs = list(
		/datum/design/bioprinter/lungs
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/computer
	disk_name = "Moebius Computer Parts"
	icon_state = "moebius"
	spawn_tags = SPAWN_TAG_DESING_COMMON
	rarity_value = 4.5
	license = 20
	designs = list(
		/datum/design/autolathe/computer_part/frame_pda,
		/datum/design/autolathe/computer_part/frame_tablet,
		/datum/design/autolathe/computer_part/frame_laptop,
		/datum/design/research/item/computer_part/disk/micro,
		/datum/design/research/item/computer_part/disk/small,
		/datum/design/research/item/computer_part/disk/normal,
		/datum/design/research/item/computer_part/disk/advanced,
		/datum/design/research/item/computer_part/cpu/basic,
		/datum/design/research/item/computer_part/cpu/basic/small,
		/datum/design/research/item/computer_part/cpu/adv,
		/datum/design/research/item/computer_part/cpu/adv/small,
		/datum/design/research/item/computer_part/netcard/basic,
		/datum/design/research/item/computer_part/netcard/advanced,
		/datum/design/research/item/computer_part/netcard/wired,
		/datum/design/research/item/computer_part/cardslot,
		/datum/design/research/item/computer_part/teslalink,
		/datum/design/research/item/computer_part/portabledrive/basic,
		/datum/design/research/item/computer_part/portabledrive/normal,
		/datum/design/research/item/computer_part/printer,
		/datum/design/research/item/computer_part/led,
		/datum/design/research/item/computer_part/led/adv,
		/datum/design/autolathe/computer_part/gps,
		/datum/design/autolathe/computer_part/scanner/paper,
		/datum/design/autolathe/computer_part/scanner/atmos,
		/datum/design/autolathe/computer_part/scanner/reagent,
		/datum/design/autolathe/computer_part/scanner/medical,
	)


// NeoTheology

// Foodstuffs, fertilizers, medical and cleaning utilities
/obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_bioprinter
	disk_name = "NeoTheology Bioprinter Products and Utilities"
	icon_state = "neotheology"

	license = -1
	designs = list(
		/datum/design/bioprinter/meat,
		/datum/design/bioprinter/milk,
		/datum/design/bioprinter/soap,

		/datum/design/bioprinter/ez,
		/datum/design/bioprinter/l4z,
		/datum/design/bioprinter/rh,

		/datum/design/bioprinter/medical/bruise,
		/datum/design/bioprinter/medical/splints,
		/datum/design/bioprinter/medical/ointment,
		/datum/design/bioprinter/medical/advanced/bruise,
		/datum/design/bioprinter/medical/advanced/ointment,

		/datum/design/autolathe/gun/nt_sprayer,
		/datum/design/autolathe/gun/plasma/martyr,
		/datum/design/autolathe/device/grenade/nt_cleaner,
		/datum/design/autolathe/device/grenade/nt_weedkiller

	)

// Clothes, armor and accesories
/obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_bioprinter_clothes
	disk_name = "NeoTheology Bio-Fabric Designs"
	icon_state = "neotheology"

	license = -1
	designs = list(
		/datum/design/bioprinter/nt_clothes/acolyte_armor,
		/datum/design/bioprinter/nt_clothes/agrolyte_armor,
		/datum/design/bioprinter/nt_clothes/custodian_armor,

		/datum/design/bioprinter/nt_clothes/preacher_coat,
		/datum/design/bioprinter/nt_clothes/acolyte_jacket,
		/datum/design/bioprinter/nt_clothes/sports_jacket,

		/datum/design/bioprinter/nt_clothes/acolyte_uniform,
		/datum/design/bioprinter/nt_clothes/sports_uniform,
		/datum/design/bioprinter/nt_clothes/church_uniform,

		/datum/design/bioprinter/belt/security/neotheology,
		/datum/design/bioprinter/belt/utility/neotheology,

		/datum/design/bioprinter/satchel,
		/datum/design/bioprinter/leather_jacket,
		/datum/design/bioprinter/wallet,
		/datum/design/bioprinter/botanic_leather,

		/datum/design/bioprinter/belt/utility,
		/datum/design/bioprinter/belt/medical,
		/datum/design/bioprinter/belt/security,
		/datum/design/bioprinter/belt/medical/emt,
		/datum/design/bioprinter/belt/misc/champion,

		/datum/design/bioprinter/leather/holster,
		/datum/design/bioprinter/leather/holster/armpit,
		/datum/design/bioprinter/leather/holster/waist,
		/datum/design/bioprinter/leather/holster/hip,

   		/datum/design/autolathe/device/headset_church,
		/datum/design/bioprinter/leather/cash_bag
	)

// Kinda like the regular product NT disk, minus the grenades, soap and the cleaner carbine. Should spawn in public access bioprinters if they get added by any chance.
/obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_bioprinter_public
	disk_name = "NeoTheology Bioprinter Pack"
	icon_state = "neotheology"

	license = -1
	designs = list(
		/datum/design/bioprinter/meat,
		/datum/design/bioprinter/milk,

		/datum/design/bioprinter/ez,
		/datum/design/bioprinter/l4z,
		/datum/design/bioprinter/rh,

		/datum/design/bioprinter/wallet,
		/datum/design/bioprinter/botanic_leather,
		/datum/design/bioprinter/satchel,
		/datum/design/bioprinter/leather_jacket,
		/datum/design/bioprinter/leather/cash_bag,
		/datum/design/bioprinter/belt/utility,
		/datum/design/bioprinter/belt/utility/neotheology,
		/datum/design/bioprinter/belt/medical,
		/datum/design/bioprinter/belt/security,
		/datum/design/bioprinter/belt/security/neotheology,
		/datum/design/bioprinter/belt/medical/emt,
		/datum/design/bioprinter/belt/misc/champion,

		/datum/design/bioprinter/leather/holster,
		/datum/design/bioprinter/leather/holster/armpit,
		/datum/design/bioprinter/leather/holster/waist,
		/datum/design/bioprinter/leather/holster/hip,

		/datum/design/autolathe/device/headset_church
	)

// Ironhammer
/obj/item/weapon/computer_hardware/hard_drive/portable/design/security
	disk_name = "Ironhammer Miscellaneous Pack"
	icon_state = "ironhammer"
	rarity_value = 5
	license = 20
	designs = list(
		/datum/design/autolathe/sec/secflashlight,
		/datum/design/research/item/flash,
		/datum/design/autolathe/sec/handcuffs,
		/datum/design/autolathe/sec/zipties,
		/datum/design/autolathe/sec/electropack,
		/datum/design/autolathe/misc/taperecorder,
		/datum/design/autolathe/tool/tacknife,
		/datum/design/autolathe/sec/beartrap,
		/datum/design/autolathe/sec/silencer,
		/datum/design/autolathe/sec/hailer
	)

// One Star
/obj/item/weapon/computer_hardware/hard_drive/portable/design/onestar
	disk_name = "One Star Tool Pack"
	icon_state = "onestar"
	rarity_value = 70
	spawn_blacklisted = TRUE
	spawn_tags = SPAWN_TAG_DESING_OS
	license = 2
	designs = list(
		/datum/design/autolathe/tool/crowbar_onestar,
		/datum/design/autolathe/tool/combi_driver_onestar,
		/datum/design/autolathe/tool/jackhammer_onestar,
		/datum/design/autolathe/tool/drill_onestar,
		/datum/design/autolathe/tool/weldertool_onestar
	)

// Magazines and ammo

/obj/item/weapon/computer_hardware/hard_drive/portable/design/nonlethal_ammo
	disk_name = "Frozen Star Nonlethal Magazines Pack"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED_COMMON
	rarity_value = 20
	license = 20
	designs = list(
		//please, maintain general order (pistol>speedloaders>smg>other>shells)+(smaller/less damaging caliber>bigger/more damaging caliber)
		//pistol mags
		/datum/design/autolathe/ammo/magazine_pistol/rubber,
		/datum/design/autolathe/ammo/mg_magnum/rubber,
		/datum/design/autolathe/ammo/cspistol/rubber,
		//speed loaders
		/datum/design/autolathe/ammo/sl_pistol/rubber,
		/datum/design/autolathe/ammo/sl_magnum/rubber,
		//smg mags
		/datum/design/autolathe/ammo/smg/rubber,
		//magnum smg mags
		/datum/design/autolathe/ammo/msmg/rubber,
		//rifles
		/datum/design/autolathe/ammo/srifle/rubber,
		/datum/design/autolathe/ammo/ihclrifle/rubber,
		/datum/design/autolathe/ammo/lrifle/rubber,
		//shells
		/datum/design/autolathe/ammo/shotgun_blanks,
		/datum/design/autolathe/ammo/shotgun_beanbag,
		/datum/design/autolathe/ammo/shotgun_flash,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/lethal_ammo
	disk_name = "Frozen Star Lethal Magazines Pack"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED_COMMON
	license = 20
	designs = list(
		//please, maintain general order (pistol>speedloaders>smg>other>shells)+(smaller/less damaging caliber>bigger/more damaging caliber)
		//pistol mags
		/datum/design/autolathe/ammo/magazine_pistol,
		/datum/design/autolathe/ammo/mg_magnum,
		/datum/design/autolathe/ammo/cspistol,
		//speed loaders
		/datum/design/autolathe/ammo/sl_pistol,
		/datum/design/autolathe/ammo/sl_magnum,
		//smg mags
		/datum/design/autolathe/ammo/smg,
		//magnum smg mags
		/datum/design/autolathe/ammo/msmg,
		//rifles
		/datum/design/autolathe/ammo/srifle,
		/datum/design/autolathe/ammo/ihclrifle,
		/datum/design/autolathe/ammo/lrifle,
		//shells
		/datum/design/autolathe/ammo/shotgun_pellet,
		/datum/design/autolathe/ammo/shotgun,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/ammo_boxes_smallarms
	disk_name = "Frozen Star .35 and .40 Ammunition"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED_COMMON
	license = 20
	designs = list(
		/datum/design/autolathe/ammo/pistol_ammobox,
		/datum/design/autolathe/ammo/pistol_ammobox/practice = 0,
		/datum/design/autolathe/ammo/pistol_ammobox/rubber,
		/datum/design/autolathe/ammo/magnum_ammobox,
		/datum/design/autolathe/ammo/magnum_ammobox/practice = 0,
		/datum/design/autolathe/ammo/magnum_ammobox/rubber,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/ammo_boxes_rifle
	disk_name = "Frozen Star Rifle Ammunition"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED_COMMON
	license = 20
	designs = list(
		/datum/design/autolathe/ammo/srifle_ammobox_small,
		/datum/design/autolathe/ammo/srifle_ammobox_small/practice = 0,
		/datum/design/autolathe/ammo/srifle_ammobox_small/rubber,
		/datum/design/autolathe/ammo/srifle_ammobox,
		/datum/design/autolathe/ammo/srifle_ammobox/rubber,
		/datum/design/autolathe/ammo/clrifle_ammobox_small,
		/datum/design/autolathe/ammo/clrifle_ammobox_small/practice = 0,
		/datum/design/autolathe/ammo/clrifle_ammobox_small/rubber,
		/datum/design/autolathe/ammo/clrifle_ammobox,
		/datum/design/autolathe/ammo/clrifle_ammobox/rubber,
		/datum/design/autolathe/ammo/lrifle_ammobox_small,
		/datum/design/autolathe/ammo/lrifle_ammobox_small/practice = 0,
		/datum/design/autolathe/ammo/lrifle_ammobox_small/rubber,
		/datum/design/autolathe/ammo/lrifle_ammobox,
	)

// Excelsior
/obj/item/weapon/computer_hardware/hard_drive/portable/design/excelsior
	disk_name = "Excelsior Means of Production"
	desc = "The back has a machine etching: \"This struggle must be organised, according to \"all the rules of the art\", by people who are professionally engaged in revolutionary activity.\""
	icon_state = "excelsior"
	spawn_blacklisted = TRUE
	license = -1
	designs = list(
		/datum/design/autolathe/gun/makarov,						//guns
		/datum/design/autolathe/gun/drozd,
		/datum/design/autolathe/gun/vintorez,
		/datum/design/autolathe/gun/boltgun,
		/datum/design/autolathe/gun/ak47,
		/datum/design/autolathe/gun/reclaimer,
		/datum/design/autolathe/ammo/magazine_pistol,				//makarov ammo
		/datum/design/autolathe/ammo/magazine_pistol/rubber,
		/datum/design/autolathe/ammo/pistol_ammobox,
		/datum/design/autolathe/ammo/pistol_ammobox/rubber,
		/datum/design/autolathe/ammo/msmg,							//drozd ammo
		/datum/design/autolathe/ammo/msmg/rubber,
		/datum/design/autolathe/ammo/magnum_ammobox,
		/datum/design/autolathe/ammo/magnum_ammobox/rubber,
		/datum/design/autolathe/ammo/srifle,						//vintorez ammo
		/datum/design/autolathe/ammo/srifle/rubber,
		/datum/design/autolathe/ammo/srifle_ammobox,
		/datum/design/autolathe/ammo/srifle_ammobox/rubber,
		/datum/design/autolathe/ammo/sl_lrifle,						//boltgun ammo
		/datum/design/autolathe/ammo/lrifle_ammobox_small,
		/datum/design/autolathe/ammo/lrifle_ammobox_small/rubber,
		/datum/design/autolathe/ammo/lrifle,						//AK ammo
		/datum/design/autolathe/ammo/lrifle/rubber,
		/datum/design/autolathe/ammo/lrifle_ammobox,
		/datum/design/autolathe/circuit/autolathe_excelsior,		//circuits
		/datum/design/autolathe/circuit/shieldgen_excelsior,
		/datum/design/autolathe/circuit/reconstructor_excelsior,
		/datum/design/autolathe/circuit/diesel_excelsior,
		/datum/design/autolathe/circuit/excelsior_boombox,
		/datum/design/autolathe/circuit/turret_excelsior,
		/datum/design/autolathe/circuit/autolathe_disk_cloner,
		/datum/design/research/item/part/micro_mani,				//machine parts
		/datum/design/research/item/part/subspace_amplifier,
		/datum/design/research/item/part/subspace_crystal,
		/datum/design/research/item/part/subspace_transmitter,
		/datum/design/autolathe/part/igniter,						//regular parts
		/datum/design/autolathe/part/signaler,
		/datum/design/autolathe/part/sensor_prox,
		/datum/design/research/item/part/basic_capacitor,
		/datum/design/autolathe/cell/large/excelsior,				//power cells
		/datum/design/autolathe/cell/medium/excelsior,
		/datum/design/autolathe/cell/small/excelsior,
		/datum/design/autolathe/device/excelsiormine,				//security
		/datum/design/autolathe/sec/beartrap,
		/datum/design/autolathe/prosthesis/excelsior/l_arm,         //prostheses
		/datum/design/autolathe/prosthesis/excelsior/r_arm,
		/datum/design/autolathe/prosthesis/excelsior/l_leg,
		/datum/design/autolathe/prosthesis/excelsior/r_leg,
		/datum/design/autolathe/device/implanter,					//misc
		/datum/design/autolathe/device/propaganda_chip,
		/datum/design/autolathe/clothing/excelsior_armor,
		/datum/design/autolathe/device/excelbaton,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/excelsior_weapons
	disk_name = "Excelsior Means of Revolution"
	desc = "The back has a machine etching: \"We stand for organized terror - this should be frankly admitted. Terror is an absolute necessity during times of revolution.\""
	icon_state = "excelsior"
	spawn_blacklisted = TRUE
	license = -1
	designs = list(
		/datum/design/autolathe/gun/makarov,
		/datum/design/autolathe/gun/drozd,
		/datum/design/autolathe/gun/vintorez,
		/datum/design/autolathe/gun/boltgun,
		/datum/design/autolathe/gun/ak47,
		/datum/design/autolathe/ammo/magazine_pistol,				//makarov ammo
		/datum/design/autolathe/ammo/magazine_pistol/rubber,
		/datum/design/autolathe/ammo/pistol_ammobox,
		/datum/design/autolathe/ammo/pistol_ammobox/rubber,
		/datum/design/autolathe/ammo/msmg,							//drozd ammo
		/datum/design/autolathe/ammo/msmg/rubber,
		/datum/design/autolathe/ammo/magnum_ammobox,
		/datum/design/autolathe/ammo/magnum_ammobox/rubber,
		/datum/design/autolathe/ammo/srifle,						//vintorez ammo
		/datum/design/autolathe/ammo/srifle/rubber,
		/datum/design/autolathe/ammo/srifle_ammobox,
		/datum/design/autolathe/ammo/srifle_ammobox/rubber,
		/datum/design/autolathe/ammo/sl_lrifle,						//boltgun ammo
		/datum/design/autolathe/ammo/lrifle_ammobox_small,
		/datum/design/autolathe/ammo/lrifle_ammobox_small/rubber,
		/datum/design/autolathe/ammo/lrifle,						//AK ammo
		/datum/design/autolathe/ammo/lrifle/rubber,
		/datum/design/autolathe/ammo/lrifle_ammobox,
		/datum/design/autolathe/sec/silencer,						//misc
		/datum/design/autolathe/clothing/excelsior_armor,
	)

// G U N S (minus excelsior and research)
// Pack is used when there is more than one gun on the disk

// .35 PISTOLS + REVOLVERS
/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns
	bad_type = /obj/item/weapon/computer_hardware/hard_drive/portable/design/guns

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_cheap_guns
	disk_name = "Frozen Star Basic - .35 Civilian Pack"
	icon_state = "frozenstar"
	rarity_value = 7
	license = 12
	designs = list(
		/datum/design/autolathe/gun/giskard = 3,
		/datum/design/autolathe/gun/olivaw = 3,
		/datum/design/autolathe/gun/clarissa = 3,
		/datum/design/autolathe/gun/havelock = 3,
		/datum/design/autolathe/ammo/magazine_pistol,
		/datum/design/autolathe/ammo/magazine_pistol/practice = 0,
		/datum/design/autolathe/ammo/magazine_pistol/rubber,
		/datum/design/autolathe/ammo/sl_pistol/practice = 0,
		/datum/design/autolathe/ammo/sl_pistol/rubber,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_mk58
	disk_name = "NeoTheology Armory - .35 MK58 Handgun Pack"
	icon_state = "neotheology"
	rarity_value = 9
	license = 12
	designs = list(
		/datum/design/autolathe/gun/mk58 = 3,
		/datum/design/autolathe/gun/mk58_wood = 3,
		/datum/design/autolathe/ammo/magazine_pistol,
		/datum/design/autolathe/ammo/magazine_pistol/practice = 0,
		/datum/design/autolathe/ammo/magazine_pistol/rubber,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_colt
	disk_name = "Frozen Star - .35 Colt 1911"
	icon_state = "frozenstar"
	rarity_value = 9
	license = 12
	designs = list(
		/datum/design/autolathe/gun/colt = 3, //"FS HG .35 Auto \"Colt M1911\""
		/datum/design/autolathe/ammo/magazine_pistol,
		/datum/design/autolathe/ammo/magazine_pistol/practice = 0,
		/datum/design/autolathe/ammo/magazine_pistol/rubber,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_silenced
	disk_name = "Frozen Star - .25 Mandella"
	icon_state = "frozenstar"
	rarity_value = 13
	license = 12
	designs = list(
		/datum/design/autolathe/gun/mandella = 3, // "FS HG .25 Caseless \"Mandella\""
		/datum/design/autolathe/ammo/cspistol,
		/datum/design/autolathe/ammo/cspistol/practice = 0,
		/datum/design/autolathe/ammo/cspistol/rubber,
	)

// .40 REVOLVERS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_miller
	disk_name = "Frozen Star - .40 Miller Revolver"
	icon_state = "frozenstar"
	rarity_value = 13
	license = 12
	designs = list(
		/datum/design/autolathe/gun/revolver = 3, // "FS REV .40 \"Miller\""
		/datum/design/autolathe/ammo/sl_magnum,
		/datum/design/autolathe/ammo/sl_magnum/practice = 0,
		/datum/design/autolathe/ammo/sl_magnum/rubber,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_consul
	disk_name = "Frozen Star - .40 Consul Revolver"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/revolver_consul = 3, // "FS REV .40 \"Consul\""
		/datum/design/autolathe/ammo/sl_magnum,
		/datum/design/autolathe/ammo/sl_magnum/practice = 0,
		/datum/design/autolathe/ammo/sl_magnum/rubber,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_deckard
	disk_name = "Frozen Star - .40 Deckard Revolver"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/revolver_deckard = 3, // "FS REV .40 \"Deckard\""
		/datum/design/autolathe/ammo/sl_magnum,
		/datum/design/autolathe/ammo/sl_magnum/practice = 0,
		/datum/design/autolathe/ammo/sl_magnum/rubber,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_mateba
	disk_name = "Frozen Star - .40 Mateba Revolver"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/revolver_mateba = 3, // "FS REV .40 Magnum \"Mateba\""
		/datum/design/autolathe/ammo/sl_magnum,
		/datum/design/autolathe/ammo/sl_magnum/practice = 0,
		/datum/design/autolathe/ammo/sl_magnum/rubber,
		)

// .40 PISTOLS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_lamia
	disk_name = "Frozen Star - .40 Lamia Handgun"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/lamia = 3, // "FS HG .40 \"Lamia\""
		/datum/design/autolathe/ammo/mg_magnum,
		/datum/design/autolathe/ammo/mg_magnum/practice = 0,
		/datum/design/autolathe/ammo/mg_magnum/rubber,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_deagle
	disk_name = "Frozen Star - .40 Avasarala Handgun"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 50
	license = 12
	designs = list(
		/datum/design/autolathe/gun/avasarala = 3, // "FS HG .40 \"Avasarala\""
		/datum/design/autolathe/ammo/mg_magnum,
		/datum/design/autolathe/ammo/mg_magnum/practice = 0,
		/datum/design/autolathe/ammo/mg_magnum/rubber,
		)

// .50 SHOTGUNS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_doublebarrel
	disk_name = "Frozen Star - .50 Double Barrel Shotgun"
	icon_state = "frozenstar"
	rarity_value = 9
	license = 12
	designs = list(
		/datum/design/autolathe/gun/doublebarrel = 3, // "double-barreled shotgun"
		/datum/design/autolathe/ammo/shotgun_pellet,
		/datum/design/autolathe/ammo/shotgun,
		/datum/design/autolathe/ammo/shotgun_beanbag,
		/datum/design/autolathe/ammo/shotgun_blanks,
		/datum/design/autolathe/ammo/shotgun_flash,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_kammerer
	disk_name = "Frozen Star - .50 Kammerer Shotgun"
	icon_state = "frozenstar"
	rarity_value = 9
	license = 12
	designs = list(
		/datum/design/autolathe/gun/pump_shotgun = 3, // "FS SG \"Kammerer\""
		/datum/design/autolathe/ammo/shotgun_pellet,
		/datum/design/autolathe/ammo/shotgun,
		/datum/design/autolathe/ammo/shotgun_beanbag,
		/datum/design/autolathe/ammo/shotgun_blanks,
		/datum/design/autolathe/ammo/shotgun_flash,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_regulator
	disk_name = "NeoTheology Armory - .50 Regulator Shotgun"
	icon_state = "neotheology"
	rarity_value = 17
	license = 12
	designs = list(
		/datum/design/autolathe/gun/regulator = 3, // "NT SG \"Regulator 1000\""
		/datum/design/autolathe/ammo/shotgun_pellet,
		/datum/design/autolathe/ammo/shotgun,
		/datum/design/autolathe/ammo/shotgun_beanbag,
		/datum/design/autolathe/ammo/shotgun_blanks,
		/datum/design/autolathe/ammo/shotgun_flash,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_gladstone
	disk_name = "Frozen Star - .50 Gladstone Shotgun"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 17
	license = 12
	designs = list(
		/datum/design/autolathe/gun/gladstone = 3, // "FS SG \"Gladstone\""
		/datum/design/autolathe/ammo/shotgun_pellet,
		/datum/design/autolathe/ammo/shotgun,
		/datum/design/autolathe/ammo/shotgun_beanbag,
		/datum/design/autolathe/ammo/shotgun_blanks,
		/datum/design/autolathe/ammo/shotgun_flash,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_pug
	disk_name = "Serbian Arms - .50 Pug Auto Shotgun"
	icon_state = "serbian"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/bojevic = 3, // "SA SG \"Bojevic\""
		/datum/design/autolathe/ammo/m12beanbag, // Never add tazershells, for love of god
		/datum/design/autolathe/ammo/m12pellet,
		/datum/design/autolathe/ammo/m12slug,
		)

// SMGs
/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_paco
	disk_name = "Frozen Star - .35 Paco HG"
	icon_state = "frozenstar"
	rarity_value = 13
	license = 12
	designs = list(
		/datum/design/autolathe/gun/paco = 3, // "FS HG .35 \"Paco\""
		/datum/design/autolathe/ammo/magazine_pistol,
		/datum/design/autolathe/ammo/magazine_pistol/practice = 0,
		/datum/design/autolathe/ammo/magazine_pistol/rubber,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_straylight
	disk_name = "Frozen Star - .35 Straylight SMG"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/straylight = 3, // "FS SMG .35 \"Straylight\""
		/datum/design/autolathe/ammo/smg,
		/datum/design/autolathe/ammo/smg/practice = 0,
		/datum/design/autolathe/ammo/smg/rubber,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_molly
	disk_name = "Frozen Star - .35 Molly SMG"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/molly = 3, // "FS MP .35 \"Molly\""
		/datum/design/autolathe/ammo/smg,
		/datum/design/autolathe/ammo/smg/practice = 0,
		/datum/design/autolathe/ammo/smg/rubber,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_zoric
	disk_name = "Serbian Arms - .40 Zoric SMG"
	icon_state = "serbian"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/zoric = 3, // "SA SMG .40 \"Zoric\""
		/datum/design/autolathe/ammo/msmg,
		/datum/design/autolathe/ammo/msmg/practice = 0,
		/datum/design/autolathe/ammo/msmg/rubber,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_atreides
	disk_name = "Frozen Star - .35 Atreides SMG"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/atreides = 3, // "FS SMG .35 \"Atreides\""
		/datum/design/autolathe/ammo/smg,
		/datum/design/autolathe/ammo/smg/practice = 0,
		/datum/design/autolathe/ammo/smg/rubber,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/ex_drozd
	disk_name = "Excelsior - .40 Drozd SMG"
	desc = {"The back has a machine etching:\n \
	\"Nobody is to be blamed for being born a slave; \
	but a slave who not only eschews a striving for freedom but justifies and eulogies his slavery - \
	such a slave is a lickspittle and a boor, who arouses a legitimate feeling of indignation, contempt, and loathing.\""}
	icon_state = "excelsior"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 50
	license = -1
	designs = list(
		/datum/design/autolathe/gun/drozd,
		/datum/design/autolathe/ammo/msmg, //comes with both lethal and rubber like means of production
		/datum/design/autolathe/ammo/msmg/rubber
	)

// .20 Rifles (AP)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_bulldog
	disk_name = "Frozen Star - .20 Bulldog Carabine"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/z8 = 3, // "FS CAR .20 \"Z8 Bulldog\""
		/datum/design/autolathe/ammo/srifle,
		/datum/design/autolathe/ammo/srifle/practice = 0,
		/datum/design/autolathe/ammo/srifle/rubber,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_wintermute
	disk_name = "Frozen Star - .20 Wintermute Assault Rifle"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/wintermute = 3, // "FS BR .20 \"Wintermute\""
		/datum/design/autolathe/ammo/srifle,
		/datum/design/autolathe/ammo/srifle/practice = 0,
		/datum/design/autolathe/ammo/srifle/rubber,
	)

// .25 Caseless

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_sol
	disk_name = "Frozen Star - .25 Sol Caseless SMG Pack"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/sol = 3, // "FS CAR .25 caseless \"Sol\""
		/datum/design/autolathe/ammo/ihclrifle,
		/datum/design/autolathe/ammo/ihclrifle/practice = 0,
		/datum/design/autolathe/ammo/ihclrifle/rubber,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/dallas
	disk_name = "PAR - .25 Dallas"
	icon_state = "black"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/dallas = 3, // "PAR .25 CS \"Dallas\""
		/datum/design/autolathe/ammo/c10x24,
	)

// .30 Rifles

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_boltgun
	disk_name = "Serbian Arms - .30  Novakovic Rifle"
	icon_state = "serbian"
	rarity_value = 5.5
	license = 12
	designs = list(
		/datum/design/autolathe/gun/boltgun_serbian = 3, // "SA BR .30 \"Novakovic\""
		/datum/design/autolathe/ammo/sl_lrifle,
		/datum/design/autolathe/ammo/lrifle_ammobox_small,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_kalashnikov
	disk_name = "Frozen Star - .30 Kalashnikov Rifle"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/ak47_fs = 3, // "FS AR .30 \"Kalashnikov\""
		/datum/design/autolathe/ammo/lrifle,
		/datum/design/autolathe/ammo/lrifle/practice = 0,
		/datum/design/autolathe/ammo/lrifle/rubber,
	)

// Heavy

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_heavysniper
	disk_name = "NeoTheology Armory - .60 Penetrator AMR"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/heavysniper = 3, // "NT AMR .60 \"Penetrator\""
		/datum/design/autolathe/ammo/antim,
		/datum/design/autolathe/ammo/box_antim,
	)


/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_pk
	disk_name = "Serbian Arms - .30 Pulemyot Kalashnikova MG"
	icon_state = "serbian"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/mg_pk = 3, // "SA MG .30 \"Pulemyot Kalashnikova\""
		/datum/design/autolathe/ammo/lrifle_pk,
	)

// Grenade Launchers

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_protector
	disk_name = "NeoTheology Armory - Protector Grenade Launcher"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 90
	license = 15
	designs = list(
		/datum/design/autolathe/gun/grenade_launcher = 3, // "NT GL \"Protector\""
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_lenar
	disk_name = "Frozen Star - Lenar Grenade Launcher"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 90
	license = 15
	designs = list(
		/datum/design/autolathe/gun/grenade_launcher_lenar = 3, // "FS GL \"Lenar\""
	)

// ENERGY SMALL ARMS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_counselor
	disk_name = "NeoTheology Armory - Councelor PDW E"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 17
	license = 12
	designs = list(
		/datum/design/autolathe/gun/taser = 3, // "NT SP \"Counselor\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_svalinn
	disk_name = "NeoTheology Armory - NT LP \"Svalinn\""
	icon_state = "neotheology"

	license = 12
	designs = list(
		/datum/design/autolathe/gun/nt_svalinn = 3,
		/datum/design/autolathe/cell/small/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_spiderrose
	disk_name = "Frozen Star - Spider Rose PDW E"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/energygun = 3, // "FS PDW E \"Spider Rose\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_martin
	disk_name = "Frozen Star - Martin PDW E"
	icon_state = "frozenstar"
	rarity_value = 9
	license = 12
	designs = list(
		/datum/design/autolathe/gun/energygun_martin = 3, // "FS PDW E \"Martin\""
		/datum/design/autolathe/cell/small/high,
	)

// ENERGY ARMS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_nemesis
	disk_name = "NeoTheology Armory - Nemesis Energy Crossbow"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 50
	license = 12
	designs = list(
		/datum/design/autolathe/gun/energy_crossbow = 3, // "NT EC \"Nemesis\"" - self charging, no cell needed
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_themis
	disk_name = "NeoTheology Armory - Themis Energy Crossbow"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/large_energy_crossbow = 3, // "NT EC \"Themis\"" - self charging, no cell needed
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_lightfall
	disk_name = "NeoTheology Armory - Lightfall Laser Gun"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	license = 12
	designs = list(
		/datum/design/autolathe/gun/laser = 3, // "NT LG \"Lightfall\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_valkirye
	disk_name = "NeoTheology Armory - Valkyrie Energy Rifle"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 50
	license = 12
	designs = list(
		/datum/design/autolathe/gun/sniperrifle = 3, //"NT MER \"Valkyrie\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_halicon
	disk_name = "NeoTheology Armory - Halicon Ion Rifle"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 33.33
	license = 12
	designs = list(
		/datum/design/autolathe/gun/ionrifle = 3, // "NT IR \"Halicon\""
		/datum/design/autolathe/cell/medium/high,
	)

// PLASMA ARMS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_dominion
	disk_name = "NeoTheology Armory - Dominion Plasma Rifle"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 50
	license = 12
	designs = list(
		/datum/design/autolathe/gun/plasma/dominion = 3, //"NT PR \"Dominion\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_purger
	disk_name = "NeoTheology Armory - Purger Plasma Rifle"
	icon_state = "neotheology"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 50
	license = 12
	designs = list(
		/datum/design/autolathe/gun/plasma/destroyer = 3, // "NT PR \"Purger\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_melee
	disk_name = "NeoTheology Armory - Melee Weapons"
	icon_state = "neotheology"
	spawn_blacklisted = TRUE
	rarity_value = 50
	license = -1
	designs = list(
		/datum/design/autolathe/sword/nt_sword,
		/datum/design/autolathe/sword/nt_longsword,
		/datum/design/autolathe/sword/nt_dagger,
		/datum/design/autolathe/sword/nt_halberd,
		/datum/design/autolathe/sword/nt_scourge,
		/datum/design/autolathe/shield/nt_shield,
		/datum/design/bioprinter/storage/sheath,
		/datum/design/autolathe/tool_upgrade/sanctifier
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_cassad
	disk_name = "Frozen Star - Cassad Plasma Rifle"
	icon_state = "frozenstar"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 90
	license = 12
	designs = list(
		/datum/design/autolathe/gun/plasma/cassad = 3, // "FS PR \"Cassad\""
		/datum/design/autolathe/cell/medium/high,
	)

// SPECIAL

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/ms_dartgun
	disk_name = "Moebius Scientifica - Z-H P Artemis Dartgun"
	icon_state = "moebius"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED
	rarity_value = 50
	license = 12
	designs = list(
		/datum/design/autolathe/gun/dart_gun = 3, // Z-H P Artemis"
		/datum/design/autolathe/ammo/dart_mag,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_grenades
	disk_name = "NeoTheology Armory - Grenades Pack"
	icon_state = "neotheology"
	spawn_blacklisted = TRUE
	rarity_value = 50
	license = 12
	designs = list(
		/datum/design/autolathe/grenade/nt_explosive = 3,
		/datum/design/autolathe/grenade/nt_flashbang,
		/datum/design/autolathe/grenade/nt_frag = 2,
		/datum/design/autolathe/grenade/nt_smokebomb
	)

// ARMOR
/obj/item/weapon/computer_hardware/hard_drive/portable/design/armor
	bad_type = /obj/item/weapon/computer_hardware/hard_drive/portable/design/armor

/obj/item/weapon/computer_hardware/hard_drive/portable/design/armor/crusader
	disk_name = "NeoTheology Armory - Crusader Armor"
	icon_state = "neotheology"
	spawn_blacklisted = TRUE
	rarity_value = 12 // one of the more common advanced disks
	license = 6 // 6 pieces, or 3 sets if you use helm + vest
	designs = list(
		/datum/design/autolathe/helmet/crusader,
		/datum/design/autolathe/armor/crusader
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/armor/generic
	disk_name = "Ironhammer Combat Equipment - Standard Armor"
	icon_state = "ironhammer"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED_COMMON
	rarity_value = 12 // one of the more common advanced disks
	license = 6 // 6 pieces, or 3 sets if you use helm + vest
	designs = list(
		/datum/design/autolathe/clothing/generic_helmet_basic,
		/datum/design/autolathe/clothing/generic_vest,
		/datum/design/autolathe/clothing/generic_vest_full = 2
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/armor/generic/bulletproof
	disk_name = "Ironhammer Combat Equipment - Bulletproof Armor"
	icon_state = "ironhammer"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED_COMMON
	rarity_value = 15 // about as rare as a advanced tool disk - remember that this takes from the 'advanced' pool (which is rare) instead of the 'common' pool like the normal armor disk does
	license = 4 // 4 pieces, or 2 sets
	designs = list(
		/datum/design/autolathe/clothing/bulletproof_helmet_generic,
		/datum/design/autolathe/clothing/bulletproof_vest_generic,
		/datum/design/autolathe/clothing/bulletproof_vest_generic_full = 2
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/armor/generic/ablative
	disk_name = "Ironhammer Combat Equipment - Laserproof Armor"
	icon_state = "ironhammer"
	spawn_tags = SPAWN_TAG_DESING_ADVANCED_COMMON
	rarity_value = 16 // slightly rarer than bulletproof gear
	license = 4 // 4 pieces, or 2 sets
	designs = list(
		/datum/design/autolathe/clothing/ablative_vest,
		/datum/design/autolathe/clothing/ablative_helmet
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/armor/ih
	disk_name = "Ironhammer Combat Equipment - Operator Armor"
	icon_state = "ironhammer"
	spawn_blacklisted = TRUE //should only be obtainable from the sectech
	license = 6
	designs = list(
		/datum/design/autolathe/clothing/ih_helmet_basic,
		/datum/design/autolathe/clothing/ih_vest_basic,
		/datum/design/autolathe/clothing/ih_vest_basic_full = 2
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/armor/ih/bulletproof
	disk_name = "Ironhammer Combat Equipment - Bulletproof Operator Armor"
	icon_state = "ironhammer"
	spawn_blacklisted = TRUE
	license = 4
	designs = list(
		/datum/design/autolathe/clothing/ih_helmet_full,
		/datum/design/autolathe/clothing/ih_vest_full
	)

