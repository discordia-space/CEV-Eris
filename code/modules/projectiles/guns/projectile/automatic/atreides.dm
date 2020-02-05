/obj/item/weapon/gun/projectile/automatic/atreides
	name = "FS SMG .35 Auto \"Atreides\""
	desc = "The Atreides is a replica of an old and popular SMG. It has a strong kick. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/atreides.dmi'
	icon_state = "atreides"
	item_state = "atreides"
	w_class = ITEM_SIZE_NORMAL
	can_dual = 1
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/pistol"
	load_method = MAGAZINE
	mag_well = MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	matter = list(MATERIAL_PLASTEEL = 16, MATERIAL_PLASTIC = 4)
	price_tag = 2000
	damage_multiplier = 0.9
	recoil_buildup = 5

	firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		BURST_3_ROUND
		)

/obj/item/weapon/gun/projectile/automatic/atreides/update_icon()
	..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]-full"
		set_item_state("-full")
	else
		icon_state = initial(icon_state)
		set_item_state()
	return
