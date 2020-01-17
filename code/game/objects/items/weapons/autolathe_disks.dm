/obj/item/weapon/computer_hardware/hard_drive/portable/design
	name = "design disk"
	icon_state = "yellow"
	desc = "Data disk used to store autolathe designs."
	max_capacity = 1024	// Up to 255 designs, automatically reduced to the nearest power of 2
	origin_tech = list(TECH_DATA = 3) // Most design disks end up being 64 to 128 GQ
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASTIC = 2, MATERIAL_GOLD = 0.5)
	license = -1
	var/list/designs = list()

/obj/item/weapon/computer_hardware/hard_drive/portable/design/install_default_files()
	..()
	// Add design files to the disk
	for(var/design_typepath in designs)
		var/datum/computer_file/binary/design/D = new
		D.set_design_type(design_typepath)
		if(license > 0)
			D.set_copy_protection(TRUE)

		store_file(D)

	// Shave off the extra space so a disk with two designs doesn't show up as 1024 GQ
	while(max_capacity > 16 && max_capacity / 2 > used_capacity)
		max_capacity /= 2

	// Prevent people from breaking DRM by copying files across protected disks.
	// Stops people from screwing around with unprotected disks too.
	read_only = TRUE
	return TRUE


// Asters
/obj/item/weapon/computer_hardware/hard_drive/portable/design/tools
	disk_name = "Asters Basic Tool Pack"
	icon_state = "guild"

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
		/datum/design/autolathe/tool/wrench,
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
		/datum/design/autolathe/container/pill_bottle,
		/datum/design/autolathe/container/spray,
		/datum/design/autolathe/misc/cane,
		/datum/design/autolathe/misc/floor_light,
		/datum/design/autolathe/misc/tube,
		/datum/design/autolathe/misc/bulb,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/devices
	disk_name = "Asters Devices and Instruments"
	icon_state = "guild"

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
		/datum/design/research/item/light_replacer
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/robustcells
	disk_name = "Asters Robustcells"
	icon_state = "guild"

	license = 8
	designs = list(
		/datum/design/autolathe/cell/large,
		/datum/design/autolathe/cell/large/high,
		/datum/design/autolathe/cell/medium,
		/datum/design/autolathe/cell/medium/high,
		/datum/design/autolathe/cell/small,
		/datum/design/autolathe/cell/small/high,
	)


// Technomancers
/obj/item/weapon/computer_hardware/hard_drive/portable/design/components
	disk_name = "Technomancers ARK-034 Components"
	icon_state = "technomancers"

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
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/adv_tools
	disk_name = "Technomancers IJIRO-451 Advanced Tools"
	icon_state = "technomancers"

	license = 10
	designs = list(
		/datum/design/autolathe/tool/big_wrench,
		/datum/design/autolathe/tool/pneumatic_crowbar,
		/datum/design/research/item/weapon/mining/jackhammer,
		/datum/design/research/item/weapon/mining/drill,
		/datum/design/research/item/weapon/mining/drill_diamond,
		/datum/design/autolathe/tool/pickaxe_excavation,
		/datum/design/autolathe/tool/circularsaw,
		/datum/design/autolathe/tool/chainsaw,
		/datum/design/autolathe/tool/rcd,
		/datum/design/autolathe/tool/electric_screwdriver,
		/datum/design/autolathe/tool/combi_driver,
		/datum/design/autolathe/tool/armature_cutter,
		/datum/design/autolathe/part/diamondblade,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/circuits
	disk_name = "Technomancers ESPO-830 Circuits"
	icon_state = "technomancers"

	license = 10
	designs = list(
		/datum/design/autolathe/circuit/airlockmodule,
		/datum/design/autolathe/circuit/airalarm,
		/datum/design/autolathe/circuit/firealarm,
		/datum/design/autolathe/circuit/powermodule,
		/datum/design/autolathe/circuit/recharger,
		/datum/design/research/circuit/autolathe,
		/datum/design/autolathe/circuit/autolathe_disk_cloner,
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

	)


// Moebius
/obj/item/weapon/computer_hardware/hard_drive/portable/design/medical
	disk_name = "Moebius Medical Designs"
	icon_state = "moebius"

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
		/datum/design/autolathe/device/implanter,
		/datum/design/autolathe/container/syringegun_ammo,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/computer
	disk_name = "Moebius Computer Parts"
	icon_state = "moebius"

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
		/datum/design/autolathe/computer_part/gps,
		/datum/design/autolathe/computer_part/scanner/paper,
		/datum/design/autolathe/computer_part/scanner/atmos,
	)


