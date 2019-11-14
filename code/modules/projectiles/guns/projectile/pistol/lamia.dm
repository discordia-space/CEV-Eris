/obj/item/weapon/gun/projectile/lamia
	name = "FS HG .44 \"Lamia\""
	desc = "FS HG .44 \"Lamia\", a heavy pistol of Ironhammer enforcers. Uses .44 rounds."
	icon = 'icons/obj/guns/projectile/lamia.dmi'
	icon_state = "lamia"
	item_state = "lamia"
	fire_sound = 'sound/weapons/guns/fire/hpistol_fire.ogg'
	caliber = ".44"
	ammo_mag = "mag_cl44"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 4)
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 8)
	price_tag = 1800
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	unload_sound 	= 'sound/weapons/guns/interact/hpistol_magout.ogg'
	reload_sound 	= 'sound/weapons/guns/interact/hpistol_magin.ogg'
	cocked_sound 	= 'sound/weapons/guns/interact/hpistol_cock.ogg'
	recoil = 0.8 //high caliber pistol recoil

/obj/item/weapon/gun/projectile/lamia/update_icon()
	..()

	var/iconstring = initial(icon_state)

	if (ammo_magazine)
		iconstring += "-[round(ammo_magazine.stored_ammo.len,4)]"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring

/obj/item/weapon/gun/projectile/lamia/Initialize()
	. = ..()
	update_icon()