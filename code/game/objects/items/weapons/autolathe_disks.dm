/obj/item/weapon/disk/autolathe_disk
	name = "Design disk"
	desc = "disk for autolathe designs."
	icon = 'icons/obj/discs.dmi'
	icon_state = "yellow"
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_DATA = 2)
	flags = CONDUCT
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_WEAK
	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)

	var/list/recipes = list()

	var/category = "Disk"
	var/license = 10


/obj/item/weapon/disk/autolathe_disk/blank
	name = "Blank disk"
	category = "Blank"
	license = -1

/obj/item/weapon/disk/autolathe_disk/basic
	name = "Asters Miscellaneous Pack"
	category = "Basic"
	icon_state = "guild"
	license = -1

/obj/item/weapon/disk/autolathe_disk/basic/New()
	recipes = list(
		/datum/autolathe/recipe/misc/flashlight,
		/datum/autolathe/recipe/misc/extinguisher,
		/datum/autolathe/recipe/misc/radio_headset,
		/datum/autolathe/recipe/misc/radio_bounced,
		/datum/autolathe/recipe/misc/ashtray_glass,
		/datum/autolathe/recipe/container/bucket,
		/datum/autolathe/recipe/container/jar,
		/datum/autolathe/recipe/container/vial,
		/datum/autolathe/recipe/container/syringe,
		/datum/autolathe/recipe/container/beaker,
		/datum/autolathe/recipe/container/beaker_large,
		/datum/autolathe/recipe/misc/cane,
		/datum/autolathe/recipe/misc/floor_light,
		/datum/autolathe/recipe/misc/tube,
		/datum/autolathe/recipe/misc/bulb,
	)
	..()


/obj/item/weapon/disk/autolathe_disk/devices
	name = "Asters Devices and Instruments"
	category = "Basic"
	icon_state = "guild"
	license = 10

/obj/item/weapon/disk/autolathe_disk/devices/New()
	recipes = list(
		/datum/autolathe/recipe/misc/flashlight,
		/datum/autolathe/recipe/device/analyzer,
		/datum/autolathe/recipe/device/plant_analyzer,
		/datum/autolathe/recipe/device/healthanalyzer,
		/datum/autolathe/recipe/device/mass_spectrometer,
		/datum/autolathe/recipe/device/reagent_scanner,
		/datum/autolathe/recipe/device/robotanalyzer,
		/datum/autolathe/recipe/device/slime_scanner,
		/datum/autolathe/recipe/device/antibody_scanner,
		/datum/autolathe/recipe/device/megaphone,
		/datum/autolathe/recipe/device/t_scanner,
		/datum/autolathe/recipe/device/gps,
		/datum/autolathe/recipe/device/destTagger,
		/datum/autolathe/recipe/device/export_scanner,
		/datum/autolathe/recipe/device/implanter,
		/datum/autolathe/recipe/device/hand_labeler,
		/datum/autolathe/recipe/device/lightreplacer,
		/datum/autolathe/recipe/misc/tube,
		/datum/autolathe/recipe/misc/bulb,
	)
	..()

/obj/item/weapon/disk/autolathe_disk/toolpack
	name = "Asters Basic Tool Pack"
	category = "Engineering"
	icon_state = "guild"
	license = -1

/obj/item/weapon/disk/autolathe_disk/toolpack/New()
	recipes = list(
		/datum/autolathe/recipe/tool/hatchet,
		/datum/autolathe/recipe/tool/minihoe,
		/datum/autolathe/recipe/tool/knife,
		/datum/autolathe/recipe/misc/heavyflashlight,
		/datum/autolathe/recipe/tool/crowbar,
		/datum/autolathe/recipe/tool/screwdriver,
		/datum/autolathe/recipe/tool/wirecutters,
		/datum/autolathe/recipe/tool/wrench,
		/datum/autolathe/recipe/tool/saw,
		/datum/autolathe/recipe/tool/multitool,
		/datum/autolathe/recipe/tool/pickaxe,
		/datum/autolathe/recipe/tool/shovel,
		/datum/autolathe/recipe/tool/spade,
		/datum/autolathe/recipe/device/t_scanner,
		/datum/autolathe/recipe/tool/weldertool,
		/datum/autolathe/recipe/tool/weldinggoggles,
		/datum/autolathe/recipe/tool/weldermask,
	)
	..()


