/obj/item/weapon/gun/projectile/automatic/idaho
	name = "FS SMG .30 Auto \"Idaho\""
	desc = "The Idaho is a cheap self-defence weapon, mass-produced by \"Frozen Star\" for paramilitary and private use. Uses 30 Auto rounds."
	icon = 'icons/obj/guns/projectile/idaho.dmi'
	icon_state = "idaho"
	item_state = "idaho"
	w_class = ITEM_SIZE_NORMAL
	caliber = "pistol"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/pistol"
	load_method = MAGAZINE
	mag_well = MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	matter = list(MATERIAL_PLASTEEL = 16, MATERIAL_WOOD = 4)
	price_tag = 1600
	damage_multiplier = 0.75
	damage_multiplier = 1.1
	recoil = 0.8
	recoil_buildup = 0.1 //smg level

	firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		BURST_3_ROUND
		)

/obj/item/weapon/gun/projectile/automatic/idaho/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]-full"
		set_item_state("-full")
	else
		icon_state = initial(icon_state)
		set_item_state()
	return