// NeoTheology
/obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_bioprinter
	disk_name = "NeoTheology Bioprinter Production"
	icon_state = "neotheology"

	license = -1
	designs = list(
		/datum/design/bioprinter/meat,
		/datum/design/bioprinter/milk,
		/datum/design/bioprinter/soap,

		/datum/design/bioprinter/ez,
		/datum/design/bioprinter/l4z,
		/datum/design/bioprinter/rh,

		/datum/design/bioprinter/wallet,
		/datum/design/bioprinter/botanic_leather,
		/datum/design/bioprinter/leather/satchel,
		/datum/design/bioprinter/leather/leather_jacket,
		/datum/design/bioprinter/leather/cash_bag,
		/datum/design/bioprinter/belt/utility,
		/datum/design/bioprinter/belt/medical,
		/datum/design/bioprinter/belt/security,
		/datum/design/bioprinter/belt/medical/emt,
		/datum/design/bioprinter/belt/misc/champion,

		/datum/design/bioprinter/medical/bruise,
		/datum/design/bioprinter/medical/splints,
		/datum/design/bioprinter/medical/ointment,
		/datum/design/bioprinter/medical/advanced/bruise,
		/datum/design/bioprinter/medical/advanced/ointment,
	)

// Same as the other NT disk, minus the medical designs. Spawns in public access bioprinters.
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
		/datum/design/bioprinter/leather/satchel,
		/datum/design/bioprinter/leather/leather_jacket,
		/datum/design/bioprinter/leather/cash_bag,
		/datum/design/bioprinter/belt/utility,
		/datum/design/bioprinter/belt/medical,
		/datum/design/bioprinter/belt/security,
		/datum/design/bioprinter/belt/medical/emt,
		/datum/design/bioprinter/belt/misc/champion,

		/datum/design/autolathe/gun/nt_sprayer
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/nt_boards
	disk_name = "NeoTheology Circuit Pack"
	icon_state = "neotheology"

	license = -1
	designs = list(
		/datum/design/autolathe/circuit/bioprinter,
		/datum/design/autolathe/circuit/solidifier,

		/datum/design/autolathe/circuit/cloner,
		/datum/design/autolathe/circuit/reader,
		/datum/design/autolathe/circuit/biocan,

		/datum/design/autolathe/circuit/bioreactor_platform,
		/datum/design/autolathe/circuit/bioreactor_unloader,
		/datum/design/autolathe/circuit/bioreactor_biotank,
		/datum/design/autolathe/circuit/bioreactor_port,
		/datum/design/autolathe/circuit/bioreactor_metrics,
		/datum/design/autolathe/circuit/bioreactor_loader,

		/datum/design/autolathe/circuit/biogen,
		/datum/design/autolathe/circuit/biogen_port,
		/datum/design/autolathe/circuit/biogen_console,
	)

