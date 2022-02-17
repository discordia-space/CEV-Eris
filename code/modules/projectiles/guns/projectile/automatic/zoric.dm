/obj/item/gun/projectile/automatic/zoric
	name = "SA SMG .40 Magnum \"Zoric\""
	desc = "A Heavy Submachine Gun made by \"Serbian Arms\", for paramilitary and private security use. \
			Rifled to take a larger caliber than a typical submachine gun, it boasts a greater impact, but suffers \
			from poor recoil control and worse than average armor penetration capabilities as a result. \
			Has worse than average fire rate. Uses .40 Magnum rounds."
	icon = 'icons/obj/guns/projectile/zoric.dmi'
	icon_state = "zoric"
	item_state = "zoric"
	w_class = ITEM_SIZE_NORMAL
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	caliber = CAL_MAGNUM
	load_method = MAGAZINE
	mag_well = MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/msmg
	matter = list(MATERIAL_PLASTEEL = 10, MATERIAL_STEEL = 6, MATERIAL_PLASTIC = 4)
	price_tag = 2000
	damage_multiplier = 1.1	 // 34 lethal on FA
	penetration_multiplier = 0.65 // 9.75 lethal
	recoil_buildup = 0.7
	twohanded = FALSE
	one_hand_penalty = 5 //smg level

	init_firemodes = list(
		FULL_AUTO_300,
		SEMI_AUTO_NODELAY,
		)
	gun_tags = list(GUN_SILENCABLE)
	gun_parts = list(/obj/item/part/gun/frame/zoric = 1, /obj/item/part/gun/grip/serb = 1, /obj/item/part/gun/mechanism/smg = 1, /obj/item/part/gun/barrel/magnum = 1)

/obj/item/gun/projectile/automatic/zoric/update_icon()
	..()
	var/itemstring = ""
	cut_overlays()

	if(ammo_magazine)
		overlays += "mag[ammo_magazine.ammo_label_string]"
		itemstring += "_mag"

	set_item_state(itemstring)

/obj/item/gun/projectile/automatic/zoric/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/zoric
	name = "Zoric frame"
	desc = "A Zoric SMG frame. Workhorse of the Excelsior force."
	icon_state = "frame_zorik"
	result = /obj/item/gun/projectile/automatic/zoric
	grip = /obj/item/part/gun/grip/serb
	mechanism = /obj/item/part/gun/mechanism/smg
	barrel = /obj/item/part/gun/barrel/magnum
