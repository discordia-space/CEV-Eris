/obj/item/gun/projectile/automatic/drozd
	name = "Excelsior SMG .40 Magnum \"Drozd\""
	desc = "An excellent fully automatic Heavy SMG. Rifled to take a larger caliber than a typical submachine gun, but unlike \
			other heavy SMGs makes use of increased caliber to achieve excellent armor penetration capabilities. \
			Suffers a bit less from poor recoil control and has worse than average fire rate. Uses .40 Magnum rounds."
	icon = 'icons/obj/guns/projectile/drozd.dmi'
	icon_state = "drozd"
	item_state = "drozd"
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2)
	caliber = CAL_MAGNUM
	load_method = MAGAZINE
	mag_well = MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/msmg
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_STEEL = 4, MATERIAL_PLASTIC = 4)
	price_tag = 2200
	damage_multiplier = 0.9
	penetration_multiplier = 0.5
	init_recoil = SMG_RECOIL(0.7)

	twohanded = FALSE
	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		FULL_AUTO_300,
		SEMI_AUTO_300
		)
	gun_parts = list(/obj/item/part/gun/frame/drozd = 1, /obj/item/part/gun/grip/excel = 1, /obj/item/part/gun/mechanism/smg = 1, /obj/item/part/gun/barrel/magnum = 1)

	serial_type = "Excelsior"

/obj/item/gun/projectile/automatic/drozd/update_icon()
	cut_overlays()
	icon_state = "[initial(icon_state)][silenced ? "_s" : ""]"

	if(ammo_magazine)
		overlays += "mag[silenced ? "_s" : ""][ammo_magazine.ammo_label_string]"
	else
		overlays += "slide[silenced ? "_s" : ""]"

/obj/item/gun/projectile/automatic/drozd/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/drozd
	name = "Drozd frame"
	desc = "A Drozd SMG frame. Workhorse of the Excelsior force."
	icon_state = "frame_excelsmg"
	resultvars = list(/obj/item/gun/projectile/automatic/drozd)
	gripvars = list(/obj/item/part/gun/grip/excel)
	mechanismvar = /obj/item/part/gun/mechanism/smg
	barrelvars = list(/obj/item/part/gun/barrel/magnum)
