/obj/item/weapon/gun/projectile/colt
	name = "FS HG .35 Auto \"Colt M1911\""
	desc = "A cheap knock-off of a Colt M1911. Uses standard .35 Auto mags."
	icon = 'icons/obj/guns/projectile/colt.dmi'
	icon_state = "colt"
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6)
	price_tag = 1200
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	can_dual = 1
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	damage_multiplier = 1.5
	recoil_buildup = 17


/obj/item/weapon/gun/projectile/colt/update_icon()
	..()

	var/iconstring = initial(icon_state)

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring

/obj/item/weapon/gun/projectile/colt/Initialize()
	. = ..()
	update_icon()
