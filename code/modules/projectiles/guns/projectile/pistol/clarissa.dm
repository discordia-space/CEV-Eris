/obj/item/weapon/gun/projectile/clarissa
	name = "FS HG 9x19 \"Clarissa\""
	desc = "A small, easily concealable, but somewhat underpowered gun. Uses 9mm rounds."
	icon_state = "clarissa"
	item_state = "clarissa"
	w_class = ITEM_SIZE_SMALL
	caliber = "9mm"
	silenced = 0
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 2)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6)
	price_tag = 1200
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	silencer_type = /obj/item/weapon/silencer
	damage_multiplier = 0.8
	recoil = 0.4 //slightly less than normal 0.5 for pistol due to lower caliber


/obj/item/weapon/gun/projectile/clarissa/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = initial(item_state)

	if (ammo_magazine)
		iconstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	if (silenced)
		iconstring += "_s"
		itemstring += "_s"

	icon_state = iconstring
	item_state = itemstring


/obj/item/weapon/gun/projectile/clarissa/makarov
	name = "Excelsior 9x19 \"Makarov\""
	desc = "Old-designed pistol of space communists. Small and easily concealable. Uses 9mm rounds."
	icon_state = "makarov"
	damage_multiplier = 1
	price_tag = 1400