// Ironhammer
/obj/item/weapon/computer_hardware/hard_drive/portable/design/security
	disk_name = "Ironhammer Miscellaneous Pack"
	icon_state = "ironhammer"

	license = 20
	designs = list(
		/datum/design/autolathe/sec/secflashlight,
		/datum/design/research/item/flash,
		/datum/design/autolathe/sec/handcuffs,
		/datum/design/autolathe/sec/zipties,
		/datum/design/autolathe/misc/taperecorder,
		/datum/design/autolathe/tool/tacknife,
		/datum/design/autolathe/sec/beartrap,
		/datum/design/autolathe/sec/silencer,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/nonlethal_ammo //please, maintain general order (pistol>speedloaders>smg>other>shells)+(smaller/less damaging caliber>bigger/more damaging caliber)
	disk_name = "Frozen Star Nonlethal Ammo Pack"
	icon_state = "frozenstar"

	license = 20
	designs = list(
		/datum/design/autolathe/ammo/magazine_pistol_rubber, //pistol mags
		/datum/design/autolathe/ammo/mg_magnum_rubber,
		/datum/design/autolathe/ammo/sl_pistol_rubber, //speed loaders
		/datum/design/autolathe/ammo/sl_magnum_rubber,
		/datum/design/autolathe/ammo/smg_rubber, //smg mags
		/datum/design/autolathe/ammo/SMG_sol_rubber, //other mags
		/datum/design/autolathe/ammo/srifle_practice,
		/datum/design/autolathe/ammo/shotgun_blanks, //shells
		/datum/design/autolathe/ammo/shotgun_flash,
		/datum/design/autolathe/ammo/stunshell,
		/datum/design/autolathe/ammo/shotgun_beanbag
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/lethal_ammo //please, maintain general order (pistol>speedloaders>smg>other>shells)+(smaller/less damaging caliber>bigger/more damaging caliber)
	disk_name = "Frozen Star Lethal Ammo Pack"
	icon_state = "frozenstar"

	license = 20
	designs = list(
		/datum/design/autolathe/ammo/magazine_pistol, //pistol mags
		/datum/design/autolathe/ammo/mg_magnum_brute,
		/datum/design/autolathe/ammo/sl_pistol_brute, //speed loaders
		/datum/design/autolathe/ammo/sl_magnum_brute,
		/datum/design/autolathe/ammo/smg_brute, //smg mags
		/datum/design/autolathe/ammo/SMG_sol_brute, //other mags
		/datum/design/autolathe/ammo/srifle,
		/datum/design/autolathe/ammo/ihsrifle,
		/datum/design/autolathe/ammo/sl_lrifle,
		/datum/design/autolathe/ammo/lrifle_short,
		/datum/design/autolathe/ammo/lrifle_long,
		/datum/design/autolathe/ammo/shotgun_pellet, //shells
		/datum/design/autolathe/ammo/shotgun
	)


// Excelsior
/obj/item/weapon/computer_hardware/hard_drive/portable/design/excelsior
	disk_name = "Excelsior Means of Production"
	desc = "Seize it."
	icon_state = "excelsior"

	license = -1
	designs = list(
		/datum/design/autolathe/circuit/autolathe_excelsior,
		/datum/design/autolathe/circuit/shieldgen_excelsior,
		/datum/design/autolathe/circuit/reconstructor_excelsior,
		/datum/design/autolathe/circuit/diesel_excelsior,
		/datum/design/autolathe/circuit/turret_excelsior,
		/datum/design/autolathe/circuit/autolathe_disk_cloner,
		/datum/design/autolathe/device/implanter,
		/datum/design/autolathe/gun/makarov,
		/datum/design/autolathe/gun/drozd,
		/datum/design/autolathe/sec/silencer,
		/datum/design/autolathe/ammo/magazine_pistol,
		/datum/design/autolathe/ammo/smg_brute,
 		/datum/design/autolathe/gun/boltgun,
		/datum/design/autolathe/gun/ak47,
		/datum/design/autolathe/ammo/sl_lrifle,
		/datum/design/autolathe/ammo/lrifle_long,
		/datum/design/autolathe/ammo/box_lrifle,
		/datum/design/autolathe/gun/vintorez,
		/datum/design/autolathe/ammo/srifle,
		/datum/design/autolathe/device/excelsiormine,
		/datum/design/autolathe/sec/beartrap,
		/datum/design/autolathe/clothing/excelsior_armor,
		/datum/design/autolathe/clothing/excelsior_helmet,
		/datum/design/autolathe/cell/large/excelsior,
		/datum/design/autolathe/cell/medium/excelsior,
		/datum/design/autolathe/cell/small/excelsior,
		/datum/design/research/item/part/micro_mani,
		/datum/design/research/item/part/subspace_amplifier,
		/datum/design/research/item/part/subspace_crystal,
		/datum/design/research/item/part/subspace_transmitter,
		/datum/design/autolathe/part/igniter,
		/datum/design/autolathe/part/signaler,
		/datum/design/autolathe/part/sensor_prox,
		/datum/design/research/item/part/basic_capacitor,
		/datum/design/autolathe/part/camera_assembly
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/excelsior_weapons
	disk_name = "Excelsior Means of Revolution"
	desc = "The back has a machine etching: \"We stand for organized terror - this should be frankly admitted. Terror is an absolute necessity during times of revolution.\""
	icon_state = "excelsior"

	license = -1
	designs = list(
		/datum/design/autolathe/gun/makarov,
		/datum/design/autolathe/gun/drozd,
		/datum/design/autolathe/sec/silencer,
		/datum/design/autolathe/ammo/magazine_pistol,
		/datum/design/autolathe/ammo/smg_brute,
		/datum/design/autolathe/gun/ak47,
   		/datum/design/autolathe/gun/boltgun,
		/datum/design/autolathe/ammo/sl_lrifle,
		/datum/design/autolathe/ammo/lrifle_long,
		/datum/design/autolathe/ammo/box_lrifle,
  		/datum/design/autolathe/gun/vintorez,
		/datum/design/autolathe/ammo/srifle,
		/datum/design/autolathe/device/excelsiormine,
		/datum/design/autolathe/sec/beartrap,
		/datum/design/autolathe/clothing/excelsior_armor,
		/datum/design/autolathe/clothing/excelsior_helmet
	)

// One Star
/obj/item/weapon/computer_hardware/hard_drive/portable/design/onestar
	disk_name = "One Star Tool Pack"
	icon_state = "onestar"

	license = 2
	designs = list(
		/datum/design/autolathe/tool/crowbar_onestar,
		/datum/design/autolathe/tool/combi_driver_onestar,
		/datum/design/autolathe/tool/jackhammer_onestar,
		/datum/design/autolathe/tool/drill_onestar,
		/datum/design/autolathe/tool/weldertool_onestar
	)

// G U N S (minus excelsior and research)

// .35 PISTOLS + REVOLVERS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_cheap_guns
	disk_name = "Frozen Star Basic .35 Civilian Pack"
	icon_state = "frozenstar"

	license = 8
	designs = list(
		/datum/design/autolathe/gun/giskard,
		/datum/design/autolathe/gun/olivaw,
		/datum/design/autolathe/gun/clarissa,
		/datum/design/autolathe/gun/revolver_detective,
		/datum/design/autolathe/ammo/magazine_pistol_rubber,
		/datum/design/autolathe/ammo/magazine_pistol,
		/datum/design/autolathe/ammo/sl_pistol_rubber,
		/datum/design/autolathe/ammo/sl_pistol_brute,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_mk58
	disk_name = "NeoTheology Armory .35 MK58 Handgun Pack"
	icon_state = "neotheology"

	license = 4
	designs = list(
		/datum/design/autolathe/gun/mk58,
		/datum/design/autolathe/gun/mk58_wood,
		/datum/design/autolathe/ammo/sl_pistol_rubber,
		/datum/design/autolathe/ammo/sl_pistol_brute,
	)

// .40 REVOLVERS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_miller
	disk_name = "Frozen Star .40 Miller Revolver Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/revolver, // "FS REV .40 \"Miller\""
		/datum/design/autolathe/ammo/sl_magnum_rubber,
		/datum/design/autolathe/ammo/sl_magnum_brute,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_consul
	disk_name = "Frozen Star .40 Consul Revolver Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/revolver_consul, // "FS REV .40 \"Consul\""
		/datum/design/autolathe/ammo/sl_magnum_rubber,
		/datum/design/autolathe/ammo/sl_magnum_brute,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_deckard
	disk_name = "Frozen Star .40 Deckard Revolver Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/revolver_deckard, // "FS REV .40 \"Deckard\""
		/datum/design/autolathe/ammo/sl_magnum_rubber,
		/datum/design/autolathe/ammo/sl_magnum_brute,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_revolver_mateba
	disk_name = "Frozen Star .40 Mateba Revolver Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/revolver_mateba, // "FS REV .40 Magnum \"Mateba\""
		/datum/design/autolathe/ammo/sl_magnum_rubber,
		/datum/design/autolathe/ammo/sl_magnum_brute,
		)

// .40 PISTOLS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_lamia
	disk_name = "Frozen Star .40 Lamia Handgun Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/lamia, // "FS HG .40 \"Lamia\""
		/datum/design/autolathe/ammo/mg_magnum_rubber,
		/datum/design/autolathe/ammo/mg_magnum_brute,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_deagle
	disk_name = "Frozen Star .40 Avasarala Handgun Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/deagle, // "FS HG .40 \"Avasarala\""
		/datum/design/autolathe/ammo/mg_magnum_rubber,
		/datum/design/autolathe/ammo/mg_magnum_brute,
		)

// .50 SHOTGUNS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_doublebarrel
	disk_name = "Frozen Star .50 Double Barrel Shotgun Pack"
	icon_state = "frozenstar"

	license = 5
	designs = list(
		/datum/design/autolathe/gun/doublebarrel, // "double-barreled shotgun"
		/datum/design/autolathe/ammo/shotgun_beanbag,
		/datum/design/autolathe/ammo/shotgun_flash,
		/datum/design/autolathe/ammo/shotgun,
		/datum/design/autolathe/ammo/shotgun_pellet,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_kammerer
	disk_name = "Frozen Star .50 Kammerer Shotgun Pack"
	icon_state = "frozenstar"

	license = 5
	designs = list(
		/datum/design/autolathe/gun/pump_shotgun, // "FS SG \"Kammerer\""
		/datum/design/autolathe/ammo/shotgun_beanbag,
		/datum/design/autolathe/ammo/shotgun_flash,
		/datum/design/autolathe/ammo/shotgun,
		/datum/design/autolathe/ammo/shotgun_pellet,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_regulator
	disk_name = "NeoTheology Armory .50 Regulator Shotgun Pack"
	icon_state = "neotheology"

	license = 5
	designs = list(
		/datum/design/autolathe/gun/combat_shotgun, // "NT SG \"Regulator 1000\""
		/datum/design/autolathe/ammo/shotgun_beanbag,
		/datum/design/autolathe/ammo/shotgun_flash,
		/datum/design/autolathe/ammo/shotgun,
		/datum/design/autolathe/ammo/shotgun_pellet,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_gladstone
	disk_name = "Frozen Star .50 Gladstone Shotgun Pack"
	icon_state = "frozenstar"

	license = 5
	designs = list(
		/datum/design/autolathe/gun/gladstone, // "FS SG \"Gladstone\""
		/datum/design/autolathe/ammo/shotgun_beanbag,
		/datum/design/autolathe/ammo/shotgun_flash,
		/datum/design/autolathe/ammo/shotgun,
		/datum/design/autolathe/ammo/shotgun_pellet,
		)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_pug
	disk_name = "Serbian Arms .50 Pug Auto Shotgun Pack"
	icon_state = "serbian"

	license = 4
	designs = list(
		/datum/design/autolathe/gun/pug, // "SA SG \"Bojevic\""
		/datum/design/autolathe/ammo/m12beanbag, // Never add tazershells, for love of god
		/datum/design/autolathe/ammo/m12pellet,
		/datum/design/autolathe/ammo/m12slug,
		)

// .35 SMGs

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_paco
	disk_name = "Frozen Star .35 Paco SMG Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/IH_sidearm, // "FS HG .35 \"Paco\""
		/datum/design/autolathe/ammo/smg_rubber,
		/datum/design/autolathe/ammo/smg_brute,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_straylight
	disk_name = "Frozen Star .35 Straylight SMG Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/IH_smg, // "FS SMG .35 \"Straylight\""
		/datum/design/autolathe/ammo/smg_rubber,
		/datum/design/autolathe/ammo/smg_brute,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_molly
	disk_name = "Frozen Star .35 Molly SMG Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/IH_machinepistol, // "FS MP .35 \"Molly\""
		/datum/design/autolathe/ammo/smg_rubber,
		/datum/design/autolathe/ammo/smg_brute,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_idaho
	disk_name = "Frozen Star .35 Idaho SMG Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/idaho, // "FS SMG .35 \"Idaho\""
		/datum/design/autolathe/ammo/smg_rubber,
		/datum/design/autolathe/ammo/smg_brute,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_atreides
	disk_name = "Frozen Star .35 Atreides SMG Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/atreides, // "FS SMG .35 \"Atreides\""
		/datum/design/autolathe/ammo/smg_rubber,
		/datum/design/autolathe/ammo/smg_brute,
	)

// .20 Rifles (AP)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_bulldog
	disk_name = "Frozen Star .20 Bulldog Carabine Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/z8, // "FS CAR .20 \"Z8 Bulldog\""
		/datum/design/autolathe/ammo/srifle_practice,
		/datum/design/autolathe/ammo/srifle,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_wintermute
	disk_name = "Frozen Star .20 Wintermute Battle Rifle Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/IH_heavyrifle, // "FS BR .20 \"Wintermute\""
		/datum/design/autolathe/ammo/ihsrifle,  // separate mag
	)

// .25 Caseless

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_sol
	disk_name = "Frozen Star .25 Sol Caseless SMG Pack"
	icon_state = "frozenstar"

	license = 4
	designs = list(
		/datum/design/autolathe/gun/smg_sol, // "FS CAR .25 caseless \"Sol\""
		/datum/design/autolathe/gun/smg_sol_rds, // "FS CAR .25 caseless \"Sol\"" - reddot sight
		/datum/design/autolathe/ammo/SMG_sol_rubber,
		/datum/design/autolathe/ammo/SMG_sol_brute,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/dallas
	disk_name = "PAR .25 Dallas Pack"
	icon_state = "black"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/dallas, // "PAR .25 CS \"Dallas\""
		/datum/design/autolathe/ammo/c10x24,
	)

// .30 Rifles

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_boltgun
	disk_name = "Serbian Arms .30  Novakovic Rifle Pack"
	icon_state = "serbian"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/boltgun_serbian, // "SA BR .30 \"Novakovic\""
		/datum/design/autolathe/ammo/sl_lrifle,
		/datum/design/autolathe/ammo/box_lrifle,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_kalashnikov
	disk_name = "Frozen Star .30 Kalashnikov Rifle Pack"
	icon_state = "frozenstar"

	license = 4
	designs = list(
		/datum/design/autolathe/gun/ak47_fs, // "FS AR .30 \"Kalashnikov\""
		/datum/design/autolathe/ammo/lrifle_long,
		/datum/design/autolathe/ammo/lrifle_short,
		/datum/design/autolathe/ammo/box_lrifle,
	)

// Heavy 

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_heavysniper
	disk_name = "NeoTheology Armory .60 Penetrator AMR Pack"
	icon_state = "neotheology"

	license = 2
	designs = list(
		/datum/design/autolathe/gun/heavysniper, // "NT AMR .60 \"Penetrator\""
		/datum/design/autolathe/ammo/antim,
	)


/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/sa_pk
	disk_name = "Serbian Arms .30 Pulemyot Kalashnikova MG Pack"
	icon_state = "serbian"

	license = 2
	designs = list(
		/datum/design/autolathe/gun/mg_pk, // "SA MG .30 \"Pulemyot Kalashnikova\""
		/datum/design/autolathe/ammo/lrifle_pk,
	)

// Grenade Launchers

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_protector
	disk_name = "NeoTheology Armory Protector Grenade Launcher"
	icon_state = "neotheology"

	license = 2
	designs = list(
		/datum/design/autolathe/gun/grenade_launcher, // "NT GL \"Protector\""
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_lenar
	disk_name = "Frozen Star Lenar Grenade Launcher"
	icon_state = "frozenstar"

	license = 2
	designs = list(
		/datum/design/autolathe/gun/grenade_launcher_lenar, // "FS GL \"Lenar\""
	)

// ENERGY SMALL ARMS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_counselor
	disk_name = "NeoTheology Armory S-Cell Councelor Energy Pistol Pack"
	icon_state = "neotheology"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/taser, // "NT SP \"Counselor\""
		/datum/design/autolathe/cell/small/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_spiderrose
	disk_name = "Frozen Star S-Cell Spider Rose Energy Pistol Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/energygun, // "FS PDW E \"Spider Rose\""
		/datum/design/autolathe/cell/small/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/fs_martin
	disk_name = "Frozen Star S-Cell Martin Energy Pistol Pack"
	icon_state = "frozenstar"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/energygun_martin, // "FS PDW E \"Martin\""
		/datum/design/autolathe/cell/small/high,
	)

// ENERGY ARMS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_nemesis
	disk_name = "NeoTheology Armory M-Cell Nemesis Energy Crossbow Pack"
	icon_state = "neotheology"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/energy_crossbow, // "NT EC \"Nemesis\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_themis
	disk_name = "NeoTheology Armory M-Cell Themis Energy Crossbow Pack"
	icon_state = "neotheology"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/large_energy_crossbow, // "NT EC \"Themis\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_lightfall
	disk_name = "NeoTheology Armory M-Cell Lightfall Laser Gun Pack"
	icon_state = "neotheology"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/laser, // "NT LG \"Lightfall\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_valkirye
	disk_name = "NeoTheology Armory M-Cell Valkyrie Energy Rifle Pack"
	icon_state = "neotheology"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/sniperrifle, //"NT MER \"Valkyrie\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_halicon
	disk_name = "NeoTheology Armory M-Cell Halicon Ion Rifle Pack"
	icon_state = "neotheology"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/ionrifle, // "NT IR \"Halicon\""
		/datum/design/autolathe/cell/medium/high,
	)

// PLASMA ARMS

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_dominion
	disk_name = "NeoTheology Armory M-Cell Dominion Plasma Rifle Pack"
	icon_state = "neotheology"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/plasma/dominion, //"NT PR \"Dominion\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_purger
	disk_name = "NeoTheology Armory M-Cell Purger Plasma Rifle Pack"
	icon_state = "neotheology"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/plasma/destroyer, // "NT PR \"Purger\""
		/datum/design/autolathe/cell/medium/high,
	)

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/nt_cassad
	disk_name = "NeoTheology Armory M-Cell Cassad Plasma Rifle Pack"
	icon_state = "neotheology"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/plasma/cassad, // "FS PR \"Cassad\""
		/datum/design/autolathe/cell/medium/high,
	)

// SPECIAL

/obj/item/weapon/computer_hardware/hard_drive/portable/design/guns/ms_syringegun
	disk_name = "Moebious Scientifica Syring Gun Pack"
	icon_state = "moebious"

	license = 3
	designs = list(
		/datum/design/autolathe/gun/syringe_gun, // "syringe gun"
		/datum/design/autolathe/container/syringegun_ammo,
	)

