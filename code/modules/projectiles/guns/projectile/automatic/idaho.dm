/obj/item/weapon/gun/projectile/automatic/idaho
	name = "FS SMG 9x19 \"Idaho\""
	desc = "The Idaho is a cheap self-defence weapon, mass-produced by \"Frozen Star\" for paramilitary and private use. Uses 9mm rounds."
	icon_state = "idaho"
	item_state = "idaho"
	w_class = ITEM_SIZE_NORMAL
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/c9mmr"
	load_method = MAGAZINE
	mag_well = MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg9mm
	matter = list(MATERIAL_PLASTEEL = 16, MATERIAL_WOOD = 4)
	price_tag = 1600
	damage_multiplier = 0.75
	recoil = 0.8
	recoil_buildup = 0.1 //smg level

	firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,     icon="burst"),
		)

/obj/item/weapon/gun/projectile/automatic/idaho/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]-full"
		item_state = "[initial(item_state)]-full"
	else
		icon_state = initial(icon_state)
		item_state = initial(item_state)
	return
