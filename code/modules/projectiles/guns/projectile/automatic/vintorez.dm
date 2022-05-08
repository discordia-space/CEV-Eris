/obj/item/gun/projectile/automatic/vintorez
	name = "Excelsior .20 \"Vintorez\""
	desc = "This gun is a copy of a design from a country that no longer exists. It is still highly prized for its armor piercing capabilities. \
			The design was made to be able to fit long magazine alongside the standard ones."
	icon = 'icons/obj/guns/projectile/vintorez.dmi'
	icon_state = "vintorez"
	item_state = "vintorez"
	w_class = ITEM_SIZE_BULKY
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_SRIFLE
	origin_tech = list(TECH_COMBAT = 6, TECH_COVERT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BACK
	ammo_type = /obj/item/ammo_casing/srifle
	load_method = MAGAZINE
	mag_well = MAG_WELL_RIFLE|MAG_WELL_RIFLE_L
	magazine_type = /obj/item/ammo_magazine/srifle
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 5)
	price_tag = 4000
	zoom_factor = 0.8 // double as IH_heavy
	penetration_multiplier = 1.2
	damage_multiplier = 1.2
	recoil_buildup = 1.3
	one_hand_penalty = 15 //automatic rifle level
	silenced = TRUE
	init_firemodes = list(
		SEMI_AUTO_NODELAY,
		BURST_2_ROUND
		)
	gun_parts = list(/obj/item/part/gun/frame/vintorez = 1, /obj/item/part/gun/grip/excel = 1, /obj/item/part/gun/mechanism/autorifle = 1, /obj/item/part/gun/barrel/srifle = 1)
	serial_type = "Excelsior"

/obj/item/gun/projectile/automatic/vintorez/update_icon()
	var/iconstring = initial(icon_state)
	var/itemstring = initial(item_state)

	if (ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"
		if(ammo_magazine.mag_well == MAG_WELL_RIFLE_L)
			itemstring += "_l"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	icon_state = iconstring
	item_state = itemstring

/obj/item/part/gun/frame/vintorez
	name = "Vintorez frame"
	desc = "A Vintorez rifle frame. Accurate and damaging."
	icon_state = "frame_vintorez"
	result = /obj/item/gun/projectile/automatic/vintorez
	grip = /obj/item/part/gun/grip/excel
	mechanism = /obj/item/part/gun/mechanism/autorifle
	barrel = /obj/item/part/gun/barrel/srifle
