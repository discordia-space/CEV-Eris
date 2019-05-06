/obj/item/weapon/disk/autolathe_disk
	name = "design disk"
	desc = "Autolathe-compatible design disk."
	icon_state = "yellow"
	origin_tech = list(TECH_DATA = 2)

	var/list/recipes = list()

	var/category = "Disk"
	var/license = 10

/obj/item/weapon/disk/autolathe_disk/proc/use_license(num = 1)
	if (license == -1)
		return TRUE

	if (license >= num)
		license -= num
		return TRUE

	return FALSE

/obj/item/weapon/disk/autolathe_disk/blank
	category = "Blank"
	license = -1

/obj/item/weapon/disk/autolathe_disk/basic
	name = "Asters Miscellaneous Pack"
	category = "Basic"
	icon_state = "guild"
	recipes = list(
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
	license = -1


/obj/item/weapon/disk/autolathe_disk/devices
	name = "Asters Devices and Instruments"
	category = "Basic"
	icon_state = "guild"
	recipes = list(
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
		/datum/design/autolathe/misc/tube,
		/datum/design/autolathe/misc/bulb,

	)
	license = 10

/obj/item/weapon/disk/autolathe_disk/toolpack
	name = "Asters Basic Tool Pack"
	category = "Engineering"
	icon_state = "guild"
	recipes = list(
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
		/datum/design/autolathe/device/flamethrower,
	)
	license = -1

/obj/item/weapon/disk/autolathe_disk/robustcells
	name = "Asters Robustcells"
	category = "Engineering"
	icon_state = "guild"
	recipes = list(
		/datum/design/autolathe/cell/large,
		/datum/design/autolathe/cell/large/high,
		/datum/design/autolathe/cell/medium,
		/datum/design/autolathe/cell/medium/high,
		/datum/design/autolathe/cell/small,
		/datum/design/autolathe/cell/small/high,
	)
	license = 8

/obj/item/weapon/disk/autolathe_disk/component
	name = "Technomancers ARK-034 Components"
	category = "Devices and Components"
	icon_state = "technomancers"
	recipes = list(
		/datum/design/autolathe/part/consolescreen,
		/datum/design/research/item/stock_part/smes_coil,
		/datum/design/research/item/stock_part/basic_capacitor,
		/datum/design/research/item/stock_part/basic_sensor,
		/datum/design/research/item/stock_part/micro_mani,
		/datum/design/research/item/stock_part/basic_micro_laser,
		/datum/design/research/item/stock_part/basic_matter_bin,
		/datum/design/autolathe/part/igniter,
		/datum/design/autolathe/part/signaler,
		/datum/design/autolathe/part/sensor_infra,
		/datum/design/autolathe/part/timer,
		/datum/design/autolathe/part/sensor_prox,
		/datum/design/autolathe/part/camera_assembly,
		/datum/design/autolathe/part/laserguide,
	)
	license = 20

/obj/item/weapon/disk/autolathe_disk/advtoolpack
	name = "Technomancers IJIRO-451 Advanced Tools"
	category = "Engineering"
	icon_state = "technomancers"
	recipes = list(
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
	license = 10

/obj/item/weapon/disk/autolathe_disk/circuitpack
	name = "Technomancers ESPO-830 Circuits"
	category = "Engineering"
	icon_state = "technomancers"
	recipes = list(
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
	)
	license = 10

/obj/item/weapon/disk/autolathe_disk/medical
	name = "Moebius Medical Designs"
	category = "Medical"
	icon_state = "moebius"
	recipes = list(
		/datum/design/autolathe/gun/syringe_gun,
		/datum/design/autolathe/misc/penflashlight,
		/datum/design/autolathe/tool/scalpel,
		/datum/design/autolathe/tool/circularsaw,
		/datum/design/autolathe/tool/surgicaldrill,
		/datum/design/autolathe/tool/retractor,
		/datum/design/autolathe/tool/cautery,
		/datum/design/autolathe/tool/hemostat,
		/datum/design/autolathe/container/syringe,
		/datum/design/autolathe/container/vial,
		/datum/design/autolathe/container/beaker,
		/datum/design/autolathe/container/beaker_large,
		/datum/design/autolathe/container/pill_bottle,
		/datum/design/autolathe/container/spray,
		/datum/design/autolathe/device/implanter,
		/datum/design/autolathe/container/syringegun_ammo,
	)
	license = 20

/obj/item/weapon/disk/autolathe_disk/computer
	name = "Moebius Computer Parts"
	category = "Electronics"
	icon_state = "moebius"
	recipes = list(
		/datum/design/autolathe/computer_part/frame_pda,
		/datum/design/autolathe/computer_part/frame_tablet,
		/datum/design/autolathe/computer_part/frame_laptop,
		/datum/design/research/item/modularcomponent/disk/micro,
		/datum/design/research/item/modularcomponent/disk/small,
		/datum/design/research/item/modularcomponent/disk/normal,
		/datum/design/research/item/modularcomponent/disk/advanced,
		/datum/design/research/item/modularcomponent/cpu/small,
		/datum/design/research/item/modularcomponent/cpu,
		/datum/design/research/item/modularcomponent/netcard/basic,
		/datum/design/research/item/modularcomponent/netcard/advanced,
		/datum/design/research/item/modularcomponent/netcard/wired,
		/datum/design/research/item/modularcomponent/cardslot,
		/datum/design/research/item/modularcomponent/teslalink,
		/datum/design/research/item/modularcomponent/portabledrive/basic,
		/datum/design/research/item/modularcomponent/nanoprinter,
		/datum/design/autolathe/computer_part/gps,
		/datum/design/autolathe/computer_part/led,
		/datum/design/autolathe/computer_part/scanner_paper,
		/datum/design/autolathe/computer_part/scanner_atmos,
	)
	license = 20

/obj/item/weapon/disk/autolathe_disk/security
	name = "Ironhammer Miscellaneous Pack"
	category = "Security"
	icon_state = "ironhammer"
	recipes = list(
		/datum/design/autolathe/sec/secflashlight,
		/datum/design/research/item/flash,
		/datum/design/autolathe/sec/handcuffs,
		/datum/design/autolathe/misc/taperecorder,
		/datum/design/autolathe/tool/tacknife,
		/datum/design/autolathe/sec/beartrap,
		/datum/design/autolathe/sec/silencer,
	)
	license = 20

/obj/item/weapon/disk/autolathe_disk/fs_cheap_guns
	name = "Frozen Star Basic Civilian Pack"
	category = "Security"
	icon_state = "frozenstar"
	recipes = list(
		/datum/design/autolathe/gun/giskard,
		/datum/design/autolathe/gun/olivaw,
		/datum/design/autolathe/gun/clarissa,
		/datum/design/autolathe/gun/revolver_detective,
		/datum/design/autolathe/gun/doublebarrel,
		/datum/design/autolathe/gun/pump_shotgun,
	)
	license = 7

/obj/item/weapon/disk/autolathe_disk/fs_kinetic_guns //please, maintain general order (pistol>revolver>SMG>Other>Shotgun>GLs)+(smaller/less damaging caliber>bigger/more damaging caliber)
	name = "Frozen Star Ultimate Protection Pack"
	category = "Security"
	icon_state = "frozenstar"
	recipes = list(
		/datum/design/autolathe/gun/IH_sidearm, //pistols
		/datum/design/autolathe/gun/IH_machinepistol,
		/datum/design/autolathe/gun/lamia,
		/datum/design/autolathe/gun/deagle,
		/datum/design/autolathe/gun/revolver_consul, //revolvers
		/datum/design/autolathe/gun/revolver_deckard,
		/datum/design/autolathe/gun/revolver,
		/datum/design/autolathe/gun/idaho, //smgs
		/datum/design/autolathe/gun/wt550,
		/datum/design/autolathe/gun/IH_smg,
		/datum/design/autolathe/gun/atreides,
		/datum/design/autolathe/gun/smg_sol, //other
		/datum/design/autolathe/gun/smg_sol_rds,
		/datum/design/autolathe/gun/z8,
		/datum/design/autolathe/gun/IH_heavyrifle,
		/datum/design/autolathe/gun/ak47_fs,
		/datum/design/autolathe/gun/grenade_launcher_lenar, //GLs
	)
	license = 5

/obj/item/weapon/disk/autolathe_disk/fs_energy_guns
	name = "Frozen Star Void Warrior Pack"
	category = "Security"
	icon_state = "frozenstar"
	recipes = list(
		/datum/design/autolathe/gun/energygun_martin,
		/datum/design/autolathe/gun/energygun,
		/datum/design/autolathe/gun/pulse_rifle_cassad,
	)
	license = 3

/obj/item/weapon/disk/autolathe_disk/nt_old_guns
	name = "NeoTheology Armory of the Old Testament"
	category = "Security"
	icon_state = "neotheology"
	recipes = list(
		/datum/design/autolathe/gun/mk58,
		/datum/design/autolathe/gun/mk58_wood,
		/datum/design/autolathe/gun/combat_shotgun,
		/datum/design/autolathe/gun/heavysniper,
		/datum/design/autolathe/gun/grenade_launcher,
		/datum/design/research/item/weapon/stunrevolver,
		/datum/design/autolathe/gun/taser,
		/datum/design/autolathe/gun/sniperrifle
	)
	license = 3

/obj/item/weapon/disk/autolathe_disk/nt_new_guns
	name = "NeoTheology Armory of the New Testament"
	category = "Security"
	icon_state = "neotheology"
	recipes = list(
		/datum/design/autolathe/gun/energy_crossbow,
		/datum/design/autolathe/gun/large_energy_crossbow,
		/datum/design/autolathe/gun/laser,
		/datum/design/autolathe/gun/pulse_rifle,
		/datum/design/autolathe/gun/pulse_rifle_destroyer,
		/datum/design/autolathe/gun/ionrifle,
	)
	license = 3

/obj/item/weapon/disk/autolathe_disk/nonlethal_ammo //please, maintain general order (pistol>speedloaders>smg>other>shells)+(smaller/less damaging caliber>bigger/more damaging caliber)
	name = "Frozen Star Nonlethal Ammo Pack"
	category = "Ammo"
	icon_state = "frozenstar"
	recipes = list(
		/datum/design/autolathe/ammo/mg_cl32_rubber, //pistol mags
		/datum/design/autolathe/ammo/magazine_mc9mm_rubber,
		/datum/design/autolathe/ammo/magazine_c45m_rubber,
		/datum/design/autolathe/ammo/magazine_a10mm_rubber,
		/datum/design/autolathe/ammo/mg_cl44_rubber,
		/datum/design/autolathe/ammo/mg_a50_rubber,
		/datum/design/autolathe/ammo/sl_c138_rubber, //speed loaders
		/datum/design/autolathe/ammo/sl_cl44_rubber,
		/datum/design/autolathe/ammo/smg9mm_rubber, //smg mags
		/datum/design/autolathe/ammo/magazine_mc9mmt_rubber,
		/datum/design/autolathe/ammo/c45smg_rubber,
		/datum/design/autolathe/ammo/SMG_sol_rubber, //other mags
		/datum/design/autolathe/ammo/a556_practice,
		/datum/design/autolathe/ammo/shotgun_blanks, //shells
		/datum/design/autolathe/ammo/shotgun_flash,
		/datum/design/autolathe/ammo/stunshell,
		/datum/design/autolathe/ammo/shotgun_beanbag
	)
	license = 20


/obj/item/weapon/disk/autolathe_disk/lethal_ammo //please, maintain general order (pistol>speedloaders>smg>other>shells)+(smaller/less damaging caliber>bigger/more damaging caliber)
	name = "Frozen Star Lethal Ammo Pack"
	category = "Ammo"
	icon_state = "frozenstar"
	recipes = list(
		/datum/design/autolathe/ammo/mg_cl32_brute, //pistol mags
		/datum/design/autolathe/ammo/magazine_mc9mm,
		/datum/design/autolathe/ammo/magazine_c45m,
		/datum/design/autolathe/ammo/magazine_a10mm,
		/datum/design/autolathe/ammo/mg_cl44_brute,
		/datum/design/autolathe/ammo/mg_a50,
		/datum/design/autolathe/ammo/sl_c138_brute, //speed loaders
		/datum/design/autolathe/ammo/sl_cl44_brute,
		/datum/design/autolathe/ammo/magazine_sl357,
		/datum/design/autolathe/ammo/smg9mm_brute, //smg mags
		/datum/design/autolathe/ammo/magazine_mc9mmt,
		/datum/design/autolathe/ammo/c45smg_brute,
		/datum/design/autolathe/ammo/magazine_smg10mm,
		/datum/design/autolathe/ammo/SMG_sol_brute, //other mags
		/datum/design/autolathe/ammo/a556,
		/datum/design/autolathe/ammo/ih556,
		/datum/design/autolathe/ammo/c762_short,
		/datum/design/autolathe/ammo/c762_long,
		/datum/design/autolathe/ammo/shotgun_pellet, //shells
		/datum/design/autolathe/ammo/shotgun
	)
	license = 20


/obj/item/weapon/disk/autolathe_disk/excelsior
	name = "Excelsior Means of Production"
	category = "Excelsior"
	desc = "Seize it."
	icon_state = "excelsior"
	recipes = list(
		/datum/design/autolathe/circuit/autolathe_excelsior,
		/datum/design/autolathe/circuit/shieldgen_excelsior,
		/datum/design/autolathe/circuit/reconstructor_excelsior,
		/datum/design/autolathe/circuit/diesel_excelsior,
		/datum/design/autolathe/circuit/turret_excelsior,
		/datum/design/autolathe/circuit/autolathe_disk_cloner,
		/datum/design/autolathe/device/implanter,
		/datum/design/autolathe/gun/makarov,
		/datum/design/autolathe/sec/silencer,
		/datum/design/autolathe/ammo/magazine_mc9mm,
		/datum/design/autolathe/gun/ak47,
		/datum/design/autolathe/ammo/c762_long,
		/datum/design/autolathe/ammo/box_a762,
		/datum/design/autolathe/device/excelsiormine,
		/datum/design/autolathe/sec/beartrap,
		/datum/design/autolathe/clothing/excelsior_armor,
		/datum/design/autolathe/clothing/excelsior_helmet,
		/datum/design/autolathe/cell/large/excelsior,
		/datum/design/autolathe/cell/medium/excelsior,
		/datum/design/autolathe/cell/small/excelsior,
		/datum/design/research/item/stock_part/micro_mani,
		/datum/design/research/item/stock_part/subspace_amplifier,
		/datum/design/research/item/stock_part/subspace_crystal,
		/datum/design/research/item/stock_part/subspace_transmitter,
		/datum/design/autolathe/part/igniter,
		/datum/design/autolathe/part/signaler,
		/datum/design/autolathe/part/sensor_prox,
		/datum/design/research/item/stock_part/basic_capacitor,
		/datum/design/autolathe/part/camera_assembly
	)
	license = -1

/obj/item/weapon/disk/autolathe_disk/excelsior_weapons
	name = "Excelsior Means of Revolution"
	category = "Excelsior"
	desc = "The back has a machine etching: \"We stand for organized terror - this should be frankly admitted. Terror is an absolute necessity during times of revolution.\""
	icon_state = "excelsior"
	recipes = list(
		/datum/design/autolathe/gun/makarov,
		/datum/design/autolathe/sec/silencer,
		/datum/design/autolathe/ammo/magazine_mc9mm,
		/datum/design/autolathe/gun/ak47,
		/datum/design/autolathe/ammo/c762_long,
		/datum/design/autolathe/ammo/box_a762,
		/datum/design/autolathe/device/excelsiormine,
		/datum/design/autolathe/sec/beartrap,
		/datum/design/autolathe/clothing/excelsior_armor,
		/datum/design/autolathe/clothing/excelsior_helmet
	)
	license = -1

/obj/item/weapon/disk/autolathe_disk/onestar
	name = "One Star Tool Pack"
	category = "Engineering"
	icon_state = "onestar"
	recipes = list(
		/datum/design/autolathe/tool/crowbar_onestar,
		/datum/design/autolathe/tool/combi_driver_onestar,
		/datum/design/autolathe/tool/jackhammer_onestar,
		/datum/design/autolathe/tool/drill_onestar,
		/datum/design/autolathe/tool/weldertool_onestar
	)
	license = 2
