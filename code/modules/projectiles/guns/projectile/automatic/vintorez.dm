/obj/item/weapon/gun/projectile/automatic/vintorez
	name = "Excelsior .20 \"Vintorez\""
	desc = "This is a copy of design from country that does not exist anymore. Still a highly valuable for it's armor piercing capabilities."
	icon = 'icons/obj/guns/projectile/vintorez.dmi'
	icon_state = "vintorez"
	item_state = "vintorez"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	caliber = "srifle"
	origin_tech = list(TECH_COMBAT = 6, TECH_ILLEGAL = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BACK
	ammo_type = "/obj/item/ammo_casing/srifle"
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	magazine_type = /obj/item/ammo_magazine/srifle
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 5)
	price_tag = 4000
	zoom_factor = 0.8 // double as IH_heavy
	damage_multiplier = 1
	recoil = 0.4
	recoil_buildup = 0.2 // higher that smg due to balance reasons
	silencer_type = /obj/item/weapon/silencer

	firemodes = list(
		SEMI_AUTO_NODELAY,
		FULL_AUTO_400
		)

//This comes with a preinstalled silencer
/obj/item/weapon/gun/projectile/automatic/vintorez/Initialize()
	.=..()
	apply_silencer(new /obj/item/weapon/silencer/integrated(src), null)

/obj/item/weapon/gun/projectile/automatic/vintorez/update_icon()
	var/iconstring = initial(icon_state)
	var/itemstring = initial(item_state)

	if (ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring
	item_state = itemstring