/obj/item/weapon/disk/autolathe_disk/component
	name = "Technomacers ARK-034 Components"
	category = "Devices and Components"
	icon_state = "technomancers"
	license = 20

/obj/item/weapon/disk/autolathe_disk/component/New()
	recipes = list(
		/datum/autolathe/recipe/part/consolescreen,
		/datum/autolathe/recipe/part/smes_coil,
		/datum/autolathe/recipe/part/capacitor,
		/datum/autolathe/recipe/part/scanning_module,
		/datum/autolathe/recipe/part/manipulator,
		/datum/autolathe/recipe/part/micro_laser,
		/datum/autolathe/recipe/part/matter_bin,
		/datum/autolathe/recipe/part/igniter,
		/datum/autolathe/recipe/part/signaler,
		/datum/autolathe/recipe/part/sensor_infra,
		/datum/autolathe/recipe/part/timer,
		/datum/autolathe/recipe/part/sensor_prox,
		/datum/autolathe/recipe/part/camera_assembly,
	)
	..()

/obj/item/weapon/disk/autolathe_disk/advtoolpack
	name = "Technomacers IJIRO-451 Advanced Tools"
	category = "Engineering"
	icon_state = "technomancers"
	license = 10

/obj/item/weapon/disk/autolathe_disk/advtoolpack/New()
	recipes = list(
		/datum/autolathe/recipe/tool/big_wrench,
		/datum/autolathe/recipe/tool/jackhammer,
		/datum/autolathe/recipe/tool/mining_drill,
		/datum/autolathe/recipe/tool/diamonddrill,
		/datum/autolathe/recipe/tool/pickaxe_excavation,
		/datum/autolathe/recipe/tool/circularsaw,
		/datum/autolathe/recipe/tool/chainsaw,
		/datum/autolathe/recipe/tool/electric_screwdriver,
		/datum/autolathe/recipe/tool/combi_driver,
		/datum/autolathe/recipe/tool/armature_cutter,
	)
	..()

/obj/item/weapon/disk/autolathe_disk/circuitpack
	name = "Technomacers ESPO-830 Curcuits"
	category = "Engineering"
	icon_state = "technomancers"
	license = 10

/obj/item/weapon/disk/autolathe_disk/circuitpack/New()
	recipes = list(
		/datum/autolathe/recipe/circuit/airlockmodule,
		/datum/autolathe/recipe/circuit/airalarm,
		/datum/autolathe/recipe/circuit/firealarm,
		/datum/autolathe/recipe/circuit/powermodule,
		/datum/autolathe/recipe/circuit/autolathe,
		/datum/autolathe/recipe/circuit/autolathe_disk_cloner,
		/datum/autolathe/recipe/circuit/arcade_battle,
		/datum/autolathe/recipe/circuit/arcade_orion_trail,
		/datum/autolathe/recipe/circuit/communications,
		/datum/autolathe/recipe/circuit/med_data,
		/datum/autolathe/recipe/circuit/secure_data,
		/datum/autolathe/recipe/circuit/teleporter,
		/datum/autolathe/recipe/circuit/crew,
		/datum/autolathe/recipe/circuit/operating,
		/datum/autolathe/recipe/circuit/helm,
		/datum/autolathe/recipe/circuit/nav,
	)
	..()

/obj/item/weapon/disk/autolathe_disk/medical
	name = "Moebius Medical Designs"
	category = "Medical"
	icon_state = "moebius"
	license = 20

