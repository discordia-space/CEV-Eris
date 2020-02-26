/obj/item/weapon/gun/projectile/mandella
	name = "FS HG .25 CS \"Mandella\""
	desc = "A rugged, robust operator handgun with inbuilt silencer. Chambered in rifle caseless ammunition, this time-tested handgun is \
			your absolute choise if you need to take someone down silently, as it's deadly, produces no sound and leaves no traces. \
			Uses .25 Caseless rounds."
	icon = 'icons/obj/guns/projectile/mandella.dmi'
	icon_state = "mandella"
	item_state = "mandella"
	w_class = ITEM_SIZE_NORMAL
	can_dual = 1
	caliber = CAL_CLRIFLE
	silencer_type = /obj/item/weapon/silencer/integrated
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6)
	price_tag = 1500
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	damage_multiplier = 1			//27 with lethal, 32 with hv
	penetration_multiplier = 0.8	//12 with lethal, 16 with hv
	recoil_buildup = 19

//This comes with a preinstalled silencer
/obj/item/weapon/gun/projectile/mandella/Initialize()
	.=..()
	apply_silencer(new /obj/item/weapon/silencer/integrated(src), null)


/obj/item/weapon/gun/projectile/mandella/update_icon()
	..()

	var/iconstring = initial(icon_state)

	if (ammo_magazine)
		iconstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring

/obj/item/weapon/gun/projectile/mandella/Initialize()
	. = ..()
	update_icon()
