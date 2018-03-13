/obj/item/weapon/disk/autolathe_disk
	name = "Design disk"
	desc = "disk for autolathe designs."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_DATA = 2)
	flags = CONDUCT
	force = WEAPON_FORCE_WEAK
	throwforce = WEAPON_FORCE_WEAK
	matter = list(MATERIAL_STEEL = 30, MATERIAL_GLASS = 10)

	var/list/recipes = list()

	var/category = "Disk"
	var/license = 10


/obj/item/weapon/disk/autolathe_disk/freeware
	category = "Empty disk"
	license = -1

/obj/item/weapon/disk/autolathe_disk/freeware/basic
	name = "Basic designs disk"
	category = "Basic"

/obj/item/weapon/disk/autolathe_disk/freeware/basic/New()
	recipes = list(
		/datum/autolathe/recipe/flashlight,
		/datum/autolathe/recipe/extinguisher,
		/datum/autolathe/recipe/radio_headset,
		/datum/autolathe/recipe/radio_bounced,
		/datum/autolathe/recipe/hatchet,
		/datum/autolathe/recipe/minihoe,
		/datum/autolathe/recipe/bucket,
		/datum/autolathe/recipe/knife,
		/datum/autolathe/recipe/ashtray_glass,
		/datum/autolathe/recipe/beaker,
		/datum/autolathe/recipe/beaker_large,
	)
	..()


/obj/item/weapon/disk/autolathe_disk/engineering
	name = "Engineering designs disk"
	category = "Engineering"

/obj/item/weapon/disk/autolathe_disk/engineering/New()
	recipes = list(
		/datum/autolathe/recipe/heavyflashlight,
		/datum/autolathe/recipe/floor_light,
		/datum/autolathe/recipe/crowbar,
		/datum/autolathe/recipe/screwdriver,
		/datum/autolathe/recipe/wirecutters,
		/datum/autolathe/recipe/wrench,
		/datum/autolathe/recipe/multitool,
		/datum/autolathe/recipe/t_scanner,
		/datum/autolathe/recipe/weldertool,
		/datum/autolathe/recipe/weldinggoggles,
		/datum/autolathe/recipe/weldermask,
		/datum/autolathe/recipe/tube,
		/datum/autolathe/recipe/bulb,
		/datum/autolathe/recipe/camera_assembly,
		/datum/autolathe/recipe/airlockmodule,
		/datum/autolathe/recipe/airalarm,
		/datum/autolathe/recipe/firealarm,
		/datum/autolathe/recipe/powermodule,
	)
	..()


/obj/item/weapon/disk/autolathe_disk/component
	name = "Component design disk"
	category = "Devices and Components"

/obj/item/weapon/disk/autolathe_disk/component/New()
	recipes = list(
		/datum/autolathe/recipe/consolescreen,
		/datum/autolathe/recipe/igniter,
		/datum/autolathe/recipe/signaler,
		/datum/autolathe/recipe/sensor_infra,
		/datum/autolathe/recipe/timer,
		/datum/autolathe/recipe/sensor_prox,
	)
	..()


/obj/item/weapon/disk/autolathe_disk/security
	name = "Security designs disk"
	category = "Security"

/obj/item/weapon/disk/autolathe_disk/security/New()
	recipes = list(
		/datum/autolathe/recipe/secflashlight,
		/datum/autolathe/recipe/flash,
		/datum/autolathe/recipe/handcuffs,
		/datum/autolathe/recipe/oshoes,
		/datum/autolathe/recipe/taperecorder,
		/datum/autolathe/recipe/tacknife,
		/datum/autolathe/recipe/beartrap,
	)
	..()


/obj/item/weapon/disk/autolathe_disk/nonlethal_ammo
	name = "Nonlethal ammo designs disk"
	category = "Nonlethal ammo"

/obj/item/weapon/disk/autolathe_disk/nonlethal_ammo/New()
	recipes = list(
		/datum/autolathe/recipe/shotgun_blanks,
		/datum/autolathe/recipe/shotgun_beanbag,
		/datum/autolathe/recipe/shotgun_flash,
		/datum/autolathe/recipe/stunshell,
		/datum/autolathe/recipe/magazine_rubber,
		/datum/autolathe/recipe/magazine_smg_rubber,
		/datum/autolathe/recipe/magazine_flash,
		/datum/autolathe/recipe/magazine_stetchkin_flash,
		/datum/autolathe/recipe/mg_cl32_rubber,
		/datum/autolathe/recipe/mg_cl44_rubber,
		/datum/autolathe/recipe/sl_cl44_rubber,
		/datum/autolathe/recipe/mg_a50_rubber,
		/datum/autolathe/recipe/SMG_sol_rubber,
	)
	..()


/obj/item/weapon/disk/autolathe_disk/lethal_ammo
	name = "Lethal ammo designs disk"
	category = "Lethal ammo"

/obj/item/weapon/disk/autolathe_disk/lethal_ammo/New()
	recipes = list(
		/datum/autolathe/recipe/magazine_revolver_1,
		/datum/autolathe/recipe/magazine_revolver_2,
		/datum/autolathe/recipe/magazine_stetchkin,
		/datum/autolathe/recipe/magazine_c20r,
		/datum/autolathe/recipe/magazine_arifle,
		/datum/autolathe/recipe/magazine_smg,
		/datum/autolathe/recipe/magazine_carbine,
		/datum/autolathe/recipe/shotgun,
		/datum/autolathe/recipe/shotgun_pellet,
		/datum/autolathe/recipe/mg_cl44_brute,
		/datum/autolathe/recipe/sl_cl44_brute,
		/datum/autolathe/recipe/mg_a50,
		/datum/autolathe/recipe/SMG_sol_brute,
	)
	..()


/obj/item/weapon/disk/autolathe_disk/medical
	name = "Medical designs disk"
	category = "Medical"

/obj/item/weapon/disk/autolathe_disk/medical/New()
	recipes = list(
		/datum/autolathe/recipe/penflashlight,
		/datum/autolathe/recipe/syringe,
		/datum/autolathe/recipe/scalpel,
		/datum/autolathe/recipe/circularsaw,
		/datum/autolathe/recipe/surgicaldrill,
		/datum/autolathe/recipe/retractor,
		/datum/autolathe/recipe/cautery,
		/datum/autolathe/recipe/hemostat,
		/datum/autolathe/recipe/beaker,
		/datum/autolathe/recipe/beaker_large,
		/datum/autolathe/recipe/vial,
		/datum/autolathe/recipe/syringegun_ammo,
	)
	..()