/obj/item/weapon/disk/autolathe_disk/medical/New()
	recipes = list(
		/datum/autolathe/recipe/gun/syringe_gun,
		/datum/autolathe/recipe/misc/penflashlight,
		/datum/autolathe/recipe/tool/scalpel,
		/datum/autolathe/recipe/tool/circularsaw,
		/datum/autolathe/recipe/tool/surgicaldrill,
		/datum/autolathe/recipe/tool/retractor,
		/datum/autolathe/recipe/tool/cautery,
		/datum/autolathe/recipe/tool/hemostat,
		/datum/autolathe/recipe/container/beaker,
		/datum/autolathe/recipe/container/beaker_large,
		/datum/autolathe/recipe/container/syringe,
		/datum/autolathe/recipe/container/vial,
		/datum/autolathe/recipe/device/implanter,
		/datum/autolathe/recipe/container/syringegun_ammo,
	)
	..()

/obj/item/weapon/disk/autolathe_disk/security
	name = "Ironhammer Miscellaneous Pack"
	category = "Security"
	icon_state = "ironhammer"
	license = 20

/obj/item/weapon/disk/autolathe_disk/security/New()
	recipes = list(
		/datum/autolathe/recipe/sec/secflashlight,
		/datum/autolathe/recipe/sec/flash,
		/datum/autolathe/recipe/sec/handcuffs,
		/datum/autolathe/recipe/misc/taperecorder,
		/datum/autolathe/recipe/tool/tacknife,
		/datum/autolathe/recipe/sec/beartrap,
	)
	..()

/obj/item/weapon/disk/autolathe_disk/fs_cheap_guns
	name = "Frozen Star Basic Civilian Pack"
	category = "Security"
	icon_state = "frozenstar"
	license = 7

/obj/item/weapon/disk/autolathe_disk/fs_cheap_guns/New()
	recipes = list(
		/datum/autolathe/recipe/gun/olivaw,
		/datum/autolathe/recipe/gun/giskard,
		/datum/autolathe/recipe/gun/clarissa,
		/datum/autolathe/recipe/gun/revolver_detective,
		/datum/autolathe/recipe/gun/doublebarrel,
		/datum/autolathe/recipe/gun/pump_shotgun,
	)

/obj/item/weapon/disk/autolathe_disk/fs_kinetic_guns
	name = "Frozen Star Ultimate Protection Pack"
	category = "Security"
	icon_state = "frozenstar"
	license = 5

/obj/item/weapon/disk/autolathe_disk/fs_kinetic_guns/New()
	recipes = list(
		/datum/autolathe/recipe/gun/revolver,
		/datum/autolathe/recipe/gun/revolver_consul,
		/datum/autolathe/recipe/gun/revolver_deckard,
		/datum/autolathe/recipe/gun/lamia,
		/datum/autolathe/recipe/gun/deagle,
		/datum/autolathe/recipe/gun/smg_sol,
		/datum/autolathe/recipe/gun/smg_sol_rds,
		/datum/autolathe/recipe/gun/ak47_fs,
		/datum/autolathe/recipe/gun/grenade_launcher_lenar,
	)
	..()

/obj/item/weapon/disk/autolathe_disk/fs_energy_guns
	name = "Frozen Star Void Warrior Pack"
	category = "Security"
	icon_state = "frozenstar"
	license = 3

/obj/item/weapon/disk/autolathe_disk/fs_energy_guns/New()
	recipes = list(
		/datum/autolathe/recipe/gun/energygun,
		/datum/autolathe/recipe/gun/energygun_martin,
		/datum/autolathe/recipe/gun/pulse_rifle_cassad,
	)
	..()

/obj/item/weapon/disk/autolathe_disk/nt_old_guns
	name = "NeoTheology Armory of Old Testament"
	category = "Security"
	icon_state = "neotheology"
	license = 3

/obj/item/weapon/disk/autolathe_disk/nt_old_guns/New()
	recipes = list(
		/datum/autolathe/recipe/gun/mk58,
		/datum/autolathe/recipe/gun/mk58_wood,
		/datum/autolathe/recipe/gun/combat_shotgun,
		/datum/autolathe/recipe/gun/heavysniper,
		/datum/autolathe/recipe/gun/sniperrifle,
		/datum/autolathe/recipe/gun/taser,
		/datum/autolathe/recipe/gun/stunrevolver,
		/datum/autolathe/recipe/gun/grenade_launcher,
	)
	..()

