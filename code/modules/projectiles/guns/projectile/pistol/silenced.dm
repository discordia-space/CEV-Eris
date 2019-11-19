/obj/item/weapon/gun/projectile/silenced
	name = "FS HG .35 Auto \"Mandella\""
	desc = "A small, quiet,  easily concealable gun. Uses standard .35 Auto mags. Has an integrated silencer which can't be removed."
	icon = 'icons/obj/guns/projectile/mandella.dmi'
	icon_state = "mandella"
	item_state = "pistol_s"
	w_class = ITEM_SIZE_NORMAL
	caliber = "pistol"
	silencer_type = /obj/item/weapon/silencer/integrated
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6)
	price_tag = 1500
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	damage_multiplier = 1.2
	recoil = 0.4 //less than regular pistol because of integrated silencer


//This comes with a preinstalled silencer
/obj/item/weapon/gun/projectile/silenced/Initialize()
	.=..()
	apply_silencer(new /obj/item/weapon/silencer/integrated(src), null)


/obj/item/weapon/gun/projectile/silenced/update_icon()
	..()

	var/iconstring = initial(icon_state)

	if (ammo_magazine)
		iconstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring

/obj/item/weapon/gun/projectile/silenced/Initialize()
	. = ..()
	update_icon()
