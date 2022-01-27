/obj/item/gun/projectile/automatic/atreides
	name = "FS SMG .35 Auto \"Atreides\""
	desc = "The Atreides is a replica of an old and popular SMG. Cheap and69ass produced generic self-defence weapon. \
			The overall design is so generic that it is69either considered good69or bad in comparison to other firearms. \
			Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/atreides.dmi'
	icon_state = "atreides"
	item_state = "atreides"
	w_class = ITEM_SIZE_NORMAL
	can_dual = TRUE
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = /obj/item/ammo_casing/pistol
	load_method =69AGAZINE
	mag_well =69AG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	matter = list(MATERIAL_PLASTEEL = 5,69ATERIAL_STEEL = 13,69ATERIAL_PLASTIC = 2)
	price_tag = 800
	damage_multiplier = 0.8
	recoil_buildup = 1.2
	one_hand_penalty = 5 //smg level
	gun_tags = list(GUN_SILENCABLE, GUN_GILDABLE)

	init_firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		)

/obj/item/gun/projectile/automatic/atreides/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if(gilded)
		iconstring += "_gold"
		itemstring += "_gold"

	if (ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	if (silenced)
		iconstring += "_s"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/automatic/atreides/Initialize()
	. = ..()
	update_icon()
