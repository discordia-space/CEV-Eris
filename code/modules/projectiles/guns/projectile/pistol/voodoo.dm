/obj/item/gun/projectile/voodoo
	name = "FS HG .40 Magnum \"Voodoo\""
	desc = "The \"Voodoo\" is a heavy pistol given to Ironhammer non-commissioned officers. \
			Renowed for its reliability and quick, two-round bursts. Uses .40 Magnum rounds."
	icon = 'icons/obj/guns/projectile/voodoo.dmi'
	icon_state = "voodoo"
	item_state = "voodoo"
	fire_sound = 'sound/weapons/guns/fire/hpistol_fire.ogg'
	ammo_mag = "mag_magnum"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4)
	can_dual = TRUE
	caliber = CAL_MAGNUM
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	magazine_type = /obj/item/ammo_magazine/magnum
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 8)
	price_tag = 2400
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	unload_sound = 'sound/weapons/guns/interact/hpistol_magout.ogg'
	reload_sound = 'sound/weapons/guns/interact/hpistol_magin.ogg'
	cocked_sound = 'sound/weapons/guns/interact/hpistol_cock.ogg'
	damage_multiplier = 1.2
	penetration_multiplier = 0.2
	init_recoil = HANDGUN_RECOIL(0.8)
	init_firemodes = list(
		list(mode_name="semiauto", mode_desc="Fire almost as fast as you can pull the trigger", burst=1, fire_delay=1.2, move_delay=null, 				icon="semi"),
		list(mode_name="2-round bursts", mode_desc="Not quite the Mozambique method", burst=2, fire_delay=0.9, move_delay=4,    	icon="burst")
		)

	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/voodoo = 1, /obj/item/part/gun/grip/rubber = 1, /obj/item/part/gun/mechanism/pistol = 1, /obj/item/part/gun/barrel/magnum = 1)
	serial_type = "FS"

/obj/item/gun/projectile/voodoo/update_icon()
	..()

	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "voodoo"
	else
		icon_state = "voodoo_empty"

/obj/item/part/gun/frame/voodoo
	name = "Voodoo frame"
	desc = "A Voodoo pistol frame. Just one promotion away from officer."
	icon_state = "frame_voodoo"
	resultvars = list(/obj/item/gun/projectile/voodoo)
	gripvars = list(/obj/item/part/gun/grip/rubber)
	mechanismvar = /obj/item/part/gun/mechanism/pistol
	barrelvars = list(/obj/item/part/gun/barrel/magnum)
