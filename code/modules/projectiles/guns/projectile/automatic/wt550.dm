/obj/item/weapon/gun/projectile/automatic/wt550
	name = "FS SMG 9x19 \"W-T Saber\""
	desc = "The W-T 550 Saber is a cheap self-defense weapon, mass-produced by \"Frozen Star\" for paramilitary and private use. Uses 9mm rounds."
	icon_state = "wt550"
	item_state = "wt550"
	w_class = ITEM_SIZE_NORMAL
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/c9mmr"
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASTIC = 12)
	price_tag = 2500
	magazine_type = /obj/item/ammo_magazine/mc9mmt/rubber
	recoil = 0.8

/obj/item/weapon/gun/projectile/automatic/wt550/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "wt550-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "wt550"
	return