/obj/item/weapon/disk/autolathe_disk/nt_new_guns
	name = "NeoTheology Armory of New Testament"
	category = "Security"
	icon_state = "neotheology"
	license = 3

/obj/item/weapon/disk/autolathe_disk/nt_new_guns/New()
	recipes = list(
		/datum/autolathe/recipe/gun/laser,
		/datum/autolathe/recipe/gun/ionrifle,
		/datum/autolathe/recipe/gun/energy_crossbow,
		/datum/autolathe/recipe/gun/large_energy_crossbow,
		/datum/autolathe/recipe/gun/pulse_rifle,
		/datum/autolathe/recipe/gun/pulse_rifle_destroyer,
	)
	..()

/obj/item/weapon/disk/autolathe_disk/nonlethal_ammo
	name = "Frozen Star Nonlethal Ammo Pack"
	category = "Ammo"
	icon_state = "frozenstar"
	license = 20

/obj/item/weapon/disk/autolathe_disk/nonlethal_ammo/New()
	recipes = list(
		/datum/autolathe/recipe/ammo/shotgun_blanks,
		/datum/autolathe/recipe/ammo/shotgun_beanbag,
		/datum/autolathe/recipe/ammo/shotgun_flash,
		/datum/autolathe/recipe/ammo/stunshell,
		/datum/autolathe/recipe/ammo/magazine_c45m_rubber,
		/datum/autolathe/recipe/ammo/magazine_mc9mmt_rubber,
		/datum/autolathe/recipe/ammo/magazine_c45m_flash,
		/datum/autolathe/recipe/ammo/magazine_mc9mm_flash,
		/datum/autolathe/recipe/ammo/mg_cl32_rubber,
		/datum/autolathe/recipe/ammo/mg_cl44_rubber,
		/datum/autolathe/recipe/ammo/sl_cl44_rubber,
		/datum/autolathe/recipe/ammo/mg_a50_rubber,
		/datum/autolathe/recipe/ammo/SMG_sol_rubber,
	)
	..()


/obj/item/weapon/disk/autolathe_disk/lethal_ammo
	name = "Frozen Star Lethal Ammo Pack"
	category = "Ammo"
	icon_state = "frozenstar"
	license = 20

/obj/item/weapon/disk/autolathe_disk/lethal_ammo/New()
	recipes = list(
		/datum/autolathe/recipe/ammo/magazine_sl357,
		/datum/autolathe/recipe/ammo/magazine_c45m,
		/datum/autolathe/recipe/ammo/magazine_mc9mm,
		/datum/autolathe/recipe/ammo/magazine_a10mm,
		/datum/autolathe/recipe/ammo/magazine_c762,
		/datum/autolathe/recipe/ammo/magazine_mc9mmt,
		/datum/autolathe/recipe/ammo/magazine_a556,
		/datum/autolathe/recipe/ammo/shotgun,
		/datum/autolathe/recipe/ammo/shotgun_pellet,
		/datum/autolathe/recipe/ammo/mg_cl44_brute,
		/datum/autolathe/recipe/ammo/sl_cl44_brute,
		/datum/autolathe/recipe/ammo/mg_a50,
		/datum/autolathe/recipe/ammo/SMG_sol_brute,
		/datum/autolathe/recipe/ammo/ak47
	)
	..()


/obj/item/weapon/disk/autolathe_disk/excelsior
	name = "Excelsior Means of Production"
	category = "Excelsior"
	desc = "Seize it."
	icon_state = "excelsior"
	license = -1

/obj/item/weapon/disk/autolathe_disk/excelsior/New()
	recipes = list(
		/datum/autolathe/recipe/circuit/autolathe,
		/datum/autolathe/recipe/gun/makarov,
		/datum/autolathe/recipe/sec/silencer,
		/datum/autolathe/recipe/ammo/magazine_mc9mm,
		/datum/autolathe/recipe/gun/ak47,
		/datum/autolathe/recipe/ammo/ak47,
		/datum/autolathe/recipe/device/excelsiormine,
		/datum/autolathe/recipe/part/igniter,
		/datum/autolathe/recipe/part/signaler,
		/datum/autolathe/recipe/part/sensor_prox
	)
	..()
