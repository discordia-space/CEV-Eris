/obj/item/weapon/gun/projectile/automatic/drozd
	name = "Excelsior 9mm \"Drozd\""
	desc = "An excellent fully automatic submachinegun. Famous for it's perfomance in close quarters. Uses 9mm rounds."
	icon_state = "drozd"
	item_state = "drozd"
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_ILLEGAL = 4)
	ammo_type = "/obj/item/ammo_casing/c9mm"
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL|MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg9mm
	matter = list(MATERIAL_PLASTEEL = 15, MATERIAL_PLASTIC = 3)
	price_tag = 2000
	damage_multiplier = 0.7 // On level with IH smg
	recoil = 0.7 //slightly more than a standart pistol due to auto-firing mode
	recoil_buildup = 0.1 //smg level
	silencer_type = /obj/item/weapon/silencer

	firemodes = list(
		FULL_AUTO_600,
		SEMI_AUTO_NODELAY
		)

/obj/item/weapon/gun/projectile/automatic/drozd/update_icon()
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
